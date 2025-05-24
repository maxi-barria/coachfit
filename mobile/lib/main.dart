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
    if (uri != null && uri.path == '/reset-password') {
      final token = uri.queryParameters['token'];
      print('📥 Token desde deep link: $token');
      if (token != null) {
        Future.microtask(() {
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
