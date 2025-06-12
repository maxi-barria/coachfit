import 'package:flutter/material.dart';
import 'package:mobile/screens/core/screen.dart'; // importa tus pantallas
import 'package:mobile/themes/themes.dart';

class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    ProfileScreen(),
    CoachScreen(),
    TrainScreen(),
    ExerciseScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.person_outline), label: 'Perfil'),
          NavigationDestination(icon: Icon(Icons.people), label: 'Coach'),
          NavigationDestination(icon: Icon(Icons.add), label: 'Entrenamiento'),
          NavigationDestination(icon: Icon(Icons.fitness_center), label: 'Ejercicios'),
        ],
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        backgroundColor: Colors.grey[200],
        indicatorColor: MyTheme.primary,
      ),
    );
  }
}
