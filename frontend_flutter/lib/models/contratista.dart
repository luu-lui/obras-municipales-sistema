class Contratista {
  final int? id;
  final String nombre;
  final String ruc;
  final String telefono;
  final String correo;
  final String direccion;

  Contratista({
    this.id,
    required this.nombre,
    required this.ruc,
    required this.telefono,
    required this.correo,
    required this.direccion,
  });

  factory Contratista.fromJson(Map<String, dynamic> json) {
    return Contratista(
      id: json['id'],
      nombre: json['nombre'] ?? '',
      ruc: json['ruc'] ?? '',
      telefono: json['telefono'] ?? '',
      correo: json['correo'] ?? '',
      direccion: json['direccion'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'nombre': nombre,
        'ruc': ruc,
        'telefono': telefono,
        'correo': correo,
        'direccion': direccion,
      };
}