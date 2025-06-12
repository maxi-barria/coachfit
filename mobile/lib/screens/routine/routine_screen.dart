import 'package:flutter/material.dart';
import 'package:mobile/widgets/routine/routine_card.dart';
import 'package:mobile/themes/themes.dart';

class RoutineScreen extends StatelessWidget {
  const RoutineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyTheme.backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'NOMBRE RUTINA',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Icon(Icons.add, color: MyTheme.primary),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'CANTIDAD DE RUTINAS',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return const RoutineCard();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}