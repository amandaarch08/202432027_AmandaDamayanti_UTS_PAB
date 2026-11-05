
import 'package:flutter/material.dart';

class AppTheme {
  // Main colors
  static const Color butterYellow = Color(0xFFF7E96A);
  static const Color navy = Color(0xFF17243E);
  static const Color cream = Color(0xFFF2F0E6);

  // Supporting colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color muted = Color(0xFF96958D);
  static const Color coral = Color(0xFFE58B78);
  static const Color softGreen = Color(0xFFA9C7A7);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: cream,
      colorScheme: const ColorScheme.light(
        primary: navy,
        secondary: butterYellow,
        surface: cream,
        error: coral,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: cream,
        foregroundColor: navy,
        elevation: 0,
        centerTitle: false,
      ),
      fontFamily: 'Roboto',
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
