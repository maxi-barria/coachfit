import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'package:mobile/core/core.dart';
import 'package:mobile/providers/loggin_provider.dart';
import 'package:mobile/providers/routine_provider.dart';
import 'package:mobile/providers/workout_status_provider.dart';
import 'package:mobile/screens/login/login_screen.dart';
import 'package:mobile/screens/login/reset_password_screen.dart';
import 'package:mobile/widgets/core/navigation.dart';
import 'package:mobile/routes/app_routes.dart';      

void main() async {
  WidgetsFlutterBinding.ensureInitialized();        
  await dotenv.load(fileName: '.env');
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LogginProvider()),
        ChangeNotifierProvider(create: (_) => RoutineProvider()),
        ChangeNotifierProvider(create: (_) => WorkoutStatusProvider()),
      ],
      child: const CoachFitApp(),
    ),
  );
}

class CoachFitApp extends StatefulWidget {
  const CoachFitApp({super.key});

  @override
  State<CoachFitApp> createState() => _CoachFitAppState();
}

class _CoachFitAppState extends State<CoachFitApp> {
  final navigatorKey = GlobalKey<NavigatorState>();
  final _appLinks = AppLinks();
  String? _lastToken;

  @override
  void initState() {
    super.initState();
    _listenInitial();
    _listenStream();
  }

  void _listenInitial() async => _handleUri(await _appLinks.getInitialLink());

  void _listenStream() => _appLinks.uriLinkStream.listen(_handleUri);

  void _handleUri(Uri? uri) {
    if (uri == null) return;
    final token = uri.queryParameters['token'];
    final isReset = uri.host == 'reset-password';
    if (!isReset || token == null || token == _lastToken) return;
    _lastToken = token;

    navigatorKey.currentState?.pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => ResetPasswordScreen(token: token)),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LogginProvider>(
      builder: (_, login, __) {
        return MaterialApp(
          title: 'CoachFit',
          debugShowCheckedModeBanner: false,
          navigatorKey: navigatorKey,
          theme: MyTheme.lightTheme,
          darkTheme: MyTheme.darkTheme,
          themeMode: ThemeMode.light,

          // 🌐 --- Localización ---
          locale: const Locale('es'),                
          supportedLocales: const [
            Locale('es'),                              // español
            Locale('en'),                              // inglés (por si acaso)
          ],
            localizationsDelegates: const [      
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
  ],

          // Rutas
          routes: AppRoutes.routes,
          onGenerateRoute: AppRoutes.onGenerateRoute,

          // Home decide según login
          home: _buildHome(login),
        );
      },
    );
  }

  Widget _buildHome(LogginProvider login) {
    if (login.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return login.isAuthenticated ? const Navigation() : const LoginScreen();
  }
}
