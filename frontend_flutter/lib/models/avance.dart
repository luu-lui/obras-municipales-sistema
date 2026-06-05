class Avance {
  final int? id;
  final int obraId;
  final String fecha;
  final double porcentaje;
  final String descripcion;
  final double gastoEjecutado;
  final String observaciones;
  final String? obraNombre;

  Avance({
    this.id,
    required this.obraId,
    required this.fecha,
    required this.porcentaje,
    required this.descripcion,
    required this.gastoEjecutado,
    required this.observaciones,
    this.obraNombre,
  });

  factory Avance.fromJson(Map<String, dynamic> json) {
    return Avance(
      id: json['id'],
      obraId: json['obra_id'],
      fecha: json['fecha']?.toString().split('T').first ?? '',
      porcentaje: double.tryParse(json['porcentaje'].toString()) ?? 0,
      descripcion: json['descripcion'] ?? '',
      gastoEjecutado: double.tryParse(json['gasto_ejecutado'].toString()) ?? 0,
      observaciones: json['observaciones'] ?? '',
      obraNombre: json['obra_nombre'],
    );
  }

  Map<String, dynamic> toJson() => {
        'obra_id': obraId,
        'fecha': fecha,
        'porcentaje': porcentaje,
        'descripcion': descripcion,
        'gasto_ejecutado': gastoEjecutado,
        'observaciones': observaciones,
      };
}