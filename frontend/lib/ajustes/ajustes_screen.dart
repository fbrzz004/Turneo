import 'package:flutter/material.dart';
import './../login/inicio_screen.dart'; // Importante para poder redirigir al inicio

class AjustesScreen extends StatelessWidget {
  const AjustesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      // Mismo fondo claro que Turnos y Calendario
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
          
          // 1. Encabezado de Perfil (Opcional pero recomendado)
          // Muestra quién tiene la sesión iniciada
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: colorScheme.primaryContainer,
                  foregroundColor: colorScheme.onPrimaryContainer,
                  child: const Icon(Icons.person, size: 40),
                ),
                const SizedBox(height: 16),
                Text(
                  'Mi Perfil',
                  style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  'usuario@ejemplo.com',
                  style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 40),
          const Divider(),

          // 2. Opción "Acerca de"
          ListTile(
            leading: Icon(Icons.info_outline, color: colorScheme.onSurface),
            title: const Text('Acerca de'),
            subtitle: const Text('Versión 1.0.0'),
            onTap: () {
              // Muestra un diálogo simple con información
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

          // 3. Opción "Cerrar Sesión"
          ListTile(
            // Usamos color rojo (error) para indicar una acción de salida
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
              
              // 1. (Opcional) Aquí podrías limpiar tokens o preferencias de usuario.
              
              // 2. Navegar a la pantalla de Inicio y ELIMINAR todo el historial anterior.
              // Esto evita que el usuario pueda volver atrás con el botón físico.
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const InicioScreen()),
                (Route<dynamic> route) => false, // La condición 'false' elimina todas las rutas previas
              );
            },
          ),
        ],
      ),
    );
  }
}