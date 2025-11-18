import 'package:flutter/material.dart';
import 'package:turneo_horarios_app/empleado/turnos_screen.dart';
import '../services/empleado_service.dart';
import '/registro/registro_empleado_screen.dart';

class LoginEmpleadoScreen extends StatefulWidget {
  const LoginEmpleadoScreen({super.key});

  @override
  State<LoginEmpleadoScreen> createState() => _LoginEmpleadoScreenState();
}

class _LoginEmpleadoScreenState extends State<LoginEmpleadoScreen> {
  final _correoController = TextEditingController();
  final _contrasenaController = TextEditingController();
  final _empleadoService = EmpleadoService();
  bool _isLoading = false;

  Future<void> _login() async {
    setState(() => _isLoading = true);

    final empleado = await _empleadoService.login(
      _correoController.text.trim(),
      _contrasenaController.text.trim(),
    );

    setState(() => _isLoading = false);

    if (!mounted) return;

    if (empleado != null) {
      if (empleado.estado == 'INACTIVO') {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Usuario inactivo. Contacte a su gerente.')));
      }
      else if (empleado.estado == 'PENDIENTE') {
        // CASO CRÍTICO: Es su primera vez, debe cambiar contraseña
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => RegistroEmpleadoScreen(empleadoPendiente: empleado),
          ),
        );
      }
      else {
        // CASO NORMAL: Login exitoso
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const TurnosScreen()),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Credenciales incorrectas')),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: kToolbarHeight),
                Text('TURNEO',
                    textAlign: TextAlign.center,
                    style: textTheme.displayLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(offset: const Offset(2.0, 2.0), blurRadius: 4.0, color: Colors.black.withOpacity(0.5)),
                        ])),
                const SizedBox(height: 16.0),
                Text('Ingresa como empleado',
                    textAlign: TextAlign.center,
                    style: textTheme.headlineMedium?.copyWith(
                        color: Colors.white, fontWeight: FontWeight.bold)),
                const SizedBox(height: 48.0),

                // Inputs
                Text('Correo:', style: textTheme.bodyLarge?.copyWith(color: Colors.white)),
                const SizedBox(height: 8.0),
                TextFormField(
                  controller: _correoController,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    filled: true, fillColor: Colors.white24, hintText: 'tu.correo@empresa.com',
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0), borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 24.0),
                Text('Contraseña:', style: textTheme.bodyLarge?.copyWith(color: Colors.white)),
                const SizedBox(height: 8.0),
                TextFormField(
                  controller: _contrasenaController,
                  obscureText: true,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    filled: true, fillColor: Colors.white24, hintText: '••••••••••••',
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0), borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 48.0),

                FilledButton(
                  onPressed: _isLoading ? null : _login,
                  style: FilledButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    textStyle: textTheme.titleMedium,
                  ),
                  child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text('Iniciar Sesión'),
                ),
                const SizedBox(height: 32.0),
                Text('Solo los Gerentes pueden crear cuentas de Empleados.',
                    textAlign: TextAlign.center,
                    style: textTheme.bodyMedium?.copyWith(color: Colors.white70)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}