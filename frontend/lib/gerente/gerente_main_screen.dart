import 'package:flutter/material.dart';
import 'package:turneo_horarios_app/ajustes/ajustes_screen.dart';
import 'empleados_screen.dart';
import 'mis_calendarios_screen.dart';
import '/crear_calendario/crear_calendario_screen.dart';
import 'roles_screen.dart';

class GerenteMainScreen extends StatefulWidget {
  final int initialIndex;
  
  const GerenteMainScreen({super.key, this.initialIndex = 1});

  @override
  State<GerenteMainScreen> createState() => _GerenteMainScreenState();
}

class _GerenteMainScreenState extends State<GerenteMainScreen> {
  late int _selectedIndex; // Start on the Calendar tab

  @override
  void initState(){
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  static const List<Widget> _widgetOptions = <Widget>[
    // La primera pestaña será la lista de empleados
    EmpleadosScreen(),
    // La segunda es el calendario que ya existía
    MisCalendariosScreen(),
    // La tercera es la pantalla de Roles
    RolesScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          _selectedIndex == 1 ? 'Mis Calendarios' : _selectedIndex == 0 ? 'Equipo' : 'Turnos y Roles',
          style: textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
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
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      floatingActionButton: _selectedIndex == 1
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CrearCalendarioScreen()),
                );
              },
              child: const Icon(Icons.add),
            )
          : null,
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
            selectedIcon: Icon(Icons.rule_folder),
            icon: Icon(Icons.rule_folder_outlined),
            label: 'Turnos',
          ),
        ],
      ),
    );
  }
}
