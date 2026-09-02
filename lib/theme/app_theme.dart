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
        titleLarge: GoogleFonts.inter(color: AppColors.primaryText, fontWeight: FontWeight.w600),
        titleMedium: GoogleFonts.inter(color: AppColors.primaryText, fontWeight: FontWeight.w500),
        titleSmall: GoogleFonts.inter(color: AppColors.primaryText, fontWeight: FontWeight.w500),
        bodyLarge: GoogleFonts.inter(color: AppColors.primaryText),
        bodyMedium: GoogleFonts.inter(color: AppColors.secondaryText),
        bodySmall: GoogleFonts.inter(color: AppColors.mutedText),
        labelLarge: GoogleFonts.inter(color: AppColors.primaryText, fontWeight: FontWeight.w500),
        labelMedium: GoogleFonts.inter(color: AppColors.secondaryText),
        labelSmall: GoogleFonts.inter(color: AppColors.mutedText),
      ),
      
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primaryAccent,
        secondary: AppColors.secondaryAccent,
        surface: AppColors.background,
        error: AppColors.error,
        onPrimary: AppColors.background,
        onSecondary: AppColors.primaryText,
        onSurface: AppColors.primaryText,
        onError: AppColors.primaryText,
      ),
      
      cardTheme: CardThemeData(
        color: AppColors.cardBackground,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.border, width: 1),
        ),
      ),
      
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.inter(
          color: AppColors.primaryText,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: const IconThemeData(color: AppColors.primaryText),
      ),
      
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryAccent,
          foregroundColor: AppColors.background,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
      
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryText,
          side: const BorderSide(color: AppColors.border),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.inter(
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
