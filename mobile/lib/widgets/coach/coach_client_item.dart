import 'package:flutter/material.dart';
import 'package:mobile/models/coach_client.dart';
import 'package:mobile/themes/themes.dart';

class CoachClientItem extends StatelessWidget {
  final CoachClient client;

  const CoachClientItem({super.key, required this.client});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: MyTheme.darkSurf,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: MyTheme.primary.withOpacity(0.1),
          child: const Icon(Icons.person, color: MyTheme.primary),
        ),
        title: Text(client.client.email, style: const TextStyle(color: Colors.white)),
        subtitle: Text(
          client.note ?? "Sin nota",
          style: TextStyle(color: Colors.grey[400], fontSize: 13),
        ),
        trailing: PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert, color: Colors.white),
          onSelected: (value) {
            switch (value) {
              case 'rutina':
                // TODO: ir a rutina
                break;
              case 'progreso':
                // TODO: ir a progreso
                break;
              case 'desvincular':
                // TODO: confirmar y eliminar
                break;
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(value: 'rutina', child: Text('Ver rutina')),
            const PopupMenuItem(value: 'progreso', child: Text('Ver progreso')),
            const PopupMenuItem(value: 'desvincular', child: Text('Desvincular')),
          ],
        ),
      ),
    );
  }
}
