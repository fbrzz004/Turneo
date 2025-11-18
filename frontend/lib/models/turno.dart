class Turno {
  int? id;
  String nombre;
  String horaInicio;
  String horaFin;
  // Mapa: NombreDelRol -> Cantidad
  Map<String, int> empleadosRequeridos;

  Turno({
    this.id,
    required this.nombre,
    required this.horaInicio,
    required this.horaFin,
    required this.empleadosRequeridos,
  });

  // Para guardar en la tabla 'turno' (sin los empleados, eso va aparte)
  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'hora_inicio': horaInicio,
      'hora_fin': horaFin,
    };
  }

  // Para leer los datos básicos de la tabla 'turno'
  factory Turno.fromMap(Map<String, dynamic> map) {
    return Turno(
      id: map['id'],
      nombre: map['nombre'],
      horaInicio: map['hora_inicio'],
      horaFin: map['hora_fin'],
      empleadosRequeridos: {}, // Se llena después con otra consulta
    );
  }
}