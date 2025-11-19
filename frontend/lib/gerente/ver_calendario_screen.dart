import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:turneo_horarios_app/database/db.dart';
import '../models/calendario.dart';
import '../ajustes/ajustes_screen.dart';
import 'gerente_main_screen.dart';

class VerCalendarioScreen extends StatefulWidget {
  final Calendario calendario;
  final bool isPublished;

  const VerCalendarioScreen({
    super.key,
    required this.calendario,
    this.isPublished = false
  });

  @override
  State<VerCalendarioScreen> createState() => _VerCalendarioScreenState();
}

class _VerCalendarioScreenState extends State<VerCalendarioScreen> {
  List<Map<String, dynamic>> _datosGrilla = [];
  List<String> _nombresDias = [];
  List<String> _nombresTurnos = [];
  bool _isLoading = true;
  bool _publicadoLocalmente = false;

  @override
  void initState() {
    super.initState();
    _publicadoLocalmente = widget.isPublished;
    _cargarGrilla();
  }

  Future<void> _cargarGrilla() async {
    final db = await AppDatabase.instance.database;

    // 1. Obtener Días
    final dias = await db.query('calendario_dia',
        where: 'calendario_id = ?',
        whereArgs: [widget.calendario.id],
        orderBy: 'fecha ASC');

    // 2. Obtener Turnos (Todos los definidos)
    final turnos = await db.query('turno');

    // 3. Obtener Asignaciones
    final asignaciones = await db.rawQuery('''
      SELECT a.calendario_dia_id, a.turno_id, e.nombre, e.rol
      FROM asignacion a
      JOIN empleado e ON a.empleado_id = e.id
      JOIN calendario_dia cd ON a.calendario_dia_id = cd.id
      WHERE cd.calendario_id = ?
    ''', [widget.calendario.id]);

    // --- PROCESAR DATOS PARA LA TABLA ---

    // Encabezados de Columnas (Días)
    List<String> headers = dias.map((d) {
      DateTime date = DateTime.parse(d['fecha'] as String);
      return DateFormat('EEEE d', 'es_ES').format(date);
    }).toList();

    // Filas (Turnos)
    List<Map<String, dynamic>> filas = [];

    for (var t in turnos) {
      Map<String, dynamic> fila = {};
      fila['nombre_turno'] = t['nombre'];
      fila['hora'] = "${t['hora_inicio']} - ${t['hora_fin']}";

      // Celdas por día
      List<String> celdas = [];
      for (var d in dias) {
        int diaId = d['id'] as int;
        int turnoId = t['id'] as int;

        // Buscar empleados asignados a este cruce
        var empleadosEnTurno = asignaciones.where((a) =>
        a['calendario_dia_id'] == diaId && a['turno_id'] == turnoId);

        if (empleadosEnTurno.isEmpty) {
          celdas.add("-");
        } else {
          // Crear string con saltos de línea: "Juan\nPedro"
          celdas.add(empleadosEnTurno.map((e) => e['nombre']).join('\n'));
        }
      }
      fila['celdas'] = celdas;
      filas.add(fila);
    }

    if (mounted) {
      setState(() {
        _nombresDias = headers;
        _datosGrilla = filas;
        _isLoading = false;
      });
    }
  }

  Future<void> _publicarCalendario() async {
    final db = await AppDatabase.instance.database;
    // Cambiar estado a 1 (Completado/Publicado)
    await db.update('calendario', {'estado': 1},
        where: 'id = ?', whereArgs: [widget.calendario.id]);

    setState(() {
      _publicadoLocalmente = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("¡Calendario Publicado! Ahora los empleados pueden verlo."), backgroundColor: Colors.green)
    );
  }

  // --- GENERACIÓN DE PDF ---
  Future<void> _generarPDF() async {
    final doc = pw.Document();

    doc.addPage(
      pw.Page(
        orientation: pw.PageOrientation.landscape, // Mejor horizontal para horarios
        build: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Header(
                level: 0,
                child: pw.Text("Horario: ${widget.calendario.nombre}", style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              ),
              pw.SizedBox(height: 20),
              pw.Table.fromTextArray(
                headers: ['Turno / Hora', ..._nombresDias.map((d) => d.toUpperCase())],
                data: _datosGrilla.map((fila) {
                  return [
                    "${fila['nombre_turno']}\n${fila['hora']}", // Primera columna
                    ...fila['celdas'] // Resto de columnas
                  ];
                }).toList(),
                border: pw.TableBorder.all(),
                headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white),
                headerDecoration: const pw.BoxDecoration(color: PdfColors.indigo),
                cellAlignment: pw.Alignment.center,
                cellStyle: const pw.TextStyle(fontSize: 10),
              ),
              pw.SizedBox(height: 20),
              pw.Text("Generado por Turneo App", style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey)),
            ],
          );
        },
      ),
    );

    // Abrir vista previa / guardar
    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => doc.save(),
        name: 'Horario_${widget.calendario.nombre}.pdf'
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.calendario.nombre, style: textTheme.headlineSmall),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AjustesScreen())),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // --- GRILLA DE HORARIO ---
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Container(
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
                                  Text(fila['hora'], style: textTheme.bodySmall),
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

            const SizedBox(height: 24),

            // --- ESTADO Y BOTONES ---
            if (_publicadoLocalmente) ...[
              Text(
                'El calendario fue publicado y es visible para los trabajadores.',
                textAlign: TextAlign.center,
                style: textTheme.bodyLarge?.copyWith(color: Colors.green, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
            ],

            ElevatedButton.icon(
              onPressed: _isLoading ? null : _generarPDF,
              icon: const Icon(Icons.picture_as_pdf),
              label: const Text('Descargar / Imprimir PDF'),
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
            ),

            if (!_publicadoLocalmente) ...[
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _isLoading ? null : _publicarCalendario,
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Publicar Calendario'),
              ),
            ],
          ],
        ),
      ),
      // ... BottomNavigationBar (Si lo necesitas, aunque esta pantalla suele ser full screen)
    );
  }
}