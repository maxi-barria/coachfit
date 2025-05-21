import 'package:flutter/material.dart';
import 'package:mobile/themes/themes.dart';

class Button extends StatelessWidget{
  final String text;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;
  final double? width;
  final double? height;

  const Button({
    required this.text, 
    required this.onPressed, 
    this.backgroundColor = MyTheme.primary, 
    this.textColor = Colors.white, 
    this.borderColor = MyTheme.primary, 
    this.width = double.infinity, 
    this.height = 32.0,
    super.key,
  });

  @override
  Widget build (BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: TextButton(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          side: BorderSide(color: borderColor ?? const Color.fromARGB(255, 255, 60, 0), width: 1.0),
        ),
        onPressed: onPressed,
        child: Text(text, style: TextStyle(color: textColor, fontSize: 16.0)),
      ),
    );
  }
}