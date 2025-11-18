import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'login_gerente_screen.dart';
import '../Registro/registro_gerente_screen.dart';
import 'login_empleado_screen.dart';

class InicioScreen extends StatelessWidget {
  const InicioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtenemos fácil acceso al tema de texto y colores de M3
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      // Usamos un color de fondo específico para igualar el mockup
      backgroundColor: const Color(0xFF3B0B5E), 
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            // Centramos el contenido verticalmente
            mainAxisAlignment: MainAxisAlignment.center,
            // Estiramos los elementos (como los botones) a lo ancho
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Título "TURNEO"
              Text(
                'TURNEO',
                textAlign: TextAlign.center,
                style: textTheme.displayLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.0,
                  // Sombra para dar el efecto 3D del mockup
                  shadows: [
                    Shadow(
                      offset: const Offset(2.0, 2.0),
                      blurRadius: 4.0,
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 72.0),

              // 2. Texto de pregunta
              Text(
                '¿Cómo quieres iniciar sesión?',
                textAlign: TextAlign.center,
                style: textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 24.0),

              // 3. Botón "Gerente"
              // FilledButton es el botón principal en M3
              FilledButton(
                onPressed: () {
                    Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const LoginGerenteScreen()),
                    );
                },
                style: FilledButton.styleFrom(
                  // Usamos colores del 'colorScheme' de M3
                  // secondaryContainer suele ser un buen color de acento
                  backgroundColor: colorScheme.secondaryContainer,
                  foregroundColor: colorScheme.onSecondaryContainer,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  textStyle: textTheme.titleMedium,
                ),
                child: const Text('Gerente'),
              ),
              const SizedBox(height: 16.0),

              // 4. Botón "Empleado"
              // Usamos el mismo estilo para consistencia
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

              // 5. Texto de registro (con parte "clicable")
              // Usamos RichText para combinar dos estilos de texto
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  // Estilo por defecto (para "¿Eres nuevo?, ")
                  style: textTheme.bodyMedium?.copyWith(
                    color: Colors.white70,
                  ),
                  children: [
                    const TextSpan(text: '¿Eres nuevo?, '),
                    TextSpan(
                      text: 'Crea tu cuenta de Gerente',
                      // Estilo para la parte "link"
                      style: textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.white,
                      ),
                      // Permite que esta parte del texto sea clicable
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