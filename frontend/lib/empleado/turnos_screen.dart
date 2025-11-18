import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../gerente_main_screen.dart';

class TurnosScreen extends StatefulWidget {
  const TurnosScreen({super.key});

  @override
  State<TurnosScreen> createState() => _TurnosScreenState();
}

class _TurnosScreenState extends State<TurnosScreen> {
  final bool _hayTurnosDisponibles = true; 

  int _selectedIndex = 0;

  bool _lunesManana = true;
  bool _lunesTarde = true;
  bool _lunesNoche = true;

  
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        title: Text(
          'Turnos Disponibles',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
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
            onPressed: () {  },
          ),
        ],
      ),
      
      body: _hayTurnosDisponibles
          ? _buildListaDeTurnos(context)
          : _buildEstadoVacio(context),
      
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index) {
          if (index == 1){
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, anim1, anim2) => const GerenteMainScreen(),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ),
            );
          } else {
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

  Widget _buildEstadoVacio(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.settings_outlined,
              size: 48.0,
              color: colorScheme.primary,
            ),
            const SizedBox(height: 24.0),

            Text(
              'No tienes ningún turno disponible para contestar.',
              textAlign: TextAlign.center,
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 16.0),

            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                children: [
                  const TextSpan(text: '¡Tal vez ya tienes un horario! Verifica en '),
                  TextSpan(
                    text: 'Calendario',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                      decoration: TextDecoration.underline,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.pushReplacement(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (context, anim1, anim2) => const GerenteMainScreen(),
                            transitionDuration: Duration.zero,
                            reverseTransitionDuration: Duration.zero,
                          ),
                        );
                      },
                  ),
                  const TextSpan(text: '.'),
                ],
              ),
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
            Text(
              'Horario asignado: Lunes a Jueves',
              style: textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24.0),

            _buildDiaExpansionTile(
              context: context,
              dia: 'Día Lunes',
              initiallyExpanded: true,
            ),
            const SizedBox(height: 12.0),
            _buildDiaExpansionTile(
              context: context,
              dia: 'Día Martes',
            ),
            const SizedBox(height: 12.0),
            _buildDiaExpansionTile(
              context: context,
              dia: 'Día Miércoles',
            ),
            const SizedBox(height: 12.0),
            _buildDiaExpansionTile(
              context: context,
              dia: 'Día Jueves',
            ),
            const SizedBox(height: 32.0),

            FilledButton(
              onPressed: () {
                _mostrarDialogoConfirmacion(context);
              },
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                textStyle: textTheme.titleMedium,
              ),
              child: const Text('Aceptar'),
            ),
            const SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }

  Widget _buildDiaExpansionTile({
    required BuildContext context,
    required String dia,
    bool initiallyExpanded = false,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Card(
      elevation: 0,
      color: colorScheme.primaryContainer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      clipBehavior: Clip.antiAlias,
      child: ExpansionTile(
        title: Text(dia, style: const TextStyle(fontWeight: FontWeight.bold)),
        initiallyExpanded: initiallyExpanded,
        backgroundColor: colorScheme.surface,
        shape: const Border(),
        collapsedShape: const Border(),
        children: [
          CheckboxListTile(
            title: const Text('Mañana'),
            subtitle: const Text('Horario: 8:00 am - 12:00 pm'),
            value: _lunesManana,
            onChanged: (bool? value) {
              setState(() { _lunesManana = value!; });
            },
            secondary: CircleAvatar(
              backgroundColor: colorScheme.secondaryContainer,
              foregroundColor: colorScheme.onSecondaryContainer,
              child: const Text('M'),
            ),
          ),
          CheckboxListTile(
            title: const Text('Tarde'),
            subtitle: const Text('Horario: 2:00 pm - 6:00 pm'),
            value: _lunesTarde,
            onChanged: (bool? value) {
              setState(() { _lunesTarde = value!; });
            },
            secondary: CircleAvatar(
              backgroundColor: colorScheme.secondaryContainer,
              foregroundColor: colorScheme.onSecondaryContainer,
              child: const Text('T'),
            ),
          ),
          CheckboxListTile(
            title: const Text('Noche'),
            subtitle: const Text('Horario: 6:00 pm - 10:00 pm'),
            value: _lunesNoche,
            onChanged: (bool? value) {
              setState(() { _lunesNoche = value!; });
            },
            secondary: CircleAvatar(
              backgroundColor: colorScheme.secondaryContainer,
              foregroundColor: colorScheme.onSecondaryContainer,
              child: const Text('N'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _mostrarDialogoConfirmacion(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Selección registrada'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Se le notificará cuando el horario se genere correctamente por el Gerente.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Aceptar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
