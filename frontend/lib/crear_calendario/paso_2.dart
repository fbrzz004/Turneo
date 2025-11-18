import 'package:flutter/material.dart';

class Paso2 extends StatelessWidget {
  const Paso2({super.key});

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
          const TextField(
            readOnly: true,
            decoration: InputDecoration(
              hintText: 'ej. Miguel Vera',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              suffixIcon: Icon(Icons.search),
            ),
          ),
          const SizedBox(height: 24),
          Text('Rol', style: textTheme.titleMedium),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
            hint: const Text('ej. Mesero'),
            items: <String>['Mesero', 'Cocinero', 'Bartender']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) {},
          ),
          const SizedBox(height: 24),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.2,
            children: [
              _buildEmployeeCard(context, 'Micky Vera', 'Ref. Mesero', true),
              _buildEmployeeCard(context, 'Carlos Vaca', 'Ref. Mesero', false),
              _buildEmployeeCard(context, 'Luciana Meylo', 'Ref. Mesero', false),
              _buildEmployeeCard(context, 'Alberto Esponja', 'Ref. Mesero', false),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmployeeCard(BuildContext context, String name, String role, bool selected) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: BorderSide(
          color: selected ? Colors.green : Colors.transparent,
          width: 2,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.person, size: 40),
            const SizedBox(height: 8),
            Text(name, textAlign: TextAlign.center),
            Text(role, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}