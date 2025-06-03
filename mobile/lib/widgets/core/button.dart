import 'package:flutter/material.dart';
import 'package:mobile/themes/themes.dart';

class Button extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;
  final double? width;
  final double? height;

  const Button({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor = MyTheme.primary,
    this.textColor = Colors.white,
    this.borderColor = MyTheme.primary,
    this.width = double.infinity,
    this.height = 48.0,
  });

  @override
  Widget build(BuildContext context) {
    final bool isTransparent = backgroundColor == null || backgroundColor == Colors.transparent;

    return SizedBox(
      width: width,
      height: height,
      child: TextButton(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          foregroundColor: textColor,
          backgroundColor: isTransparent ? null : backgroundColor,
          side: BorderSide(
            color: borderColor ?? MyTheme.primary,
            width: isTransparent ? 1.0 : 0.0,
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontSize: 16.0,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
