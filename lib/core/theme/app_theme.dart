import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // A modern, clean color palette
  static const Color _primaryColor = Color(0xFF5E5CE5); // A vibrant, yet calming blue/purple
  static const Color _secondaryColor = Color(0xFF7D7F8A);
  static const Color _surfaceColor = Color(0xFFFFFFFF); // Pure white for a clean look
  static const Color _backgroundColor = Color(0xFFF2F2F7); // A very light grey for the background
  static const Color _textColor = Color(0xFF1D1D1F); // A dark, readable text color
  static const Color _accentColor = Color(0xFFFF9F0A); // An accent for highlights or warnings

  static ThemeData get lightTheme {
    final textTheme = GoogleFonts.interTextTheme(ThemeData.light().textTheme).apply(
      bodyColor: _textColor,
      displayColor: _textColor,
    );

    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: _backgroundColor,
      colorScheme: ColorScheme.fromSeed(
        seedColor: _primaryColor,
        primary: _primaryColor,
        secondary: _secondaryColor,
        surface: _surfaceColor,
        background: _backgroundColor,
        error: Colors.redAccent,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: _textColor,
        onBackground: _textColor,
        brightness: Brightness.light,
      ),
      textTheme: textTheme.copyWith(
        headlineSmall: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        titleLarge: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        titleMedium: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        bodyLarge: textTheme.bodyLarge?.copyWith(fontSize: 16.0),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: _backgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: _primaryColor),
        titleTextStyle: TextStyle(
          color: _textColor,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: _surfaceColor,
        clipBehavior: Clip.antiAlias,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _backgroundColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _primaryColor, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          backgroundColor: _primaryColor,
          foregroundColor: Colors.white,
          elevation: 2,
          shadowColor: _primaryColor.withOpacity(0.2),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ).copyWith(
          elevation: MaterialStateProperty.all(0),
          // Add a subtle press effect
          overlayColor: MaterialStateProperty.resolveWith<Color?>(
                (Set<MaterialState> states) {
              if (states.contains(MaterialState.pressed)) {
                return Colors.white.withOpacity(0.1);
              }
              return null; // Defer to the widget's default.
            },
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: _primaryColor,
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      iconTheme: const IconThemeData(
        color: _secondaryColor,
        size: 24.0,
      ),
    );
  }
}
