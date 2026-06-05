import 'package:flutter/material.dart';
import '../models/contratista.dart';
import '../services/api_service.dart';

class ContratistaFormScreen extends StatefulWidget {
  final Contratista? contratista;

  const ContratistaFormScreen({super.key, this.contratista});

  @override
  State<ContratistaFormScreen> createState() => _ContratistaFormScreenState();
}

class _ContratistaFormScreenState extends State<ContratistaFormScreen> {
  final api = ApiService();
  final formKey = GlobalKey<FormState>();

  late TextEditingController nombreCtrl;
  late TextEditingController rucCtrl;
  late TextEditingController telefonoCtrl;
  late TextEditingController correoCtrl;
  late TextEditingController direccionCtrl;

  bool loading = false;

  @override
  void initState() {
    super.initState();
    final c = widget.contratista;
    nombreCtrl = TextEditingController(text: c?.nombre ?? '');
    rucCtrl = TextEditingController(text: c?.ruc ?? '');
    telefonoCtrl = TextEditingController(text: c?.telefono ?? '');
    correoCtrl = TextEditingController(text: c?.correo ?? '');
    direccionCtrl = TextEditingController(text: c?.direccion ?? '');
  }

  Future<void> guardar() async {
    if (!formKey.currentState!.validate()) return;

    setState(() => loading = true);

    final c = Contratista(
      nombre: nombreCtrl.text,
      ruc: rucCtrl.text,
      telefono: telefonoCtrl.text,
      correo: correoCtrl.text,
      direccion: direccionCtrl.text,
    );

    try {
      if (widget.contratista == null) {
        await api.crearContratista(c);
      } else {
        await api.actualizarContratista(widget.contratista!.id!, c);
      }

      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  String? obligatorio(String? v) {
    if (v == null || v.trim().isEmpty) return 'Campo obligatorio';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.contratista == null ? 'Nuevo Contratista' : 'Editar Contratista'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              TextFormField(controller: nombreCtrl, decoration: const InputDecoration(labelText: 'Nombre *'), validator: obligatorio),
              TextFormField(controller: rucCtrl, decoration: const InputDecoration(labelText: 'RUC *'), validator: obligatorio),
              TextFormField(controller: telefonoCtrl, decoration: const InputDecoration(labelText: 'Teléfono *'), validator: obligatorio),
              TextFormField(controller: correoCtrl, decoration: const InputDecoration(labelText: 'Correo *'), validator: obligatorio),
              TextFormField(controller: direccionCtrl, decoration: const InputDecoration(labelText: 'Dirección')),
              const SizedBox(height: 24),
              SizedBox(
                height: 50,
                child: FilledButton.icon(
                  onPressed: loading ? null : guardar,
                  icon: const Icon(Icons.save),
                  label: Text(loading ? 'Guardando...' : 'Guardar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}