import 'package:flutter/material.dart';
import '../services/gerente_service.dart';
import '../gerente/gerente_main_screen.dart';

class LoginGerenteScreen extends StatefulWidget {
  const LoginGerenteScreen({super.key});

  @override
  State<LoginGerenteScreen> createState() => _LoginGerenteScreenState();
}

class _LoginGerenteScreenState extends State<LoginGerenteScreen> {
  // 1. Controladores
  final _correoController = TextEditingController();
  final _contrasenaController = TextEditingController();

  // 2. Servicio
  final _gerenteService = GerenteService();

  // 3. Estado de carga (opcional para mejor UX)
  bool _isLoading = false;

  // Función de Login
  Future<void> _iniciarSesion() async {
    // Validacion simple de campos vacios
    if (_correoController.text.isEmpty || _contrasenaController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor llena todos los campos')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Llamada a SQLite
      final gerente = await _gerenteService.login(
        _correoController.text.trim(),
        _contrasenaController.text.trim(),
      );

      if (!mounted) return;

      if (gerente != null) {
        // ¡LOGIN EXITOSO!
        // Aquí podrías guardar la sesión en SharedPreferences si quisieras
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const GerenteMainScreen()),
        );
      } else {
        // LOGIN FALLIDO
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Credenciales incorrectas'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error de base de datos: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _correoController.dispose();
    _contrasenaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
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
                Text(
                  'TURNEO',
                  textAlign: TextAlign.center,
                  style: textTheme.displayLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        offset: const Offset(2.0, 2.0),
                        blurRadius: 4.0,
                        color: Colors.black,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16.0),
                Text(
                  'Ingresa como Gerente',
                  textAlign: TextAlign.center,
                  style: textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 48.0),

                // --- Correo ---
                Text('Correo:',
                    style: textTheme.bodyLarge?.copyWith(color: Colors.white)),
                const SizedBox(height: 8.0),
                TextFormField(
                  controller: _correoController,
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white24,
                    hintText: 'ejemplo@correo.com',
                    hintStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 24.0),

                // --- Contraseña ---
                Text('Contraseña:',
                    style: textTheme.bodyLarge?.copyWith(color: Colors.white)),
                const SizedBox(height: 8.0),
                TextFormField(
                  controller: _contrasenaController,
                  obscureText: true,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white24,
                    hintText: '••••••••••••',
                    hintStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 48.0),

                // Botón Iniciar Sesión
                FilledButton(
                  onPressed: _isLoading
                      ? null
                      : _iniciarSesion, // Deshabilita si está cargando
                  style: FilledButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    textStyle: textTheme.titleMedium,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                        color: Colors.white, strokeWidth: 2),
                  )
                      : const Text('Iniciar Sesión'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}