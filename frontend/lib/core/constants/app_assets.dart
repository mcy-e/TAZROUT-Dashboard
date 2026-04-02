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

  //& Custom App Icons — Dark Theme
  //? Naming: variant=IconName — I = Idle, H = Hover, Active = selected

  //* Navigation icons
  static const String darkIconHomeI = 'assets/icons/Dark/svg/app_icons/variant=Home I.svg';
  static const String darkIconHomeH = 'assets/icons/Dark/svg/app_icons/variant=Home H.svg';
  static const String darkIconHomeActive = 'assets/icons/Dark/svg/app_icons/variant=Home Active.svg';
  static const String darkIconZoneI = 'assets/icons/Dark/svg/app_icons/variant=Zone I.svg';
  static const String darkIconZoneH = 'assets/icons/Dark/svg/app_icons/variant=Zone H.svg';
  static const String darkIconZonesActive = 'assets/icons/Dark/svg/app_icons/variant=Zones Active.svg';
  static const String darkIconAnalyticsI = 'assets/icons/Dark/svg/app_icons/variant=Analytics I.svg';
  static const String darkIconAnalyticsH = 'assets/icons/Dark/svg/app_icons/variant=Analytics H.svg';
  static const String darkIconAnalyticsActive = 'assets/icons/Dark/svg/app_icons/variant=Analytics Active.svg';
  static const String darkIconEmergencyI = 'assets/icons/Dark/svg/app_icons/variant=Emergency I.svg';
  static const String darkIconEmergencyH = 'assets/icons/Dark/svg/app_icons/variant=Emergency H.svg';
  static const String darkIconEmergencyActive = 'assets/icons/Dark/svg/app_icons/variant=Emergency Active.svg';
  static const String darkIconSettingI = 'assets/icons/Dark/svg/app_icons/variant=Setting I.svg';
  static const String darkIconSettingH = 'assets/icons/Dark/svg/app_icons/variant=Setting H.svg';
  static const String darkIconSettingsActive = 'assets/icons/Dark/svg/app_icons/variant=Settings Active.svg';
  static const String darkIconHelpI = 'assets/icons/Dark/svg/app_icons/variant=Help I.svg';
  static const String darkIconHelpH = 'assets/icons/Dark/svg/app_icons/variant=Help H.svg';
  static const String darkIconHelpActive = 'assets/icons/Dark/svg/app_icons/variant=Help Active.svg';
  static const String darkIconUserManualI = 'assets/icons/Dark/svg/app_icons/variant=User Manual I.svg';
  static const String darkIconUserManualH = 'assets/icons/Dark/svg/app_icons/variant=User Manual H.svg';
  static const String darkIconUserManualActive = 'assets/icons/Dark/svg/app_icons/variant=User Manual Active.svg';
  static const String darkIconSideMenu = 'assets/icons/Dark/svg/app_icons/variant=Side Menu.svg';

  //* Action icons
  static const String darkIconRebootI = 'assets/icons/Dark/svg/app_icons/variant=Reboot I.svg';
  static const String darkIconRebootH = 'assets/icons/Dark/svg/app_icons/variant=Reboot H.svg';
  static const String darkIconShutDownI = 'assets/icons/Dark/svg/app_icons/variant=Shut Down I.svg';
  static const String darkIconShutDownH = 'assets/icons/Dark/svg/app_icons/variant=Shut Down H.svg';
  static const String darkIconEmergencyButton = 'assets/icons/Dark/svg/app_icons/variant=Emergency Button.svg';
  static const String darkIconEmergencyIcon = 'assets/icons/Dark/svg/app_icons/variant=Emergency Icon.svg';
  static const String darkIconChecked = 'assets/icons/Dark/svg/app_icons/variant=Checked.svg';
  static const String darkIconExclamation = 'assets/icons/Dark/svg/app_icons/variant=Exclamation.svg';
  static const String darkIconArrowRight = 'assets/icons/Dark/svg/app_icons/variant=Arrow Right.svg';
  static const String darkIconOffPoint = 'assets/icons/Dark/svg/app_icons/variant=OFF_Point.svg';

  //* Sensor & data icons
  static const String darkIconWaterI = 'assets/icons/Dark/svg/app_icons/variant=Water I.svg';
  static const String darkIconWaterH = 'assets/icons/Dark/svg/app_icons/variant=Water H.svg';
  static const String darkIconWaterPercentage = 'assets/icons/Dark/svg/app_icons/variant=Water Percentage.svg';
  static const String darkIconWaterValveClosed = 'assets/icons/Dark/svg/app_icons/variant=Water Valve Closed.svg';
  static const String darkIconTemperatureI = 'assets/icons/Dark/svg/app_icons/variant=Temperature I.svg';
  static const String darkIconTemperatureH = 'assets/icons/Dark/svg/app_icons/variant=Temperature H.svg';
  static const String darkIconHumidityI = 'assets/icons/Dark/svg/app_icons/variant=Humidity I.svg';
  static const String darkIconHumidityH = 'assets/icons/Dark/svg/app_icons/variant=Humidity H.svg';
  static const String darkIconSoilIdle = 'assets/icons/Dark/svg/app_icons/variant=Soil Idle.svg';
  static const String darkIconSoilH = 'assets/icons/Dark/svg/app_icons/variant=Soil H.svg';
  static const String darkIconPerformance = 'assets/icons/Dark/svg/app_icons/variant=Performance.svg';
  static const String darkIconConnectionState = 'assets/icons/Dark/svg/app_icons/variant=Conection State.svg';
  static const String darkIconConnectionStateClosed = 'assets/icons/Dark/svg/app_icons/variant=Conection State Closed.svg';
  static const String darkIconData = 'assets/icons/Dark/svg/app_icons/variant=Data.svg';

  //* Analytics & AI icons
  static const String darkIconAiDecision = 'assets/icons/Dark/svg/app_icons/variant=AI Decesision.svg';
  static const String darkIconObservation = 'assets/icons/Dark/svg/app_icons/variant=Observation.svg';
  static const String darkIconRecommendation = 'assets/icons/Dark/svg/app_icons/variant=Recomondation.svg';
  static const String darkIconReadings = 'assets/icons/Dark/svg/app_icons/variant=Readings.svg';
  static const String darkIconAccess = 'assets/icons/Dark/svg/app_icons/variant=Access.svg';

  //* Settings icons
  static const String darkIconScreenSettings = 'assets/icons/Dark/svg/app_icons/variant=Screen Settings.svg';
  static const String darkIconSystemSettings = 'assets/icons/Dark/svg/app_icons/variant=System Settings.svg';
  static const String darkIconNotificationSettings = 'assets/icons/Dark/svg/app_icons/variant=Notification Settings.svg';

  //* Help & support icons
  static const String darkIconFactLamp = 'assets/icons/Dark/svg/app_icons/variant=Fact lamp.svg';
  static const String darkIconFactStar = 'assets/icons/Dark/svg/app_icons/variant=Fact Star.svg';
  static const String darkIconAssistanceBg = 'assets/icons/Dark/svg/app_icons/variant=Assistance Icon BG.svg';
  static const String darkIconManual = 'assets/icons/Dark/svg/app_icons/variant=Manual.svg';
  static const String darkIconCalendar = 'assets/icons/Dark/svg/app_icons/variant=Calendar.svg';

  //& Custom App Icons — Light Theme
  //? Same naming structure as dark — swap Dark → Light in path

  static const String lightIconHomeI = 'assets/icons/Light/svg/app_icons/variant=Home I.svg';
  static const String lightIconHomeH = 'assets/icons/Light/svg/app_icons/variant=Home H.svg';
  static const String lightIconHomeActive = 'assets/icons/Light/svg/app_icons/variant=Home Active.svg';
  static const String lightIconZoneI = 'assets/icons/Light/svg/app_icons/variant=Zone I.svg';
  static const String lightIconZoneH = 'assets/icons/Light/svg/app_icons/variant=Zone H.svg';
  static const String lightIconZonesActive = 'assets/icons/Light/svg/app_icons/variant=Zones Active.svg';
  static const String lightIconAnalyticsI = 'assets/icons/Light/svg/app_icons/variant=Analytics I.svg';
  static const String lightIconAnalyticsH = 'assets/icons/Light/svg/app_icons/variant=Analytics H.svg';
  static const String lightIconAnalyticsActive = 'assets/icons/Light/svg/app_icons/variant=Analytics Active.svg';
  static const String lightIconEmergencyI = 'assets/icons/Light/svg/app_icons/variant=Emergency I.svg';
  static const String lightIconEmergencyH = 'assets/icons/Light/svg/app_icons/variant=Emergency H.svg';
  static const String lightIconEmergencyActive = 'assets/icons/Light/svg/app_icons/variant=Emergency Active.svg';
  static const String lightIconSettingI = 'assets/icons/Light/svg/app_icons/variant=Setting I.svg';
  static const String lightIconSettingH = 'assets/icons/Light/svg/app_icons/variant=Setting H.svg';
  static const String lightIconSettingsActive = 'assets/icons/Light/svg/app_icons/variant=Settings Active.svg';
  static const String lightIconHelpI = 'assets/icons/Light/svg/app_icons/variant=Help I.svg';
  static const String lightIconHelpH = 'assets/icons/Light/svg/app_icons/variant=Help H.svg';
  static const String lightIconHelpActive = 'assets/icons/Light/svg/app_icons/variant=Help Active.svg';
  static const String lightIconUserManualI = 'assets/icons/Light/svg/app_icons/variant=User Manual I.svg';
  static const String lightIconUserManualH = 'assets/icons/Light/svg/app_icons/variant=User Manual H.svg';
  static const String lightIconUserManualActive = 'assets/icons/Light/svg/app_icons/variant=User Manual Active.svg';
  static const String lightIconSideMenu = 'assets/icons/Light/svg/app_icons/variant=Side Menu.svg';
  static const String lightIconRebootI = 'assets/icons/Light/svg/app_icons/variant=Reboot I.svg';
  static const String lightIconRebootH = 'assets/icons/Light/svg/app_icons/variant=Reboot H.svg';
  static const String lightIconShutDownI = 'assets/icons/Light/svg/app_icons/variant=Shut Down I.svg';
  static const String lightIconShutDownH = 'assets/icons/Light/svg/app_icons/variant=Shut Down H.svg';
  static const String lightIconEmergencyButton = 'assets/icons/Light/svg/app_icons/variant=Emergency Button.svg';
  static const String lightIconEmergencyIcon = 'assets/icons/Light/svg/app_icons/variant=Emergency Icon.svg';
  static const String lightIconChecked = 'assets/icons/Light/svg/app_icons/variant=Checked.svg';
  static const String lightIconExclamation = 'assets/icons/Light/svg/app_icons/variant=Exclamation.svg';
  static const String lightIconArrowRight = 'assets/icons/Light/svg/app_icons/variant=Arrow Right.svg';
  static const String lightIconWaterI = 'assets/icons/Light/svg/app_icons/variant=Water I.svg';
  static const String lightIconWaterH = 'assets/icons/Light/svg/app_icons/variant=Water H.svg';
  static const String lightIconWaterPercentage = 'assets/icons/Light/svg/app_icons/variant=Water Percentage.svg';
  static const String lightIconWaterValveClosed = 'assets/icons/Light/svg/app_icons/variant=Water Valve Closed.svg';
  static const String lightIconTemperatureI = 'assets/icons/Light/svg/app_icons/variant=Temperature I.svg';
  static const String lightIconTemperatureH = 'assets/icons/Light/svg/app_icons/variant=Temperature H.svg';
  static const String lightIconHumidityI = 'assets/icons/Light/svg/app_icons/variant=Humidity I.svg';
  static const String lightIconHumidityH = 'assets/icons/Light/svg/app_icons/variant=Humidity H.svg';
  static const String lightIconSoilIdle = 'assets/icons/Light/svg/app_icons/variant=Soil Idle.svg';
  static const String lightIconSoilH = 'assets/icons/Light/svg/app_icons/variant=Soil H.svg';
  static const String lightIconPerformance = 'assets/icons/Light/svg/app_icons/variant=Performance.svg';
  static const String lightIconConnectionState = 'assets/icons/Light/svg/app_icons/variant=Conection State.svg';
  static const String lightIconConnectionStateClosed = 'assets/icons/Light/svg/app_icons/variant=Conection State Closed.svg';
  static const String lightIconAiDecision = 'assets/icons/Light/svg/app_icons/variant=AI Decesision.svg';
  static const String lightIconObservation = 'assets/icons/Light/svg/app_icons/variant=Observation.svg';
  static const String lightIconRecommendation = 'assets/icons/Light/svg/app_icons/variant=Recomondation.svg';
  static const String lightIconReadings = 'assets/icons/Light/svg/app_icons/variant=Readings.svg';
  static const String lightIconAccess = 'assets/icons/Light/svg/app_icons/variant=Access.svg';
  static const String lightIconScreenSettings = 'assets/icons/Light/svg/app_icons/variant=Screen Settings.svg';
  static const String lightIconSystemSettings = 'assets/icons/Light/svg/app_icons/variant=System Settings.svg';
  static const String lightIconNotificationSettings = 'assets/icons/Light/svg/app_icons/variant=Notification Settings.svg';
  static const String lightIconFactLamp = 'assets/icons/Light/svg/app_icons/variant=Fact lamp.svg';
  static const String lightIconFactStar = 'assets/icons/Light/svg/app_icons/variant=Fact Star.svg';
  static const String lightIconAssistanceBg = 'assets/icons/Light/svg/app_icons/variant=Assistance Icon BG.svg';
  static const String lightIconManual = 'assets/icons/Light/svg/app_icons/variant=Manual.svg';
  static const String lightIconCalendar = 'assets/icons/Light/svg/app_icons/variant=Calendar.svg';

  //& Chart Preview Images
  //? Static graph preview images per sensor type and theme

  static const String chartWaterDark = 'assets/images/chart_previews/variant=Water_Graph_dark.png';
  static const String chartWaterLight = 'assets/images/chart_previews/variant=Water_Graph_light.png';
  static const String chartTemperatureDark = 'assets/images/chart_previews/variant=Temperature_Graph_dark.png';
  static const String chartTemperatureLight = 'assets/images/chart_previews/variant=Temperature_Graph_light.png';
  static const String chartHumidityDark = 'assets/images/chart_previews/variant=Humidity_Graph_dark.png';
  static const String chartHumidityLight = 'assets/images/chart_previews/variant=Humidity_Graph_light.png';
  static const String chartSoilDark = 'assets/images/chart_previews/variant=Soil_Graph_dark.png';
  static const String chartSoilLight = 'assets/images/chart_previews/variant=Soil_Graph_light.png';
  static const String chartWaterTempDark = 'assets/images/chart_previews/variant=Water_Temp_Graph_dark.png';
  static const String chartWaterTempLight = 'assets/images/chart_previews/variant=Water_Temp_Graph_light.png';

  //& Chart Graph Background Textures
  //? Grid texture used as background inside metric sub-card charts
  static const String graphBgDark  = 'assets/images/chart_previews/graph_bg_dark.svg';
  static const String graphBgDarkPng  = 'assets/images/chart_previews/graph_bg_dark.png';
  static const String graphBgLight = 'assets/images/chart_previews/graph_bg_light.svg';
  static const String graphBgLightPng = 'assets/images/chart_previews/graph_bg_light.png';

  //& Nav Item Hover Background
  //? Pill-shaped snowflake pattern used as sidebar hover overlay
  static const String navHoverBgLight = 'assets/images/nav_hover/nav_hover_bg_light.svg';
  static const String navHoverBgDark  = 'assets/images/nav_hover/nav_hover_bg_dark.svg';

  //& Show Stats Button Hover Patterns
  static const String showStatsNavActiveLight = 'assets/images/show_satas_nav/show_satas_nav_active_light.svg';
  static const String showStatsNavInactiveLight = 'assets/images/show_satas_nav/show_satas_nav_inactive_light.svg';
  static const String showStatsNavActiveDark = 'assets/images/show_satas_nav/show_satas_nav_active_dark.svg';
  static const String showStatsNavInactiveDark = 'assets/images/show_satas_nav/show_satas_nav_inactive_dark.svg';
}
