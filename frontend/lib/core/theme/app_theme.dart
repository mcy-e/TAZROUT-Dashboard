//& Imports
import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart';

//& AppTheme Class
class AppTheme {
  
  //& Light Theme
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.lightBackground,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        surface: AppColors.lightSurfaceCard,
        onSurface: AppColors.lightPrimaryText,
      ),
      textTheme: TextTheme(
        labelSmall: AppTypography.captionBold, 
      ),
    );
  }

  //& Dark Theme
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.darkBase,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        surface: AppColors.darkPanelCard,
        onSurface: AppColors.darkPrimaryText,
      ),
      textTheme: TextTheme(
        labelSmall: AppTypography.captionBold,
      ),
    );
  }
}
