import 'package:flutter/material.dart';
import '../models/rol.dart';
import '../models/turno.dart';

class AgregarTurnoScreen extends StatefulWidget {
  final Function(Turno) onTurnoCreado;
  final List<Rol> roles;

  const AgregarTurnoScreen(
      {super.key, required this.onTurnoCreado, required this.roles});

  @override
  State<AgregarTurnoScreen> createState() => _AgregarTurnoScreenState();
}

class _AgregarTurnoScreenState extends State<AgregarTurnoScreen> {
  final _nombreController = TextEditingController();
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  // Lista para manejar el form dinámico
  final List<Map<String, dynamic>> _empleadosRequeridosFields = [
    {'rol': null, 'cantidad': null}
  ];

  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        if (isStartTime) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

  void _guardar() {
    // 1. Validaciones básicas
    if (_nombreController.text.isEmpty || _startTime == null || _endTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Completa nombre y horarios')),
        
      );
      return;
    }

    // 2. Construir mapa de requerimientos
    final Map<String, int> empleadosRequeridos = {};

    for (var field in _empleadosRequeridosFields) {
      final String? rolNombre = field['rol'];
      final int? cantidad = field['cantidad'];

      if (rolNombre != null && cantidad != null && cantidad > 0) {
        empleadosRequeridos[rolNombre] = cantidad;
      }
    }

    if (empleadosRequeridos.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Agrega al menos un rol con cantidad')),
      );
      return;
    }

    // 3. Crear objeto
    final nuevoTurno = Turno(
      nombre: _nombreController.text.trim(),
      // Usamos context para formatear la hora segun local (AM/PM o 24h)
      horaInicio: _startTime!.format(context),
      horaFin: _endTime!.format(context),
      empleadosRequeridos: empleadosRequeridos,
    );

    // 4. Callback a la pantalla anterior (que guardará en DB)
    widget.onTurnoCreado(nuevoTurno);
    Navigator.of(context).pop();
  }

  void _agregarCampoEmpleado() {
    setState(() {
      _empleadosRequeridosFields.add({'rol': null, 'cantidad': null});
    });
  }

  void _eliminarCampoEmpleado(int index) {
    if (_empleadosRequeridosFields.length > 1) {
      setState(() {
        _empleadosRequeridosFields.removeAt(index);
      });
    }
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
          'Agregar Turno',
          style: textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTextField(
                controller: _nombreController,
                labelText: 'Nombre del Turno',
                hintText: 'ej. Turno Mañana'),
            const SizedBox(height: 16),
            _buildTimeField(
              context: context,
              labelText: 'Hora Inicio',
              hintText: '-- : --',
              time: _startTime,
              onTap: () => _selectTime(context, true),
            ),
            const SizedBox(height: 16),
            _buildTimeField(
              context: context,
              labelText: 'Hora Fin',
              hintText: '-- : --',
              time: _endTime,
              onTap: () => _selectTime(context, false),
            ),
            const SizedBox(height: 24),

            Text('Empleados requeridos', style: textTheme.titleLarge),
            const SizedBox(height: 8),

            if(widget.roles.isEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                color: Colors.amber.withOpacity(0.2),
                child: const Text("No tienes Roles creados. Crea roles en la pantalla anterior primero."),
              ),

            ..._empleadosRequeridosFields
                .asMap()
                .entries
                .map((entry) => _buildRequiredEmployeeField(entry.key)),

            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: widget.roles.isNotEmpty ? _agregarCampoEmpleado : null,
                icon: const Icon(Icons.add),
                label: const Text('Agregar otro rol'),
              ),
            ),
            const SizedBox(height: 32),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: widget.roles.isNotEmpty ? _guardar : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Guardar Turno'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: OutlinedButton( // Cambié a Outlined para diseño más limpio
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: BorderSide(color: colorScheme.error),
                      foregroundColor: colorScheme.error,
                    ),
                    child: const Text('Cancelar'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ... Tus Widgets auxiliares (_buildTextField, _buildTimeField) se mantienen igual ...
  // Solo asegúrate que _buildRequiredEmployeeField tenga botón de eliminar si quieres UX pro

  Widget _buildTextField({required TextEditingController controller, required String labelText, required String hintText}) {
    return TextField(
      controller: controller,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildTimeField({required BuildContext context, required String labelText, required String hintText, required TimeOfDay? time, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Text(
          time?.format(context) ?? hintText,
          style: time == null ? TextStyle(color: Theme.of(context).hintColor) : null,
        ),
      ),
    );
  }

  Widget _buildRequiredEmployeeField(int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: DropdownButtonFormField<String>(
              isExpanded: true,
              decoration: InputDecoration(
                  labelText: 'Rol',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16)
              ),
              value: _empleadosRequeridosFields[index]['rol'],
              items: widget.roles.map((rol) => DropdownMenuItem(
                value: rol.nombre,
                child: Text(rol.nombre, overflow: TextOverflow.ellipsis),
              )).toList(),
              onChanged: (value) {
                setState(() {
                  _empleadosRequeridosFields[index]['rol'] = value;
                });
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Cant.',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                final int? quantity = int.tryParse(value);
                if (quantity != null) {
                  _empleadosRequeridosFields[index]['cantidad'] = quantity;
                }
              },
            ),
          ),
          if (_empleadosRequeridosFields.length > 1)
            IconButton(
              icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
              onPressed: () => _eliminarCampoEmpleado(index),
            )
        ],
      ),
    );
  }
}