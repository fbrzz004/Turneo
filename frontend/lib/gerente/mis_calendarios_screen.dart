import 'package:flutter/material.dart';
import '../crear_calendario/crear_calendario_screen.dart';
import 'ver_calendario_screen.dart';

class MisCalendariosScreen extends StatelessWidget {
  const MisCalendariosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          _buildCalendarItem(context, "1", "Calendario 1", "En Espera", const Color(0xFFFDE047), false),
          const SizedBox(height: 16),
          _buildCalendarItem(context, "2", "Calendario 2", "Completado", const Color(0xFF86EFAC), true),
          const SizedBox(height: 16),
          _buildCalendarItem(context, "3", "Calendario 3", "Completado", const Color(0xFF86EFAC), true),
        ],
      ),
    );
  }

  Widget _buildCalendarItem(BuildContext context, String number, String title, String status, Color statusColor, bool isPublished) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => VerCalendarioScreen(isPublished: isPublished)),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              child: Text(number),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(title, style: textTheme.titleMedium),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                status,
                style: textTheme.bodyMedium?.copyWith(color: statusColor.computeLuminance() > 0.5 ? Colors.black : Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}