import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: const Color(0xFFF7ECE9),

    textTheme: GoogleFonts.playfairDisplayTextTheme(),

    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF8B5E5E),
    ),

    useMaterial3: true,
  );
}