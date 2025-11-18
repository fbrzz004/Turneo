import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'login_gerente_screen.dart'; // Importamos para el link de "Inicia Sesión"

class RegistroGerenteScreen extends StatelessWidget {
  const RegistroGerenteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtenemos fácil acceso al tema de texto y colores de M3
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      // 1. AppBar transparente para el botón de "atrás"
      // Permite al usuario volver a la pantalla de bienvenida/inicio.
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true, // El fondo se extiende detrás del AppBar
      
      // 2. Mismo fondo que las pantallas anteriores
      backgroundColor: const Color(0xFF3B0B5E),
      
      // 3. Usamos SingleChildScrollView para evitar que el teclado
      // cause un "overflow".
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              // Alineamos los labels ("Nombre completo:", "Correo:", etc.)
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 4. Título "Regístrate"
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
                
                // 5. Subtítulo "Gerente"
                Text(
                  'Gerente',
                  textAlign: TextAlign.center,
                  style: textTheme.headlineSmall?.copyWith(
                    color: Colors.white70, // Un poco menos de énfasis
                  ),
                ),
                const SizedBox(height: 32.0),

                // 6. Formulario
                // --- Nombre Completo ---
                Text(
                  'Nombre completo:',
                  style: textTheme.bodyLarge?.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 8.0),
                TextFormField(
                  keyboardType: TextInputType.name,
                  textCapitalization: TextCapitalization.words,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white24, // Mismo estilo que Login
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
                Text(
                  'Correo:',
                  style: textTheme.bodyLarge?.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 8.0),
                TextFormField(
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
                Text(
                  'Contraseña:',
                  style: textTheme.bodyLarge?.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 8.0),
                TextFormField(
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
                Text(
                  'Confirmar contraseña:',
                  style: textTheme.bodyLarge?.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 8.0),
                TextFormField(
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
                  onPressed: () {
                    
                  },
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
                            // Esta es la mejor UX: reemplaza la pantalla de
                            // registro con la de login.
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginGerenteScreen(),
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
    );
  }
}