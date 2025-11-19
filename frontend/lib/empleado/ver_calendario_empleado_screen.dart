import 'package:flutter/material.dart';
import '../empleado/turnos_screen.dart';
import 'package:turneo_horarios_app/ajustes/ajustes_screen.dart';

class VerCalendarioEmpleadoScreen extends StatelessWidget {
  // En esta pantalla el índice siempre es 1 (Calendario)
  final int selectedIndex = 1; 
  final bool isPublished;

  const VerCalendarioEmpleadoScreen({super.key, this.isPublished = false});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Mi Calendario',
          style: textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AjustesScreen()),
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
                  color: colorScheme.surfaceContainerHighest, // Actualizado a Material 3 estándar
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: const Center(
                  child: Text('Contenido del Calendario'),
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.download),
              label: const Text('Descargar como PDF'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
            )
          ],
        ),
      ),
      
      // AQUI ESTÁ EL BOTTOM NAVIGATION BAR INTEGRADO
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (int index) {
          // Si el usuario selecciona el índice 0 (Turnos), navegamos allí
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, anim1, anim2) => const TurnosScreen(),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ),
            );
          }
          // Si el index es 1, no hacemos nada porque ya estamos en Calendario
        },
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.person),
            icon: Icon(Icons.person_outline),
            label: 'Turnos',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.calendar_month),
            icon: Icon(Icons.calendar_month_outlined),
            label: 'Calendario',
          ),
        ],
      ),
    );
  }
}