import 'package:flutter/material.dart';
import '../models/empleado.dart';
import '../services/empleado_service.dart';
import '../services/rol_service.dart';
import '../models/rol.dart';

class EditarEmpleadoScreen extends StatefulWidget {
  final Empleado empleado;
  const EditarEmpleadoScreen({super.key, required this.empleado});

  @override
  State<EditarEmpleadoScreen> createState() => _EditarEmpleadoScreenState();
}

class _EditarEmpleadoScreenState extends State<EditarEmpleadoScreen> {
  final _empleadoService = EmpleadoService();
  final _rolService = RolService();

  late TextEditingController _nombreController;
  late String _selectedRol;
  late String _selectedEstado;
  List<Rol> _rolesDisponibles = [];

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(text: widget.empleado.nombre);
    _selectedRol = widget.empleado.rol;
    _selectedEstado = widget.empleado.estado;
    _cargarRoles();
  }

  Future<void> _cargarRoles() async {
    final roles = await _rolService.listarRoles();
    setState(() {
      _rolesDisponibles = roles;
      // Validar que el rol actual siga existiendo, si no, añadirlo visualmente o manejar error
    });
  }

  Future<void> _actualizar() async {
    widget.empleado.nombre = _nombreController.text;
    widget.empleado.rol = _selectedRol;
    widget.empleado.estado = _selectedEstado;

    await _empleadoService.actualizarEmpleado(widget.empleado);
    if(!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Empleado'),
        backgroundColor: colorScheme.surface,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const SizedBox(height: 16),
            Text('Editar información',
                style: textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),

            TextFormField(
              controller: _nombreController,
              decoration: InputDecoration(
                labelText: 'Nombre',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0), borderSide: BorderSide.none),
                filled: true,
                fillColor: colorScheme.surfaceVariant.withOpacity(0.5),
              ),
            ),
            const SizedBox(height: 16),

            DropdownButtonFormField<String>(
              value: _selectedRol,
              decoration: InputDecoration(
                labelText: 'Rol',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0), borderSide: BorderSide.none),
                filled: true,
                fillColor: colorScheme.surfaceVariant.withOpacity(0.5),
              ),
              // Combinamos roles disponibles. Si la lista carga vacía, mostramos al menos el rol actual
              items: _rolesDisponibles.isEmpty
                  ? [DropdownMenuItem(value: _selectedRol, child: Text(_selectedRol))]
                  : _rolesDisponibles.map((r) => DropdownMenuItem(value: r.nombre, child: Text(r.nombre))).toList(),
              onChanged: (value) => setState(() => _selectedRol = value!),
            ),
            const SizedBox(height: 16),

            DropdownButtonFormField<String>(
              value: _selectedEstado,
              decoration: InputDecoration(
                labelText: 'Estado',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0), borderSide: BorderSide.none),
                filled: true,
                fillColor: colorScheme.surfaceVariant.withOpacity(0.5),
              ),
              items: const [
                DropdownMenuItem(value: 'ACTIVO', child: Text('Activo')),
                DropdownMenuItem(value: 'PENDIENTE', child: Text('Pendiente')),
                DropdownMenuItem(value: 'INACTIVO', child: Text('Inactivo')),
              ],
              onChanged: (value) => setState(() => _selectedEstado = value!),
            ),
            const SizedBox(height: 32),

            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    icon: const Icon(Icons.check),
                    label: const Text('Aceptar'),
                    onPressed: _actualizar,
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: const Color(0xFF6750A4),
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: FilledButton.icon(
                    icon: const Icon(Icons.cancel_outlined),
                    label: const Text('Cancelar'),
                    onPressed: () => Navigator.pop(context),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: const Color(0xFFB3261E),
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}