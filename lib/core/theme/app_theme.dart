import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const primary = Color(0xFF1A73E8);
  static const primaryDark = Color(0xFF0B3D91);
  static const teal = Color(0xFF00A896);
  static const saffron = Color(0xFFFFB703);
  static const coral = Color(0xFFE85D75);
  static const error = coral;
  static const ink = Color(0xFF172033);
  static const muted = Color(0xFF667085);
  static const bgColor = Color(0xFFF6F8FC);
  static const bgDark = Color(0xFF0F172A);
  static const surfaceDark = Color(0xFF1E293B);

  static ThemeData get lightTheme {
    final textTheme = GoogleFonts.plusJakartaSansTextTheme();
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: bgColor,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        primary: primary,
        secondary: teal,
        tertiary: saffron,
        surface: Colors.white,
        error: coral,
      ),
      textTheme: textTheme.apply(bodyColor: ink, displayColor: ink),
      appBarTheme: AppBarTheme(
        centerTitle: false,
        backgroundColor: bgColor,
        elevation: 0,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: ink,
          fontWeight: FontWeight.w800,
        ),
      ),
      cardTheme: const CardThemeData(
        elevation: 0,
        color: Colors.white,
        surfaceTintColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primary, width: 2),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    final textTheme =
        GoogleFonts.plusJakartaSansTextTheme(ThemeData.dark().textTheme);
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: bgDark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        brightness: Brightness.dark,
        primary: const Color(0xFF4A90D9),
        secondary: teal,
        tertiary: saffron,
        surface: surfaceDark,
        error: coral,
      ),
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: bgDark,
        elevation: 0,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w800,
        ),
      ),
      cardTheme: const CardThemeData(
        elevation: 0,
        color: surfaceDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
      ),
    );
  }
}