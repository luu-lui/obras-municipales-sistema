import 'package:flutter/material.dart';
import '../models/contratista.dart';
import '../services/api_service.dart';
import 'contratista_form_screen.dart';

class ContratistasScreen extends StatefulWidget {
  const ContratistasScreen({super.key});

  @override
  State<ContratistasScreen> createState() => _ContratistasScreenState();
}

class _ContratistasScreenState extends State<ContratistasScreen> {
  final api = ApiService();
  List<Contratista> lista = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    cargar();
  }

  Future<void> cargar() async {
    setState(() => loading = true);
    try {
      lista = await api.obtenerContratistas();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
    if (mounted) setState(() => loading = false);
  }

  Future<void> eliminar(Contratista c) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Eliminar'),
        content: Text('¿Eliminar ${c.nombre}?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Eliminar')),
        ],
      ),
    );

    if (ok == true) {
      await api.eliminarContratista(c.id!);
      cargar();
    }
  }

  void detalle(Contratista c) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(c.nombre),
        content: Text(
          'RUC: ${c.ruc}\nTeléfono: ${c.telefono}\nCorreo: ${c.correo}\nDirección: ${c.direccion}',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cerrar')),
        ],
      ),
    );
  }

  Future<void> abrirForm([Contratista? c]) async {
    final ok = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ContratistaFormScreen(contratista: c)),
    );
    if (ok == true) cargar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contratistas'),
        backgroundColor: Colors.blue,
        actions: [IconButton(onPressed: cargar, icon: const Icon(Icons.refresh))],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => abrirForm(),
        child: const Icon(Icons.add),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : lista.isEmpty
              ? const Center(child: Text('No hay contratistas'))
              : ListView.builder(
                  itemCount: lista.length,
                  itemBuilder: (_, i) {
                    final c = lista[i];
                    return Card(
                      child: ListTile(
                        leading: const CircleAvatar(child: Icon(Icons.business)),
                        title: Text(c.nombre),
                        subtitle: Text('${c.ruc} - ${c.correo}'),
                        onTap: () => detalle(c),
                        trailing: PopupMenuButton<String>(
                          onSelected: (v) {
                            if (v == 'editar') abrirForm(c);
                            if (v == 'eliminar') eliminar(c);
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