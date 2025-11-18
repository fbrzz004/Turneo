import 'package:flutter/material.dart';
import 'empleados_screen.dart';
import 'calendario_screen.dart';
import 'roles_screen.dart';

class GerenteMainScreen extends StatefulWidget {
  const GerenteMainScreen({super.key});

  @override
  State<GerenteMainScreen> createState() => _GerenteMainScreenState();
}

class _GerenteMainScreenState extends State<GerenteMainScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    // La primera pestaña será la lista de empleados
    EmpleadosScreen(),
    // La segunda es el calendario que ya existía
    CalendarioScreen(),
    // La tercera es un placeholder por ahora
    RolesScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: _onItemTapped,
        indicatorColor: Theme.of(context).colorScheme.primaryContainer,
        selectedIndex: _selectedIndex,
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
            selectedIcon: Icon(Icons.settings),
            icon: Icon(Icons.settings_outlined),
            label: 'Roles',
          ),
        ],
      ),
    );
  }
}