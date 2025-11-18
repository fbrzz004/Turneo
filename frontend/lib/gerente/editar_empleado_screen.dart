import 'package:flutter/material.dart';

class EditarEmpleadoScreen extends StatelessWidget {
  const EditarEmpleadoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      // 1. AppBar
      appBar: AppBar(
        title: const Text('Editar Empleado'),
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
              'Editar información',
              style: textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),

            // Campo para Nombre (pre-llenado con datos de ejemplo)
            TextFormField(
              initialValue: 'Miguel Vera',
              decoration: InputDecoration(
                labelText: 'Nombre',
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
              value: 'Mesero',
              decoration: InputDecoration(
                labelText: 'Rol',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: colorScheme.surfaceVariant.withOpacity(0.5),
              ),
              items: const [
                DropdownMenuItem(value: 'Mesero', child: Text('Mesero')),
                DropdownMenuItem(value: 'Cajero', child: Text('Cajero')),
              ],
              onChanged: (value) {},
            ),
            const SizedBox(height: 16),

            // Dropdown para Estado
            DropdownButtonFormField<String>(
              value: 'Activo',
              decoration: InputDecoration(
                labelText: 'Estado',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: colorScheme.surfaceVariant.withOpacity(0.5),
              ),
              items: const [
                DropdownMenuItem(value: 'Activo', child: Text('Activo')),
                DropdownMenuItem(value: 'Inactivo', child: Text('Inactivo')),
              ],
              onChanged: (value) {},
            ),
            const SizedBox(height: 32),

            // Botones de Acción
            Row(
              children: [
                // Botón Aceptar
                Expanded(
                  child: FilledButton.icon(
                    icon: const Icon(Icons.check),
                    label: const Text('Aceptar'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: const Color(0xFF6750A4),
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                // Botón Cancelar
                Expanded(
                  child: FilledButton.icon(
                    icon: const Icon(Icons.cancel_outlined),
                    label: const Text('Cancelar'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: const Color(0xFFB3261E),
                      foregroundColor: Colors.white,
                    ),
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