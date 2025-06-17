// lib/routes/app_routes.dart
import 'package:flutter/material.dart';
import 'package:mobile/models/routine.dart';

// Auth
import 'package:mobile/screens/login/login_screen.dart';
import 'package:mobile/screens/login/register_screen.dart';
import 'package:mobile/screens/login/request_reset_screen.dart';
import 'package:mobile/screens/login/reset_password_screen.dart';

// Core / Home
import 'package:mobile/screens/core/home_screen.dart';
import 'package:mobile/screens/core/error_screen.dart';
import 'package:mobile/screens/core/main_screen.dart';

// Routine & Workout
import 'package:mobile/models/workout.dart';
import 'package:mobile/screens/profile/workout_detail_screen.dart';
import 'package:mobile/screens/routine/routine_screen.dart';
import 'package:mobile/screens/routine/routine_wizard_screen.dart';
import 'package:mobile/screens/routine/workout_screen.dart';


// Exercise
import 'package:mobile/screens/exercise/exercise_form_screen.dart';
import 'package:mobile/screens/exercise/exercise_detail_screen.dart';

class AppRoutes {
  static const initialRoute = 'home';

  // Rutas “simples” (sin argumentos)
  static Map<String, WidgetBuilder> routes = {
    'login': (_) => const LoginScreen(),
    'register': (_) => const RegisterScreen(),
    'home': (_) => const HomeScreen(),
    'error': (_) => const ErrorScreen(),
    'main': (_) => const MainScreen(),
    'request-reset': (_) => const RequestResetScreen(),
    'routine': (_) => const RoutineScreen(),
  };

  // Rutas que necesitan argumentos o lógica adicional
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final name = settings.name;
    final args = settings.arguments;

    /* ---------- Workout con argumento ---------- */
    if (name == 'workout') {
      // Esta ruta espera un **Workout** como argumento
      if (args is Workout) {
        return MaterialPageRoute(
          builder: (_) => WorkoutScreen(workout: args),
          settings: settings,
        );
      }
      return _error();
    }

    /* ---------- Workout detail ---------- */
    if (name == 'workout_detail' && args is Map<String, dynamic>) {
      return MaterialPageRoute(
        builder: (_) => const WorkoutDetailScreen(),
        settings: settings,
      );
    }

    /* ---------- Exercise form (create / edit) ---------- */
    if (name == 'exercise_form') {
      if (args != null && args is Map<String, dynamic>) {
        return MaterialPageRoute(
          builder: (_) => ExerciseFormScreen(existingExercise: args),
          settings: settings,
        );
      }
      return MaterialPageRoute(
        builder: (_) => const ExerciseFormScreen(),
        settings: settings,
      );
    }

    /* ---------- Exercise detail ---------- */
    if (name == 'exercise_detail' && args is String) {
      return MaterialPageRoute(
        builder: (_) => ExerciseDetailScreen(id: args),
        settings: settings,
      );
    }

    /* ---------- Reset password (deep-link) ---------- */
    if (name == '/reset' && args is String) {
      return MaterialPageRoute(
        builder: (_) => ResetPasswordScreen(token: args),
        settings: settings,
      );
    }

    // Ignora /?token=… (Render redirect) → pantalla vacía
    if (name?.startsWith('/?token=') ?? false) {
      return MaterialPageRoute(
        builder: (_) => const SizedBox.shrink(),
        settings: settings,
      );
    }
    if (name == 'routine_wizard' && args is Routine) {
  return MaterialPageRoute(
    builder: (_) => RoutineWizardScreen(routine: args),
    settings: settings,
  );
}

    /* ---------- Ruta no encontrada ---------- */
    return _error();
  }

  static MaterialPageRoute _error() =>
      MaterialPageRoute(builder: (_) => const ErrorScreen());
}
