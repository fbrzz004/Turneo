import 'package:flutter/material.dart';

class Paso1 extends StatelessWidget {
  const Paso1({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Nombre', style: textTheme.titleMedium),
          const SizedBox(height: 8),
          TextField(
            decoration: InputDecoration(
              hintText: 'ej. Calendario 1',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text('Elige los días de tu horario', style: textTheme.titleMedium),
          const SizedBox(height: 16),
          _buildDaySelector(context, 'Lunes'),
          const SizedBox(height: 16),
          _buildDaySelector(context, 'Miércoles'),
          const SizedBox(height: 16),
          _buildDaySelector(context, 'Viernes'),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () {},
            child: const Text('Agregar más días...'),
          ),
        ],
      ),
    );
  }

  Widget _buildDaySelector(BuildContext context, String day) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
      hint: Text('Elegir Día'),
      value: day,
      items: <String>['Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (String? newValue) {},
    );
  }
}
