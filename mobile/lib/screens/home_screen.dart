import 'package:mobile/core/core.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LoginContainer(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(), // Espacio arriba

            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  'lib/assets/logo.svg',
                  height: 100,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 16),
                Text(
                  'CoachFit',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: MyTheme.primary,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 3,
                  width: 100,
                  color: Colors.yellow,
                ),
              ],
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Button(
                  text: 'Registrarse',
                  onPressed: () => Navigator.pushNamed(context, '/register'),
                ),
                const SizedBox(height: 12),
                Button(
                  text: 'Iniciar Sesión',
                  onPressed: () => Navigator.pushNamed(context, '/login'),
                  textColor: MyTheme.primary,
                  backgroundColor: Colors.transparent,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
