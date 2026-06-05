import 'package:flutter/material.dart';
import 'contratistas_screen.dart';
import 'supervisores_screen.dart';
import 'obras_screen.dart';
import 'avances_screen.dart';
import 'reporte_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Widget item(BuildContext context, IconData icon, String title, Widget screen, Color color) {
    return SizedBox(
      width: 260,
      height: 120,
      child: Card(
        child: InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: color),
              const SizedBox(height: 10),
              Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sistema de Control de Obras Municipales'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Wrap(
          spacing: 20,
          runSpacing: 20,
          children: [
            item(context, Icons.business, 'Contratistas', const ContratistasScreen(), Colors.blue),
            item(context, Icons.engineering, 'Supervisores', const SupervisoresScreen(), Colors.green),
            item(context, Icons.construction, 'Obras', const ObrasScreen(), Colors.orange),
            item(context, Icons.trending_up, 'Avances', const AvancesScreen(), Colors.purple),
            item(context, Icons.bar_chart, 'Reporte', const ReporteScreen(), Colors.red),
          ],
        ),
      ),
    );
  }
}