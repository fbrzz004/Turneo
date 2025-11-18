import 'package:flutter/material.dart';

class Paso4 extends StatelessWidget {
  const Paso4({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '¡Calendarios generados!',
            style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text('Seleccione el que desee.'),
          const SizedBox(height: 24),
          Container(
            height: 200,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.green, width: 2),
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: const Center(child: Text('Calendario Sugerido 1')),
          ),
          const SizedBox(height: 16),
          Container(
            height: 200,
            decoration: BoxDecoration(
              border: Border.all(color: colorScheme.outline.withOpacity(0.5)),
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: const Center(child: Text('Calendario Sugerido 2')),
          ),
        ],
      ),
    );
  }
}