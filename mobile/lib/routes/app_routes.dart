import 'package:flutter/material.dart';
import 'package:mobile/models/routine.dart';
import 'package:mobile/models/workout.dart';
import 'package:mobile/screens/routine/workout_screen.dart';
import '../screens/core/screen.dart';
import '../screens/login/reset_password_screen.dart'; 
import '../screens/login/request_reset_screen.dart';


class AppRoutes {
  static const initialRoute = 'home';
  static Map<String, Widget Function(BuildContext)> routes = {
    'login': (BuildContext context) => const LoginScreen(),
    'register': (BuildContext context) => const RegisterScreen(),
    'home': (BuildContext context) => const HomeScreen(),
    'error': (BuildContext context) => const ErrorScreen(),
    'main': (BuildContext context) => const MainScreen(),
    'request-reset': (BuildContext context) => const RequestResetScreen(),

    'exercise_detail': (BuildContext context) => ExerciseDetailScreen(id: ModalRoute.of(context)!.settings.arguments as String),
    'workout': (BuildContext context) =>  WorkoutScreen(workout: ModalRoute.of(context)!.settings.arguments as Workout),
  };
  
static Route<dynamic> onGenerateRoute(RouteSettings s) {
  if (s.name == 'workout_detail' && s.arguments is Map<String, dynamic>) {
  return MaterialPageRoute(
    builder: (_) => const WorkoutDetailScreen(), // Usa los argumentos dentro de la pantalla
    settings: s,
  );
}

  if (s.name == 'exercise_form') {
  final args = s.arguments;
  if (args != null && args is Map<String, dynamic>) {
    return MaterialPageRoute(
      builder: (_) => ExerciseFormScreen(existingExercise: args),
    );
  }
  return MaterialPageRoute(
    builder: (_) => const ExerciseFormScreen(),
  );
}

  if (s.name == 'exercise_detail' && s.arguments is String) {
    return MaterialPageRoute(
      builder: (_) => ExerciseDetailScreen(id: s.arguments as String),
    );
  }
  if (s.name == '/reset' && s.arguments is String) {
    return MaterialPageRoute(
      builder: (_) => ResetPasswordScreen(token: s.arguments as String),
    );
  }
  if (s.name?.startsWith('/?token=') ?? false) {
    // descartamos “/?token=…” si Android lo llegara a inyectar
    return MaterialPageRoute(builder: (_) => const SizedBox.shrink());
  }
  return MaterialPageRoute(builder: (_) => const ErrorScreen());
}}
