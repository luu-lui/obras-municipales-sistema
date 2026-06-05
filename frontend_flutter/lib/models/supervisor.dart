class Supervisor {
  final int? id;
  final String nombre;
  final String cargo;
  final String telefono;
  final String correo;

  Supervisor({
    this.id,
    required this.nombre,
    required this.cargo,
    required this.telefono,
    required this.correo,
  });

  factory Supervisor.fromJson(Map<String, dynamic> json) {
    return Supervisor(
      id: json['id'],
      nombre: json['nombre'] ?? '',
      cargo: json['cargo'] ?? '',
      telefono: json['telefono'] ?? '',
      correo: json['correo'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'nombre': nombre,
        'cargo': cargo,
        'telefono': telefono,
        'correo': correo,
      };
}