import 'package:sqflite/sqflite.dart';
import '../database/db.dart';
import '../models/rol.dart';

class RolService {
  final table = 'rol';
  final tableEmpleado = 'empleado';
  final tableTurnoRol = 'turno_rol';

  // Crear un rol
  Future<int> crearRol(Rol rol) async {
    final db = await AppDatabase.instance.database;
    return await db.insert(table, rol.toMap());
  }

  // Listar todos los roles
  Future<List<Rol>> listarRoles() async {
    final db = await AppDatabase.instance.database;
    final result = await db.query(table);

    // Convertir la lista de Maps a lista de objetos Rol
    return result.map((map) => Rol.fromMap(map)).toList();
  }

  // Eliminar rol
  Future<Map<String, dynamic>> eliminarRolSeguro(int id, String nombreRol) async {
    final db = await AppDatabase.instance.database;

    // 1. Verificar si hay EMPLEADOS con este rol
    final empleadosUsandoRol = await db.query(
      tableEmpleado,
      where: 'rol = ?',
      whereArgs: [nombreRol], // Como en empleado guardamos el nombre (TEXT)
    );

    if (empleadosUsandoRol.isNotEmpty) {
      return {
        'success': false,
        'message': 'No se puede eliminar: Hay ${empleadosUsandoRol.length} empleados con este rol.'
      };
    }

    // 2. Verificar si hay TURNOS que requieren este rol
    final turnosUsandoRol = await db.query(
      tableTurnoRol,
      where: 'rol_id = ?',
      whereArgs: [id],
    );

    if (turnosUsandoRol.isNotEmpty) {
      return {
        'success': false,
        'message': 'No se puede eliminar: Este rol es requerido en ${turnosUsandoRol.length} turnos.'
      };
    }

    // 3. Si no se usa en ningún lado, PROCEDEMOS A BORRAR
    await db.delete(table, where: 'id = ?', whereArgs: [id]);

    return {
      'success': true,
      'message': 'Rol eliminado correctamente'
    };
  }
}