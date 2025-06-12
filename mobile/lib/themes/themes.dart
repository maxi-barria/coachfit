import 'package:flutter/material.dart';

class MyTheme {
  static const Color primary   = Color.fromRGBO(255, 60, 0, 1);
  static const Color secondary = Color.fromRGBO(29, 31, 36, 1);
  static const Color darkBg    = Color(0xFF0F0F0F);   // negro “real”
  static const Color darkSurf  = Color(0xFF1B1B1B); 
  static const Color backgroundColor = Color(0xD3D3D3D3); // tarjetas / campos

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
      onSurface: Colors.black,
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
    textTheme: TextTheme(
      titleLarge: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: Colors.black,
        decoration: TextDecoration.none
      ),
      titleMedium: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.black,
        decoration: TextDecoration.none
      ),
      titleSmall: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.black,
        decoration: TextDecoration.none
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: Colors.black,
        decoration: TextDecoration.none
      )
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
      onSurface: Colors.white,
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

    textTheme: TextTheme(
      titleLarge: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: Colors.white,
        decoration: TextDecoration.none
      ),
      titleMedium: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.white,
        decoration: TextDecoration.none
      ),
      titleSmall: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.white,
        decoration: TextDecoration.none
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: Colors.white,
        decoration: TextDecoration.none
      )
    ),
  );
}
