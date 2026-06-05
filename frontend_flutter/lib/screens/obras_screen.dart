import 'package:flutter/material.dart';
import '../models/obra.dart';
import '../services/api_service.dart';
import 'obra_form_screen.dart';

class ObrasScreen extends StatefulWidget {
  const ObrasScreen({super.key});

  @override
  State<ObrasScreen> createState() => _ObrasScreenState();
}

class _ObrasScreenState extends State<ObrasScreen> {
  final api = ApiService();
  List<Obra> lista = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    cargar();
  }

  Future<void> cargar() async {
    setState(() => loading = true);
    try {
      lista = await api.obtenerObras();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
    if (mounted) setState(() => loading = false);
  }

  Future<void> eliminar(Obra o) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Eliminar'),
        content: Text('¿Eliminar ${o.nombre}?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Eliminar')),
        ],
      ),
    );

    if (ok == true) {
      await api.eliminarObra(o.id!);
      cargar();
    }
  }

  void detalle(Obra o) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(o.nombre),
        content: Text(
          'Tipo: ${o.tipo}\n'
          'Ubicación: ${o.ubicacion}\n'
          'Presupuesto: \$${o.presupuesto.toStringAsFixed(2)}\n'
          'Estado: ${o.estado}\n'
          'Inicio: ${o.fechaInicio}\n'
          'Fin: ${o.fechaFin}\n'
          'Contratista: ${o.contratistaNombre ?? o.contratistaId}\n'
          'Supervisor: ${o.supervisorNombre ?? o.supervisorId}',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cerrar')),
        ],
      ),
    );
  }

  Future<void> abrirForm([Obra? o]) async {
    final ok = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ObraFormScreen(obra: o)),
    );
    if (ok == true) cargar();
  }

  Color colorEstado(String estado) {
    switch (estado) {
      case 'en_ejecucion':
        return Colors.orange;
      case 'finalizada':
        return Colors.green;
      case 'suspendida':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Obras'),
        backgroundColor: Colors.orange,
        actions: [IconButton(onPressed: cargar, icon: const Icon(Icons.refresh))],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => abrirForm(),
        child: const Icon(Icons.add),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : lista.isEmpty
              ? const Center(child: Text('No hay obras'))
              : ListView.builder(
                  itemCount: lista.length,
                  itemBuilder: (_, i) {
                    final o = lista[i];
                    return Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: colorEstado(o.estado),
                          child: const Icon(Icons.construction, color: Colors.white),
                        ),
                        title: Text(o.nombre),
                        subtitle: Text('${o.ubicacion} - ${o.estado} - \$${o.presupuesto.toStringAsFixed(2)}'),
                        onTap: () => detalle(o),
                        trailing: PopupMenuButton<String>(
                          onSelected: (v) {
                            if (v == 'editar') abrirForm(o);
                            if (v == 'eliminar') eliminar(o);
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