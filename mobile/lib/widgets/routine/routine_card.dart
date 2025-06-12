import 'package:flutter/material.dart';
import 'package:mobile/themes/themes.dart';

class RoutineCard extends StatelessWidget {
  const RoutineCard({super.key});
  

  @override
  Widget build(BuildContext context) {
     return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'NAME ROUTINE',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Icon(Icons.add, color: MyTheme.primary),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'DETALLE EJERCICIOS',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          Row(
            children: const [
              Icon(Icons.access_time, color: Colors.red, size: 16),
              SizedBox(width: 4),
              Text("HACE CUANTOS DÍAS SE HIZO LA RUTINA"),
            ],
          ),
        ],
      ),
    );
  }
}