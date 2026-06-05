import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/contratista.dart';
import '../models/supervisor.dart';
import '../models/obra.dart';
import '../models/avance.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:3000/api';

  Future<bool> login(String usuario, String contrasena) async {
    final res = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'usuario': usuario, 'contrasena': contrasena}),
    );
    return res.statusCode == 200;
  }

  Future<List<Contratista>> obtenerContratistas() async {
    final res = await http.get(Uri.parse('$baseUrl/contratistas'));
    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body);
      return data.map((e) => Contratista.fromJson(e)).toList();
    }
    throw Exception('Error al obtener contratistas');
  }

  Future<void> crearContratista(Contratista c) async {
    final res = await http.post(Uri.parse('$baseUrl/contratistas'),
        headers: {'Content-Type': 'application/json'}, body: jsonEncode(c.toJson()));
    if (res.statusCode != 201) throw Exception('Error al crear contratista');
  }

  Future<void> actualizarContratista(int id, Contratista c) async {
    final res = await http.put(Uri.parse('$baseUrl/contratistas/$id'),
        headers: {'Content-Type': 'application/json'}, body: jsonEncode(c.toJson()));
    if (res.statusCode != 200) throw Exception('Error al actualizar contratista');
  }

  Future<void> eliminarContratista(int id) async {
    final res = await http.delete(Uri.parse('$baseUrl/contratistas/$id'));
    if (res.statusCode != 200) throw Exception('Error al eliminar contratista');
  }

  Future<List<Supervisor>> obtenerSupervisores() async {
    final res = await http.get(Uri.parse('$baseUrl/supervisores'));
    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body);
      return data.map((e) => Supervisor.fromJson(e)).toList();
    }
    throw Exception('Error al obtener supervisores');
  }

  Future<void> crearSupervisor(Supervisor s) async {
    final res = await http.post(Uri.parse('$baseUrl/supervisores'),
        headers: {'Content-Type': 'application/json'}, body: jsonEncode(s.toJson()));
    if (res.statusCode != 201) throw Exception('Error al crear supervisor');
  }

  Future<void> actualizarSupervisor(int id, Supervisor s) async {
    final res = await http.put(Uri.parse('$baseUrl/supervisores/$id'),
        headers: {'Content-Type': 'application/json'}, body: jsonEncode(s.toJson()));
    if (res.statusCode != 200) throw Exception('Error al actualizar supervisor');
  }

  Future<void> eliminarSupervisor(int id) async {
    final res = await http.delete(Uri.parse('$baseUrl/supervisores/$id'));
    if (res.statusCode != 200) throw Exception('Error al eliminar supervisor');
  }

  Future<List<Obra>> obtenerObras() async {
    final res = await http.get(Uri.parse('$baseUrl/obras'));
    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body);
      return data.map((e) => Obra.fromJson(e)).toList();
    }
    throw Exception('Error al obtener obras');
  }

  Future<void> crearObra(Obra o) async {
    final res = await http.post(Uri.parse('$baseUrl/obras'),
        headers: {'Content-Type': 'application/json'}, body: jsonEncode(o.toJson()));
    if (res.statusCode != 201) throw Exception('Error al crear obra');
  }

  Future<void> actualizarObra(int id, Obra o) async {
    final res = await http.put(Uri.parse('$baseUrl/obras/$id'),
        headers: {'Content-Type': 'application/json'}, body: jsonEncode(o.toJson()));
    if (res.statusCode != 200) throw Exception('Error al actualizar obra');
  }

  Future<void> eliminarObra(int id) async {
    final res = await http.delete(Uri.parse('$baseUrl/obras/$id'));
    if (res.statusCode != 200) throw Exception('Error al eliminar obra');
  }

  Future<Map<String, dynamic>> obtenerReporte() async {
    final res = await http.get(Uri.parse('$baseUrl/obras/reporte'));
    if (res.statusCode == 200) return jsonDecode(res.body);
    throw Exception('Error al obtener reporte');
  }

  Future<List<Avance>> obtenerAvances() async {
    final res = await http.get(Uri.parse('$baseUrl/avances'));
    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body);
      return data.map((e) => Avance.fromJson(e)).toList();
    }
    throw Exception('Error al obtener avances');
  }

  Future<void> crearAvance(Avance a) async {
    final res = await http.post(Uri.parse('$baseUrl/avances'),
        headers: {'Content-Type': 'application/json'}, body: jsonEncode(a.toJson()));
    if (res.statusCode != 201) throw Exception('Error al crear avance');
  }

  Future<void> actualizarAvance(int id, Avance a) async {
    final res = await http.put(Uri.parse('$baseUrl/avances/$id'),
        headers: {'Content-Type': 'application/json'}, body: jsonEncode(a.toJson()));
    if (res.statusCode != 200) throw Exception('Error al actualizar avance');
  }

  Future<void> eliminarAvance(int id) async {
    final res = await http.delete(Uri.parse('$baseUrl/avances/$id'));
    if (res.statusCode != 200) throw Exception('Error al eliminar avance');
  }
}