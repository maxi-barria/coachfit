import 'package:flutter/material.dart';
import '../screens/screen.dart';
import '../screens/reset_password_screen.dart'; 
import '../screens/request_reset_screen.dart';

class AppRoutes {
  static const initialRoute = '/home';

  static Map<String, Widget Function(BuildContext)> routes = {
    '/login': (BuildContext context) => const LoginScreen(),
    '/register': (BuildContext context) => const RegisterScreen(),
    '/home': (BuildContext context) => const HomeScreen(),
    '/primary': (BuildContext context) => const PrimaryScreen(),
    '/error': (BuildContext context) => const ErrorScreen(),
    '/request-reset': (BuildContext context) => const RequestResetScreen(),
  };

static Route<dynamic> onGenerateRoute(RouteSettings settings) {
  debugPrint('📍 onGenerateRoute: ${settings.name}');
  debugPrint('📦 arguments: ${settings.arguments}');

  if (settings.name == '/reset') {
    final token = settings.arguments;
    if (token is String) {
      debugPrint('✅ Redirigiendo a ResetPasswordScreen con token');
      return MaterialPageRoute(
        builder: (context) => ResetPasswordScreen(token: token),
      );
    } else {
      debugPrint('❌ Argumento no válido');
    }
  }

  return MaterialPageRoute(builder: (_) => const ErrorScreen());
}

}
