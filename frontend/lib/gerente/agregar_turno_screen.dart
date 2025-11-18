import 'package:flutter/material.dart';
import 'package:turneo_horarios_app/models/rol.dart';
import 'package:turneo_horarios_app/models/turno.dart';

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

  void _agregarTurno() {
    if (_nombreController.text.isNotEmpty &&
        _startTime != null &&
        _endTime != null) {
      final Map<String, int> empleadosRequeridos = {};
      for (var field in _empleadosRequeridosFields) {
        if (field['rol'] != null && field['cantidad'] != null) {
          empleadosRequeridos[field['rol']] = field['cantidad'];
        }
      }
      final nuevoTurno = Turno(
        nombre: _nombreController.text,
        horaInicio: _startTime!.format(context),
        horaFin: _endTime!.format(context),
        empleadosRequeridos: empleadosRequeridos,
      );
      widget.onTurnoCreado(nuevoTurno);
      Navigator.of(context).pop();
    }
  }

  void _agregarCampoEmpleado() {
    setState(() {
      _empleadosRequeridosFields.add({'rol': null, 'cantidad': null});
    });
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
            _buildTextField(
                controller: _nombreController,
                labelText: 'Nombre',
                hintText: 'ej. Turno Mañana'),
            const SizedBox(height: 16),
            _buildTimeField(
              context: context,
              labelText: 'Hora Inicio',
              hintText: 'ej. 8:00 AM',
              time: _startTime,
              onTap: () => _selectTime(context, true),
            ),
            const SizedBox(height: 16),
            _buildTimeField(
              context: context,
              labelText: 'Hora Fin',
              hintText: 'ej. 12:00 PM',
              time: _endTime,
              onTap: () => _selectTime(context, false),
            ),
            const SizedBox(height: 24),
            Text('Empleados requeridos', style: textTheme.titleLarge),
            const SizedBox(height: 16),
            ..._empleadosRequeridosFields
                .asMap()
                .entries
                .map((entry) => _buildRequiredEmployeeField(entry.key)),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: _agregarCampoEmpleado,
                child: const Text('Agregar más...'),
              ),
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _agregarTurno,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Aceptar'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.error,
                      foregroundColor: colorScheme.onError,
                      padding: const EdgeInsets.symmetric(vertical: 16),
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

  Widget _buildTextField(
      {required TextEditingController controller,
      required String labelText,
      required String hintText}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildTimeField({
    required BuildContext context,
    required String labelText,
    required String hintText,
    required TimeOfDay? time,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          time?.format(context) ?? hintText,
          style: time == null
              ? TextStyle(color: Theme.of(context).hintColor)
              : null,
        ),
      ),
    );
  }

  Widget _buildRequiredEmployeeField(int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Rol',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              value: _empleadosRequeridosFields[index]['rol'],
              items: widget.roles
                  .map((rol) => DropdownMenuItem(
                        value: rol.nombre,
                        child: Text(rol.nombre),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _empleadosRequeridosFields[index]['rol'] = value;
                });
              },
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 1,
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Cantidad',
                hintText: 'ej. 9',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
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
        ],
      ),
    );
  }
}
