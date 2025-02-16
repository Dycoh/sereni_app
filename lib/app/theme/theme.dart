import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const kBackgroundColor = Color(0xFFFDFDEE);
  static const kPrimaryGreen = Color(0xFF0FB400);
  static const kAccentBrown = Color(0xFF8B4513);
  static const kTextGreen = Color(0xFF2A2A09);
  
  // Opacity Colors
  static const kLightGreenContainer = Color(0x400FB400);
  static const kLightBrownContainer = Color(0x408B4513);
  
  // Spacing
  static const double kSpacing = 8.0;
  static const double kSpacing2x = 16.0;
  static const double kSpacing3x = 24.0;
  static const double kSpacing4x = 32.0;
  
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: kPrimaryGreen,
        surface: kBackgroundColor,
      ),
      scaffoldBackgroundColor: kBackgroundColor,
      textTheme: GoogleFonts.poppinsTextTheme(),
      // Add more theme configurations
    );
  }
}