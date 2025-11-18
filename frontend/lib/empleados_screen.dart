import 'package:flutter/material.dart';

// Placeholder para la pantalla de agregar empleado
import 'agregar_empleado_screen.dart';
// Placeholder para la pantalla de editar empleado
import 'editar_empleado_screen.dart';

class EmpleadosScreen extends StatelessWidget {
  const EmpleadosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      // 1. AppBar con título y un ícono de ajustes
      appBar: AppBar(
        // El título se alinea a la izquierda por defecto en M3
        title: const Text('Empleados registrados'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              // Lógica para los ajustes (vacío por ahora)
            },
          ),
        ],
        // Damos un color de fondo para que combine con el diseño
        backgroundColor: colorScheme.surface,
        elevation: 0, // Sin sombra
      ),

      // 2. FAB para agregar nuevos empleados
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AgregarEmpleadoScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),

      // 3. Contenido principal de la pantalla
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ListView( // Usamos ListView para que sea "scrollable"
          children: [
            const SizedBox(height: 16),

            // Título "Mi equipo"
            Text(
              'Mi equipo',
              style: textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),

            // Campo de búsqueda por Nombre
            TextField(
              decoration: InputDecoration(
                labelText: 'Nombre',
                hintText: 'ej. Miguel Vera',
                prefixIcon: const Icon(Icons.search),
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
            const SizedBox(height: 16),

            // Dropdown para Estado
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Estado',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: colorScheme.surfaceVariant.withOpacity(0.5),
              ),
              hint: const Text('ej. Activo'),
              items: const [
                DropdownMenuItem(value: 'Activo', child: Text('Activo')),
                DropdownMenuItem(value: 'Inactivo', child: Text('Inactivo')),
              ],
              onChanged: (value) {},
            ),
            const SizedBox(height: 32),

            // Grilla de empleados (con datos de ejemplo)
            GridView.count(
              crossAxisCount: 2, // Dos columnas
              shrinkWrap: true, // Para que funcione dentro de un ListView
              physics: const NeverScrollableScrollPhysics(), // Desactiva el scroll de la grilla
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.8, // Ajusta la proporción de las tarjetas
              children: [
                _buildEmployeeCard(
                  context,
                  name: 'Micky Vera',
                  role: 'Mesero',
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const EditarEmpleadoScreen()));
                  }
                ),
                _buildEmployeeCard(
                  context,
                  name: 'Richi Towers',
                  role: 'Cajero',
                   onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const EditarEmpleadoScreen()));
                  }
                ),
              ],
            ),
             const SizedBox(height: 16),
            // Un indicador de carga para simular que hay más contenido
            const Center(
              child: CircularProgressIndicator(),
            ),
            const SizedBox(height: 80), // Espacio para que el FAB no tape contenido
          ],
        ),
      ),
    );
  }

  // Widget helper para construir las tarjetas de empleado
  Widget _buildEmployeeCard(BuildContext context, {required String name, required String role, VoidCallback? onTap}) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Card(
        // El color de la tarjeta será un poco más claro que el fondo
        color: colorScheme.surfaceVariant.withOpacity(0.3),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icono de placeholder (como en el mockup)
              Icon(
                Icons.person,
                size: 48,
                color: colorScheme.onSurfaceVariant,
              ),
              const SizedBox(height: 16),
              Text(
                name,
                style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                'Rol: $role',
                style: textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}