// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Tazrout';

  @override
  String get navHome => 'Home';

  @override
  String get navZones => 'Zones';

  @override
  String get navAnalytics => 'Analytics';

  @override
  String get navEmergency => 'Emergency';

  @override
  String get navSettings => 'Settings';

  @override
  String get navHelp => 'Help';

  @override
  String get navUserManual => 'User Manual';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsSubtitle =>
      'Manage your preferences and system configurations.';

  @override
  String get settingsDisplayTitle => 'Display Settings';

  @override
  String get settingsSystemTitle => 'System Settings';

  @override
  String get settingsNotificationTitle => 'Notification Settings';

  @override
  String get settingsLanguage => 'Switch Language';

  @override
  String get settingsLanguageSubtitle =>
      'Select your preferred interface language.';

  @override
  String get settingsTheme => 'Switch Theme';

  @override
  String get settingsThemeSubtitle => 'Toggle between Light and Dark mode.';

  @override
  String get settingsFontSize => 'Switch Font Size';

  @override
  String get settingsFontSizeSubtitle =>
      'Adjust the text size for better readability.';

  @override
  String get settingsDateFormat => 'Date Format';

  @override
  String get settingsDateFormatSubtitle => 'Choose how dates are displayed.';

  @override
  String get settingsTimeFormat => 'Time Format';

  @override
  String get settingsTimeFormatSubtitle =>
      'Choose between 12-hour and 24-hour clocks.';

  @override
  String get settingsPowerSaving => 'Power Saving';

  @override
  String get settingsPowerSavingSubtitle =>
      'Reduce performance to save energy.';

  @override
  String get settingsAutoSleep => 'Auto-Sleep Timer';

  @override
  String get settingsAutoSleepSubtitle =>
      'Duration before entering sleep mode.';

  @override
  String get settingsUiAnimations => 'UI Animations';

  @override
  String get settingsUiAnimationsSubtitle =>
      'Enable smooth transitions and effects.';

  @override
  String get settingsSoundAlerts => 'Sound Alerts';

  @override
  String get settingsSoundAlertsSubtitle =>
      'Play a sound when a notification arrives.';

  @override
  String get settingsApply => 'Apply Settings';

  @override
  String get resetDefault => 'Reset Default';

  @override
  String get settingsReset => 'Settings have been reset to default values.';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get fontSmall => 'Small';

  @override
  String get fontMedium => 'Medium';

  @override
  String get fontLarge => 'Large';

  @override
  String get time24h => '24 Hours';

  @override
  String get time12h => '12 Hours';

  @override
  String get min5 => '5 Minutes';

  @override
  String get min10 => '10 Minutes';

  @override
  String get min15 => '15 Minutes';

  @override
  String get min30 => '30 Minutes';

  @override
  String get hour1 => '1 Hour';

  @override
  String get langEnglish => 'English';

  @override
  String get langFrench => 'Français';

  @override
  String get langArabic => 'العربية';

  @override
  String get dateFormatDDMMYYYY => 'DD/MM/YYYY';

  @override
  String get dateFormatMMDDYYYY => 'MM/DD/YYYY';

  @override
  String get dateFormatYYYYMMDD => 'YYYY/MM/DD';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'Confirm';

  @override
  String get confirmActionTitle => 'Confirm action';

  @override
  String get confirmRebootBody => 'Are you sure you want to reboot the system?';

  @override
  String get confirmShutdownBody =>
      'Are you sure you want to shut down the system?';

  @override
  String get tooltipTestNotification => 'Test notification';

  @override
  String get testNotificationTitle => 'Zone C Offline';

  @override
  String get testNotificationMessage =>
      'Device lost connection. Check gateway.';

  @override
  String get closeTooltip => 'Close';

  @override
  String get helpMoreHelpTitle => 'More Help?';

  @override
  String get helpScanCodeCall =>
      'Scan the code below or call the following number for more help.';

  @override
  String get helpSupportFooterBold => 'Still need assistance? ';

  @override
  String get helpSupportFooterRest => 'Our support team is available 24/7...';

  @override
  String get supportStillNeedTitle => 'Still need assistance?';

  @override
  String get supportTeamAvailable =>
      'Our support team is available 24/7 to help you resolve any issues regarding the system.';

  @override
  String get supportGetSupport => 'Get Support';

  @override
  String get faqOfflineTitle => 'System Offline?';

  @override
  String get faqOfflineDesc =>
      'If zones appear offline, check the main power supply and ensure the gateway is connected to the network.';

  @override
  String get faqErraticTitle => 'Erratic Readings?';

  @override
  String get faqErraticDesc =>
      'Sensor calibration may be required. Visit the Zones tab to run a diagnostic test on specific sensors.';

  @override
  String get faqSyncTitle => 'Data Not Syncing?';

  @override
  String get faqSyncDesc =>
      'Ensure your internet connection is stable. Data will cache locally and sync once connection is restored.';

  @override
  String get faqAccessTitle => 'Access Denied?';

  @override
  String get faqAccessDesc =>
      'Contact your administrator to verify your permissions settings if you cannot access certain controls.';

  @override
  String get aiLatestDecisionTitle => 'AI Latest Decision';

  @override
  String get observationTitle => 'Observation';

  @override
  String get recommendationTitle => 'Recommendation';

  @override
  String get resourceConsumptionTitle => 'Resource Consumption by Zone';

  @override
  String get legendWaterShort => 'WATER';

  @override
  String get legendMoistureShort => 'MOISTURE';

  @override
  String get legendTempShort => 'TEMP';

  @override
  String get chartPeriodDay => 'Day';

  @override
  String get chartPeriodWeek => 'Week';

  @override
  String get chartPeriodMonth => 'Month';

  @override
  String get waterUsageTitle => 'WATER USAGE (LITERS)';

  @override
  String waterUsageTooltipLiters(String value) {
    return '$value L';
  }

  @override
  String chartWeekLabel(int week) {
    return 'W$week';
  }

  @override
  String get decisionLogsTitle => 'Decision Logs';

  @override
  String get columnId => 'ID';

  @override
  String get columnDate => 'DATE';

  @override
  String get columnType => 'TYPE';

  @override
  String get columnDetails => 'DETAILS';

  @override
  String get filterAll => 'All';

  @override
  String get filterIrrigation => 'Irrigation';

  @override
  String get filterAlerts => 'Alerts';

  @override
  String get filterAdvice => 'Advice';

  @override
  String get envStatsTitle => 'ENV STATS';

  @override
  String get envLegendTempShort => 'Temp';

  @override
  String get envLegendHumShort => 'Hum';

  @override
  String get envAvgTempLabel => 'AVG TEMP';

  @override
  String get zoneStatsTempLabel => 'T : C°';

  @override
  String get zoneStatsMoistureLabel => 'M : g/m³';

  @override
  String get zoneStatsWaterLabel => 'Water : %';

  @override
  String get emergencyStatusOnline => 'ONLINE';

  @override
  String get emergencyStatusOffline => 'OFFLINE';

  @override
  String get emergencyStopConfirmTitle => 'Confirm Emergency Stop';

  @override
  String get emergencyStopConfirmBody =>
      'This will halt all irrigation immediately. Are you sure?';

  @override
  String get confirmEmergencyStop => 'CONFIRM STOP';

  @override
  String get documentHelperTitle => 'Document Helper';

  @override
  String get documentHelperBody =>
      'The comprehensive user manual content will be rendered here.\nThis area is designed to handle embedded PDF viewers\nor rich text documentation.';

  @override
  String get manualFooterMeta => 'Last updated: Oct 24, 2024 • Version 2.0';

  @override
  String get manualPdfFileName => 'manual_v2.0.pdf';

  @override
  String get emptyStateNoData => 'No data available';

  @override
  String get emergencyStop => 'EMERGENCY STOP';

  @override
  String get emergencyTitle => 'Emergency Control';

  @override
  String get emergencySubtitle =>
      'Monitor live independent device states. In case of system failure or hazard, initiate emergency stop immediately.';

  @override
  String get welcomeTitle => 'Welcome Back!';

  @override
  String get welcomeSubtitle =>
      'All agricultural systems are running within optimal parameters today.';

  @override
  String get zoneOnline => 'Online';

  @override
  String get zoneOffline => 'Offline';

  @override
  String get valveOpen => 'Open';

  @override
  String get valveClosed => 'Closed';

  @override
  String get showStats => 'Show Stats';

  @override
  String get hideStats => 'Hide Stats';

  @override
  String get helpTitle => 'Help Center';

  @override
  String get helpSubtitle => 'Find answers and support for your dashboard.';

  @override
  String get manualTitle => 'User Manual';

  @override
  String get manualSubtitle => 'View documentation and operating procedures.';

  @override
  String get welcomeBack => 'Welcome Back!';

  @override
  String get systemStatus =>
      'All agricultural systems are running within optimal parameters today.';

  @override
  String get systemControls => 'System Controls';

  @override
  String get reboot => 'REBOOT';

  @override
  String get shutdown => 'SHUT DOWN';

  @override
  String get performanceMonitor => 'Performance Monitor';

  @override
  String get waterOutput => 'WATER OUTPUT';

  @override
  String get soilMoisture => 'SOIL MOISTURE';

  @override
  String get temperature => 'TEMPERATURE';

  @override
  String get humidity => 'HUMIDITY';

  @override
  String get time => 'TIME';

  @override
  String get today => 'TODAY';

  @override
  String get noEvents => 'No events scheduled';

  @override
  String get didYouKnow => 'DID YOU KNOW?';

  @override
  String get zonesTitle => 'Zones Monitoring';

  @override
  String get zonesSubtitle => 'Monitor and control your irrigation zones.';

  @override
  String get deviceState => 'DEVICE STATE';

  @override
  String get valveState => 'VALVE STATE';

  @override
  String get online => 'Online';

  @override
  String get offline => 'Offline';

  @override
  String get open => 'Open';

  @override
  String get closed => 'Closed';

  @override
  String get analyticsTitle => 'Analytics';

  @override
  String get analyticsSubtitle => 'View performance data and AI insights.';

  @override
  String get userManualTitle => 'User Manual';

  @override
  String get settingsApplied => 'Settings applied successfully.';

  @override
  String get ok => 'OK';
}
