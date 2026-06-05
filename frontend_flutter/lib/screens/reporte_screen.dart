import 'package:flutter/material.dart';
import '../services/api_service.dart';

class ReporteScreen extends StatefulWidget {
  const ReporteScreen({super.key});

  @override
  State<ReporteScreen> createState() => _ReporteScreenState();
}

class _ReporteScreenState extends State<ReporteScreen> {
  final api = ApiService();
  Map<String, dynamic>? reporte;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    cargar();
  }

  Future<void> cargar() async {
    setState(() => loading = true);
    try {
      reporte = await api.obtenerReporte();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
    if (mounted) setState(() => loading = false);
  }

  String money(dynamic value) {
    final n = double.tryParse(value.toString()) ?? 0;
    return '\$${n.toStringAsFixed(2)}';
  }

  Widget card(String title, String value, IconData icon, Color color) {
    return SizedBox(
      width: 280,
      height: 160,
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 44, color: color),
            const SizedBox(height: 12),
            Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
            const SizedBox(height: 6),
            Text(title, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final r = reporte ?? {};

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reporte de Obras'),
        backgroundColor: Colors.red,
        actions: [IconButton(onPressed: cargar, icon: const Icon(Icons.refresh))],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: Wrap(
                spacing: 20,
                runSpacing: 20,
                children: [
                  card('Total de obras', '${r['total_obras'] ?? 0}', Icons.construction, Colors.blue),
                  card('Presupuesto total', money(r['presupuesto_total']), Icons.attach_money, Colors.green),
                  card('Presupuesto promedio', money(r['presupuesto_promedio']), Icons.bar_chart, Colors.orange),
                ],
              ),
            ),
    );
  }
}