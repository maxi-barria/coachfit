import 'package:mobile/core/core.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  final AppLinks _appLinks = AppLinks();

  @override
  void initState() {
    super.initState();
    _listenForInitialLink();
    _listenForLiveLinks();
  }

  void _listenForInitialLink() async {
    try {
      final uri = await _appLinks.getInitialAppLink();
      _redirectIfNeeded(uri);
    } catch (e) {
      print('Error al obtener el link inicial: $e');
    }
  }

  void _listenForLiveLinks() {
    _appLinks.uriLinkStream.listen((uri) {
      _redirectIfNeeded(uri);
    });
  }
void _redirectIfNeeded(Uri? uri) {
  if (uri != null) {
    debugPrint('🌐 URI: $uri');
    final path = uri.path;
    final token = uri.queryParameters['token'];
    debugPrint('📍 path: $path');
    debugPrint('📦 token: $token');

    if (path == '/reset-password' && token != null) {
      Future.microtask(() {
        debugPrint('🧭 Navegando a /reset con token: $token');
        navigatorKey.currentState?.pushNamed('/reset', arguments: token);
      });
    }
  }
}



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
  title: 'CoachFit',
  navigatorKey: navigatorKey,
  theme:      MyTheme.lightTheme,
  darkTheme:  MyTheme.darkTheme,
  themeMode:  ThemeMode.dark,
  initialRoute: AppRoutes.initialRoute,
  routes:       AppRoutes.routes,
  onGenerateRoute: AppRoutes.onGenerateRoute,
);
  }
}
