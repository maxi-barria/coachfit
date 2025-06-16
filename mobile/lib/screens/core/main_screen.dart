
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:mobile/screens/core/screen.dart';
import 'package:mobile/themes/themes.dart';
import 'package:mobile/providers/loggin_provider.dart';
import 'package:mobile/providers/workout_status_provider.dart';
import 'package:mobile/widgets/active_workout_bar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  void _onItemTapped(int i) => setState(() => _selectedIndex = i);

  @override
  Widget build(BuildContext context) {
    /* ─────────── datos de sesión ─────────── */
    final auth  = context.watch<LogginProvider>();
    final rol   = auth.currentUser!.rol;
    final coach = auth.currentUser!.id;
    final token = auth.token!;

    /* ─────────── proveedor de workout ─────────── */
    final ws = context.watch<WorkoutStatusProvider>();

    /* ─────────── páginas ─────────── */
    final pages = <Widget>[
      const ProfileScreen(),
      if (rol == 'coach') CoachScreen(coachId: coach, token: token),
      const RoutineScreen(),
      const ExerciseScreen(),
    ];

    /* ─────────── UI ─────────── */
    final bottomSafe = MediaQuery.of(context).padding.bottom;
    const barH       = kBottomNavigationBarHeight;        // 56

    return Scaffold(
      body: Stack(
        children: [
          pages[_selectedIndex],
          if (ws.activeWorkout != null)                    // barra SIEMPRE visible
            Positioned(
              // 8 px arriba de la nav bar + respetamos bottom inset
              bottom: barH + bottomSafe ,
              left: 16,
              right: 16,
              child: ActiveWorkoutBar(
                onTap: () {
                  if (ws.isMinimized) {
                    ws.resumeWorkout();
                    Navigator.pushNamed(context, 'workout',
                        arguments: ws.activeWorkout);
                  }
                },
              ),
            ),
        ],
      ),

      /* ───────── bottom nav ───────── */
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        backgroundColor: MyTheme.secondary,
        indicatorColor: MyTheme.primary,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.person_outline), label: 'Perfil'),
          NavigationDestination(icon: Icon(Icons.people),            label: 'Coach'),
          NavigationDestination(icon: Icon(Icons.add),               label: 'Entrenamiento'),
          NavigationDestination(icon: Icon(Icons.fitness_center),    label: 'Ejercicios'),
        ],
      ),
    );
  }
}
