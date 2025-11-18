import 'package:flutter/material.dart';
import 'package:turneo_horarios_app/gerente/agregar_turno_screen.dart';
import 'package:turneo_horarios_app/gerente/descripcion_turno_screen.dart';
import 'package:turneo_horarios_app/models/rol.dart';
import 'package:turneo_horarios_app/models/turno.dart';

class RolesScreen extends StatefulWidget {
  const RolesScreen({super.key});

  @override
  State<RolesScreen> createState() => _RolesScreenState();
}

class _RolesScreenState extends State<RolesScreen> {
  final List<Turno> _turnos = [
    Turno(
      nombre: 'Turno Mañana',
      horaInicio: '8:00 am',
      horaFin: '12:00 pm',
      empleadosRequeridos: {'Meseros': 9, 'Cocineros': 10},
    ),
    Turno(
      nombre: 'Turno Tarde',
      horaInicio: '2:00 pm',
      horaFin: '6:00 pm',
      empleadosRequeridos: {'Meseros': 10, 'Cocineros': 12},
    ),
    Turno(
      nombre: 'Turno Noche',
      horaInicio: '10:00 pm',
      horaFin: '6:00 am',
      empleadosRequeridos: {'Bartenders': 5, 'Cocineros': 8},
    ),
    Turno(
      nombre: 'Turno Diurno',
      horaInicio: '10:00 am',
      horaFin: '02:00 am',
      empleadosRequeridos: {'Meseros': 8, 'Bartenders': 4},
    ),
  ];

  final List<Rol> _roles = [
    Rol(nombre: 'Mesero'),
    Rol(nombre: 'Cocinero'),
    Rol(nombre: 'Bartenders'),
  ];

  void _agregarTurno(Turno turno) {
    setState(() {
      _turnos.add(turno);
    });
  }

  void _navigateToAgregarTurno() {
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => AgregarTurnoScreen(
              onTurnoCreado: _agregarTurno, roles: _roles)),
    );
  }

  void _navigateToDescripcionTurno(Turno turno) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DescripcionTurnoScreen(turno: turno),
      ),
    );
  }

  void _showAgregarRolDialog() {
    final TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Agregar Rol'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: "ej. Bartenders"),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Guardar'),
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  setState(() {
                    _roles.add(Rol(nombre: controller.text));
                  });
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Icon(Icons.blur_on, size: 32),
        ),
        title: Text(
          'Mis turnos',
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
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.secondaryContainer,
                foregroundColor: colorScheme.onSecondaryContainer,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Generar enlace'),
            ),
            const SizedBox(height: 24),
            ..._turnos.map((turno) => _buildTurnoCard(context, turno)),
            const SizedBox(height: 24),
            Text(
              'Roles',
              style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ..._roles.asMap().entries.map((entry) {
              int idx = entry.key;
              Rol rol = entry.value;
              return _buildRolCard(context, rol, idx + 1);
            }),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton.extended(
            onPressed: _navigateToAgregarTurno,
            label: const Text('Agregar Turno'),
            icon: const Icon(Icons.add),
            heroTag: 'agregarTurno',
          ),
          const SizedBox(height: 16),
          FloatingActionButton.extended(
            onPressed: _showAgregarRolDialog,
            label: const Text('Agregar Rol'),
            icon: const Icon(Icons.add),
            heroTag: 'agregarRol',
          ),
        ],
      ),
    );
  }

  Widget _buildTurnoCard(BuildContext context, Turno turno) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return GestureDetector(
      onTap: () => _navigateToDescripcionTurno(turno),
      child: Card(
        elevation: 0,
        color: colorScheme.surfaceVariant.withOpacity(0.5),
        margin: const EdgeInsets.only(bottom: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(turno.nombre, style: textTheme.titleLarge),
              const SizedBox(height: 8),
              Text('Hora inicio: ${turno.horaInicio}'),
              Text('Hora fin: ${turno.horaFin}'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRolCard(BuildContext context, Rol rol, int index) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Card(
      elevation: 0,
      color: colorScheme.surfaceVariant.withOpacity(0.5),
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: colorScheme.secondaryContainer,
              child: Text('$index',
                  style:
                      TextStyle(color: colorScheme.onSecondaryContainer)),
            ),
            const SizedBox(width: 16),
            Expanded(child: Text(rol.nombre, style: textTheme.titleMedium)),
            IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
          ],
        ),
      ),
    );
  }
}
