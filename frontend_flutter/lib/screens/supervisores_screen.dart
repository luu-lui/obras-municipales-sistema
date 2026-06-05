import 'package:flutter/material.dart';
import '../models/supervisor.dart';
import '../services/api_service.dart';
import 'supervisor_form_screen.dart';

class SupervisoresScreen extends StatefulWidget {
  const SupervisoresScreen({super.key});

  @override
  State<SupervisoresScreen> createState() => _SupervisoresScreenState();
}

class _SupervisoresScreenState extends State<SupervisoresScreen> {
  final api = ApiService();
  List<Supervisor> lista = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    cargar();
  }

  Future<void> cargar() async {
    setState(() => loading = true);
    try {
      lista = await api.obtenerSupervisores();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
    if (mounted) setState(() => loading = false);
  }

  Future<void> eliminar(Supervisor s) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Eliminar'),
        content: Text('¿Eliminar ${s.nombre}?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Eliminar')),
        ],
      ),
    );

    if (ok == true) {
      await api.eliminarSupervisor(s.id!);
      cargar();
    }
  }

  void detalle(Supervisor s) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(s.nombre),
        content: Text(
          'Cargo: ${s.cargo}\nTeléfono: ${s.telefono}\nCorreo: ${s.correo}',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cerrar')),
        ],
      ),
    );
  }

  Future<void> abrirForm([Supervisor? s]) async {
    final ok = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => SupervisorFormScreen(supervisor: s)),
    );
    if (ok == true) cargar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Supervisores'),
        backgroundColor: Colors.green,
        actions: [IconButton(onPressed: cargar, icon: const Icon(Icons.refresh))],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => abrirForm(),
        child: const Icon(Icons.add),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : lista.isEmpty
              ? const Center(child: Text('No hay supervisores'))
              : ListView.builder(
                  itemCount: lista.length,
                  itemBuilder: (_, i) {
                    final s = lista[i];
                    return Card(
                      child: ListTile(
                        leading: const CircleAvatar(child: Icon(Icons.engineering)),
                        title: Text(s.nombre),
                        subtitle: Text('${s.cargo} - ${s.correo}'),
                        onTap: () => detalle(s),
                        trailing: PopupMenuButton<String>(
                          onSelected: (v) {
                            if (v == 'editar') abrirForm(s);
                            if (v == 'eliminar') eliminar(s);
                          },
                          itemBuilder: (_) => const [
                            PopupMenuItem(value: 'editar', child: Text('Editar')),
                            PopupMenuItem(value: 'eliminar', child: Text('Eliminar')),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}