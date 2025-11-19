import '../database/db.dart';
import '../models/calendario.dart';
import '../models/empleado.dart';

class CalendarioService {

  // --- CREACIÓN (GERENTE) ---

  // 1. Crear el calendario padre y devolver su ID
  Future<int> crearCalendario(String nombre) async {
    final db = await AppDatabase.instance.database;
    return await db.insert('calendario', {
      'nombre': nombre,
      'fecha_creacion': DateTime.now().toIso8601String(),
      'estado': 0 // Pendiente
    });
  }

  // 2. Agregar días al calendario
  Future<void> agregarDias(int calendarioId, List<DateTime> fechas) async {
    final db = await AppDatabase.instance.database;
    final batch = db.batch();

    for (var fecha in fechas) {
      batch.insert('calendario_dia', {
        'calendario_id': calendarioId,
        'fecha': fecha.toIso8601String(), // Guardamos fecha completa
      });
    }
    await batch.commit();
  }

  // 3. Agregar participantes (Empleados invitados)
  Future<void> agregarParticipantes(int calendarioId, List<Empleado> empleados) async {
    final db = await AppDatabase.instance.database;
    final batch = db.batch();

    for (var emp in empleados) {
      batch.insert('calendario_participante', {
        'calendario_id': calendarioId,
        'empleado_id': emp.id,
      });
    }
    await batch.commit();
  }

  // --- LECTURA (EMPLEADO / GERENTE) ---

  // Listar calendarios activos
  Future<List<Calendario>> listarCalendarios() async {
    final db = await AppDatabase.instance.database;
    final result = await db.query('calendario', orderBy: 'id DESC');
    return result.map((e) => Calendario.fromMap(e)).toList();
  }

  // Obtener días de un calendario específico
  Future<List<CalendarioDia>> obtenerDiasDeCalendario(int calendarioId) async {
    final db = await AppDatabase.instance.database;
    final result = await db.query(
        'calendario_dia',
        where: 'calendario_id = ?',
        whereArgs: [calendarioId],
        orderBy: 'fecha ASC' // Importante para mostrar Lunes, Martes... en orden
    );
    return result.map((e) => CalendarioDia.fromMap(e)).toList();
  }

  // --- DISPONIBILIDAD (EMPLEADO) ---

  Future<void> guardarDisponibilidad(List<Disponibilidad> disponibilidades) async {
    final db = await AppDatabase.instance.database;
    final batch = db.batch();

    for(var disp in disponibilidades) {
      batch.insert('disponibilidad', disp.toMap());
    }

    await batch.commit();
  }

  // Verificar si un empleado ya respondió a un calendario
  Future<bool> haRespondido(int calendarioId, int empleadoId) async {
    final db = await AppDatabase.instance.database;
    // Hacemos un join para ver si hay disponibilidad en días de este calendario
    final result = await db.rawQuery('''
      SELECT d.id FROM disponibilidad d
      JOIN calendario_dia cd ON d.calendario_dia_id = cd.id
      WHERE cd.calendario_id = ? AND d.empleado_id = ?
      LIMIT 1
    ''', [calendarioId, empleadoId]);

    return result.isNotEmpty;
  }

  Future<bool> esInvitado(int calendarioId, int empleadoId) async {
    final db = await AppDatabase.instance.database;
    final result = await db.query('calendario_participante',
        where: 'calendario_id = ? AND empleado_id = ?',
        whereArgs: [calendarioId, empleadoId]);
    return result.isNotEmpty;
  }

  // Obtener lista de participantes con su estado (Para el Paso 3 del Gerente)
  Future<List<Map<String, dynamic>>> obtenerParticipantesConEstado(int calendarioId) async {
    final db = await AppDatabase.instance.database;

    // 1. Obtener los empleados invitados
    final participantes = await db.rawQuery('''
      SELECT e.id, e.nombre, e.rol 
      FROM empleado e
      JOIN calendario_participante cp ON e.id = cp.empleado_id
      WHERE cp.calendario_id = ?
    ''', [calendarioId]);

    List<Map<String, dynamic>> resultado = [];

    // 2. Verificar disponibilidad para cada uno
    for (var part in participantes) {
      final empId = part['id'] as int;

      // Verificamos si existe al menos un registro en disponibilidad para este calendario y empleado
      final tieneRespuesta = await db.rawQuery('''
        SELECT d.id FROM disponibilidad d
        JOIN calendario_dia cd ON d.calendario_dia_id = cd.id
        WHERE cd.calendario_id = ? AND d.empleado_id = ?
        LIMIT 1
      ''', [calendarioId, empId]);

      resultado.add({
        'id': empId,
        'nombre': part['nombre'],
        'rol': part['rol'],
        'respondio': tieneRespuesta.isNotEmpty, // True o False
      });
    }

    return resultado;
  }
}