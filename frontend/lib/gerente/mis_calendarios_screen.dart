import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/calendario_service.dart';
import '../models/calendario.dart';
import '../crear_calendario/crear_calendario_screen.dart';
import 'ver_calendario_screen.dart';

class MisCalendariosScreen extends StatefulWidget {
  const MisCalendariosScreen({super.key});

  @override
  State<MisCalendariosScreen> createState() => _MisCalendariosScreenState();
}

class _MisCalendariosScreenState extends State<MisCalendariosScreen> {
  final _calendarioService = CalendarioService();
  List<Calendario> _calendarios = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _cargarCalendarios();
  }

  Future<void> _cargarCalendarios() async {
    final lista = await _calendarioService.listarCalendarios();
    if (mounted) {
      setState(() {
        _calendarios = lista;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Center(child: CircularProgressIndicator());

    if (_calendarios.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.calendar_today, size: 60, color: Colors.grey),
            SizedBox(height: 16),
            Text("No has creado calendarios aún."),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _cargarCalendarios,
      child: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _calendarios.length,
        itemBuilder: (context, index) {
          final cal = _calendarios[index];
          final esCompletado = cal.estado == 1; // 1 = Publicado

          return _buildCalendarItem(
            context,
            cal,
            esCompletado ? "Completado" : "En Espera",
            esCompletado ? const Color(0xFF86EFAC) : const Color(0xFFFDE047),
          );
        },
      ),
    );
  }

  Widget _buildCalendarItem(BuildContext context, Calendario cal, String statusLabel, Color statusColor) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () {
        if (cal.estado == 0) {
          // CASO A: EN ESPERA -> Vamos al flujo de creación (Paso 3)
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CrearCalendarioScreen(calendarioExistente: cal),
            ),
          ).then((_) => _cargarCalendarios());
        } else {
          // CASO B: COMPLETADO -> Vamos a VerCalendarioScreen (Modo Solo Lectura)
          // ¡AQUÍ ESTÁ EL CAMBIO! Usamos la misma pantalla.
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VerCalendarioScreen(
                  calendario: cal,
                  isPublished: true // <--- Esto oculta el botón de publicar
              ),
            ),
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              child: Text("${cal.id}"),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(cal.nombre, style: textTheme.titleMedium),
                  Text(
                    DateFormat('dd/MM/yyyy').format(cal.fechaCreacion),
                    style: textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.5),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                statusLabel,
                style: textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}