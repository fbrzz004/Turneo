import '../database/db.dart';
import '../models/calendario.dart';

class GeneradorHorariosService {

  // Configuración de restricciones (Puedes hacerlas dinámicas luego)
  final int MAX_TURNOS_POR_DIA = 2;

  Future<void> generarHorario(int calendarioId) async {
    final db = await AppDatabase.instance.database;

    // 1. OBTENER DATOS
    // Días del calendario
    final dias = await db.query('calendario_dia',
        where: 'calendario_id = ?', whereArgs: [calendarioId], orderBy: 'fecha ASC');

    // Turnos disponibles (Definición)
    final turnosDef = await db.query('turno');

    // Disponibilidades (Lo que marcaron los empleados)
    // Hacemos un Join para traer datos útiles
    final disponibilidadesRaw = await db.rawQuery('''
      SELECT d.empleado_id, d.calendario_dia_id, d.turno_id, e.rol, e.nombre
      FROM disponibilidad d
      JOIN calendario_dia cd ON d.calendario_dia_id = cd.id
      JOIN empleado e ON d.empleado_id = e.id
      WHERE cd.calendario_id = ?
    ''', [calendarioId]);

    // Requerimientos por Turno (Turno_Rol)
    // Saber cuántos "Meseros" necesitamos por turno
    final requerimientosRaw = await db.rawQuery('''
      SELECT tr.turno_id, r.nombre as rol_nombre, tr.cantidad
      FROM turno_rol tr
      JOIN rol r ON tr.rol_id = r.id
    ''');

    // --- 2. PREPARAR ESTRUCTURAS (Adapta tu lógica JS) ---

    // Slots: Cada espacio que necesitamos llenar (Día - Turno - Rol - Puesto #1)
    List<Map<String, dynamic>> slots = [];

    for (var dia in dias) {
      for (var turno in turnosDef) {
        // Buscar qué roles necesita este turno
        final reqsTurno = requerimientosRaw.where((r) => r['turno_id'] == turno['id']);

        for (var req in reqsTurno) {
          int cantidad = req['cantidad'] as int;
          String rol = req['rol_nombre'] as String;

          for (int i = 0; i < cantidad; i++) {
            slots.push({
              'dia_id': dia['id'],
              'turno_id': turno['id'],
              'rol': rol,
              'slot_id': '${dia['id']}-${turno['id']}-$rol-$i'
            });
          }
        }
      }
    }

    // Variables de Tracking (para restricciones)
    // Map<EmpleadoID, Map<DiaID, int>> -> Cuántos turnos tiene tal empleado tal día
    Map<int, Map<int, int>> turnosPorDiaEmpleado = {};

    List<Map<String, dynamic>> asignacionesFinales = [];

    // --- 3. EJECUTAR GREEDY ---

    // Ordenamos slots (opcional: priorizar turnos difíciles)
    // En tu JS priorizabas noche, aquí lo haremos simple por orden de llegada por ahora

    for (var slot in slots) {
      int diaId = slot['dia_id'];
      int turnoId = slot['turno_id'];
      String rolNecesario = slot['rol'];

      // Buscar candidatos que:
      // a) Tengan ese Rol
      // b) Tengan disponibilidad marcada en ese Día y Turno
      var candidatos = disponibilidadesRaw.where((disp) {
        bool mismoRol = disp['rol'] == rolNecesario;
        bool disponible = disp['calendario_dia_id'] == diaId && disp['turno_id'] == turnoId;
        return mismoRol && disponible;
      }).toList();

      // Filtrar restricciones (Max turnos por día)
      candidatos = candidatos.where((c) {
        int empId = c['empleado_id'] as int;
        int turnosHoy = turnosPorDiaEmpleado[empId]?[diaId] ?? 0;
        return turnosHoy < MAX_TURNOS_POR_DIA;
      }).toList();

      // Ordenar candidatos (Menos carga de trabajo primero para equilibrar)
      // Aquí podríamos sumar carga total, por simplicidad usaremos random o el primero
      candidatos.shuffle();

      if (candidatos.isNotEmpty) {
        var elegido = candidatos.first;
        int empId = elegido['empleado_id'] as int;

        // Guardar asignación en memoria
        asignacionesFinales.add({
          'calendario_dia_id': diaId,
          'empleado_id': empId,
          'turno_id': turnoId
        });

        // Actualizar tracking
        if (!turnosPorDiaEmpleado.containsKey(empId)) {
          turnosPorDiaEmpleado[empId] = {};
        }
        int actuales = turnosPorDiaEmpleado[empId]![diaId] ?? 0;
        turnosPorDiaEmpleado[empId]![diaId] = actuales + 1;
      } else {
        print("⚠️ No se pudo llenar el slot: ${slot['slot_id']}");
      }
    }

    // --- 4. GUARDAR RESULTADOS EN BD ---
    final batch = db.batch();

    // Limpiar asignaciones previas si hubieran (para regenerar)
    // Primero obtenemos IDs de dias de este calendario
    List<int> idsDias = dias.map((d) => d['id'] as int).toList();
    if(idsDias.isNotEmpty) {
      String idsString = idsDias.join(',');
      db.rawDelete('DELETE FROM asignacion WHERE calendario_dia_id IN ($idsString)');
    }

    for (var asig in asignacionesFinales) {
      batch.insert('asignacion', asig);
    }

    // IMPORTANTE: No cambiamos el estado a 1 todavía.
    // El estado 1 (Publicado) se pone cuando el gerente le da "Publicar".

    await batch.commit();
  }
}

// Extensión simple para listas (como en JS)
extension ListExtension on List {
  void push(dynamic item) => add(item);
}