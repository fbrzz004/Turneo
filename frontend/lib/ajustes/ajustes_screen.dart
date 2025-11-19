import 'package:flutter/material.dart';
import '../services/user_session.dart'; // Tu servicio Singleton
import '../login/inicio_screen.dart';   // Tu pantalla de inicio

class AjustesScreen extends StatelessWidget {
  const AjustesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // 1. Instanciamos la sesión para leer los datos guardados en el Login
    final session = UserSession();

    return Scaffold(
      backgroundColor: colorScheme.surface,

      appBar: AppBar(
        title: const Text('Ajustes'),
        centerTitle: true,
        backgroundColor: colorScheme.surface,
        elevation: 0,
      ),

      body: ListView(
        children: [
          const SizedBox(height: 20),

          // 2. Encabezado de Perfil (DATOS REALES)
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: colorScheme.primaryContainer,
                  foregroundColor: colorScheme.onPrimaryContainer,
                  // Lógica: Si tiene nombre, muestra la primera letra en mayúscula. Si no, muestra 'U'.
                  child: Text(
                    session.nombre.isNotEmpty ? session.nombre[0].toUpperCase() : 'U',
                    style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 16),

                // Nombre traído de la sesión
                Text(
                  session.nombre,
                  style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),

                // Correo traído de la sesión
                Text(
                  session.correo,
                  style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 8),

                // Etiqueta pequeña para mostrar el Rol (Gerente, Mesero, etc.)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    session.rol, // Rol traído de la sesión
                    style: textTheme.labelMedium?.copyWith(
                        color: colorScheme.onSecondaryContainer,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 40),
          const Divider(),

          // 3. Opción "Acerca de"
          ListTile(
            leading: Icon(Icons.info_outline, color: colorScheme.onSurface),
            title: const Text('Acerca de'),
            subtitle: const Text('Versión 1.0.0'),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Turneo App'),
                  content: const Text('Desarrollada por Andre, Enmanuel, Miguel y Richard. 2025. Los Soteros.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cerrar'),
                    ),
                  ],
                ),
              );
            },
          ),

          // 4. Opción "Cerrar Sesión"
          ListTile(
            leading: Icon(Icons.logout, color: colorScheme.error),
            title: Text(
              'Cerrar Sesión',
              style: TextStyle(
                color: colorScheme.error,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              // --- LÓGICA DE CERRAR SESIÓN ---

              // 1. Borramos los datos de la memoria
              UserSession().logout();

              // 2. Redirigimos al inicio eliminando el historial de navegación
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const InicioScreen()),
                    (Route<dynamic> route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}