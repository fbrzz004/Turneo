import 'package:flutter/material.dart';
import 'package:turneo_horarios_app/models/turno.dart';

class DescripcionTurnoScreen extends StatelessWidget {
  final Turno turno;

  const DescripcionTurnoScreen({super.key, required this.turno});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Icon(Icons.blur_on, size: 32), // Placeholder for custom icon
        ),
        title: Text(
          turno.nombre,
          style: textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {},
          ),
        ],
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildInfoCard(
              context,
              children: [
                Text('Hora inicio: ${turno.horaInicio}'),
                const SizedBox(height: 8),
                Text('Hora fin: ${turno.horaFin}'),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoCard(
              context,
              title: 'Empleados requeridos',
              children: turno.empleadosRequeridos.entries
                  .map((entry) => Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text('${entry.key}: ${entry.value}'),
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, {String? title, required List<Widget> children}) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Card(
      elevation: 0,
      color: colorScheme.surfaceVariant.withOpacity(0.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (title != null) ...[
              Text(title, style: textTheme.titleLarge),
              const SizedBox(height: 16),
            ],
            ...children,
          ],
        ),
      ),
    );
  }
}
