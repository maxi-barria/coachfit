import 'package:mobile/core/core.dart';
import 'screens/login/reset_password_screen.dart';
import 'package:mobile/providers/loggin_provider.dart';
import 'package:provider/provider.dart';

void main() => runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => LogginProvider()),
    ],
    child: MyApp(),
  ));

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final navigatorKey = GlobalKey<NavigatorState>();
  final _appLinks    = AppLinks();
  String? _lastToken;                       // evita dobles intents

  @override
  void initState() {
    super.initState();
    _listenInitial();
    _listenStream();
  }

  /* ---------- deep-links ---------- */

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

    if (!isReset || token == null) return;          // no es nuestro link
    if (token == _lastToken) return;                // duplicado
    _lastToken = token;

    debugPrint('🧭 deep-link con token $token');

    // ‼️ limpiamos la pila y reemplazamos por la pantalla de reset
    navigatorKey.currentState?.pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => ResetPasswordScreen(token: token),
      ),
      (route) => false,      // elimina todas las rutas anteriores
    );
  }

  /* ---------- app ---------- */

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CoachFit',
      navigatorKey: navigatorKey,
      theme:       MyTheme.lightTheme,
      darkTheme:   MyTheme.darkTheme,
      themeMode:   ThemeMode.light,
      initialRoute: AppRoutes.initialRoute,
      routes:        AppRoutes.routes,
      onGenerateRoute: AppRoutes.onGenerateRoute,
      debugShowCheckedModeBanner: false,
    );
  }
}