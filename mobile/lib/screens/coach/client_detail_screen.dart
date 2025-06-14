import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile/models/coach_client.dart';
import 'package:mobile/themes/themes.dart';
import 'package:mobile/services/coach/coach_client_service.dart';
import 'package:mobile/widgets/custom_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:mobile/providers/loggin_provider.dart';

class ClientDetailScreen extends StatelessWidget {
  final CoachClient client;

  const ClientDetailScreen({super.key, required this.client});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy');
    final start = dateFormat.format(client.startDate);
    final end = client.endDate != null ? dateFormat.format(client.endDate!) : 'Actualidad';

    return Scaffold(
      appBar: CustomAppBar(title: 'Detalle del cliente'),
      backgroundColor: MyTheme.darkBg,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              client.client.email,
              style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Nota: ${client.note ?? "Sin nota"}', style: const TextStyle(color: Colors.white70)),
            const SizedBox(height: 8),
            Text('Desde: $start', style: const TextStyle(color: Colors.white70)),
            Text('Hasta: $end', style: const TextStyle(color: Colors.white70)),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              icon: const Icon(Icons.bar_chart),
              onPressed: () {
                // TODO: ver progreso
              },
              label: const Text('Ver progreso'),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              icon: const Icon(Icons.calendar_today),
              onPressed: () {
                // TODO: ver rutina
              },
              label: const Text('Ver rutina'),
            ),
            const SizedBox(height: 10),
            OutlinedButton.icon(
              icon: const Icon(Icons.person_remove_alt_1, color: Colors.red),
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Desvincular cliente'),
                    content: const Text('¿Estás seguro de desvincular a este cliente?'),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancelar')),
                      TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Desvincular')),
                    ],
                  ),
                );

                if (confirm == true) {
                  try {
                    final token = Provider.of<LogginProvider>(context, listen: false).token!;
                    await CoachClientService().deleteClient(client.id, token);
                    Navigator.pop(context, true);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Cliente desvinculado')),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error al desvincular: $e')),
                    );
                  }
                }
              },
              label: const Text(
                'Desvincular cliente',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
