import 'package:flutter/material.dart';
import '../models/avance.dart';
import '../services/api_service.dart';
import 'avance_form_screen.dart';

class AvancesScreen extends StatefulWidget {
  const AvancesScreen({super.key});

  @override
  State<AvancesScreen> createState() => _AvancesScreenState();
}

class _AvancesScreenState extends State<AvancesScreen> {
  final api = ApiService();
  List<Avance> lista = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    cargar();
  }

  Future<void> cargar() async {
    setState(() => loading = true);
    try {
      lista = await api.obtenerAvances();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
    if (mounted) setState(() => loading = false);
  }

  Future<void> eliminar(Avance a) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Eliminar'),
        content: Text('¿Eliminar avance de ${a.porcentaje}%?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Eliminar')),
        ],
      ),
    );

    if (ok == true) {
      await api.eliminarAvance(a.id!);
      cargar();
    }
  }

  void detalle(Avance a) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(a.obraNombre ?? 'Avance'),
        content: Text(
          'Fecha: ${a.fecha}\n'
          'Porcentaje: ${a.porcentaje}%\n'
          'Descripción: ${a.descripcion}\n'
          'Gasto ejecutado: \$${a.gastoEjecutado.toStringAsFixed(2)}\n'
          'Observaciones: ${a.observaciones}',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cerrar')),
        ],
      ),
    );
  }

  Future<void> abrirForm([Avance? a]) async {
    final ok = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AvanceFormScreen(avance: a)),
    );
    if (ok == true) cargar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Avances'),
        backgroundColor: Colors.purple,
        actions: [IconButton(onPressed: cargar, icon: const Icon(Icons.refresh))],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => abrirForm(),
        child: const Icon(Icons.add),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : lista.isEmpty
              ? const Center(child: Text('No hay avances'))
              : ListView.builder(
                  itemCount: lista.length,
                  itemBuilder: (_, i) {
                    final a = lista[i];
                    return Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.purple,
                          child: Text('${a.porcentaje.toInt()}%', style: const TextStyle(color: Colors.white)),
                        ),
                        title: Text(a.obraNombre ?? 'Obra ID ${a.obraId}'),
                        subtitle: Text('${a.fecha} - ${a.descripcion}'),
                        onTap: () => detalle(a),
                        trailing: PopupMenuButton<String>(
                          onSelected: (v) {
                            if (v == 'editar') abrirForm(a);
                            if (v == 'eliminar') eliminar(a);
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