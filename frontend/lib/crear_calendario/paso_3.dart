import 'package:flutter/material.dart';

class Paso3 extends StatelessWidget {
  const Paso3({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('¡Encuesta enviada!', style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('Esperando a que el personal ingrese sus turnos disponibles...'),
          const SizedBox(height: 24),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.2,
            children: [
              _buildEmployeeCard(context, 'Micky Vera', 'Ref. Mesero', 'Contestado', Colors.green),
              _buildEmployeeCard(context, 'Carlos Vaca', 'Ref. Mesero', 'Pendiente', Colors.grey),
              _buildEmployeeCard(context, 'Luciana Meylo', 'Ref. Mesero', 'Pendiente', Colors.grey),
              _buildEmployeeCard(context, 'Alberto Esponja', 'Ref. Mesero', 'Pendiente', Colors.grey),
            ],
          ),
          const SizedBox(height: 24),
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text('Cancelar Encuesta'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmployeeCard(BuildContext context, String name, String role, String status, Color statusColor) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: BorderSide(
          color: status == 'Contestado' ? Colors.green : Colors.transparent,
          width: 2,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.person, size: 40),
            const SizedBox(height: 8),
            Text(name, textAlign: TextAlign.center),
            Text(role, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                status,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: statusColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}