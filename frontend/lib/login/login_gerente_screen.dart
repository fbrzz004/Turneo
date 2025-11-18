import 'package:flutter/material.dart';
import '../gerente_main_screen.dart';

class LoginGerenteScreen extends StatelessWidget {
  const LoginGerenteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
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
                        color: Colors.black.withOpacity(0.5),
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
                    hintText: 'ejemplo@correo.com',
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide.none, 
                    ),
                  ),
                ),
                const SizedBox(height: 24.0),

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

                FilledButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const GerenteMainScreen()),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
