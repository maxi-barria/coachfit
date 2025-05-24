import 'package:flutter/material.dart';

class LoginContainer extends StatelessWidget {
  final Widget child;

  const LoginContainer({
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor, // Usa el color del tema
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          width: double.infinity,
          height: double.infinity,
          child: child,
        ),
      ),
    );
  }
}
