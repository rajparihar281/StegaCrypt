import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      primaryColor: AppColors.primaryAccent,

      textTheme: GoogleFonts.interTextTheme().copyWith(
        displayLarge: GoogleFonts.inter(color: AppColors.primaryText, fontWeight: FontWeight.bold),
        displayMedium: GoogleFonts.inter(color: AppColors.primaryText, fontWeight: FontWeight.bold),
        displaySmall: GoogleFonts.inter(color: AppColors.primaryText, fontWeight: FontWeight.bold),
        headlineLarge: GoogleFonts.inter(color: AppColors.primaryText, fontWeight: FontWeight.w600),
        headlineMedium: GoogleFonts.inter(color: AppColors.primaryText, fontWeight: FontWeight.w600),
        headlineSmall: GoogleFonts.inter(color: AppColors.primaryText, fontWeight: FontWeight.w600),
        titleLarge: GoogleFonts.inter(color: AppColors.primaryText, fontWeight: FontWeight.w600, fontSize: 20),
        titleMedium: GoogleFonts.inter(color: AppColors.primaryText, fontWeight: FontWeight.w500, fontSize: 16),
        titleSmall: GoogleFonts.inter(color: AppColors.primaryText, fontWeight: FontWeight.w500, fontSize: 14),
        bodyLarge: GoogleFonts.inter(color: AppColors.primaryText, fontSize: 15),
        bodyMedium: GoogleFonts.inter(color: AppColors.secondaryText, fontSize: 14),
        bodySmall: GoogleFonts.inter(color: AppColors.mutedText, fontSize: 12),
        labelLarge: GoogleFonts.inter(color: AppColors.primaryText, fontWeight: FontWeight.w500, fontSize: 14),
        labelMedium: GoogleFonts.inter(color: AppColors.secondaryText, fontSize: 13),
        labelSmall: GoogleFonts.inter(color: AppColors.mutedText, fontSize: 11),
      ),

      colorScheme: const ColorScheme.dark(
        primary: AppColors.primaryAccent,
        secondary: AppColors.secondaryAccent,
        surface: AppColors.cardBackground,
        error: AppColors.error,
        onPrimary: Color(0xFF111214),
        onSecondary: AppColors.primaryText,
        onSurface: AppColors.primaryText,
        onError: AppColors.primaryText,
      ),

      cardTheme: CardThemeData(
        color: AppColors.cardBackground,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: const BorderSide(color: AppColors.border, width: 1),
        ),
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.inter(
          color: AppColors.primaryText,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
        iconTheme: const IconThemeData(color: AppColors.secondaryText),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryAccent,
          foregroundColor: Color(0xFF111214),
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.secondaryText,
          side: const BorderSide(color: AppColors.border),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: GoogleFonts.inter(
            fontWeight: FontWeight.w500,
            fontSize: 15,
          ),
        ),
      ),

      dividerTheme: const DividerThemeData(
        color: AppColors.border,
        thickness: 1,
      ),
    );
  }
}
