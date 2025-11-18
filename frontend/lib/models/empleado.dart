class Empleado {
  int? id;
  String nombre;
  String correo;
  String contrasena;
  String rol;
  String estado; // 'PENDIENTE' o 'ACTIVO' (o 'INACTIVO')

  Empleado({
    this.id,
    required this.nombre,
    required this.correo,
    required this.contrasena,
    required this.rol,
    this.estado = 'PENDIENTE',
  });

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'correo': correo,
      'contrasena': contrasena,
      'rol': rol,
      'estado': estado,
    };
  }

  factory Empleado.fromMap(Map<String, dynamic> map) {
    return Empleado(
      id: map['id'],
      nombre: map['nombre'],
      correo: map['correo'],
      contrasena: map['contrasena'],
      rol: map['rol'],
      estado: map['estado'],
    );
  }
}