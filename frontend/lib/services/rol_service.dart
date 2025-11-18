import '../database/db.dart';
import '../models/rol.dart';

class RolService {
  final table = 'rol';

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

  // Opcional: Eliminar rol
  Future<int> eliminarRol(int id) async {
    final db = await AppDatabase.instance.database;
    return await db.delete(table, where: 'id = ?', whereArgs: [id]);
  }
}