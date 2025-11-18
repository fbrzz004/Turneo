import '../database/db.dart';
import '../models/gerente.dart';

class GerenteService {
  final table = 'gerente';

  Future<int> insertarGerente(Gerente gerente) async {
    final db = await AppDatabase.instance.database;
    return await db.insert(table, gerente.toMap());
  }

  Future<Gerente?> login(String correo, String contrasena) async {
    final db = await AppDatabase.instance.database;

    final result = await db.query(
      table,
      where: 'correo = ? AND contrasena = ?',
      whereArgs: [correo, contrasena],
    );

    if (result.isNotEmpty) {
      return Gerente.fromMap(result.first);
    }
    return null;
  }

  Future<List<Gerente>> listar() async {
    final db = await AppDatabase.instance.database;

    final result = await db.query(table);

    return result.map((m) => Gerente.fromMap(m)).toList();
  }
}