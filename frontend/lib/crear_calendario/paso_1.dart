import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Necesitas agregar intl en pubspec.yaml

class Paso1 extends StatefulWidget {
  final TextEditingController nombreController;
  final List<DateTime> fechasSeleccionadas;
  final Function(List<DateTime>) onFechasChanged;

  const Paso1({
    super.key,
    required this.nombreController,
    required this.fechasSeleccionadas,
    required this.onFechasChanged,
  });

  @override
  State<Paso1> createState() => _Paso1State();
}

class _Paso1State extends State<Paso1> {

  Future<void> _seleccionarFecha(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      // Evitar duplicados
      if (!widget.fechasSeleccionadas.any((f) => isSameDay(f, picked))) {
        final nuevasFechas = List<DateTime>.from(widget.fechasSeleccionadas)..add(picked);
        // Ordenar cronológicamente
        nuevasFechas.sort();
        widget.onFechasChanged(nuevasFechas);
      }
    }
  }

  void _eliminarFecha(int index) {
    final nuevasFechas = List<DateTime>.from(widget.fechasSeleccionadas)..removeAt(index);
    widget.onFechasChanged(nuevasFechas);
  }

  bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Nombre del Calendario', style: textTheme.titleMedium),
          const SizedBox(height: 8),
          TextField(
            controller: widget.nombreController,
            decoration: InputDecoration(
              hintText: 'ej. Semana 1 Noviembre',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
            ),
          ),
          const SizedBox(height: 24),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Días a laborar', style: textTheme.titleMedium),
              TextButton.icon(
                onPressed: () => _seleccionarFecha(context),
                icon: const Icon(Icons.add_circle_outline),
                label: const Text("Agregar Día"),
              )
            ],
          ),
          const SizedBox(height: 8),

          if (widget.fechasSeleccionadas.isEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange.withOpacity(0.3))
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.orange),
                  SizedBox(width: 8),
                  Text("Selecciona los días para este horario."),
                ],
              ),
            ),

          // Lista de fechas seleccionadas
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.fechasSeleccionadas.length,
            itemBuilder: (context, index) {
              final fecha = widget.fechasSeleccionadas[index];
              // Formatear fecha: "Lunes, 20 de Noviembre"
              final nombreDia = DateFormat('EEEE d', 'es_ES').format(fecha);
              // Nota: Necesitas configurar localizaciones en main.dart o usar 'en_US' si no quieres liar con intl

              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                    child: Text('${index + 1}'),
                  ),
                  title: Text(nombreDia.toUpperCase()), // Ej. LUNES 20
                  subtitle: Text(DateFormat('yyyy-MM-dd').format(fecha)),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _eliminarFecha(index),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}