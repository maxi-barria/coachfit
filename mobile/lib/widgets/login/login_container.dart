import 'package:flutter/material.dart';

class LoginContainer extends StatelessWidget {
  final Widget child;
  const LoginContainer({
    required this.child,
    super.key, 
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(32, 48, 16, 16),
      color: Color.fromRGBO(29, 31, 36, 1),
      width: double.infinity,
      height: double.infinity,
      child:  child,
      );
    }
  }