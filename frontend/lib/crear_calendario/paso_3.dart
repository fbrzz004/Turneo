import 'package:flutter/material.dart';
import '../services/calendario_service.dart';
import '../models/calendario.dart';

class Paso3 extends StatefulWidget {
  final Calendario calendario;
  final VoidCallback onGenerarPresionado; // Para ir al Paso 4

  const Paso3({
    super.key,
    required this.calendario,
    required this.onGenerarPresionado,
  });

  @override
  State<Paso3> createState() => _Paso3State();
}

class _Paso3State extends State<Paso3> {
  final _calendarioService = CalendarioService();
  List<Map<String, dynamic>> _participantes = [];
  bool _isLoading = true;
  int _totalContestados = 0;

  @override
  void initState() {
    super.initState();
    _cargarEstado();
  }

  Future<void> _cargarEstado() async {
    final lista = await _calendarioService.obtenerParticipantesConEstado(widget.calendario.id!);

    int contestados = lista.where((p) => p['respondio'] == true).length;

    if (mounted) {
      setState(() {
        _participantes = lista;
        _totalContestados = contestados;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final todosRespondieron = _participantes.isNotEmpty && _totalContestados == _participantes.length;

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('Monitoreo de Respuestas', style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('$_totalContestados de ${_participantes.length} empleados han respondido.'),

          const SizedBox(height: 16),
          // Botón para refrescar manualmente (útil en desarrollo local)
          TextButton.icon(
            onPressed: _cargarEstado,
            icon: const Icon(Icons.refresh),
            label: const Text("Actualizar estado"),
          ),

          const SizedBox(height: 24),

          if (_participantes.isEmpty)
            const Text("No hay participantes en este calendario."),

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.2,
            ),
            itemCount: _participantes.length,
            itemBuilder: (context, index) {
              final p = _participantes[index];
              final bool respondio = p['respondio'];

              return _buildEmployeeCard(
                  context,
                  p['nombre'],
                  p['rol'],
                  respondio ? 'Contestado' : 'Pendiente',
                  respondio ? Colors.green : Colors.grey
              );
            },
          ),

          const SizedBox(height: 32),

          // Botón Generar (Se activa idealmente cuando todos responden, o cuando el gerente quiera)
          ElevatedButton.icon(
            onPressed: todosRespondieron ? widget.onGenerarPresionado : null,
            // Nota: Si quieres permitir generar aunque falten, quita el null y pon widget.onGenerarPresionado
            style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white
            ),
            icon: const Icon(Icons.auto_awesome),
            label: const Text('GENERAR HORARIO'),
          ),

          if (!todosRespondieron)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                "Espera a que todos respondan para generar.",
                style: textTheme.bodySmall?.copyWith(color: Colors.grey),
              ),
            ),

          const SizedBox(height: 24),
          TextButton(
            onPressed: () {
              // Lógica para borrar o cancelar (opcional)
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Volver'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmployeeCard(BuildContext context, String name, String role, String status, Color statusColor) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: BorderSide(
          color: statusColor == Colors.green ? Colors.green : Colors.transparent,
          width: 2,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person, size: 40, color: statusColor),
            const SizedBox(height: 8),
            Text(name, textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis),
            Text(role, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                status,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: statusColor, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}