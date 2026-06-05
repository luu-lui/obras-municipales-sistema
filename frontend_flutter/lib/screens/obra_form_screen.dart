import 'package:flutter/material.dart';
import '../models/obra.dart';
import '../models/contratista.dart';
import '../models/supervisor.dart';
import '../services/api_service.dart';

class ObraFormScreen extends StatefulWidget {
  final Obra? obra;

  const ObraFormScreen({super.key, this.obra});

  @override
  State<ObraFormScreen> createState() => _ObraFormScreenState();
}

class _ObraFormScreenState extends State<ObraFormScreen> {
  final api = ApiService();
  final formKey = GlobalKey<FormState>();

  late TextEditingController nombreCtrl;
  late TextEditingController tipoCtrl;
  late TextEditingController ubicacionCtrl;
  late TextEditingController presupuestoCtrl;
  late TextEditingController fechaInicioCtrl;
  late TextEditingController fechaFinCtrl;

  List<Contratista> contratistas = [];
  List<Supervisor> supervisores = [];

  int? contratistaId;
  int? supervisorId;
  String estado = 'planificada';

  bool loading = true;
  bool guardando = false;

  final estados = ['planificada', 'en_ejecucion', 'suspendida', 'finalizada'];

  @override
  void initState() {
    super.initState();

    final o = widget.obra;

    nombreCtrl = TextEditingController(text: o?.nombre ?? '');
    tipoCtrl = TextEditingController(text: o?.tipo ?? '');
    ubicacionCtrl = TextEditingController(text: o?.ubicacion ?? '');
    presupuestoCtrl = TextEditingController(text: o?.presupuesto.toString() ?? '');
    fechaInicioCtrl = TextEditingController(text: o?.fechaInicio ?? '');
    fechaFinCtrl = TextEditingController(text: o?.fechaFin ?? '');

    contratistaId = o?.contratistaId;
    supervisorId = o?.supervisorId;
    estado = o?.estado ?? 'planificada';

    cargarDatos();
  }

  Future<void> cargarDatos() async {
    try {
      final c = await api.obtenerContratistas();
      final s = await api.obtenerSupervisores();

      if (!mounted) return;

      setState(() {
        contratistas = c;
        supervisores = s;
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

    if (contratistaId == null || supervisorId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Seleccione contratista y supervisor')),
      );
      return;
    }

    setState(() => guardando = true);

    final obra = Obra(
      nombre: nombreCtrl.text,
      tipo: tipoCtrl.text,
      ubicacion: ubicacionCtrl.text,
      presupuesto: double.tryParse(presupuestoCtrl.text) ?? 0,
      estado: estado,
      fechaInicio: fechaInicioCtrl.text,
      fechaFin: fechaFinCtrl.text,
      contratistaId: contratistaId!,
      supervisorId: supervisorId!,
    );

    try {
      if (widget.obra == null) {
        await api.crearObra(obra);
      } else {
        await api.actualizarObra(widget.obra!.id!, obra);
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

    if (contratistas.isEmpty || supervisores.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Obra')),
        body: const Center(
          child: Text('Debe registrar contratistas y supervisores primero'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.obra == null ? 'Nueva Obra' : 'Editar Obra'),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: nombreCtrl,
                decoration: const InputDecoration(labelText: 'Nombre de la obra *'),
                validator: obligatorio,
              ),
              TextFormField(
                controller: tipoCtrl,
                decoration: const InputDecoration(labelText: 'Tipo *'),
                validator: obligatorio,
              ),
              TextFormField(
                controller: ubicacionCtrl,
                decoration: const InputDecoration(labelText: 'Ubicación *'),
                validator: obligatorio,
              ),
              TextFormField(
                controller: presupuestoCtrl,
                decoration: const InputDecoration(labelText: 'Presupuesto *'),
                keyboardType: TextInputType.number,
                validator: obligatorio,
              ),
              TextFormField(
                controller: fechaInicioCtrl,
                decoration: const InputDecoration(labelText: 'Fecha inicio YYYY-MM-DD'),
              ),
              TextFormField(
                controller: fechaFinCtrl,
                decoration: const InputDecoration(labelText: 'Fecha fin YYYY-MM-DD'),
              ),
              DropdownButtonFormField<String>(
                value: estado,
                decoration: const InputDecoration(labelText: 'Estado'),
                items: estados
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) => setState(() => estado = v!),
              ),
              DropdownButtonFormField<int>(
                value: contratistaId,
                decoration: const InputDecoration(labelText: 'Contratista *'),
                items: contratistas
                    .map((c) => DropdownMenuItem(value: c.id, child: Text(c.nombre)))
                    .toList(),
                onChanged: (v) => setState(() => contratistaId = v),
                validator: (v) => v == null ? 'Campo obligatorio' : null,
              ),
              DropdownButtonFormField<int>(
                value: supervisorId,
                decoration: const InputDecoration(labelText: 'Supervisor *'),
                items: supervisores
                    .map((s) => DropdownMenuItem(value: s.id, child: Text(s.nombre)))
                    .toList(),
                onChanged: (v) => setState(() => supervisorId = v),
                validator: (v) => v == null ? 'Campo obligatorio' : null,
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