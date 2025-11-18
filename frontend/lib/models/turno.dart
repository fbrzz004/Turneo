class Turno {
  final String nombre;
  final String horaInicio;
  final String horaFin;
  final Map<String, int> empleadosRequeridos;

  Turno({
    required this.nombre,
    required this.horaInicio,
    required this.horaFin,
    required this.empleadosRequeridos,
  });
}
