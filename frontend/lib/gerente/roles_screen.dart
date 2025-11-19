import 'package:flutter/material.dart';
import 'package:turneo_horarios_app/gerente/agregar_turno_screen.dart';
import 'package:turneo_horarios_app/gerente/descripcion_turno_screen.dart';
import 'package:turneo_horarios_app/models/rol.dart';
import 'package:turneo_horarios_app/models/turno.dart';
import 'package:turneo_horarios_app/services/rol_service.dart';
import 'package:turneo_horarios_app/services/turno_service.dart';

class RolesScreen extends StatefulWidget {
  const RolesScreen({super.key});

  @override
  State<RolesScreen> createState() => _RolesScreenState();
}

class _RolesScreenState extends State<RolesScreen> {
  final _rolService = RolService();
  final _turnoService = TurnoService();

  List<Turno> _turnos = [];
  List<Rol> _roles = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    setState(() => _isLoading = true);
    final roles = await _rolService.listarRoles();
    final turnos = await _turnoService.listarTurnos();

    if(mounted) {
      setState(() {
        _roles = roles;
        _turnos = turnos;
        _isLoading = false;
      });
    }
  }

  // --- Lógica de Roles ---
  Future<void> _agregarRol(String nombre) async {
    if (nombre.isNotEmpty) {
      await _rolService.crearRol(Rol(nombre: nombre));
      _cargarDatos();
    }
  }

  Future<void> _eliminarRol(Rol rol) async {
    if (rol.id != null) {
      await _rolService.eliminarRol(rol.id!); // Asegúrate de tener este método en RolService
      _cargarDatos();
    }
  }

  // --- Lógica de Turnos ---
  Future<void> _agregarTurno(Turno turno) async {
    await _turnoService.insertarTurno(turno);
    _cargarDatos();
  }

  Future<void> _eliminarTurno(Turno turno) async {
    if (turno.id != null) {
      await _turnoService.eliminarTurno(turno.id!);
      _cargarDatos();
    }
  }

  // --- Navegación ---
  void _navigateToAgregarTurno() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AgregarTurnoScreen(
          onTurnoCreado: _agregarTurno, // Callback que llama a la DB
          roles: _roles,
        ),
      ),
    );
  }

  void _navigateToDescripcionTurno(Turno turno) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DescripcionTurnoScreen(turno: turno),
      ),
    );
  }

  // --- Diálogos ---
  void _showAgregarRolDialog() {
    final TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Agregar Rol'),
          content: TextField(
            controller: controller,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(hintText: "ej. Bartenders"),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Guardar'),
              onPressed: () {
                _agregarRol(controller.text.trim());
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showEliminarDialog({
    required String titulo,
    required String contenido,
    required VoidCallback onConfirm
  }) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(titulo),
        content: Text(contenido),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text("Cancelar"),
          ),
          TextButton(
            onPressed: () {
              onConfirm();
              Navigator.of(ctx).pop();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text("Eliminar"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Turnos', style: textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
      ),
      
      body: 
        _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 24),

            // Lista de Turnos
            if (_turnos.isEmpty)
              const Center(child: Text("No hay turnos agregados")),
            ..._turnos.map((turno) => _buildTurnoCard(context, turno)),

            const SizedBox(height: 24),
            Text('Roles', style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),

            // Lista de Roles
            if (_roles.isEmpty)
              const Center(child: Text("No hay roles agregados")),
            ..._roles.asMap().entries.map((entry) {
              return _buildRolCard(context, entry.value, entry.key + 1);
            }),
            const SizedBox(height: 80), // Espacio para el FAB
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton.extended(
            onPressed: _navigateToAgregarTurno,
            label: const Text('Agregar Turno'),
            icon: const Icon(Icons.access_time),
            heroTag: 'btnTurno',
          ),
          const SizedBox(height: 16),
          FloatingActionButton.extended(
            onPressed: _showAgregarRolDialog,
            label: const Text('Agregar Rol'),
            icon: const Icon(Icons.person_add),
            heroTag: 'btnRol',
          ),
        ],
      ),
    );
  }

  Widget _buildTurnoCard(BuildContext context, Turno turno) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () => _navigateToDescripcionTurno(turno),
      onLongPress: () => _showEliminarDialog(
        titulo: "Eliminar Turno",
        contenido: "¿Deseas eliminar el turno '${turno.nombre}'?",
        onConfirm: () => _eliminarTurno(turno),
      ),
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
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      // Agregamos el LongPress para eliminar rol
      onLongPress: () => _showEliminarDialog(
        titulo: "Eliminar Rol",
        contenido: "¿Deseas eliminar el rol '${rol.nombre}'?",
        onConfirm: () => _eliminarRol(rol),
      ),
      child: Card(
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
                child: Text('$index', style: TextStyle(color: colorScheme.onSecondaryContainer)),
              ),
              const SizedBox(width: 16),
              Expanded(child: Text(rol.nombre, style: textTheme.titleMedium)),
              const Icon(Icons.touch_app, size: 16, color: Colors.grey), // Indicador visual de interacción
            ],
          ),
        ),
      ),
    );
  }
}