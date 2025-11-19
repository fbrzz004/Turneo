import 'package:flutter/material.dart';
import '../models/empleado.dart';

class Paso2 extends StatefulWidget {
  final List<Empleado> todosLosEmpleados;
  final List<Empleado> empleadosSeleccionados;
  final Function(List<Empleado>) onSelectionChanged;

  const Paso2({
    super.key,
    required this.todosLosEmpleados,
    required this.empleadosSeleccionados,
    required this.onSelectionChanged,
  });

  @override
  State<Paso2> createState() => _Paso2State();
}

class _Paso2State extends State<Paso2> {
  String _filtroNombre = '';
  String? _filtroRol;

  void _toggleSelection(Empleado empleado) {
    final seleccionados = List<Empleado>.from(widget.empleadosSeleccionados);
    if (seleccionados.any((e) => e.id == empleado.id)) {
      seleccionados.removeWhere((e) => e.id == empleado.id);
    } else {
      seleccionados.add(empleado);
    }
    widget.onSelectionChanged(seleccionados);
  }

  void _seleccionarTodos(List<Empleado> filtrados) {
    final seleccionados = List<Empleado>.from(widget.empleadosSeleccionados);
    for (var emp in filtrados) {
      if (!seleccionados.any((e) => e.id == emp.id)) {
        seleccionados.add(emp);
      }
    }
    widget.onSelectionChanged(seleccionados);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    // Aplicar filtros
    final empleadosFiltrados = widget.todosLosEmpleados.where((emp) {
      final coincideNombre = emp.nombre.toLowerCase().contains(_filtroNombre.toLowerCase());
      final coincideRol = _filtroRol == null || emp.rol == _filtroRol;
      // Solo mostramos activos, opcional
      final esActivo = emp.estado == 'ACTIVO';
      return coincideNombre && coincideRol && esActivo;
    }).toList();

    // Obtener roles únicos para el dropdown
    final roles = widget.todosLosEmpleados.map((e) => e.rol).toSet().toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Buscador
              TextField(
                onChanged: (v) => setState(() => _filtroNombre = v),
                decoration: InputDecoration(
                  labelText: 'Buscar empleado',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
                ),
              ),
              const SizedBox(height: 16),
              // Filtro Rol
              DropdownButtonFormField<String>(
                value: _filtroRol,
                decoration: InputDecoration(
                  labelText: 'Filtrar por Rol',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
                ),
                items: [
                  const DropdownMenuItem(value: null, child: Text("Todos los roles")),
                  ...roles.map((r) => DropdownMenuItem(value: r, child: Text(r)))
                ],
                onChanged: (v) => setState(() => _filtroRol = v),
              ),

              // Resumen y Selección Masiva
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("${widget.empleadosSeleccionados.length} seleccionados",
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    TextButton(
                      onPressed: () => _seleccionarTodos(empleadosFiltrados),
                      child: const Text("Seleccionar Visibles"),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),

        // Grilla de Empleados
        Expanded(
          child: empleadosFiltrados.isEmpty
              ? const Center(child: Text("No se encontraron empleados activos"))
              : GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.1,
            ),
            itemCount: empleadosFiltrados.length,
            itemBuilder: (context, index) {
              final emp = empleadosFiltrados[index];
              final isSelected = widget.empleadosSeleccionados.any((e) => e.id == emp.id);

              return _buildEmployeeCard(context, emp, isSelected);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEmployeeCard(BuildContext context, Empleado emp, bool isSelected) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: () => _toggleSelection(emp),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? colorScheme.primaryContainer : colorScheme.surface,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(
            color: isSelected ? colorScheme.primary : Colors.grey.shade300,
            width: 2,
          ),
          boxShadow: [
            if(!isSelected) BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                const Icon(Icons.person, size: 40, color: Colors.grey),
                if (isSelected)
                  const Positioned(
                    right: 0, bottom: 0,
                    child: Icon(Icons.check_circle, color: Colors.green, size: 20),
                  )
              ],
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Text(
                emp.nombre,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            Text(emp.rol, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}