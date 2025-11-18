import 'package:flutter/material.dart';

class AgregarEmpleadoScreen extends StatelessWidget {
  const AgregarEmpleadoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      // 1. AppBar con título y un ícono de ajustes (similar al anterior)
      appBar: AppBar(
        title: const Text('Agregar Empleado'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {},
          ),
        ],
        backgroundColor: colorScheme.surface,
        elevation: 0,
      ),

      // 2. Contenido principal con el formulario
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const SizedBox(height: 16),

            // Título de la sección
            Text(
              'Agregar empleado',
              style: textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),

            // Campo para Nombre
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Nombre',
                hintText: 'ej. Miguel Vera',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: colorScheme.surfaceVariant.withOpacity(0.5),
              ),
            ),
            const SizedBox(height: 16),

            // Campo para Correo
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Correo',
                hintText: 'ej. mickyvera@gmail.com',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: colorScheme.surfaceVariant.withOpacity(0.5),
              ),
            ),
            const SizedBox(height: 16),

            // Dropdown para Rol
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Rol',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: colorScheme.surfaceVariant.withOpacity(0.5),
              ),
              hint: const Text('ej. Mesero'),
              items: const [
                DropdownMenuItem(value: 'Mesero', child: Text('Mesero')),
                DropdownMenuItem(value: 'Cajero', child: Text('Cajero')),
              ],
              onChanged: (value) {},
            ),
            const SizedBox(height: 32),

            // Botones de Acción
            Row(
              children: [
                // Botón Aceptar (estilo principal)
                Expanded(
                  child: FilledButton.icon(
                    icon: const Icon(Icons.check),
                    label: const Text('Aceptar'),
                    onPressed: () {
                      // Lógica de aceptar (vacío)
                      Navigator.pop(context); // Regresa a la pantalla anterior
                    },
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      // Usamos un color personalizado para que coincida con el mockup
                      backgroundColor: const Color(0xFF6750A4),
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                // Botón Cancelar (estilo secundario)
                Expanded(
                  child: FilledButton.icon(
                    icon: const Icon(Icons.cancel_outlined),
                    label: const Text('Cancelar'),
                    onPressed: () {
                      Navigator.pop(context); // Regresa a la pantalla anterior
                    },
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      // Usamos un color rojo para indicar cancelación
                      backgroundColor: const Color(0xFFB3261E),
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Nota informativa
            Row(
              children: [
                const Icon(Icons.info_outline, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Se le enviará una notificación al correo del empleado para crear su cuenta.',
                    style: textTheme.bodySmall,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}