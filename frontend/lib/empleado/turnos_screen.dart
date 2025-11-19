import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:turneo_horarios_app/ajustes/ajustes_screen.dart';
import '../empleado/ver_calendario_empleado_screen.dart';
import '../models/calendario.dart';
import '../services/user_session.dart';
import '../services/calendario_service.dart';
import '../services/turno_service.dart';
import '../models/turno.dart';

class TurnosScreen extends StatefulWidget {
  const TurnosScreen({super.key});

  @override
  State<TurnosScreen> createState() => _TurnosScreenState();
}

class _TurnosScreenState extends State<TurnosScreen> {
  int _selectedIndex = 0;
  bool _isLoading = true;

  // Datos dinámicos
  Calendario? _calendarioPendiente;
  List<CalendarioDia> _diasCalendario = [];
  List<Turno> _turnosDisponibles = [];

  // Almacén de respuestas: Map<DiaID, List<TurnoID>>
  final Map<int, Set<int>> _respuestas = {};

  final _calendarioService = CalendarioService();
  final _turnoService = TurnoService();

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    final empleadoId = UserSession().id;
    if (empleadoId == null) return;

    // 1. Buscar calendarios activos
    final calendarios = await _calendarioService.listarCalendarios();

    // Filtramos para encontrar uno PENDIENTE donde el empleado esté invitado Y NO haya respondido aún
    Calendario? encontrado;
    for (var cal in calendarios) {
      if (cal.estado == 0) { // 0 = Pendiente/Borrador
        // Verificar si está invitado (esto requiere un método nuevo en servicio, o lo asumimos por ahora)
        // Verificar si YA respondió
        final yaRespondio = await _calendarioService.haRespondido(cal.id!, empleadoId);
        if (!yaRespondio) {
          encontrado = cal;
          break; // Tomamos el primero que encuentre
        }
      }
    }

    if (encontrado != null) {
      // Cargar días y turnos
      final dias = await _calendarioService.obtenerDiasDeCalendario(encontrado.id!);
      final turnos = await _turnoService.listarTurnos();

      if (mounted) {
        setState(() {
          _calendarioPendiente = encontrado;
          _diasCalendario = dias;
          _turnosDisponibles = turnos;
          _isLoading = false;
        });
      }
    } else {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _guardarRespuestas() async {
    if (_calendarioPendiente == null) return;

    final empleadoId = UserSession().id!;
    List<Disponibilidad> listaAGuardar = [];

    // Convertir el mapa de respuestas a objetos Disponibilidad
    _respuestas.forEach((diaId, turnosIds) {
      for (var turnoId in turnosIds) {
        listaAGuardar.add(Disponibilidad(
          calendarioDiaId: diaId,
          empleadoId: empleadoId,
          turnoId: turnoId,
        ));
      }
    });

    if (listaAGuardar.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Por favor selecciona al menos un turno disponible"))
      );
      return;
    }

    try {
      await _calendarioService.guardarDisponibilidad(listaAGuardar);

      if (!mounted) return;

      // Mostrar éxito y recargar (lo que llevará a la pantalla vacía)
      await _mostrarDialogoConfirmacion(context);
      setState(() {
        _calendarioPendiente = null; // Limpiamos para forzar vista vacía
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'Turnos Disponibles',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings_outlined, color: colorScheme.onSurface),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const AjustesScreen()));
            },
          ),
        ],
      ),

      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : (_calendarioPendiente != null
          ? _buildListaDeTurnos(context)
          : _buildEstadoVacio(context)),

      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index) {
          if (index == 1) {
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, anim1, anim2) => const VerCalendarioEmpleadoScreen(),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ),
            );
          } else {
            setState(() => _selectedIndex = index);
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

  // ... _buildEstadoVacio SE QUEDA IGUAL QUE EN TU CÓDIGO ...
  Widget _buildEstadoVacio(BuildContext context) {
    // Copia tu widget _buildEstadoVacio aquí tal cual lo tenías
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.done_all, size: 64.0, color: Colors.green.withOpacity(0.5)),
            const SizedBox(height: 24.0),
            Text(
              '¡Todo listo por ahora!',
              textAlign: TextAlign.center,
              style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: colorScheme.onSurface),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'No tienes encuestas pendientes. Revisa tu calendario para ver tus horarios confirmados.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListaDeTurnos(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.withOpacity(0.3))
              ),
              child: Text(
                'Encuesta: ${_calendarioPendiente?.nombre}',
                style: textTheme.titleMedium?.copyWith(color: Colors.blue[800], fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 24.0),

            // GENERAMOS LOS DÍAS DINÁMICAMENTE
            ..._diasCalendario.asMap().entries.map((entry) {
              final index = entry.key;
              final diaObj = entry.value;
              // Formato: "Lunes 20"
              final nombreDia = DateFormat('EEEE d', 'es_ES').format(diaObj.fecha).toUpperCase();

              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: _buildDiaExpansionTile(
                  context: context,
                  diaObj: diaObj,
                  titulo: nombreDia,
                  initiallyExpanded: index == 0, // Solo el primero abierto
                ),
              );
            }),

            const SizedBox(height: 32.0),

            FilledButton(
              onPressed: _guardarRespuestas,
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                textStyle: textTheme.titleMedium,
              ),
              child: const Text('Enviar Disponibilidad'),
            ),
            const SizedBox(height: 32.0),
          ],
        ),
      ),
    );
  }

  Widget _buildDiaExpansionTile({
    required BuildContext context,
    required CalendarioDia diaObj,
    required String titulo,
    bool initiallyExpanded = false,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 0,
      color: colorScheme.primaryContainer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      clipBehavior: Clip.antiAlias,
      child: ExpansionTile(
        title: Text(titulo, style: const TextStyle(fontWeight: FontWeight.bold)),
        initiallyExpanded: initiallyExpanded,
        backgroundColor: colorScheme.surface,
        shape: const Border(),
        collapsedShape: const Border(),
        children: _turnosDisponibles.map((turno) {

          // Lógica de Selección
          final isSelected = _respuestas[diaObj.id]?.contains(turno.id) ?? false;

          return CheckboxListTile(
            title: Text(turno.nombre),
            subtitle: Text('${turno.horaInicio} - ${turno.horaFin}'),
            value: isSelected,
            onChanged: (bool? value) {
              setState(() {
                if (value == true) {
                  // Agregar
                  _respuestas.putIfAbsent(diaObj.id!, () => {});
                  _respuestas[diaObj.id]!.add(turno.id!);
                } else {
                  // Quitar
                  _respuestas[diaObj.id]?.remove(turno.id);
                }
              });
            },
            secondary: CircleAvatar(
              backgroundColor: colorScheme.secondaryContainer,
              foregroundColor: colorScheme.onSecondaryContainer,
              child: Text(turno.nombre.isNotEmpty ? turno.nombre[0] : 'T'),
            ),
          );
        }).toList(),
      ),
    );
  }

  Future<void> _mostrarDialogoConfirmacion(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('¡Enviado!'),
          content: const Text('Tus preferencias han sido guardadas. Se te notificará cuando el Gerente publique el horario final.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Entendido'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }
}