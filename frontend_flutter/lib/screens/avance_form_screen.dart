import 'package:flutter/material.dart';
import '../models/avance.dart';
import '../models/obra.dart';
import '../services/api_service.dart';

class AvanceFormScreen extends StatefulWidget {
  final Avance? avance;

  const AvanceFormScreen({super.key, this.avance});

  @override
  State<AvanceFormScreen> createState() => _AvanceFormScreenState();
}

class _AvanceFormScreenState extends State<AvanceFormScreen> {
  final api = ApiService();
  final formKey = GlobalKey<FormState>();

  late TextEditingController fechaCtrl;
  late TextEditingController porcentajeCtrl;
  late TextEditingController descripcionCtrl;
  late TextEditingController gastoCtrl;
  late TextEditingController observacionesCtrl;

  List<Obra> obras = [];
  int? obraId;
  bool loading = true;
  bool guardando = false;

  @override
  void initState() {
    super.initState();
    final a = widget.avance;

    obraId = a?.obraId;
    fechaCtrl = TextEditingController(text: a?.fecha ?? '');
    porcentajeCtrl = TextEditingController(text: a?.porcentaje.toString() ?? '');
    descripcionCtrl = TextEditingController(text: a?.descripcion ?? '');
    gastoCtrl = TextEditingController(text: a?.gastoEjecutado.toString() ?? '');
    observacionesCtrl = TextEditingController(text: a?.observaciones ?? '');

    cargarObras();
  }

  Future<void> cargarObras() async {
    try {
      final data = await api.obtenerObras();
      if (!mounted) return;
      setState(() {
        obras = data;
        loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    }
  }

  String? obligatorio(String? v) {
    if (v == null || v.trim().isEmpty) return 'Campo obligatorio';
    return null;
  }

  Future<void> guardar() async {
    if (!formKey.currentState!.validate()) return;

    if (obraId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Seleccione una obra')),
      );
      return;
    }

    setState(() => guardando = true);

    final avance = Avance(
      obraId: obraId!,
      fecha: fechaCtrl.text,
      porcentaje: double.tryParse(porcentajeCtrl.text) ?? 0,
      descripcion: descripcionCtrl.text,
      gastoEjecutado: double.tryParse(gastoCtrl.text) ?? 0,
      observaciones: observacionesCtrl.text,
    );

    try {
      if (widget.avance == null) {
        await api.crearAvance(avance);
      } else {
        await api.actualizarAvance(widget.avance!.id!, avance);
      }

      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => guardando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (obras.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Avance')),
        body: const Center(child: Text('Debe registrar una obra primero')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.avance == null ? 'Nuevo Avance' : 'Editar Avance'),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<int>(
                value: obraId,
                decoration: const InputDecoration(labelText: 'Obra *'),
                items: obras
                    .map((o) => DropdownMenuItem(value: o.id, child: Text(o.nombre)))
                    .toList(),
                onChanged: (v) => setState(() => obraId = v),
                validator: (v) => v == null ? 'Campo obligatorio' : null,
              ),
              TextFormField(
                controller: fechaCtrl,
                decoration: const InputDecoration(labelText: 'Fecha YYYY-MM-DD *'),
                validator: obligatorio,
              ),
              TextFormField(
                controller: porcentajeCtrl,
                decoration: const InputDecoration(labelText: 'Porcentaje avance *'),
                keyboardType: TextInputType.number,
                validator: obligatorio,
              ),
              TextFormField(
                controller: descripcionCtrl,
                decoration: const InputDecoration(labelText: 'Descripción *'),
                validator: obligatorio,
              ),
              TextFormField(
                controller: gastoCtrl,
                decoration: const InputDecoration(labelText: 'Gasto ejecutado'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: observacionesCtrl,
                decoration: const InputDecoration(labelText: 'Observaciones'),
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 50,
                child: FilledButton.icon(
                  onPressed: guardando ? null : guardar,
                  icon: const Icon(Icons.save),
                  label: Text(guardando ? 'Guardando...' : 'Guardar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}