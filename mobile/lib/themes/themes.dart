import 'package:flutter/material.dart';

class MyTheme {
  static const Color primary   = Color.fromRGBO(255, 60, 0, 1);
  static const Color secondary = Color.fromRGBO(29, 31, 36, 1);
  static const Color darkBg    = Color(0xFF0F0F0F);   // negro “real”
  static const Color darkSurf  = Color(0xFF1B1B1B);   // tarjetas / campos

  // ------------------ Tema claro (sin cambios mayores) ------------------ //
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: primary,
    fontFamily: 'Poppins',
    colorScheme: ColorScheme.fromSeed(
      seedColor: primary,
      brightness: Brightness.light,
      primary: primary,
      secondary: secondary,
      error: Colors.red,
    ),
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: primary,
      foregroundColor: Colors.white,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: Colors.white,
      ),
    ),
  );

  // ------------------ Tema oscuro actualizado ------------------ //
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    fontFamily: 'Poppins',

    // Estos dos cubren prácticamente todo el fondo
    scaffoldBackgroundColor: darkBg,
    canvasColor: darkBg,

    colorScheme: const ColorScheme.dark().copyWith(
      primary: primary,
      secondary: secondary,
      background: darkBg,
      surface:   darkSurf,
      error: Colors.red,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: primary,
      foregroundColor: Colors.white,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: Colors.white,
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: darkSurf,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: primary, width: 2),
      ),
      labelStyle: const TextStyle(color: Colors.white70),
    ),
  );
}
