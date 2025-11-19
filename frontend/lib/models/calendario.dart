class Calendario {
  int? id;
  String nombre;
  DateTime fechaCreacion;
  int estado; // 0: Pendiente, 1: Generado

  Calendario({this.id, required this.nombre, required this.fechaCreacion, this.estado = 0});

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'fecha_creacion': fechaCreacion.toIso8601String(),
      'estado': estado,
    };
  }

  factory Calendario.fromMap(Map<String, dynamic> map) {
    return Calendario(
      id: map['id'],
      nombre: map['nombre'],
      fechaCreacion: DateTime.parse(map['fecha_creacion']),
      estado: map['estado'],
    );
  }
}

class CalendarioDia {
  int? id;
  int calendarioId;
  DateTime fecha;

  CalendarioDia({this.id, required this.calendarioId, required this.fecha});

  Map<String, dynamic> toMap() {
    return {
      'calendario_id': calendarioId,
      'fecha': fecha.toIso8601String().split('T')[0], // Solo fecha YYYY-MM-DD
    };
  }

  factory CalendarioDia.fromMap(Map<String, dynamic> map) {
    return CalendarioDia(
      id: map['id'],
      calendarioId: map['calendario_id'],
      fecha: DateTime.parse(map['fecha']),
    );
  }
}

// Modelo simple para Disponibilidad
class Disponibilidad {
  int? id;
  int calendarioDiaId;
  int empleadoId;
  int turnoId;

  Disponibilidad({this.id, required this.calendarioDiaId, required this.empleadoId, required this.turnoId});

  Map<String, dynamic> toMap() {
    return {
      'calendario_dia_id': calendarioDiaId,
      'empleado_id': empleadoId,
      'turno_id': turnoId,
    };
  }
}

// Modelo para Asignación Final (Resultado)
class Asignacion {
  int? id;
  int calendarioDiaId;
  int empleadoId;
  int turnoId;

  Asignacion({this.id, required this.calendarioDiaId, required this.empleadoId, required this.turnoId});

  Map<String, dynamic> toMap() {
    return {
      'calendario_dia_id': calendarioDiaId,
      'empleado_id': empleadoId,
      'turno_id': turnoId,
    };
  }
}