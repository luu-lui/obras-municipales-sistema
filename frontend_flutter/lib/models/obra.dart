class Obra {
  final int? id;
  final String nombre;
  final String tipo;
  final String ubicacion;
  final double presupuesto;
  final String estado;
  final String fechaInicio;
  final String fechaFin;
  final int contratistaId;
  final int supervisorId;
  final String? contratistaNombre;
  final String? supervisorNombre;

  Obra({
    this.id,
    required this.nombre,
    required this.tipo,
    required this.ubicacion,
    required this.presupuesto,
    required this.estado,
    required this.fechaInicio,
    required this.fechaFin,
    required this.contratistaId,
    required this.supervisorId,
    this.contratistaNombre,
    this.supervisorNombre,
  });

  factory Obra.fromJson(Map<String, dynamic> json) {
    return Obra(
      id: json['id'],
      nombre: json['nombre'] ?? '',
      tipo: json['tipo'] ?? '',
      ubicacion: json['ubicacion'] ?? '',
      presupuesto: double.tryParse(json['presupuesto'].toString()) ?? 0,
      estado: json['estado'] ?? 'planificada',
      fechaInicio: json['fecha_inicio']?.toString().split('T').first ?? '',
      fechaFin: json['fecha_fin']?.toString().split('T').first ?? '',
      contratistaId: json['contratista_id'],
      supervisorId: json['supervisor_id'],
      contratistaNombre: json['contratista_nombre'],
      supervisorNombre: json['supervisor_nombre'],
    );
  }

  Map<String, dynamic> toJson() => {
        'nombre': nombre,
        'tipo': tipo,
        'ubicacion': ubicacion,
        'presupuesto': presupuesto,
        'estado': estado,
        'fecha_inicio': fechaInicio,
        'fecha_fin': fechaFin,
        'contratista_id': contratistaId,
        'supervisor_id': supervisorId,
      };
}