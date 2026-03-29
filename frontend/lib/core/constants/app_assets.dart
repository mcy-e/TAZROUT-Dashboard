//? Centralizes all asset paths for the Tazrout app.
//? SVG is preferred. PNG fallback used where SVG rendering fails.
//? Do not hardcode asset paths anywhere else in the project.

abstract class AppAssets {

  //& Logo — Dark Theme (for dark sidebar background)
  //* Default state
  static const String logoDarkDefault = 'assets/icons/Dark/svg/logo_dark_default.svg';
  static const String logoDarkDefaultPng = 'assets/icons/Dark/png/logo_dark_default.png';
  //* Hover state
  static const String logoDarkHover = 'assets/icons/Dark/svg/logo_dark_hover.svg';
  //* Collapsed sidebar — icon only
  static const String logoDarkIconDefault = 'assets/icons/Dark/svg/logo_dark_icon_only_default.svg';
  static const String logoDarkIconHover = 'assets/icons/Dark/svg/logo_dark_icon_only_hover.svg';

  //& Logo — Light Theme (for light sidebar background)
  static const String logoLightDefault = 'assets/icons/Light/svg/logo_light_default.svg';
  static const String logoLightDefaultPng = 'assets/icons/Light/png/logo_light_default.png';
  static const String logoLightHover = 'assets/icons/Light/svg/logo_light_hover.svg';
  static const String logoLightIconDefault = 'assets/icons/Light/svg/logo_light_icon_only_default.svg';
  static const String logoLightIconHover = 'assets/icons/Light/svg/logo_light_icon_only_hover.svg';

  //& Patterns
  //? Horizontal border strips used as decorative elements across screens
  static const String patternDotsLine = 'assets/images/patterns/svg/pattern_01_dots_line.svg';
  static const String patternDiamondsChain = 'assets/images/patterns/svg/pattern_02_diamonds_chain.svg';
  static const String patternCrossDiamondGrid = 'assets/images/patterns/svg/pattern_03_cross_diamond_grid.svg';
  static const String patternZigzagBold = 'assets/images/patterns/svg/pattern_04_zigzag_bold.svg';
  static const String patternSmallDiamonds = 'assets/images/patterns/svg/pattern_05_small_diamonds_row.svg';
  static const String patternTinyDots = 'assets/images/patterns/svg/pattern_06_tiny_dots.svg';
  static const String patternTriangleWave = 'assets/images/patterns/svg/pattern_07_triangle_wave.svg';
  static const String patternSnowflakeRow = 'assets/images/patterns/svg/pattern_08_snowflake_row.svg';
  static const String patternCrossAsterisk = 'assets/images/patterns/svg/pattern_09_cross_asterisk_row.svg';
  static const String patternFilledTriangleBand = 'assets/images/patterns/svg/pattern_10_filled_triangle_band.svg';
  static const String patternArrowChevron = 'assets/images/patterns/svg/pattern_11_arrow_chevron_row.svg';
  static const String patternCircleMedallion = 'assets/images/patterns/svg/pattern_12_circle_medallion_row.svg';
  static const String patternCheckerboard = 'assets/images/patterns/svg/pattern_13_checkerboard.svg';
  static const String patternGreekKey = 'assets/images/patterns/svg/pattern_14_greek_key.svg';
  static const String patternColumnDividers = 'assets/images/patterns/svg/pattern_15_column_dividers.svg';
  static const String patternFilledTrianglesBorder = 'assets/images/patterns/svg/pattern_16_filled_triangles_border.svg';

  //& Berberian Symbols
  //? Named by their cultural meaning — used as decorative zone placeholders and card elements
  static const String symbolBalance = 'assets/images/berber_symbols/svg/Balance.svg';
  static const String symbolEye = 'assets/images/berber_symbols/svg/Eye.svg';
  static const String symbolLife = 'assets/images/berber_symbols/svg/Life.svg';
  static const String symbolUnity = 'assets/images/berber_symbols/svg/Unity.svg';
  static const String symbolWisdom = 'assets/images/berber_symbols/svg/Wisdom.svg';
  static const String symbolFertilityDefault = 'assets/images/berber_symbols/svg/Fertility_default.svg';
  static const String symbolFertilityHover = 'assets/images/berber_symbols/svg/Fertility_hover.svg';
  static const String symbolEnFertilityDefault = 'assets/images/berber_symbols/svg/EnFertility_default.svg';
  static const String symbolEnFertilityHover = 'assets/images/berber_symbols/svg/EnFertility_hover.svg';

  //& Berberian Typography Glyphs
  //? Tifinagh letter forms — spell T-A-Z-R-O-U-T
  static const String glyphT = 'assets/images/berber_typography/svg/T.svg';
  static const String glyphA = 'assets/images/berber_typography/svg/A.svg';
  static const String glyphZ = 'assets/images/berber_typography/svg/Z.svg';
  static const String glyphR = 'assets/images/berber_typography/svg/R.svg';
  static const String glyphU = 'assets/images/berber_typography/svg/U.svg';
  static const String glyphActive = 'assets/images/berber_typography/svg/Active.svg';
  static const String glyphInActive = 'assets/images/berber_typography/svg/InActive.svg';

  //& Berberian Icons
  //? Decorative Amazigh icons — used in cards and accent elements
  static const String berberIconDiamondElongated = 'assets/images/berber_icons/svg/icon_diamond_elongated.svg';
  static const String berberIconCrossAsterisk = 'assets/images/berber_icons/svg/icon_cross_asterisk.svg';
  static const String berberIconDiamondOutline = 'assets/images/berber_icons/svg/icon_diamond_outline.svg';
  static const String berberIconFigureRed = 'assets/images/berber_icons/svg/icon_figure_red.svg';
  static const String berberIconDiamondSun = 'assets/images/berber_icons/svg/icon_diamond_sun.svg';
  static const String berberIconStarDotted = 'assets/images/berber_icons/svg/icon_star_dotted.svg';
  static const String berberIconDotSmall = 'assets/images/berber_icons/svg/icon_dot_small.svg';
  static const String berberIconDiamondTeal = 'assets/images/berber_icons/svg/icon_diamond_teal.svg';
  static const String berberIconDiamondTealOutline = 'assets/images/berber_icons/svg/icon_diamond_teal_outline.svg';
  static const String berberIconCrossCenter = 'assets/images/berber_icons/svg/icon_cross_center.svg';
  static const String berberIconDiamondDouble = 'assets/images/berber_icons/svg/icon_diamond_double.svg';
  static const String berberIconTrianglePink = 'assets/images/berber_icons/svg/icon_triangle_pink.svg';
  static const String berberIconStarburst = 'assets/images/berber_icons/svg/icon_starburst.svg';
  static const String berberIconArrowsCross = 'assets/images/berber_icons/svg/icon_arrows_cross.svg';
}
