import 'package:mobile/themes/themes.dart';
import 'package:flutter/material.dart';
import 'package:mobile/screens/core/screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final List<Widget> _widgetOptions = [
    ProfileScreen(),
    CoachScreen(),
    RoutineScreen(),
    ExerciseScreen(),
  ];

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        destinations: [
          NavigationDestination(icon: Icon(Icons.person_outline), label: 'Perfil',),
          NavigationDestination(icon: Icon(Icons.people), label: 'Coach'),
          NavigationDestination(icon: Icon(Icons.add), label: 'Entrenamiento'),
          NavigationDestination(icon: Icon(Icons.fitness_center), label: 'Ejercicios',
          ),
        ],
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        backgroundColor: MyTheme.secondary,
        indicatorColor: MyTheme.primary,
      ),
    );
  }
}
