import 'package:flutter/material.dart';
// 1. Importaciones necesarias para el idioma
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'login/inicio_screen.dart';

// 2. Convertimos el main a async para esperar la inicialización
void main() async {
  // 3. Aseguramos que los widgets estén listos
  WidgetsFlutterBinding.ensureInitialized();

  // 4. Inicializamos el formato de fechas para Español ('es_ES')
  // Esto soluciona el error "Locale data has not been initialized"
  await initializeDateFormatting('es_ES', null);

  runApp(const TurneoApp());
}

class TurneoApp extends StatelessWidget {
  const TurneoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Turneo',
      debugShowCheckedModeBanner: false,

      // 5. Configuramos el idioma de los widgets de Flutter (como el DatePicker)
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('es', 'ES'), // Definimos Español como soportado
      ],

      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
      ),
      home: const InicioScreen(),
    );
  }
}