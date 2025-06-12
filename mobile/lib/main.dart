import 'package:flutter/material.dart';
import 'package:mobile/core/core.dart';
import 'package:mobile/providers/loggin_provider.dart';
import 'package:mobile/screens/login/reset_password_screen.dart';
import 'package:mobile/screens/login/login_screen.dart';
import 'package:provider/provider.dart';
import 'package:mobile/screens/exercise/exercise_screen.dart';
import 'widgets/core/navigation.dart';

void main() => runApp(
  MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => LogginProvider()),
    ],
    child: const MyApp(),
  ),
);

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final navigatorKey = GlobalKey<NavigatorState>();
  final _appLinks = AppLinks();

  String? _lastToken;

  @override
  void initState() {
    super.initState();
    _listenInitial();
    _listenStream();
  }

  void _listenInitial() async {
    _handleUri(await _appLinks.getInitialAppLink());
  }

  void _listenStream() {
    _appLinks.uriLinkStream.listen(_handleUri);
  }

  void _handleUri(Uri? uri) {
    if (uri == null) return;

    final token = uri.queryParameters['token'];
    final isReset = uri.host == 'reset-password';

    if (!isReset || token == null) return;
    if (token == _lastToken) return;
    _lastToken = token;

    navigatorKey.currentState?.pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => ResetPasswordScreen(token: token),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LogginProvider>(
      builder: (context, loginProvider, _) {
        return MaterialApp(
          title: 'CoachFit',
          navigatorKey: navigatorKey,
          theme: MyTheme.lightTheme,
          darkTheme: MyTheme.darkTheme,
          themeMode: ThemeMode.light,
          routes: AppRoutes.routes, // <- sigue usando routes estáticas simples
          onGenerateRoute: AppRoutes.onGenerateRoute,
          debugShowCheckedModeBanner: false,
          home: _buildHome(loginProvider),
        );
      },
    );
  }

  Widget _buildHome(LogginProvider provider) {
    if (provider.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (provider.isAuthenticated) {
      return const Navigation();
    } else {
      return const LoginScreen();
    }
  }
}
