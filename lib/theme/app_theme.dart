import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_fonts.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.accent1,
        secondary: AppColors.accent2,
        surface: AppColors.surface,
        onPrimary: AppColors.white,
        onSecondary: AppColors.background,
        onSurface: AppColors.white,
      ),
      textTheme: TextTheme(
        headlineLarge: AppFonts.h1,
        headlineMedium: AppFonts.h2,
        headlineSmall: AppFonts.h3,
        bodyLarge: AppFonts.bodyLarge,
        bodyMedium: AppFonts.bodyMedium,
        bodySmall: AppFonts.bodySmall,
      ),
    );
  }
}
