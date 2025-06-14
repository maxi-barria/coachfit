import 'package:flutter/material.dart';
import 'package:mobile/screens/core/screen.dart'; // importa tus pantallas
import 'package:mobile/themes/themes.dart';
import 'package:provider/provider.dart';
import 'package:mobile/providers/loggin_provider.dart';

class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<LogginProvider>(context);
    final token = auth.token!;
    final coachId = auth.currentUser!.id;
    final rol = auth.currentUser!.rol;

    final pages = <Widget>[
      const ProfileScreen(),
      if (rol == 'coach') CoachScreen(coachId: coachId, token: token),
      const TrainScreen(),
      const ExerciseScreen(),
    ];

    final destinations = <NavigationDestination>[
      const NavigationDestination(icon: Icon(Icons.person_outline), label: 'Perfil'),
      if (rol == 'coach') const NavigationDestination(icon: Icon(Icons.people), label: 'Coach'),
      const NavigationDestination(icon: Icon(Icons.add), label: 'Entrenamiento'),
      const NavigationDestination(icon: Icon(Icons.fitness_center), label: 'Ejercicios'),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        destinations: destinations,
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        backgroundColor: Colors.grey[200],
        indicatorColor: MyTheme.primary,
      ),
    );
  }
}
