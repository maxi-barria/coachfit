import 'package:flutter/material.dart';
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
  };
  
static Route<dynamic> onGenerateRoute(RouteSettings s) {
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
