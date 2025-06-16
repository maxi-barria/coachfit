import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:mobile/screens/core/screen.dart';
import 'package:mobile/themes/themes.dart';
import 'package:mobile/providers/loggin_provider.dart';
import 'package:mobile/providers/workout_status_provider.dart';
import 'package:mobile/widgets/active_workout_bar.dart';

class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int _selected = 0;

  void _onTap(int i) {
    if (i == _selected) return;
    setState(() => _selected = i);
  }

  @override
  Widget build(BuildContext context) {
    /* ---------- datos de autenticación ---------- */
    final auth   = context.watch<LogginProvider>();
    final rol    = auth.currentUser!.rol;
    final coach  = auth.currentUser!.id;
    final token  = auth.token!;

    /* ---------- provider de workout ---------- */
    final ws        = context.watch<WorkoutStatusProvider>();
    final workout   = ws.activeWorkout;
    final minimized = ws.isMinimized;

    /* ---------- páginas ---------- */
    final pages = <Widget>[
      const ProfileScreen(),
      if (rol == 'coach') CoachScreen(coachId: coach, token: token),
      const RoutineScreen(),
      const ExerciseScreen(),
    ];

    /* ---------- bottom nav ---------- */
    final destinations = <NavigationDestination>[
      const NavigationDestination(icon: Icon(Icons.person_outline), label: 'Perfil'),
      if (rol == 'coach')
        const NavigationDestination(icon: Icon(Icons.people), label: 'Coach'),
      const NavigationDestination(icon: Icon(Icons.add), label: 'Entrenamiento'),
      const NavigationDestination(icon: Icon(Icons.fitness_center), label: 'Ejercicios'),
    ];

    return Scaffold(
      body: Stack(
        children: [
          /* Contenido principal */
          IndexedStack(index: _selected, children: pages),

          /* Barra flotante del workout */
          if (workout != null)
            SafeArea(
              bottom: true,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(
                          bottom: kBottomNavigationBarHeight + 8),
                  child: ActiveWorkoutBar(
                    onTap: () {
                      if (minimized) {
                        ws.resumeWorkout();
                        Navigator.pushNamed(context, 'workout',
                            arguments: workout);
                      }
                    },
                  ),
                ),
              ),
            ),
        ],
      ),

      bottomNavigationBar: NavigationBar(
        selectedIndex: _selected,
        onDestinationSelected: _onTap,
        destinations: destinations,
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        backgroundColor: Colors.grey.shade200,
        indicatorColor: MyTheme.primary,
      ),
    );
  }
}
