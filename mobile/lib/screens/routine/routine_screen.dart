import 'package:flutter/material.dart';
import 'package:mobile/providers/routine_provider.dart';
import 'package:mobile/widgets/routine/routine_card.dart';
import 'package:mobile/themes/themes.dart';
import 'package:provider/provider.dart';
import 'package:mobile/core/core.dart'; // Importa CustomAppBar desde aquí

class RoutineScreen extends StatefulWidget {
  const RoutineScreen({super.key});

  @override
  State<RoutineScreen> createState() => _RoutineScreenState();
}

class _RoutineScreenState extends State<RoutineScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<RoutineProvider>(context, listen: false).fetchRoutines());
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RoutineProvider>(
      builder: (context, routineProvider, _) {
        return Scaffold(
          backgroundColor: MyTheme.backgroundColor,
          appBar: const CustomAppBar(title: 'Rutinas', showBack: false),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Mis Rutinas (${routineProvider.routines.length})',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Icon(Icons.add, color: MyTheme.primary),
                  ],
                ),
                const SizedBox(height: 16),
                if (routineProvider.isLoading)
                  const Center(child: CircularProgressIndicator())
                else if (routineProvider.error != null)
                  Center(child: Text('Error: ${routineProvider.error}'))
                else if (routineProvider.routines.isEmpty)
                  const Center(child: Text('No hay rutinas disponibles'))
                else
                  Expanded(
                    child: ListView.builder(
                      itemCount: routineProvider.routines.length,
                      itemBuilder: (context, index) {
                        final routine = routineProvider.routines[index];
                        return RoutineCard(routine: routine);
                      },
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
