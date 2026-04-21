import 'package:flutter/material.dart';

class AppThemes {
  // light Theme
  static final light = ThemeData(
    primaryColor: const Color(0xFFff5722),
    scaffoldBackgroundColor: Colors.white,
    brightness: Brightness.light,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.black),
    ),
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFFff5722),
      primary: const Color(0xFFff5722),
      brightness: Brightness.light,
      surface: Colors.white,
    ),
    cardColor: Colors.white,
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: const Color(0xFFff5722),
      unselectedItemColor: Colors.grey,
    ),
  );

  // Dark theme
  static final dark = ThemeData(
    primaryColor: const Color(0xFFff5722),
    scaffoldBackgroundColor: Color(0xFF121212),
    brightness: Brightness.dark,
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF121212),
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.white),
    ),
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFFff5722),
      primary: const Color(0xFFff5722),
      brightness: Brightness.dark,
      surface: const Color(0xFF121212),
    ),
    cardColor: Color(0xFF1E1E1E),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor:Color(0xFF1E1E1E),
      selectedItemColor: const Color(0xFFff5722),
      unselectedItemColor: Colors.grey,
    ),
  );
}
