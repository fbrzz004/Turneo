import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'login_gerente_screen.dart';
import '../registro/registro_gerente_screen.dart';
import 'login_empleado_screen.dart';

class InicioScreen extends StatelessWidget {
  const InicioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: const Color(0xFF3B0B5E), 
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'TURNEO',
                textAlign: TextAlign.center,
                style: textTheme.displayLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.0,
                  shadows: [
                    Shadow(
                      offset: const Offset(2.0, 2.0),
                      blurRadius: 4.0,
                      color: Colors.black,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 72.0),

              Text(
                '¿Cómo quieres iniciar sesión?',
                textAlign: TextAlign.center,
                style: textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 24.0),

              FilledButton(
                onPressed: () {
                    Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const LoginGerenteScreen()),
                    );
                },
                style: FilledButton.styleFrom(
                  backgroundColor: colorScheme.secondaryContainer,
                  foregroundColor: colorScheme.onSecondaryContainer,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  textStyle: textTheme.titleMedium,
                ),
                child: const Text('Gerente'),
              ),
              const SizedBox(height: 16.0),

              FilledButton(
                onPressed: () {
                  Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (context) => const LoginEmpleadoScreen()),
                    );
                },
                style: FilledButton.styleFrom(
                  backgroundColor: colorScheme.secondaryContainer,
                  foregroundColor: colorScheme.onSecondaryContainer,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  textStyle: textTheme.titleMedium,
                ),
                child: const Text('Empleado'),
              ),
              const SizedBox(height: 48.0),

              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: textTheme.bodyMedium?.copyWith(
                    color: Colors.white70,
                  ),
                  children: [
                    const TextSpan(text: '¿Eres nuevo?, '),
                    TextSpan(
                      text: 'Crea tu cuenta de Gerente',
                      style: textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.white,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.push(context, 
                          MaterialPageRoute(builder: (context) => const RegistroGerenteScreen()),
                          );
                        },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
