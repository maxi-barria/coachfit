import 'package:flutter/material.dart';
import '../screens/screen.dart';

class AppRoutes {
  static const initialRoute = 'home';
  static Map<String, Widget Function(BuildContext)> routes = {
    'login': (BuildContext context) => const LoginScreen(),
    'register': (BuildContext context) => const RegisterScreen(),
    'home': (BuildContext context) => const HomeScreen(),
    'error': (BuildContext context) => const ErrorScreen(),
    'profile': (BuildContext context) => const ProfileScreen(),
    'coach': (BuildContext context) => const CoachScreen(),
    'exercise': (BuildContext context) => const ExerciseScreen(),
    'train': (BuildContext context) => const TrainScreen(),
  }; 

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (context) => const ErrorScreen(),
    );
  }
}
