import 'package:flutter/material.dart';
import 'package:mobile/providers/routine_provider.dart';
import 'package:mobile/screens/routine/routine_screen_form.dart';
import 'package:mobile/screens/routine/routine_wizard_screen.dart';
import 'package:mobile/widgets/routine/routine_card.dart';
import 'package:mobile/themes/themes.dart';
import 'package:provider/provider.dart';
import 'package:mobile/core/core.dart'; // CustomAppBar

class RoutineScreen extends StatefulWidget {
  const RoutineScreen({super.key});

  @override
  State<RoutineScreen> createState() => _RoutineScreenState();
}

class _RoutineScreenState extends State<RoutineScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _anim = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 150),
    upperBound: 0.1,
  );

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => context.read<RoutineProvider>().fetchRoutines(),
    );
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

Future<void> _openRoutineForm() async {
  final Map<String, dynamic>? data = await Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => const RoutineWizardScreen()),
  );

  if (data != null && mounted) {
    await context.read<RoutineProvider>().createRoutine(data);
  }
}


  @override
  Widget build(BuildContext context) {
    return Consumer<RoutineProvider>(
      builder: (_, routineProvider, __) {
        // ----- SnackBar para error ---------------------------------------------------
        if (routineProvider.error != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(routineProvider.error!)),
            );
          });
        }

        return Scaffold(
          backgroundColor: MyTheme.backgroundColor,
          appBar: const CustomAppBar(title: 'Rutinas', showBack: false),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ---------- Encabezado ------------------------------------------------
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Mis Rutinas (${routineProvider.routines.length})',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    InkResponse(
                      onTapDown: (_) => _anim.forward(),
                      onTapCancel: _anim.reverse,
                      onTap: () {
                        _anim.reverse();
                        _openRoutineForm();
                      },
                      radius: 24,
                      child: ScaleTransition(
                        scale: Tween(begin: 1.0, end: 0.9).animate(_anim),
                        child: Icon(Icons.add, color: MyTheme.primary, size: 28),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // ---------- Contenido principal --------------------------------------
                Expanded(
                  child: Builder(
                    builder: (_) {
                      if (routineProvider.isLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (routineProvider.routines.isEmpty) {
                        return const Center(
                            child: Text('No hay rutinas disponibles'));
                      }

                      return ListView.builder(
                        itemCount: routineProvider.routines.length,
                        itemBuilder: (context, index) {
                          final routine = routineProvider.routines[index];
                          return RoutineCard(routine: routine);
                        },
                      );
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
