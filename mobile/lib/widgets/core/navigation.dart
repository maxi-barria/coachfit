import 'package:mobile/themes/themes.dart';
import 'package:flutter/material.dart';
import 'package:mobile/screens/core/screen.dart';

class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  final List<String> _routeNames = [
    'profile',
    'coach',
    'train',
    'exercise',
  ];

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;
    setState(() {
      _selectedIndex = index;
    });
    Navigator.pushReplacementNamed(context, _routeNames[index]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Navigator(
        key: GlobalKey<NavigatorState>(),
        onGenerateRoute: (settings) {
          Widget page;
          switch (_routeNames[_selectedIndex]) {
            case 'profile':
              page = ProfileScreen();
              break;
            case 'coach':
              page = CoachScreen();
              break;
            case 'routine':
              page = RoutineScreen();
              break;
            case 'exercise':
              page = ExerciseScreen();
              break;
            default:
              page = ProfileScreen();
          }
          return MaterialPageRoute(builder: (_) => page);
        },
      ),
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
        backgroundColor: Colors.grey[200],
        indicatorColor: MyTheme.primary,
      ),
    );
  }
}
