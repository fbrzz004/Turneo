import 'package:flutter/material.dart';
import '../models/calendario.dart';
import '../services/generador_horarios_service.dart';
import '../gerente/ver_calendario_screen.dart'; // La pantalla de detalle

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

  Future<void> _ejecutarAlgoritmo() async {
    setState(() => _generando = true);

    // Simulamos un pequeño delay para que se vea "pensando"
    await Future.delayed(const Duration(seconds: 2));

    await _generadorService.generarHorario(widget.calendario.id!);

    if (mounted) {
      setState(() {
        _generando = false;
        _generado = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // Ejecutamos automáticamente al entrar
    _ejecutarAlgoritmo();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (_generando) ...[
            const CircularProgressIndicator(),
            const SizedBox(height: 20),
            const Text("El algoritmo está optimizando los turnos..."),
          ] else if (_generado) ...[
            const Icon(Icons.check_circle, size: 60, color: Colors.green),
            const SizedBox(height: 20),
            const Text("¡Horario Generado con Éxito!", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            const Text("Hemos encontrado una distribución óptima para tu equipo."),
            const SizedBox(height: 40),

            // TARJETA DEL HORARIO (Simula la selección)
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VerCalendarioScreen(
                        calendario: widget.calendario,
                        isPublished: widget.calendario.estado == 1
                    ),
                  ),
                );
              },
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const Icon(Icons.calendar_month, size: 40, color: Colors.indigo),
                      const SizedBox(height: 10),
                      Text("Propuesta Automática", style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 5),
                      const Text("Basada en disponibilidad y roles"),
                      const SizedBox(height: 15),
                      const Chip(label: Text("Ver Detalle"), backgroundColor: Colors.indigo, labelStyle: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
            TextButton.icon(
              onPressed: _ejecutarAlgoritmo, // Regenerar
              icon: const Icon(Icons.refresh),
              label: const Text("Regenerar (Intentar otra combinación)"),
            )
          ]
        ],
      ),
    );
  }
}