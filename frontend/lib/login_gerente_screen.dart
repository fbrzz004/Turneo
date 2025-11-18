import 'package:flutter/material.dart';
import 'gerente_main_screen.dart';

class LoginGerenteScreen extends StatelessWidget {
  const LoginGerenteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtenemos fácil acceso al tema de texto y colores de M3
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      // 1. AppBar transparente para el botón de "atrás"
      // Esto permite al usuario regresar a la pantalla de selección de rol.
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        // El color del icono de "atrás" se toma automáticamente del tema
      ),
      // 2. Extender el fondo morado detrás del AppBar
      extendBodyBehindAppBar: true,
      
      // 3. Mismo fondo que la pantalla anterior para consistencia
      backgroundColor: const Color(0xFF3B0B5E),
      
      // 4. Usamos SingleChildScrollView para evitar que el teclado
      // cause un "overflow" (pixeles amarillos y negros).
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              // Alineamos los elementos a la izquierda (como los labels)
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Damos un espacio para que el contenido no quede
                // debajo del botón de "atrás" del AppBar
                const SizedBox(height: kToolbarHeight), 
                
                // 5. Título "TURNEO" (estilo consistente)
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

                // 6. Subtítulo de la pantalla
                Text(
                  'Ingresa como Gerente',
                  textAlign: TextAlign.center,
                  style: textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 48.0),

                // 7. Formulario de Correo
                Text(
                  'Correo:',
                  style: textTheme.bodyLarge?.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 8.0),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  // Estilo del texto que el usuario escribe
                  style: const TextStyle(color: Colors.white), 
                  decoration: InputDecoration(
                    filled: true,
                    // Usamos un blanco transparente para el fondo "glass"
                    fillColor: Colors.white24, 
                    hintText: 'ejemplo@correo.com',
                    // Estilo del texto de placeholder (hint)
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      // Sin borde visible, como en el mockup
                      borderSide: BorderSide.none, 
                    ),
                  ),
                ),
                const SizedBox(height: 24.0),

                // 8. Formulario de Contraseña
                Text(
                  'Contraseña:',
                  style: textTheme.bodyLarge?.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 8.0),
                TextFormField(
                  obscureText: true, // Oculta la contraseña
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

                // 9. Botón de Iniciar Sesión
                // Este es el botón de acción principal. En M3, un 'FilledButton'
                // con el color primario es la elección correcta.
                FilledButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const GerenteMainScreen()),
                    );
                  },
                  style: FilledButton.styleFrom(
                    // Usamos el color primario del tema
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    textStyle: textTheme.titleMedium,
                  ),
                  child: const Text('Iniciar Sesión'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}