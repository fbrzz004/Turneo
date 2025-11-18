import 'package:flutter/material.dart';
import 'inicio_screen.dart';

void main() {
  runApp(const TurneoApp());
}

class TurneoApp extends StatelessWidget {
  const TurneoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Turneo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // 1. Esta es la activación clave de Material 3
        useMaterial3: true,
        
        // 2. Usamos un tema oscuro como en el mockup
        brightness: Brightness.dark,
        
        // 3. Creamos la paleta de colores de M3 a partir de un color "semilla"
        // Flutter generará automáticamente los colores primario, secundario,
        // de fondo, etc., de forma armónica.
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
      ),
      home: const InicioScreen(),
    );
  }
}