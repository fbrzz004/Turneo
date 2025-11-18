import 'package:flutter/material.dart';
import 'turnos_screen.dart';

class CalendarioScreen extends StatefulWidget {
  const CalendarioScreen({super.key});

  @override
  State<CalendarioScreen> createState() => _CalendarioScreenState();
}

class _CalendarioScreenState extends State<CalendarioScreen> {
  // --- ESTADO ---
  // Esta vez, el índice seleccionado por defecto es 1 (Calendario)
  int _selectedIndex = 1; 

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      // 1. Fondo claro (consistente con la pantalla de turnos)
      backgroundColor: colorScheme.surface,
      
      // 2. AppBar (casi idéntica a la de Turnos)
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        // Título actualizado
        title: Text(
          'Mi Calendario',
          style: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: colorScheme.primaryContainer,
            foregroundColor: colorScheme.onPrimaryContainer,
            child: const Icon(Icons.person_outline), 
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings_outlined, color: colorScheme.onSurface),
            onPressed: () { /* TODO: Ajustes */ },
          ),
        ],
      ),
      
      // 3. Cuerpo de la pantalla
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 4. Contenedor del Calendario (Placeholder)
              // Usamos 'surfaceContainer' del tema M3
              Container(
                height: 400, // Ajusta la altura como necesites
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(16.0),
                  border: Border.all(
                    color: colorScheme.outline.withOpacity(0.2),
                  ),
                ),
                // TODO: Reemplazar este Center con tu widget de Calendario
                child: const Center(
                  child: Text('Aquí va el widget del calendario'),
                ),
              ),
              const SizedBox(height: 32.0),

              // 5. Botón de Descarga
              // Usamos FilledButton.icon para el icono
              FilledButton.icon(
                icon: const Icon(Icons.download_rounded),
                label: const Text('Descargar como PDF'),
                onPressed: () {
                  // TODO: Lógica para generar y descargar el PDF
                },
                style: FilledButton.styleFrom(
                  // Color personalizado del mockup (amarillo/oliva)
                  backgroundColor: const Color(0xFFa98e3b),
                  // Color del texto para que contraste
                  foregroundColor: Colors.white, 
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  textStyle: textTheme.titleMedium,
                ),
              ),
            ],
          ),
        ),
      ),
      
      // 6. Barra de Navegación Inferior (M3)
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index) {
          // --- ¡LÓGICA DE NAVEGACIÓN! ---
          if (index == 0) {
            // Si el índice es 0 (Turnos), navega a TurnosScreen
            // Usamos 'pushReplacement' para que no se apilen las pantallas
            Navigator.pushReplacement(
              context,
              // Usamos PageRouteBuilder para quitar la animación
              PageRouteBuilder(
                pageBuilder: (context, anim1, anim2) => const TurnosScreen(),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ),
            );
          } else {
            // Si ya está en 1 (Calendario), actualiza el estado
            setState(() {
              _selectedIndex = index;
            });
          }
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