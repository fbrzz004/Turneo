import 'package:flutter/material.dart';
import '../models/calendario.dart';
import '../services/generador_horarios_service.dart';
import '../gerente/ver_calendario_screen.dart'; // La pantalla de la grilla grande

class Paso4 extends StatefulWidget {
  final Calendario calendario;

  const Paso4({super.key, required this.calendario});

  @override
  State<Paso4> createState() => _Paso4State();
}

class _Paso4State extends State<Paso4> {
  final _generadorService = GeneradorHorariosService();
  bool _generando = false;
  bool _generado = false;

  @override
  void initState() {
    super.initState();
    _ejecutarAlgoritmo();
  }

  Future<void> _ejecutarAlgoritmo() async {
    setState(() {
      _generando = true;
      _generado = false; // Reseteamos estado visual
    });

    // Simulamos "pensando" para que el usuario vea que algo pasa
    await Future.delayed(const Duration(seconds: 2));

    // Corremos el algoritmo (sobreescribe la tabla asignacion)
    await _generadorService.generarHorario(widget.calendario.id!);

    if (mounted) {
      setState(() {
        _generando = false;
        _generado = true;
      });
    }
  }

  void _verDetalle() {
    // Navegamos a la pantalla grande
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VerCalendarioScreen(
          calendario: widget.calendario,
          isPublished: false, // Aún no está publicado, es modo "Previsualización"
        ),
      ),
    ).then((sePublico) {
      // TRUCO: Si en la otra pantalla le dio a "Publicar", regresará un true.
      // Si regresa true, cerramos todo el wizard de creación.
      if (sePublico == true && mounted) {
        Navigator.pop(context); // Cierra CrearCalendarioScreen
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (_generando) ...[
            const SizedBox(
              width: 60, height: 60,
              child: CircularProgressIndicator(strokeWidth: 6),
            ),
            const SizedBox(height: 32),
            Text("Optimizando turnos...", style: textTheme.titleLarge),
            const SizedBox(height: 8),
            const Text("Analizando disponibilidad y roles del personal."),
          ]
          else if (_generado) ...[
            const Icon(Icons.check_circle_outline, size: 80, color: Colors.green),
            const SizedBox(height: 16),
            Text("¡Propuesta Lista!", style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text("Hemos generado un horario óptimo para tu equipo."),
            const SizedBox(height: 48),

            // --- LA TARJETA QUE PIDES ---
            InkWell(
              onTap: _verDetalle,
              borderRadius: BorderRadius.circular(16),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: colorScheme.primary, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.primary.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: Row(
                  children: [
                    Icon(Icons.calendar_month, size: 48, color: colorScheme.primary),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.calendario.nombre,
                            style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          const Text("Toque para ver detalles, hacer zoom y aprobar.", style: TextStyle(fontSize: 12, color: Colors.grey)),
                        ],
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios, size: 16),
                  ],
                ),
              ),
            ),

            const Spacer(),

            // Botón para volver a intentar si no le gustó
            TextButton.icon(
              onPressed: _ejecutarAlgoritmo,
              icon: const Icon(Icons.refresh),
              label: const Text("No me gusta, regenerar otro"),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
            ),
          ]
        ],
      ),
    );
  }
}