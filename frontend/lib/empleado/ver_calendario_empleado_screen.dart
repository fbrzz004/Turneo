import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
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
  int _selectedIndex = 1; // Estamos en la pestaña Calendario
  bool _isLoading = true;
  Calendario? _calendarioPublicado;

  // Variables para la grilla (Idénticas al gerente)
  List<Map<String, dynamic>> _datosGrilla = [];
  List<String> _nombresDias = [];

  @override
  void initState() {
    super.initState();
    _cargarUltimoCalendarioPublicado();
  }

  Future<void> _cargarUltimoCalendarioPublicado() async {
    final db = await AppDatabase.instance.database;

    // 1. Buscar el último calendario con estado 1 (Publicado)
    final res = await db.query('calendario',
        where: 'estado = ?',
        whereArgs: [1],
        orderBy: 'id DESC',
        limit: 1
    );

    if (res.isNotEmpty) {
      final cal = Calendario.fromMap(res.first);

      // 2. Cargar la grilla (Misma lógica que el gerente)
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

    // Obtener Días
    final dias = await db.query('calendario_dia',
        where: 'calendario_id = ?', whereArgs: [cal.id], orderBy: 'fecha ASC');

    // Obtener Turnos
    final turnos = await db.query('turno');

    // Obtener Asignaciones
    final asignaciones = await db.rawQuery('''
      SELECT a.calendario_dia_id, a.turno_id, e.nombre
      FROM asignacion a
      JOIN empleado e ON a.empleado_id = e.id
      JOIN calendario_dia cd ON a.calendario_dia_id = cd.id
      WHERE cd.calendario_id = ?
    ''', [cal.id]);

    // Construir Cabeceras
    List<String> headers = dias.map((d) {
      DateTime date = DateTime.parse(d['fecha'] as String);
      return DateFormat('EEEE d', 'es_ES').format(date);
    }).toList();

    // Construir Filas
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
          celdas.add(empleadosEnTurno.map((e) => e['nombre']).join('\n'));
        }
      }
      fila['celdas'] = celdas;
      filas.add(fila);
    }

    _nombresDias = headers;
    _datosGrilla = filas;
  }

  // --- PDF (Igual que el gerente, el empleado también puede querer descargarlo) ---
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
                  ...fila['celdas']
                ]).toList(),
                border: pw.TableBorder.all(),
                headerDecoration: const pw.BoxDecoration(color: PdfColors.indigo),
                headerStyle: const pw.TextStyle(color: PdfColors.white),
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
            // Título del calendario
            Text(
                _calendarioPublicado!.nombre,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)
            ),
            const SizedBox(height: 16),

            // LA GRILLA (Idéntica visualmente)
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
                              DataCell(Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(fila['nombre_turno'], style: const TextStyle(fontWeight: FontWeight.bold)),
                                  Text(fila['hora'], style: const TextStyle(fontSize: 10)),
                                ],
                              )),
                              ... (fila['celdas'] as List<String>).map((celda) => DataCell(
                                  Container(
                                    padding: const EdgeInsets.symmetric(vertical: 8),
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

            // Botón PDF
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
            // Ir a Turnos
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.calendar_today_outlined, size: 60, color: Colors.grey),
          SizedBox(height: 16),
          Text("No hay calendarios publicados aún."),
        ],
      ),
    );
  }
}