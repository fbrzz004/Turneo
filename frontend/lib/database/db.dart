import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AppDatabase {
  static final AppDatabase instance = AppDatabase._init();
  static Database? _database;

  AppDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('empresa_v2.db'); // Cambié el nombre para forzar actualización
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final fullPath = join(dbPath, filePath);

    return await openDatabase(
      fullPath,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    // 1. Gerente
    await db.execute('''
      CREATE TABLE gerente (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT NOT NULL,
        correo TEXT UNIQUE NOT NULL,
        contrasena TEXT NOT NULL
      )
    ''');

    // 2. Rol
    await db.execute('''
      CREATE TABLE rol (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT UNIQUE NOT NULL
      )
    ''');

    // 3. Turno
    await db.execute('''
      CREATE TABLE turno (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT NOT NULL,
        hora_inicio TEXT NOT NULL,
        hora_fin TEXT NOT NULL
      )
    ''');

    // 4. Turno_Rol
    await db.execute('''
      CREATE TABLE turno_rol (
        turno_id INTEGER,
        rol_id INTEGER,
        cantidad INTEGER,
        PRIMARY KEY (turno_id, rol_id),
        FOREIGN KEY (turno_id) REFERENCES turno (id) ON DELETE CASCADE,
        FOREIGN KEY (rol_id) REFERENCES rol (id) ON DELETE CASCADE
      )
    ''');

    // 5. Empleado
    await db.execute('''
      CREATE TABLE empleado (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT NOT NULL,
        correo TEXT UNIQUE NOT NULL,
        contrasena TEXT NOT NULL,
        rol TEXT NOT NULL,
        estado TEXT DEFAULT 'PENDIENTE'
      )
    ''');
  }
}