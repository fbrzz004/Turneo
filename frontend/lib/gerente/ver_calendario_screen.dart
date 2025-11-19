import 'package:flutter/material.dart';
import 'package:turneo_horarios_app/ajustes/ajustes_screen.dart';

class VerCalendarioScreen extends StatelessWidget {
  final bool isPublished;

  const VerCalendarioScreen({super.key, this.isPublished = false});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Calendario 1', style: textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => const AjustesScreen()
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: colorScheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: const Center(
                  child: Text('Contenido del Calendario'),
                ),
              ),
            ),
            const SizedBox(height: 24),
            if (isPublished)
              Text(
                'El calendario fue publicado y visible para los trabajadores seleccionados.',
                textAlign: TextAlign.center,
                style: textTheme.bodyLarge?.copyWith(color: Colors.green),
              ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.download),
              label: const Text('Descargar como PDF'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
            if (!isPublished) ...[
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {},
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
    );
  }
}