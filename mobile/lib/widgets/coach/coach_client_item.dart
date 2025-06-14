import 'package:flutter/material.dart';
import 'package:mobile/models/coach_client.dart';
import 'package:mobile/themes/themes.dart';
import 'package:mobile/screens/coach/client_detail_screen.dart';

class CoachClientItem extends StatelessWidget {
  final CoachClient client;
  final void Function(String clientId)? onClientDeleted;

  const CoachClientItem({
    super.key,
    required this.client,
    this.onClientDeleted,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: MyTheme.darkSurf,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        onTap: () async {
          final wasDeleted = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ClientDetailScreen(client: client),
            ),
          );

          if (wasDeleted == true) {
            onClientDeleted?.call(client.id);
          }
        },
        leading: CircleAvatar(
          backgroundColor: MyTheme.primary.withOpacity(0.1),
          child: const Icon(Icons.person, color: MyTheme.primary),
        ),
        title: Text(client.client.email, style: const TextStyle(color: Colors.white)),
        subtitle: Text(
          client.note ?? "Sin nota",
          style: TextStyle(color: Colors.grey[400], fontSize: 13),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.white),
      ),
    );
  }
}
