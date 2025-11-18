import '../database/db.dart';
import '../models/turno.dart';

class TurnoService {
  final tableTurno = 'turno';
  final tableTurnoRol = 'turno_rol';
  final tableRol = 'rol';

  // --- INSERTAR ---
  Future<void> insertarTurno(Turno turno) async {
    final db = await AppDatabase.instance.database;

    // 1. Insertar el turno y obtener su ID
    final turnoId = await db.insert(tableTurno, turno.toMap());

    // 2. Insertar las relaciones en turno_rol
    // Recorremos el mapa: {'Mesero': 2, 'Cocinero': 1}
    for (var entry in turno.empleadosRequeridos.entries) {
      final nombreRol = entry.key;
      final cantidad = entry.value;

      // Necesitamos el ID del rol basado en su nombre
      final rolResult = await db.query(
        tableRol,
        where: 'nombre = ?',
        whereArgs: [nombreRol],
      );

      if (rolResult.isNotEmpty) {
        final rolId = rolResult.first['id'] as int;

        // Insertamos en la tabla intermedia
        await db.insert(tableTurnoRol, {
          'turno_id': turnoId,
          'rol_id': rolId,
          'cantidad': cantidad,
        });
      }
    }
  }

  // --- LISTAR ---
  Future<List<Turno>> listarTurnos() async {
    final db = await AppDatabase.instance.database;

    // 1. Obtener todos los turnos base
    final resultTurnos = await db.query(tableTurno);
    List<Turno> listaTurnos = [];

    for (var map in resultTurnos) {
      Turno t = Turno.fromMap(map);

      // 2. Para cada turno, buscar sus empleados requeridos
      // Hacemos un JOIN entre turno_rol y rol
      final resultRoles = await db.rawQuery('''
        SELECT r.nombre, tr.cantidad 
        FROM $tableTurnoRol tr
        JOIN $tableRol r ON tr.rol_id = r.id
        WHERE tr.turno_id = ?
      ''', [t.id]);

      // 3. Construir el mapa de empleados
      Map<String, int> empleados = {};
      for (var row in resultRoles) {
        empleados[row['nombre'] as String] = row['cantidad'] as int;
      }

      t.empleadosRequeridos = empleados;
      listaTurnos.add(t);
    }

    return listaTurnos;
  }

  // --- ELIMINAR ---
  Future<void> eliminarTurno(int id) async {
    final db = await AppDatabase.instance.database;
    // Primero borramos las relaciones (aunque el CASCADE en DB debería hacerlo, es más seguro así)
    await db.delete(tableTurnoRol, where: 'turno_id = ?', whereArgs: [id]);
    // Borramos el turno
    await db.delete(tableTurno, where: 'id = ?', whereArgs: [id]);
  }
}