import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:turneo_horarios_app/services/user_session.dart';
import '../database/db.dart';
import '../models/calendario.dart';
import '../ajustes/ajustes_screen.dart';
import 'turnos_screen.dart';

class VerCalendarioEmpleadoScreen extends StatefulWidget {
  const VerCalendarioEmpleadoScreen({super.key});

  @override
  State<VerCalendarioEmpleadoScreen> createState() => _VerCalendarioEmpleadoScreenState();
}

class _VerCalendarioEmpleadoScreenState extends State<VerCalendarioEmpleadoScreen> {
  int _selectedIndex = 1;
  bool _isLoading = true;
  Calendario? _calendarioPublicado;

  List<Map<String, dynamic>> _datosGrilla = [];
  List<String> _nombresDias = [];

  @override
  void initState() {
    super.initState();
    _cargarUltimoCalendarioPublicado();
  }

  Future<void> _cargarUltimoCalendarioPublicado() async {
    final db = await AppDatabase.instance.database;
    final empleadoId = UserSession().id; // Obtenemos ID del usuario actual

    if (empleadoId == null) return;

    // --- CORRECCIÓN 1: FILTRO DE PRIVACIDAD ---
    // Solo traemos calendarios Publicados (estado=1) DONDE el empleado esté en la lista de participantes
    final res = await db.rawQuery('''
      SELECT c.* 
      FROM calendario c
      JOIN calendario_participante cp ON c.id = cp.calendario_id
      WHERE c.estado = 1 AND cp.empleado_id = ?
      ORDER BY c.id DESC
      LIMIT 1
    ''', [empleadoId]);

    if (res.isNotEmpty) {
      final cal = Calendario.fromMap(res.first);
      await _cargarGrilla(cal);

      if (mounted) {
        setState(() {
          _calendarioPublicado = cal;
          _isLoading = false;
        });
      }
    } else {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _cargarGrilla(Calendario cal) async {
    final db = await AppDatabase.instance.database;

    final dias = await db.query('calendario_dia',
        where: 'calendario_id = ?', whereArgs: [cal.id], orderBy: 'fecha ASC');

    final turnos = await db.query('turno');

    final asignaciones = await db.rawQuery('''
      SELECT a.calendario_dia_id, a.turno_id, e.nombre
      FROM asignacion a
      JOIN empleado e ON a.empleado_id = e.id
      JOIN calendario_dia cd ON a.calendario_dia_id = cd.id
      WHERE cd.calendario_id = ?
    ''', [cal.id]);

    List<String> headers = dias.map((d) {
      DateTime date = DateTime.parse(d['fecha'] as String);
      // Asegúrate de tener configurado la localización en main.dart
      return DateFormat('EEEE d', 'es_ES').format(date);
    }).toList();

    List<Map<String, dynamic>> filas = [];

    for (var t in turnos) {
      Map<String, dynamic> fila = {};
      fila['nombre_turno'] = t['nombre'];
      fila['hora'] = "${t['hora_inicio']} - ${t['hora_fin']}";

      List<String> celdas = [];
      for (var d in dias) {
        int diaId = d['id'] as int;
        int turnoId = t['id'] as int;

        var empleadosEnTurno = asignaciones.where((a) =>
        a['calendario_dia_id'] == diaId && a['turno_id'] == turnoId);

        if (empleadosEnTurno.isEmpty) {
          celdas.add("-");
        } else {
          // --- CORRECCIÓN 2: EVITAR DUPLICADOS ---
          final nombresUnicos = empleadosEnTurno
              .map((e) => e['nombre'].toString())
              .toSet() // Elimina repetidos
              .toList();

          // Unir con saltos de línea para que salga uno debajo de otro
          celdas.add(nombresUnicos.join('\n'));
        }
      }
      fila['celdas'] = celdas;
      filas.add(fila);
    }

    _nombresDias = headers;
    _datosGrilla = filas;
  }

  Future<void> _generarPDF() async {
    if (_calendarioPublicado == null) return;

    final doc = pw.Document();
    doc.addPage(
      pw.Page(
        orientation: pw.PageOrientation.landscape,
        build: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Header(level: 0, child: pw.Text("Horario: ${_calendarioPublicado!.nombre}")),
              pw.SizedBox(height: 20),
              pw.Table.fromTextArray(
                headers: ['Turno', ..._nombresDias.map((d) => d.toUpperCase())],
                data: _datosGrilla.map((fila) => [
                  "${fila['nombre_turno']}\n${fila['hora']}",
                  ...fila['celdas'] // Aquí ya vienen sin duplicados gracias a _cargarGrilla
                ]).toList(),
                border: pw.TableBorder.all(),
                headerDecoration: const pw.BoxDecoration(color: PdfColors.indigo),
                headerStyle: const pw.TextStyle(color: PdfColors.white),
                cellAlignment: pw.Alignment.center,
                cellStyle: const pw.TextStyle(fontSize: 10),
              ),
            ],
          );
        },
      ),
    );
    await Printing.layoutPdf(onLayout: (format) => doc.save(), name: 'Mi_Horario.pdf');
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendario Actual'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AjustesScreen())),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _calendarioPublicado == null
          ? _buildEstadoVacio()
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
                _calendarioPublicado!.nombre,
                style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)
            ),
            const SizedBox(height: 16),

            // --- CORRECCIÓN 3: VISUALIZACIÓN EXPANDIBLE ---
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      // Permite que la fila crezca para mostrar todos los nombres
                      dataRowMaxHeight: double.infinity,
                      dataRowMinHeight: 60, // Altura mínima para que se vea bien

                      headingRowColor: MaterialStateProperty.all(colorScheme.primaryContainer),
                      columns: [
                        const DataColumn(label: Text("TURNO", style: TextStyle(fontWeight: FontWeight.bold))),
                        ..._nombresDias.map((dia) => DataColumn(
                            label: Text(dia.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold))
                        )),
                      ],
                      rows: _datosGrilla.map((fila) {
                        return DataRow(
                            cells: [
                              DataCell(Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(fila['nombre_turno'], style: const TextStyle(fontWeight: FontWeight.bold)),
                                    Text(fila['hora'], style: const TextStyle(fontSize: 10)),
                                  ],
                                ),
                              )),
                              ... (fila['celdas'] as List<String>).map((celda) => DataCell(
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                                    child: Text(celda, textAlign: TextAlign.center),
                                  )
                              )),
                            ]
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            ElevatedButton.icon(
              onPressed: _generarPDF,
              icon: const Icon(Icons.download),
              label: const Text('Descargar PDF'),
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
            ),
          ],
        ),
      ),

      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, anim1, anim2) => const TurnosScreen(),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ),
            );
          } else {
            setState(() => _selectedIndex = index);
          }
        },
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.person),
            icon: Icon(Icons.person_outline),
            label: 'Turnos',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.calendar_month),
            icon: Icon(Icons.calendar_month_outlined),
            label: 'Calendario',
          ),
        ],
      ),
    );
  }

  Widget _buildEstadoVacio() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.calendar_today_outlined, size: 60, color: Colors.grey),
            SizedBox(height: 16),
            Text("No tienes calendarios asignados.", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            SizedBox(height: 8),
            Text("Cuando el gerente publique un horario en el que participas, aparecerá aquí.", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}