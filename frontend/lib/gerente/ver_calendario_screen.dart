import 'package:flutter/material.dart';
import './../ajustes/ajustes_screen.dart';
import './gerente_main_screen.dart';

class VerCalendarioScreen extends StatefulWidget {
  final bool isPublished;

  const VerCalendarioScreen({super.key, this.isPublished = false});

  @override
  State<VerCalendarioScreen> createState() => _VerCalendarioScreenState();
}

class _VerCalendarioScreenState extends State<VerCalendarioScreen> {
  final int _selectedIndex = 1;

  void _onItemTapped(int index){
    if (index == _selectedIndex) {
      return;
    }

    Navigator.pushAndRemoveUntil(context,
    MaterialPageRoute(builder: (context) => GerenteMainScreen(initialIndex: index),), (Route<dynamic> route) => false,);
  }


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
            if (widget.isPublished)
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
            if (!widget.isPublished) ...[
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
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: _onItemTapped,
        indicatorColor: Theme.of(context).colorScheme.primaryContainer,
        selectedIndex: _selectedIndex, // Mantiene seleccionado el ícono de calendario
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.people),
            icon: Icon(Icons.people_outline),
            label: 'Equipo',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.calendar_today),
            icon: Icon(Icons.calendar_today_outlined),
            label: 'Calendario',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.rule_folder),
            icon: Icon(Icons.rule_folder_outlined),
            label: 'Turnos',
          ),
        ],
      ),
    );
  }
}