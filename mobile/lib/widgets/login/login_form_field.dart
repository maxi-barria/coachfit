import 'package:mobile/themes/themes.dart';
import 'package:flutter/material.dart';


class LoginFormField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool? obscureText;
  final String ? Function(String?)? validator;

  const LoginFormField({
    required this.controller,
    required this.label,
    this.obscureText = false,
    this.validator,
    super.key, 
    });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 8,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.white, fontSize: 16),),
        TextFormField(
          controller: controller,
          obscureText: obscureText ?? false,
          validator: validator,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            labelStyle: TextStyle(color: Colors.white70),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: MyTheme.primary),
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: MyTheme.primary, width: 2),
              borderRadius: BorderRadius.circular(8),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: MyTheme.primary),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        )
      ],
    );  
  }
}