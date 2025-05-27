import 'package:flutter/material.dart';
import 'package:mobile/themes/themes.dart';

class LoginFormField extends StatelessWidget {
  final String label;
  final String? hintText;
  final TextEditingController controller;
  final bool obscureText;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final Widget? suffixIcon;

  const LoginFormField({
    super.key,
    required this.controller,
    required this.label,
    this.hintText,
    this.obscureText = false,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: MyTheme.primary),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
        const SizedBox(height: 8),
        TextFormField(
  controller: controller,
  obscureText: obscureText,
  validator: validator,
  keyboardType: keyboardType,
  style: const TextStyle(color: Colors.white),
  decoration: InputDecoration(
    filled: true,
    fillColor: MyTheme.darkSurf, // Fondo oscuro consistente
    hintText: hintText,
    hintStyle: const TextStyle(color: Colors.white54),
    labelStyle: const TextStyle(color: Colors.white70),
    enabledBorder: border,
    focusedBorder: border.copyWith(
      borderSide: const BorderSide(color: MyTheme.primary, width: 2),
    ),
    border: border,
    suffixIcon: suffixIcon,
  ),
),

      ],
    );
  }
}
