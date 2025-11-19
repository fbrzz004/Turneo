import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AppDatabase {
  static final AppDatabase instance = AppDatabase._init();
  static Database? _database;

  AppDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('empresa_v3.db');
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
    // --- TABLAS EXISTENTES ---
    await db.execute('''
      CREATE TABLE gerente (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT NOT NULL,
        correo TEXT UNIQUE NOT NULL,
        contrasena TEXT NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE rol (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT UNIQUE NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE turno (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT NOT NULL,
        hora_inicio TEXT NOT NULL,
        hora_fin TEXT NOT NULL
      )
    ''');
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

    // --- NUEVAS TABLAS PARA EL ALGORITMO ---

    // 1. CALENDARIO: Agrupa todo (Ej. "Semana 1 Noviembre")
    // Estado: 0 = Borrador/Abierto, 1 = Cerrado/Generado
    await db.execute('''
      CREATE TABLE calendario (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT NOT NULL,
        fecha_creacion TEXT NOT NULL,
        estado INTEGER DEFAULT 0 
      )
    ''');

    // 2. DÍAS DEL CALENDARIO: Qué fechas específicas abarca (Ej. 2023-11-20)
    await db.execute('''
      CREATE TABLE calendario_dia (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        calendario_id INTEGER NOT NULL,
        fecha TEXT NOT NULL, -- Formato ISO8601 (YYYY-MM-DD)
        FOREIGN KEY (calendario_id) REFERENCES calendario (id) ON DELETE CASCADE
      )
    ''');

    // 3. PARTICIPANTES: Qué empleados fueron invitados a llenar disponibilidad
    await db.execute('''
      CREATE TABLE calendario_participante (
        calendario_id INTEGER NOT NULL,
        empleado_id INTEGER NOT NULL,
        PRIMARY KEY (calendario_id, empleado_id),
        FOREIGN KEY (calendario_id) REFERENCES calendario (id) ON DELETE CASCADE,
        FOREIGN KEY (empleado_id) REFERENCES empleado (id) ON DELETE CASCADE
      )
    ''');

    // 4. DISPONIBILIDAD: La respuesta del empleado (INPUT para el algoritmo)
    // "Juan puede trabajar el Día X en el Turno Y"
    await db.execute('''
      CREATE TABLE disponibilidad (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        calendario_dia_id INTEGER NOT NULL,
        empleado_id INTEGER NOT NULL,
        turno_id INTEGER NOT NULL,
        FOREIGN KEY (calendario_dia_id) REFERENCES calendario_dia (id) ON DELETE CASCADE,
        FOREIGN KEY (empleado_id) REFERENCES empleado (id) ON DELETE CASCADE,
        FOREIGN KEY (turno_id) REFERENCES turno (id) ON DELETE CASCADE
      )
    ''');

    // 5. ASIGNACIÓN: El resultado final (OUTPUT del algoritmo)
    // "Juan FUE ASIGNADO al Día X en el Turno Y"
    await db.execute('''
      CREATE TABLE asignacion (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        calendario_dia_id INTEGER NOT NULL,
        empleado_id INTEGER NOT NULL,
        turno_id INTEGER NOT NULL,
        FOREIGN KEY (calendario_dia_id) REFERENCES calendario_dia (id) ON DELETE CASCADE,
        FOREIGN KEY (empleado_id) REFERENCES empleado (id) ON DELETE CASCADE,
        FOREIGN KEY (turno_id) REFERENCES turno (id) ON DELETE CASCADE
      )
    ''');
  }
}