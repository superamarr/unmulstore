import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFFFFCC00); // Yellow from mockup
  static const Color scaffoldBackgroundColor = Colors.white;
  static const Color textColor = Color(0xFF1B1B1B); // Sharper Black
  static const Color subtitleColor = Color(0xFF4B4B4B); // Darker Grey (was 0xFF8E929A)
  static const Color borderColor = Color(0xFFE2E8F0);

  static ThemeData get lightTheme {
    final baseTextTheme = GoogleFonts.poppinsTextTheme();
    return ThemeData(
      primaryColor: primaryColor,
      scaffoldBackgroundColor: scaffoldBackgroundColor,
      textTheme: baseTextTheme.copyWith(
        displayLarge: GoogleFonts.poppins(color: textColor, fontWeight: FontWeight.bold, fontSize: 24),
        titleLarge: GoogleFonts.poppins(color: textColor, fontWeight: FontWeight.bold, fontSize: 20),
        bodyLarge: GoogleFonts.poppins(color: textColor, fontSize: 16),
        bodyMedium: GoogleFonts.poppins(color: textColor, fontSize: 14),
        bodySmall: GoogleFonts.poppins(color: subtitleColor, fontSize: 12),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: textColor,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
    );
  }
}
