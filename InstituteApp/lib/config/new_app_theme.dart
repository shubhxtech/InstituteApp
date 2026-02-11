
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NewAppTheme {
  // Colors
  static const Color bgPrimary = Color(0xFF050505);
  static const Color bgSecondary = Color(0xFF121212);
  static const Color bgCard = Color(0xFF1C1C1E);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF8E8E93);
  static const Color accentBlue = Color(0xFF0A84FF);
  
  // Gradients
  static const LinearGradient brandGradient = LinearGradient(
    colors: [Color(0xFF0A84FF), Color(0xFF5E5CE6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const RadialGradient mainBgGradient = RadialGradient(
    center: Alignment(0.8, -0.43), // Approx 90% 28.3%
    radius: 0.8, // Approx 64% 40%
    colors: [
      Color(0xFF101C28),
      Color(0xFF0D0F12),
    ],
    stops: [0.24, 0.44],
  );

  static const LinearGradient lightBgGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFF5F5F7), // Light Gray
      Color(0xFFE5E5EA), // Slightly darker gray
      Color(0xFFD1D1D6), // Even darker for contrast
    ],
  );

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: bgPrimary,
      primaryColor: accentBlue,
      canvasColor: bgPrimary,
      cardColor: bgCard,
      
      // Color Scheme for consistent colors
      colorScheme: const ColorScheme.dark(
        primary: accentBlue,
        secondary: accentBlue,
        surface: bgCard,
        background: bgPrimary,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: textPrimary,
        onBackground: textPrimary,
      ),
      
      // Typography
      textTheme: GoogleFonts.interTextTheme().apply(
        bodyColor: textPrimary,
        displayColor: textPrimary,
      ),
      
      // Card Theme
      cardTheme: CardThemeData(
        color: bgCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        margin: EdgeInsets.zero,
      ),
      
      // AppBar Theme
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(color: textPrimary),
      ),
      
      // Button Themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accentBlue,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: const Color(0xFFF5F5F7),
      primaryColor: accentBlue,
      canvasColor: const Color(0xFFF5F5F7),
      cardColor: Colors.white,
      
      // Color Scheme for light mode
      colorScheme: const ColorScheme.light(
        primary: accentBlue,
        secondary: accentBlue,
        surface: Colors.white,
        background: Color(0xFFF5F5F7),
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Color(0xFF1C1C1E),
        onBackground: Color(0xFF1C1C1E),
      ),
      
      // Typography
      textTheme: GoogleFonts.interTextTheme().apply(
        bodyColor: const Color(0xFF1C1C1E),
        displayColor: const Color(0xFF1C1C1E),
      ),
      
      // Card Theme
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        margin: EdgeInsets.zero,
      ),
      
      // AppBar Theme
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: Color(0xFF1C1C1E),
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(color: Color(0xFF1C1C1E)),
      ),
      
      // Button Themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accentBlue,
          foregroundColor: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
    );
  }
}
