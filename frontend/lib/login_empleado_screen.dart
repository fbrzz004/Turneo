import 'package:flutter/material.dart';
import 'package:turneo_horarios_app/turnos_screen.dart';

class LoginEmpleadoScreen extends StatelessWidget {
  const LoginEmpleadoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtenemos fácil acceso al tema de texto y colores de M3
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      // 1. AppBar transparente para el botón de "atrás"
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      
      // 2. Mismo fondo que las pantallas anteriores
      backgroundColor: const Color(0xFF3B0B5E),
      
      // 3. Usamos SingleChildScrollView para evitar que el teclado
      // cause un "overflow".
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: kToolbarHeight), 
                
                // 4. Título "TURNEO" (estilo consistente)
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
                        color: Colors.black.withOpacity(0.5),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16.0),

                // 5. Subtítulo (CAMBIO DE TEXTO)
                Text(
                  'Ingresa como Empleado',
                  textAlign: TextAlign.center,
                  style: textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 48.0),

                // 6. Formulario de Correo (Idéntico al de Gerente)
                Text(
                  'Correo:',
                  style: textTheme.bodyLarge?.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 8.0),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  style: const TextStyle(color: Colors.white), 
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white24, 
                    hintText: 'tu.correo@empresa.com',
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide.none, 
                    ),
                  ),
                ),
                const SizedBox(height: 24.0),

                // 7. Formulario de Contraseña (Idéntico al de Gerente)
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
                    hintText: '••••••••••••',
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 48.0),

                // 8. Botón de Iniciar Sesión
                FilledButton(
                  onPressed: () {
                    Navigator.push(
                      context, 
                    MaterialPageRoute(builder: (context) => const TurnosScreen()),
                    );
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    textStyle: textTheme.titleMedium,
                  ),
                  child: const Text('Iniciar Sesión'),
                ),
                const SizedBox(height: 32.0), // Espacio antes del texto final

                // 9. Texto informativo (CAMBIO DE TEXTO)
                Text(
                  'Solo los Gerentes pueden crear cuentas de Empleados.',
                  textAlign: TextAlign.center,
                  style: textTheme.bodyMedium?.copyWith(
                    color: Colors.white70, // Color más sutil
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}