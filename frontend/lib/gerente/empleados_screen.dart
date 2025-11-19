import 'package:flutter/material.dart';
import '../models/empleado.dart';
import '../services/empleado_service.dart';
import 'agregar_empleado_screen.dart';
import 'editar_empleado_screen.dart';

class EmpleadosScreen extends StatefulWidget {
  const EmpleadosScreen({super.key});

  @override
  State<EmpleadosScreen> createState() => _EmpleadosScreenState();
}

class _EmpleadosScreenState extends State<EmpleadosScreen> {
  final _empleadoService = EmpleadoService();
  List<Empleado> _todosLosEmpleados = [];
  List<Empleado> _empleadosFiltrados = [];
  bool _isLoading = true;

  // Controladores para filtros
  final _searchController = TextEditingController();
  String? _filtroRol;
  String? _filtroEstado;

  @override
  void initState() {
    super.initState();
    _cargarEmpleados();
  }

  Future<void> _cargarEmpleados() async {
    final lista = await _empleadoService.listarEmpleados();
    if (!mounted) return;
    setState(() {
      _todosLosEmpleados = lista;
      _aplicarFiltros(); // Inicializa la lista filtrada
      _isLoading = false;
    });
  }

  void _aplicarFiltros() {
    setState(() {
      _empleadosFiltrados = _todosLosEmpleados.where((emp) {
        // Filtro por Nombre
        final nombreMatch = emp.nombre
            .toLowerCase()
            .contains(_searchController.text.toLowerCase());
        // Filtro por Rol
        final rolMatch = _filtroRol == null || emp.rol == _filtroRol;
        // Filtro por Estado
        final estadoMatch =
            _filtroEstado == null || emp.estado == _filtroEstado;

        return nombreMatch && rolMatch && estadoMatch;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    // Obtenemos roles únicos para llenar el dropdown dinámicamente (opcional)
    final rolesDisponibles = _todosLosEmpleados.map((e) => e.rol).toSet().toList();

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Esperamos a que vuelva de la pantalla agregar para recargar
          await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const AgregarEmpleadoScreen()),
          );
          _cargarEmpleados();
        },
        child: const Icon(Icons.add),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Text('Mi equipo',
                style: textTheme.headlineLarge
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),

            // Buscador
            TextField(
              controller: _searchController,
              onChanged: (_) => _aplicarFiltros(),
              decoration: InputDecoration(
                labelText: 'Buscar por nombre',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor:
                colorScheme.surfaceVariant.withOpacity(0.5),
              ),
            ),
            const SizedBox(height: 16),

            // Filtros Row
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Rol',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide.none),
                      filled: true,
                      fillColor:
                      colorScheme.surfaceVariant.withOpacity(0.5),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                    ),
                    value: _filtroRol,
                    items: [
                      const DropdownMenuItem(
                          value: null, child: Text("Todos")),
                      ...rolesDisponibles.map((rol) => DropdownMenuItem(
                          value: rol, child: Text(rol))),
                    ],
                    onChanged: (value) {
                      _filtroRol = value;
                      _aplicarFiltros();
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Estado',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide.none),
                      filled: true,
                      fillColor:
                      colorScheme.surfaceVariant.withOpacity(0.5),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                    ),
                    value: _filtroEstado,
                    items: const [
                      DropdownMenuItem(value: null, child: Text("Todos")),
                      DropdownMenuItem(
                          value: 'ACTIVO', child: Text('Activo')),
                      DropdownMenuItem(
                          value: 'PENDIENTE', child: Text('Pendiente')),
                      DropdownMenuItem(
                          value: 'INACTIVO', child: Text('Inactivo')),
                    ],
                    onChanged: (value) {
                      _filtroEstado = value;
                      _aplicarFiltros();
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Grilla
            Expanded(
              child: _empleadosFiltrados.isEmpty
                  ? const Center(child: Text("No se encontraron empleados"))
                  : GridView.builder(
                itemCount: _empleadosFiltrados.length,
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.8,
                ),
                itemBuilder: (context, index) {
                  final empleado = _empleadosFiltrados[index];
                  return _buildEmployeeCard(
                    context,
                    empleado: empleado,
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              EditarEmpleadoScreen(
                                  empleado: empleado),
                        ),
                      );
                      _cargarEmpleados();
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmployeeCard(BuildContext context,
      {required Empleado empleado, VoidCallback? onTap}) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    // Color diferente si está pendiente
    final isPending = empleado.estado == 'PENDIENTE';

    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: isPending
            ? Colors.orange.withOpacity(0.2)
            : colorScheme.surfaceVariant.withOpacity(0.3),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isPending ? Icons.access_time : Icons.person,
                size: 48,
                color: isPending ? Colors.orange : colorScheme.onSurfaceVariant,
              ),
              const SizedBox(height: 16),
              Text(
                empleado.nombre,
                style:
                textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                empleado.rol,
                style: textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              if (isPending)
                Text(
                  '(Pendiente)',
                  style: textTheme.bodySmall?.copyWith(color: Colors.orange),
                )
            ],
          ),
        ),
      ),
    );
  }
}