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

    // Esta ruta espera una Routine como argumento
    'workout': (BuildContext context) {
  final args = ModalRoute.of(context)?.settings.arguments;
  if (args is Workout) {
    return WorkoutScreen(workout: args);
  }
  return const ErrorScreen();
},
  };

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final name = settings.name;
    final args = settings.arguments;

    if (name == 'workout_detail' && args is Map<String, dynamic>) {
      return MaterialPageRoute(
        builder: (_) => const WorkoutDetailScreen(),
        settings: settings,
      );
    }

    if (name == 'exercise_form') {
      if (args != null && args is Map<String, dynamic>) {
        return MaterialPageRoute(
          builder: (_) => ExerciseFormScreen(existingExercise: args),
        );
      }
      return MaterialPageRoute(
        builder: (_) => const ExerciseFormScreen(),
      );
    }

    if (name == 'exercise_detail' && args is String) {
      return MaterialPageRoute(
        builder: (_) => ExerciseDetailScreen(id: args),
      );
    }

    if (name == '/reset' && args is String) {
      return MaterialPageRoute(
        builder: (_) => ResetPasswordScreen(token: args),
      );
    }

    if (name?.startsWith('/?token=') ?? false) {
      return MaterialPageRoute(builder: (_) => const SizedBox.shrink());
    }

    return MaterialPageRoute(builder: (_) => const ErrorScreen());
  }
}
