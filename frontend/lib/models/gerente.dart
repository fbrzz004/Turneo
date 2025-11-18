class Gerente {
  int? id;
  String nombre;
  String correo;
  String contrasena;

  Gerente({
    this.id,
    required this.nombre,
    required this.correo,
    required this.contrasena,
  });

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'correo': correo,
      'contrasena': contrasena,
    };
  }

  factory Gerente.fromMap(Map<String, dynamic> map) {
    return Gerente(
      id: map['id'],
      nombre: map['nombre'],
      correo: map['correo'],
      contrasena: map['contrasena'],
    );
  }
}