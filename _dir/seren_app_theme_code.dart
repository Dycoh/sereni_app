import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Core theme configuration for Sereni Mental Health App
/// Implements a consistent design system with predefined colors, typography,
/// spacing, and component styles
class AppTheme {
  // Color System
  // Primary Colors
  static const kBackgroundColor = Color(0xFFFDFDEE); // Main app background
  static const kPrimaryGreen = Color(0xFF0FB400);    // Primary actions, buttons
  static const kAccentBrown = Color(0xFF8B4513);     // Secondary actions
  static const kTextGreen = Color(0xFF2A2A09);       // Primary text color

  // Secondary Colors
  static const kLightGreenContainer = Color(0x400FB400); // Cards, containers with 25% opacity
  static const kLightBrownContainer = Color(0x408B4513); // Secondary containers with 25% opacity
  
  // Feedback Colors
  static const kSuccessGreen = Color(0xFF4CAF50);    // Success states
  static const kErrorRed = Color(0xFFE53935);        // Error states
  static const kWarningYellow = Color(0xFFFFC107);   // Warning states
  static const kInfoBlue = Color(0xFF2196F3);        // Information states

  // Neutral Colors
  static const kWhite = Color(0xFFFFFFFF);
  static const kGray100 = Color(0xFFF5F5F5);
  static const kGray200 = Color(0xFFEEEEEE);
  static const kGray300 = Color(0xFFE0E0E0);
  static const kGray400 = Color(0xFFBDBDBD);
  static const kGray500 = Color(0xFF9E9E9E);
  static const kGray600 = Color(0xFF757575);
  static const kGray700 = Color(0xFF616161);
  static const kGray800 = Color(0xFF424242);
  static const kGray900 = Color(0xFF212121);

  // Spacing System (8-point grid)
  static const double kSpacing = 8.0;      // Base spacing unit
  static const double kSpacing2x = 16.0;   // Padding between related elements
  static const double kSpacing3x = 24.0;   // Padding between sections
  static const double kSpacing4x = 32.0;   // Large component spacing
  static const double kSpacing5x = 40.0;   // Section spacing
  static const double kSpacing6x = 48.0;   // Screen padding
  static const double kSpacing8x = 64.0;   // Large screen padding

  // Border Radius
  static const double kRadiusSmall = 4.0;
  static const double kRadiusMedium = 8.0;
  static const double kRadiusLarge = 16.0;
  static const double kRadiusXLarge = 24.0;

  // Elevation
  static const List<BoxShadow> kShadowSmall = [
    BoxShadow(
      color: Color(0x1A000000),
      offset: Offset(0, 1),
      blurRadius: 3,
    ),
  ];

  static const List<BoxShadow> kShadowMedium = [
    BoxShadow(
      color: Color(0x1A000000),
      offset: Offset(0, 2),
      blurRadius: 6,
    ),
  ];

  // Typography System
  static TextTheme get _customTextTheme {
    return TextTheme(
      // Large Titles
      displayLarge: GoogleFonts.inter(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        letterSpacing: -0.5,
        color: kTextGreen,
      ), // App name in header
      
      displayMedium: GoogleFonts.inter(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        letterSpacing: -0.5,
        color: kTextGreen,
      ), // Screen titles
      
      displaySmall: GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: kTextGreen,
      ), // Section headers

      // Headlines
      headlineLarge: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: kTextGreen,
      ), // Card titles
      
      headlineMedium: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: kTextGreen,
      ), // Important subsections
      
      headlineSmall: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: kTextGreen,
      ), // Dialog titles

      // Body Text
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: kTextGreen,
      ), // Primary body text
      
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: kTextGreen,
      ), // Secondary body text
      
      bodySmall: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: kGray600,
      ), // Helper text, timestamps

      // Labels
      labelLarge: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: kTextGreen,
      ), // Button text
      
      labelMedium: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: kTextGreen,
      ), // Small button text
      
      labelSmall: GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: kGray600,
      ), // Input labels, captions
    );
  }

  /// Light theme configuration
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: kPrimaryGreen,
        background: kBackgroundColor,
        surface: kBackgroundColor,
        primary: kPrimaryGreen,
        secondary: kAccentBrown,
        error: kErrorRed,
      ),
      
      // Background Colors
      scaffoldBackgroundColor: kBackgroundColor,
      
      // Typography
      textTheme: _customTextTheme,
      
      // Card Theme
      cardTheme: CardTheme(
        color: kWhite,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kRadiusMedium),
        ),
        margin: const EdgeInsets.all(kSpacing),
      ),
      
      // Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: kPrimaryGreen,
          foregroundColor: kWhite,
          padding: const EdgeInsets.symmetric(
            horizontal: kSpacing3x,
            vertical: kSpacing2x,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kRadiusMedium),
          ),
        ),
      ),
      
      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: kWhite,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kRadiusMedium),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kRadiusMedium),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kRadiusMedium),
          borderSide: const BorderSide(color: kPrimaryGreen),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kRadiusMedium),
          borderSide: const BorderSide(color: kErrorRed),
        ),
        contentPadding: const EdgeInsets.all(kSpacing2x),
      ),
      
      // App Bar Theme
      appBarTheme: const AppBarTheme(
        backgroundColor: kBackgroundColor,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: kTextGreen),
        titleTextStyle: TextStyle(
          color: kTextGreen,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      
      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: kWhite,
        selectedItemColor: kPrimaryGreen,
        unselectedItemColor: kGray400,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
    );
  }
}
