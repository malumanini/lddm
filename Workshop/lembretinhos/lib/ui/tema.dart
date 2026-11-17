import 'package:flutter/material.dart';

class Fofo {
  static const rosa = Color(0xFFE8639B);
  static const rosaClaro = Color(0xFFFDE7F0);
  static const creme = Color(0xFFFFF5F7);
  static const lilas = Color(0xFFB49BE8);
  static const menta = Color(0xFF7FD1BE);
  static const manteiga = Color(0xFFFFD9A0);
  static const ameixa = Color(0xFF4A2B3F);
  static const ameixaSuave = Color(0xFF8A6B7C);

  static const pastel = [
    rosaClaro,
    Color(0xFFE9E1FB),
    Color(0xFFDFF3EE),
    Color(0xFFFFEFD6),
  ];

  static const sombra = [
    BoxShadow(color: Color(0x1FE8639B), blurRadius: 24, offset: Offset(0, 8)),
  ];

  static ThemeData get tema => ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: creme,
        colorScheme: ColorScheme.fromSeed(
          seedColor: rosa,
          primary: rosa,
          surface: creme,
        ),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: ameixa,
          contentTextStyle: const TextStyle(color: Colors.white, fontSize: 15),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
      );
}
