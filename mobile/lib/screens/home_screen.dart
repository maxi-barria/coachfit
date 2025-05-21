import 'package:mobile/widgets/login/login_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile/widgets/core/button.dart';
import 'package:mobile/themes/themes.dart';

class HomeScreen extends StatelessWidget{
  const HomeScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return LoginContainer(
      child: Column(
        children: [
          Expanded(child: Column(
            children: [
              SvgPicture.asset(
                'lib/assets/logo.svg',
                fit: BoxFit.contain,  
              ),
              Text(
                'CoachFit', 
                style: TextStyle(
                  fontSize: 64, 
                  fontWeight: FontWeight.bold
                )
              ),
            ],
          ),
        ),
        Column(
          spacing: 8,
          children: [
            Button(
              text: 'Registrarse', 
              onPressed: () => Navigator.pushNamed(context, 'register'),
            ),
            Button(
              text: 'Iniciar Sesión',
              onPressed: () => Navigator.pushNamed(context, 'login'),
              textColor: MyTheme.primary,
              backgroundColor: null,
            )
          ]
        )
      ],
      )
    );
  }
}