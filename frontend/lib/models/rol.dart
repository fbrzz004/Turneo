class Rol {
  int? id;
  String nombre;

  Rol({
    this.id,
    required this.nombre,
  });

  // Convertir a Map para insertar en la BD
  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
    };
  }

  // Crear objeto desde Map de la BD
  factory Rol.fromMap(Map<String, dynamic> map) {
    return Rol(
      id: map['id'],
      nombre: map['nombre'],
    );
  }
}