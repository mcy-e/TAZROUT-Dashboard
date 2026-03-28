//& Imports
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

//& Color Definitions
class AppColors {
  static const Color primary = Color(0xFF123456);
  static const Color darkPanelCard = Color(0xFF234567);
  static const Color darkPrimaryText = Color(0xFFFFFFFF);
  static const Color lightSurfaceCard = Color(0xFFF1F2F3);
  static const Color lightPrimaryText = Color(0xFF000000);
}

//& Typography Definitions
class AppTypography {
  static final TextStyle captionBold = GoogleFonts.lato(
    fontSize: 12.0,
    fontWeight: FontWeight.bold,
  );
}

//& Theme Definitions
final ThemeData lightTheme = ThemeData(
  //* Explicit light color scheme from design tokens
  colorScheme: const ColorScheme.light(
    primary: AppColors.primary,
    surface: AppColors.lightSurfaceCard,
    onSurface: AppColors.lightPrimaryText,
  ),
  textTheme: TextTheme(
    captionBold: AppTypography.captionBold,
  ),
);

final ThemeData darkTheme = ThemeData(
  //* Explicit dark color scheme from design tokens
  colorScheme: const ColorScheme.dark(
    primary: AppColors.primary,
    surface: AppColors.darkPanelCard,
    onSurface: AppColors.darkPrimaryText,
  ),
  textTheme: TextTheme(
    captionBold: AppTypography.captionBold,
  ),
);
