import 'package:flutter/material.dart';

class MyTheme {
  static const Color primary = Color.fromRGBO(255, 60, 0, 1);
  static const Color secundary = Color.fromRGBO(29, 31, 36, 1);
  static final ThemeData myTheme = ThemeData(
      primaryColor: primary,
      brightness: Brightness.light,
      fontFamily: 'Poppins',
      appBarTheme: const AppBarTheme(
        color: primary,
        elevation: 20,
      ),
      textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(foregroundColor:primary)),
      floatingActionButtonTheme:
          const FloatingActionButtonThemeData(backgroundColor: primary));
}