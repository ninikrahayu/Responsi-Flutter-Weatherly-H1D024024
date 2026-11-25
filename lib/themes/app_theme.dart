import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const primary = Color(0xFFE52528);
  static const primaryLight = Color(0xFFFCE8E8);
  static const textPrimary = Color(0xFF181818);
  static const textSecondary = Color(0xFF737373);
  static const background = Color(0xFFF5F5F3);
  static const surface = Colors.white;
  static const border = Color(0xFFD4D4D4);

  static TextStyle dotText({double fontSize = 28, Color color = textPrimary}) {
    return GoogleFonts.dotGothic16(
      fontSize: fontSize,
      color: color,
      letterSpacing: 1.2,
    );
  }

  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    fontFamily: GoogleFonts.spaceGrotesk().fontFamily,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primary,
      primary: primary,
      surface: surface,
      onSurface: textPrimary,
    ),
    scaffoldBackgroundColor: background,
    appBarTheme: AppBarTheme(
      backgroundColor: background,
      foregroundColor: textPrimary,
      elevation: 0,
      scrolledUnderElevation: 0,
      titleTextStyle: dotText(),
    ),
    navigationBarTheme: const NavigationBarThemeData(
      backgroundColor: surface,
      indicatorColor: primaryLight,
      elevation: 0,
      height: 70,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: textPrimary),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: textPrimary),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: primary, width: 1.5),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        shape: const StadiumBorder(),
      ),
    ),
    dividerTheme: const DividerThemeData(color: border),
  );
}
