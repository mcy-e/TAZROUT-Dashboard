//& Imports
import 'dart:ui';

//& AppColors Class
abstract class AppColors {
  
  //& Dark Theme Surface Tokens
  static const Color darkBase = Color(0xFF141C16);
  static const Color darkSidebar = Color(0xFF182319);
  static const Color darkPanelCard = Color(0xFF243128);
  static const Color darkElevatedCard = Color(0xFF2B3A2D);
  static const Color darkHoverSurface = Color(0xFF394C3F);
  static const Color darkActiveSurface = Color(0xFF4A6353);
  static const Color darkStrokeDivider = Color(0xFF5C7D67);
  static const Color darkSubtleText = Color(0xFF6B8B77);
  static const Color darkMutedText = Color(0xFF8CAAA5);
  static const Color darkBodyText = Color(0xFFC5D5CD);
  static const Color darkPrimaryText = Color(0xFFF8FCFA);

  //& Light Theme Surface Tokens
  static const Color lightBackground = Color(0xFFF8FCFA);
  static const Color lightSurfaceCard = Color(0xFFFFFFFF);
  static const Color lightElevatedCard = Color(0xFFEEF5F3);
  static const Color lightStrokeDivider = Color(0xFFDCE6DF);
  static const Color lightMutedText = Color(0xFF8CAAA5);
  static const Color lightBodyText = Color(0xFF2B3A2D);
  static const Color lightPrimaryText = Color(0xFF182319);

  //& Brand Colors
  static const Color primary = Color(0xFF4CAF50);
  static const Color primaryDark = Color(0xFF258439);
  static const Color primaryLight = Color(0xFF81C784);

  //& Semantic Status Colors
  static const Color successSolid = Color(0xFF4CAF50);
  static const Color errorSolid = Color(0xFFE94E31);
  static const Color warningSolid = Color(0xFFF6A623);
  static const Color infoSolid = Color(0xFF488FE1);

  //& Alpha Variants
  static const Color primary10 = Color(0x1A4CAF50);
  static const Color primary20 = Color(0x334CAF50);
  static const Color primaryDark10 = Color(0x1A258439);
  static const Color primaryDark20 = Color(0x33258439);
  static const Color error10 = Color(0x1AE94E31);
  static const Color warning10 = Color(0x1AF6A623);
  static const Color info10 = Color(0x1A488FE1);

  //& Data Visualization Series
  static const Color series1Primary = Color(0xFF4CAF50);
  static const Color series2Blue = Color(0xFF549DF6);
  static const Color series3Amber = Color(0xFFFFB74D);
  static const Color series4Danger = Color(0xFFEE7373);
  static const Color series5Cyan = Color(0xFF4FC3F7);
  static const Color series6Purple = Color(0xFFC084FC);

  //& Component Interaction States
  static const Color defaultBg = Color(0xFFFFFFFF);
  static const Color defaultBorder = Color(0xFFDCE6DF);
  static const Color defaultText = Color(0xFF2B3A2D);
  static const Color hoverBg = Color(0xFFF8FCFA);
  static const Color hoverBorder = Color(0xFF8CAAA5);
  static const Color focusedBg = Color(0xFFF8FCFA);
  static const Color focusedBorder = Color(0xFF4CAF50);
  static const Color activeBg = Color(0x1A4CAF50);
  static const Color selectedSidebarBg = Color(0x1A258439);
  static const Color disabledBg = Color(0xFFEEF5F3);
  static const Color disabledBorder = Color(0xFFE3EBE7);
  static const Color disabledText = Color(0xFF8CAAA5);
}
