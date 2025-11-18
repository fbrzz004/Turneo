import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../login/login_gerente_screen.dart';
import '../models/gerente.dart';
import '../services/gerente_service.dart';

class RegistroGerenteScreen extends StatefulWidget {
  const RegistroGerenteScreen({super.key});

  @override
  State<RegistroGerenteScreen> createState() => _RegistroGerenteScreenState();
}

class _RegistroGerenteScreenState extends State<RegistroGerenteScreen> {
  // 1. Controladores para capturar el texto
  final _nombreController = TextEditingController();
  final _correoController = TextEditingController();
  final _contrasenaController = TextEditingController();
  final _confirmarController = TextEditingController();

  // 2. Instancia del servicio
  final _gerenteService = GerenteService();

  // 3. Clave para validar el formulario
  final _formKey = GlobalKey<FormState>();

  // Función para registrar
  Future<void> _registrar() async {
    if (_formKey.currentState!.validate()) {
      // Verificar que las contraseñas coincidan
      if (_contrasenaController.text != _confirmarController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Las contraseñas no coinciden')),
        );
        return;
      }

      try {
        // Crear el objeto modelo
        final nuevoGerente = Gerente(
          nombre: _nombreController.text.trim(),
          correo: _correoController.text.trim(),
          contrasena: _contrasenaController.text.trim(),
        );

        // Guardar en SQLite
        await _gerenteService.insertarGerente(nuevoGerente);

        if (!mounted) return;

        // Mostrar éxito
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('¡Cuenta creada con éxito! Inicia sesión.'),
            backgroundColor: Colors.green,
          ),
        );

        // Redirigir al Login
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginGerenteScreen()),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al registrar: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    // Limpiar controladores para evitar fugas de memoria
    _nombreController.dispose();
    _correoController.dispose();
    _contrasenaController.dispose();
    _confirmarController.dispose();
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFF3B0B5E),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Form(
              key: _formKey, // Asignamos la llave del formulario
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Regístrate',
                    textAlign: TextAlign.center,
                    style: textTheme.displayMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          offset: const Offset(2.0, 2.0),
                          blurRadius: 4.0,
                          color: Colors.black.withOpacity(0.5),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    'Gerente',
                    textAlign: TextAlign.center,
                    style: textTheme.headlineSmall?.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 32.0),

                  // --- Nombre Completo ---
                  Text('Nombre completo:',
                      style: textTheme.bodyLarge?.copyWith(color: Colors.white)),
                  const SizedBox(height: 8.0),
                  TextFormField(
                    controller: _nombreController,
                    validator: (value) => value == null || value.isEmpty
                        ? 'Ingresa tu nombre'
                        : null,
                    keyboardType: TextInputType.name,
                    textCapitalization: TextCapitalization.words,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white24,
                      hintText: 'Tu nombre y apellido',
                      hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24.0),

                  // --- Correo ---
                  Text('Correo:',
                      style: textTheme.bodyLarge?.copyWith(color: Colors.white)),
                  const SizedBox(height: 8.0),
                  TextFormField(
                    controller: _correoController,
                    validator: (value) => value == null || !value.contains('@')
                        ? 'Correo inválido'
                        : null,
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white24,
                      hintText: 'ejemplo@correo.com',
                      hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
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
                    validator: (value) => value == null || value.length < 4
                        ? 'Mínimo 4 caracteres' // SQLite no valida longitud, pero es buena UX
                        : null,
                    obscureText: true,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white24,
                      hintText: 'Mínimo 8 caracteres',
                      hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24.0),

                  // --- Confirmar Contraseña ---
                  Text('Confirmar contraseña:',
                      style: textTheme.bodyLarge?.copyWith(color: Colors.white)),
                  const SizedBox(height: 8.0),
                  TextFormField(
                    controller: _confirmarController,
                    validator: (value) =>
                    value == null || value.isEmpty ? 'Repite la contraseña' : null,
                    obscureText: true,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white24,
                      hintText: 'Repite tu contraseña',
                      hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32.0),

                  // 7. Botón de Crear Cuenta
                  FilledButton(
                    onPressed: _registrar, // Llamamos a la función lógica
                    style: FilledButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      textStyle: textTheme.titleMedium,
                    ),
                    child: const Text('Crear cuenta'),
                  ),
                  const SizedBox(height: 24.0),

                  // 8. Link a Iniciar Sesión
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: textTheme.bodyMedium?.copyWith(
                        color: Colors.white70,
                      ),
                      children: [
                        const TextSpan(text: 'Si ya tienes una cuenta, '),
                        TextSpan(
                          text: 'Inicia Sesión',
                          style: textTheme.bodyMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.white,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                  const LoginGerenteScreen(),
                                ),
                              );
                            },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24.0),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}