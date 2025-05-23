import 'package:flutter/material.dart';
import '../screens/screen.dart';
import '../screens/reset_password_screen.dart'; // <- Asegúrate de tener este archivo
import '../screens/request_reset_screen.dart'; // <- Asegúrate de tener este archivo

class AppRoutes {
  static const initialRoute = 'home';

  static Map<String, Widget Function(BuildContext)> routes = {
    'login': (BuildContext context) => const LoginScreen(),
    'register': (BuildContext context) => const RegisterScreen(),
    'home': (BuildContext context) => const HomeScreen(),
    'primary': (BuildContext context) => const PrimaryScreen(),
    'error': (BuildContext context) => const ErrorScreen(),
    'request-reset': (BuildContext context) => const RequestResetScreen(),
  };

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    if (settings.name == '/reset') {
      final token = settings.arguments as String;
      return MaterialPageRoute(
        builder: (context) => ResetPasswordScreen(token: token),
      );
    }

    return MaterialPageRoute(
      builder: (context) => const ErrorScreen(),
    );
  }
}
