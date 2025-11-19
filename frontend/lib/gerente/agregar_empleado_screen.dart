import 'package:flutter/material.dart';
import '../models/empleado.dart';
import '../services/empleado_service.dart';
import '../services/rol_service.dart'; // Necesitamos cargar los roles reales
import '../models/rol.dart';

class AgregarEmpleadoScreen extends StatefulWidget {
  const AgregarEmpleadoScreen({super.key});

  @override
  State<AgregarEmpleadoScreen> createState() => _AgregarEmpleadoScreenState();
}

class _AgregarEmpleadoScreenState extends State<AgregarEmpleadoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _correoController = TextEditingController();

  String? _selectedRol;
  List<Rol> _rolesDisponibles = [];

  final _empleadoService = EmpleadoService();
  final _rolService = RolService();

  @override
  void initState() {
    super.initState();
    _cargarRoles();
  }

  Future<void> _cargarRoles() async {
    final roles = await _rolService.listarRoles();
    setState(() {
      _rolesDisponibles = roles;
    });
  }

  Future<void> _guardarEmpleado() async {
    if (_formKey.currentState!.validate()) {
      try {
        final nuevoEmpleado = Empleado(
          nombre: _nombreController.text.trim(),
          correo: _correoController.text.trim(),
          rol: _selectedRol!,
          // CLAVE POR DEFECTO
          contrasena: '123456',
          estado: 'PENDIENTE',
        );

        await _empleadoService.crearEmpleado(nuevoEmpleado);

        if(!mounted) return;

        // Mostrar feedback
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Empleado creado. Contraseña temporal: 123456'),
            duration: Duration(seconds: 4),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);

      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: El correo ya podría existir')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 16),
              Text('Agregar empleado',
                  style: textTheme.headlineLarge
                      ?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),

              // Nombre
              TextFormField(
                controller: _nombreController,
                validator: (v) => v!.isEmpty ? 'Campo requerido' : null,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  labelText: 'Nombre',
                  hintText: 'ej. Miguel Vera',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide.none),
                  filled: true,
                  fillColor: colorScheme.surfaceVariant.withOpacity(0.5),
                ),
              ),
              const SizedBox(height: 16),

              // Correo
              TextFormField(
                controller: _correoController,
                validator: (v) => !v!.contains('@') ? 'Correo inválido' : null,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Correo',
                  hintText: 'ej. mickyvera@gmail.com',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide.none),
                  filled: true,
                  fillColor: colorScheme.surfaceVariant.withOpacity(0.5),
                ),
              ),
              const SizedBox(height: 16),

              // Rol
              DropdownButtonFormField<String>(
                validator: (v) => v == null ? 'Selecciona un rol' : null,
                decoration: InputDecoration(
                  labelText: 'Rol',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide.none),
                  filled: true,
                  fillColor: colorScheme.surfaceVariant.withOpacity(0.5),
                ),
                hint: const Text('Seleccionar...'),
                value: _selectedRol,
                // Si no hay roles, muestra aviso o lista vacia
                items: _rolesDisponibles.isEmpty
                    ? []
                    : _rolesDisponibles.map((rol) => DropdownMenuItem(
                  value: rol.nombre,
                  child: Text(rol.nombre),
                )).toList(),
                onChanged: (value) {
                  setState(() => _selectedRol = value);
                },
              ),
              const SizedBox(height: 32),

              // Botones
              Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      icon: const Icon(Icons.check),
                      label: const Text('Aceptar'),
                      onPressed: _guardarEmpleado,
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
              const SizedBox(height: 24),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.info_outline, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'El empleado deberá cambiar su contraseña la primera vez que inicie sesión. (Clave temporal: 123456)',
                      style: textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}