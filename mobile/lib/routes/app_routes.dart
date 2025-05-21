import 'package:flutter/material.dart';
import '../screens/screen.dart';

class AppRoutes {
  static const initialRoute = 'home';
  static Map<String, Widget Function(BuildContext)> routes = {
    'login': (BuildContext context) => const LoginScreen(),
    'register': (BuildContext context) => const RegisterScreen(),
    'home': (BuildContext context) => const HomeScreen(),
    'primary': (BuildContext context) => const PrimaryScreen(),
    'error': (BuildContext context) => const ErrorScreen(),
  };

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (context) => const ErrorScreen(),
    );
  }
}
