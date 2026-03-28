//& Imports
import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart';

//& AppTheme Class
class AppTheme {
  
  //& Light Theme
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: AppColors.primary,
      colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
      cardTheme: CardTheme(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        elevation: 2.0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.0),
        ),
      ),
      textTheme: TextTheme(
        displayLarge: AppTypography.displayXL,
        displayMedium: AppTypography.displayL,
        headlineMedium: AppTypography.headingM,
        headlineSmall: AppTypography.headingS,
        bodyLarge: AppTypography.bodyLBold,
        bodyMedium: AppTypography.bodyMBold,
        bodySmall: AppTypography.bodySMedium,
        caption: AppTypography.captionBold,
      ),
    );
  }

  //& Dark Theme
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: AppColors.primaryDark,
      colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryDark),
      cardTheme: CardTheme(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        elevation: 2.0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.0),
        ),
      ),
      textTheme: TextTheme(
        displayLarge: AppTypography.displayXL,
        displayMedium: AppTypography.displayL,
        headlineMedium: AppTypography.headingM,
        headlineSmall: AppTypography.headingS,
        bodyLarge: AppTypography.bodyLBold,
        bodyMedium: AppTypography.bodyMBold,
        bodySmall: AppTypography.bodySMedium,
        caption: AppTypography.captionBold,
      ),
    );
  }
}
