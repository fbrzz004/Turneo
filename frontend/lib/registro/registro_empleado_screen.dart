import 'package:flutter/material.dart';
import '../empleado/turnos_screen.dart';
import '../models/empleado.dart';
import '../services/empleado_service.dart';

class RegistroEmpleadoScreen extends StatefulWidget {
  final Empleado empleadoPendiente;

  const RegistroEmpleadoScreen({super.key, required this.empleadoPendiente});

  @override
  State<RegistroEmpleadoScreen> createState() => _RegistroEmpleadoScreenState();
}

class _RegistroEmpleadoScreenState extends State<RegistroEmpleadoScreen> {
  final _passController = TextEditingController();
  final _confirmController = TextEditingController();
  final _empleadoService = EmpleadoService();
  final _formKey = GlobalKey<FormState>();

  Future<void> _completarRegistro() async {
    if (_formKey.currentState!.validate()) {
      if (_passController.text != _confirmController.text) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Las contraseñas no coinciden")));
        return;
      }

      // Actualizar objeto
      widget.empleadoPendiente.contrasena = _passController.text.trim();
      widget.empleadoPendiente.estado = 'ACTIVO';

      // Guardar en DB
      await _empleadoService.actualizarEmpleado(widget.empleadoPendiente);

      if(!mounted) return;

      // Navegar al home
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const TurnosScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFF3B0B5E),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Completar Registro',
                      textAlign: TextAlign.center,
                      style: textTheme.displayMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                  Text('Crea tu nueva contraseña',
                      textAlign: TextAlign.center,
                      style: textTheme.headlineSmall?.copyWith(color: Colors.white70)),
                  const SizedBox(height: 48.0),

                  // Datos NO editables (solo visuales)
                  Text('Nombre:', style: textTheme.bodyLarge?.copyWith(color: Colors.white)),
                  const SizedBox(height: 8.0),
                  TextFormField(
                    initialValue: widget.empleadoPendiente.nombre,
                    readOnly: true,
                    style: const TextStyle(color: Colors.grey),
                    decoration: InputDecoration(
                      filled: true, fillColor: Colors.black26,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
                    ),
                  ),
                  const SizedBox(height: 24.0),

                  Text('Correo:', style: textTheme.bodyLarge?.copyWith(color: Colors.white)),
                  const SizedBox(height: 8.0),
                  TextFormField(
                    initialValue: widget.empleadoPendiente.correo,
                    readOnly: true,
                    style: const TextStyle(color: Colors.grey),
                    decoration: InputDecoration(
                      filled: true, fillColor: Colors.black26,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
                    ),
                  ),
                  const SizedBox(height: 24.0),

                  // NUEVA CONTRASEÑA
                  Text('Nueva contraseña:', style: textTheme.bodyLarge?.copyWith(color: Colors.white)),
                  const SizedBox(height: 8.0),
                  TextFormField(
                    controller: _passController,
                    obscureText: true,
                    validator: (v) => v!.length < 4 ? 'Mínimo 4 caracteres' : null,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      filled: true, fillColor: Colors.white24, hintText: 'Mínimo 4 caracteres',
                      hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0), borderSide: BorderSide.none),
                    ),
                  ),
                  const SizedBox(height: 24.0),

                  Text('Confirmar contraseña:', style: textTheme.bodyLarge?.copyWith(color: Colors.white)),
                  const SizedBox(height: 8.0),
                  TextFormField(
                    controller: _confirmController,
                    obscureText: true,
                    validator: (v) => v!.isEmpty ? 'Confirma tu contraseña' : null,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      filled: true, fillColor: Colors.white24, hintText: 'Repite tu contraseña',
                      hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0), borderSide: BorderSide.none),
                    ),
                  ),
                  const SizedBox(height: 48.0),

                  FilledButton(
                    onPressed: _completarRegistro,
                    style: FilledButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      textStyle: textTheme.titleMedium,
                    ),
                    child: const Text('Finalizar y Entrar'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}