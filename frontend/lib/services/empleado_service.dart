import '../database/db.dart';
import '../models/empleado.dart';

class EmpleadoService {
  final table = 'empleado';

  // Insertar nuevo empleado
  Future<int> crearEmpleado(Empleado empleado) async {
    final db = await AppDatabase.instance.database;
    return await db.insert(table, empleado.toMap());
  }

  // Listar todos
  Future<List<Empleado>> listarEmpleados() async {
    final db = await AppDatabase.instance.database;
    final result = await db.query(table);
    return result.map((e) => Empleado.fromMap(e)).toList();
  }

  // Actualizar (sirve para editar info o para cambiar la contraseña)
  Future<int> actualizarEmpleado(Empleado empleado) async {
    final db = await AppDatabase.instance.database;
    return await db.update(
      table,
      empleado.toMap(),
      where: 'id = ?',
      whereArgs: [empleado.id],
    );
  }

  // Login específico de empleado
  Future<Empleado?> login(String correo, String contrasena) async {
    final db = await AppDatabase.instance.database;
    final result = await db.query(
      table,
      where: 'correo = ? AND contrasena = ?',
      whereArgs: [correo, contrasena],
    );

    if (result.isNotEmpty) {
      return Empleado.fromMap(result.first);
    }
    return null;
  }
}