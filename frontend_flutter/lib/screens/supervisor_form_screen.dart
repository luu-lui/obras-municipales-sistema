import 'package:flutter/material.dart';
import '../models/supervisor.dart';
import '../services/api_service.dart';

class SupervisorFormScreen extends StatefulWidget {
  final Supervisor? supervisor;

  const SupervisorFormScreen({super.key, this.supervisor});

  @override
  State<SupervisorFormScreen> createState() => _SupervisorFormScreenState();
}

class _SupervisorFormScreenState extends State<SupervisorFormScreen> {
  final api = ApiService();
  final formKey = GlobalKey<FormState>();

  late TextEditingController nombreCtrl;
  late TextEditingController cargoCtrl;
  late TextEditingController telefonoCtrl;
  late TextEditingController correoCtrl;

  bool loading = false;

  @override
  void initState() {
    super.initState();
    final s = widget.supervisor;
    nombreCtrl = TextEditingController(text: s?.nombre ?? '');
    cargoCtrl = TextEditingController(text: s?.cargo ?? '');
    telefonoCtrl = TextEditingController(text: s?.telefono ?? '');
    correoCtrl = TextEditingController(text: s?.correo ?? '');
  }

  String? obligatorio(String? v) {
    if (v == null || v.trim().isEmpty) return 'Campo obligatorio';
    return null;
  }

  Future<void> guardar() async {
    if (!formKey.currentState!.validate()) return;

    setState(() => loading = true);

    final s = Supervisor(
      nombre: nombreCtrl.text,
      cargo: cargoCtrl.text,
      telefono: telefonoCtrl.text,
      correo: correoCtrl.text,
    );

    try {
      if (widget.supervisor == null) {
        await api.crearSupervisor(s);
      } else {
        await api.actualizarSupervisor(widget.supervisor!.id!, s);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.supervisor == null ? 'Nuevo Supervisor' : 'Editar Supervisor'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              TextFormField(controller: nombreCtrl, decoration: const InputDecoration(labelText: 'Nombre *'), validator: obligatorio),
              TextFormField(controller: cargoCtrl, decoration: const InputDecoration(labelText: 'Cargo *'), validator: obligatorio),
              TextFormField(controller: telefonoCtrl, decoration: const InputDecoration(labelText: 'Teléfono *'), validator: obligatorio),
              TextFormField(controller: correoCtrl, decoration: const InputDecoration(labelText: 'Correo *'), validator: obligatorio),
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