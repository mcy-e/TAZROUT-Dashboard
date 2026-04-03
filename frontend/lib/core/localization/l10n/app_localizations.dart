import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
    Locale('fr'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Tazrout'**
  String get appTitle;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navZones.
  ///
  /// In en, this message translates to:
  /// **'Zones'**
  String get navZones;

  /// No description provided for @navAnalytics.
  ///
  /// In en, this message translates to:
  /// **'Analytics'**
  String get navAnalytics;

  /// No description provided for @navEmergency.
  ///
  /// In en, this message translates to:
  /// **'Emergency'**
  String get navEmergency;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @navHelp.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get navHelp;

  /// No description provided for @navUserManual.
  ///
  /// In en, this message translates to:
  /// **'User Manual'**
  String get navUserManual;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage your preferences and system configurations.'**
  String get settingsSubtitle;

  /// No description provided for @settingsDisplayTitle.
  ///
  /// In en, this message translates to:
  /// **'Display Settings'**
  String get settingsDisplayTitle;

  /// No description provided for @settingsSystemTitle.
  ///
  /// In en, this message translates to:
  /// **'System Settings'**
  String get settingsSystemTitle;

  /// No description provided for @settingsNotificationTitle.
  ///
  /// In en, this message translates to:
  /// **'Notification Settings'**
  String get settingsNotificationTitle;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Switch Language'**
  String get settingsLanguage;

  /// No description provided for @settingsLanguageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Select your preferred interface language.'**
  String get settingsLanguageSubtitle;

  /// No description provided for @settingsTheme.
  ///
  /// In en, this message translates to:
  /// **'Switch Theme'**
  String get settingsTheme;

  /// No description provided for @settingsThemeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Toggle between Light and Dark mode.'**
  String get settingsThemeSubtitle;

  /// No description provided for @settingsFontSize.
  ///
  /// In en, this message translates to:
  /// **'Switch Font Size'**
  String get settingsFontSize;

  /// No description provided for @settingsFontSizeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Adjust the text size for better readability.'**
  String get settingsFontSizeSubtitle;

  /// No description provided for @settingsDateFormat.
  ///
  /// In en, this message translates to:
  /// **'Date Format'**
  String get settingsDateFormat;

  /// No description provided for @settingsDateFormatSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose how dates are displayed.'**
  String get settingsDateFormatSubtitle;

  /// No description provided for @settingsTimeFormat.
  ///
  /// In en, this message translates to:
  /// **'Time Format'**
  String get settingsTimeFormat;

  /// No description provided for @settingsTimeFormatSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose between 12-hour and 24-hour clocks.'**
  String get settingsTimeFormatSubtitle;

  /// No description provided for @settingsPowerSaving.
  ///
  /// In en, this message translates to:
  /// **'Power Saving'**
  String get settingsPowerSaving;

  /// No description provided for @settingsPowerSavingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Reduce performance to save energy.'**
  String get settingsPowerSavingSubtitle;

  /// No description provided for @settingsAutoSleep.
  ///
  /// In en, this message translates to:
  /// **'Auto-Sleep Timer'**
  String get settingsAutoSleep;

  /// No description provided for @settingsAutoSleepSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Duration before entering sleep mode.'**
  String get settingsAutoSleepSubtitle;

  /// No description provided for @settingsUiAnimations.
  ///
  /// In en, this message translates to:
  /// **'UI Animations'**
  String get settingsUiAnimations;

  /// No description provided for @settingsUiAnimationsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enable smooth transitions and effects.'**
  String get settingsUiAnimationsSubtitle;

  /// No description provided for @settingsSoundAlerts.
  ///
  /// In en, this message translates to:
  /// **'Sound Alerts'**
  String get settingsSoundAlerts;

  /// No description provided for @settingsSoundAlertsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Play a sound when a notification arrives.'**
  String get settingsSoundAlertsSubtitle;

  /// No description provided for @settingsApply.
  ///
  /// In en, this message translates to:
  /// **'Apply Settings'**
  String get settingsApply;

  /// No description provided for @resetDefault.
  ///
  /// In en, this message translates to:
  /// **'Reset Default'**
  String get resetDefault;

  /// No description provided for @settingsReset.
  ///
  /// In en, this message translates to:
  /// **'Settings have been reset to default values.'**
  String get settingsReset;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @fontSmall.
  ///
  /// In en, this message translates to:
  /// **'Small'**
  String get fontSmall;

  /// No description provided for @fontMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get fontMedium;

  /// No description provided for @fontLarge.
  ///
  /// In en, this message translates to:
  /// **'Large'**
  String get fontLarge;

  /// No description provided for @time24h.
  ///
  /// In en, this message translates to:
  /// **'24 Hours'**
  String get time24h;

  /// No description provided for @time12h.
  ///
  /// In en, this message translates to:
  /// **'12 Hours'**
  String get time12h;

  /// No description provided for @min5.
  ///
  /// In en, this message translates to:
  /// **'5 Minutes'**
  String get min5;

  /// No description provided for @min10.
  ///
  /// In en, this message translates to:
  /// **'10 Minutes'**
  String get min10;

  /// No description provided for @min15.
  ///
  /// In en, this message translates to:
  /// **'15 Minutes'**
  String get min15;

  /// No description provided for @min30.
  ///
  /// In en, this message translates to:
  /// **'30 Minutes'**
  String get min30;

  /// No description provided for @hour1.
  ///
  /// In en, this message translates to:
  /// **'1 Hour'**
  String get hour1;

  /// No description provided for @langEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get langEnglish;

  /// No description provided for @langFrench.
  ///
  /// In en, this message translates to:
  /// **'Français'**
  String get langFrench;

  /// No description provided for @langArabic.
  ///
  /// In en, this message translates to:
  /// **'العربية'**
  String get langArabic;

  /// No description provided for @dateFormatDDMMYYYY.
  ///
  /// In en, this message translates to:
  /// **'DD/MM/YYYY'**
  String get dateFormatDDMMYYYY;

  /// No description provided for @dateFormatMMDDYYYY.
  ///
  /// In en, this message translates to:
  /// **'MM/DD/YYYY'**
  String get dateFormatMMDDYYYY;

  /// No description provided for @dateFormatYYYYMMDD.
  ///
  /// In en, this message translates to:
  /// **'YYYY/MM/DD'**
  String get dateFormatYYYYMMDD;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @confirmActionTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm action'**
  String get confirmActionTitle;

  /// No description provided for @confirmRebootBody.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to reboot the system?'**
  String get confirmRebootBody;

  /// No description provided for @confirmShutdownBody.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to shut down the system?'**
  String get confirmShutdownBody;

  /// No description provided for @tooltipTestNotification.
  ///
  /// In en, this message translates to:
  /// **'Test notification'**
  String get tooltipTestNotification;

  /// No description provided for @testNotificationTitle.
  ///
  /// In en, this message translates to:
  /// **'Zone C Offline'**
  String get testNotificationTitle;

  /// No description provided for @testNotificationMessage.
  ///
  /// In en, this message translates to:
  /// **'Device lost connection. Check gateway.'**
  String get testNotificationMessage;

  /// No description provided for @closeTooltip.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get closeTooltip;

  /// No description provided for @helpMoreHelpTitle.
  ///
  /// In en, this message translates to:
  /// **'More Help?'**
  String get helpMoreHelpTitle;

  /// No description provided for @helpScanCodeCall.
  ///
  /// In en, this message translates to:
  /// **'Scan the code below or call the following number for more help.'**
  String get helpScanCodeCall;

  /// No description provided for @helpSupportFooterBold.
  ///
  /// In en, this message translates to:
  /// **'Still need assistance? '**
  String get helpSupportFooterBold;

  /// No description provided for @helpSupportFooterRest.
  ///
  /// In en, this message translates to:
  /// **'Our support team is available 24/7...'**
  String get helpSupportFooterRest;

  /// No description provided for @supportStillNeedTitle.
  ///
  /// In en, this message translates to:
  /// **'Still need assistance?'**
  String get supportStillNeedTitle;

  /// No description provided for @supportTeamAvailable.
  ///
  /// In en, this message translates to:
  /// **'Our support team is available 24/7 to help you resolve any issues regarding the system.'**
  String get supportTeamAvailable;

  /// No description provided for @supportGetSupport.
  ///
  /// In en, this message translates to:
  /// **'Get Support'**
  String get supportGetSupport;

  /// No description provided for @faqOfflineTitle.
  ///
  /// In en, this message translates to:
  /// **'System Offline?'**
  String get faqOfflineTitle;

  /// No description provided for @faqOfflineDesc.
  ///
  /// In en, this message translates to:
  /// **'If zones appear offline, check the main power supply and ensure the gateway is connected to the network.'**
  String get faqOfflineDesc;

  /// No description provided for @faqErraticTitle.
  ///
  /// In en, this message translates to:
  /// **'Erratic Readings?'**
  String get faqErraticTitle;

  /// No description provided for @faqErraticDesc.
  ///
  /// In en, this message translates to:
  /// **'Sensor calibration may be required. Visit the Zones tab to run a diagnostic test on specific sensors.'**
  String get faqErraticDesc;

  /// No description provided for @faqSyncTitle.
  ///
  /// In en, this message translates to:
  /// **'Data Not Syncing?'**
  String get faqSyncTitle;

  /// No description provided for @faqSyncDesc.
  ///
  /// In en, this message translates to:
  /// **'Ensure your internet connection is stable. Data will cache locally and sync once connection is restored.'**
  String get faqSyncDesc;

  /// No description provided for @faqAccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Access Denied?'**
  String get faqAccessTitle;

  /// No description provided for @faqAccessDesc.
  ///
  /// In en, this message translates to:
  /// **'Contact your administrator to verify your permissions settings if you cannot access certain controls.'**
  String get faqAccessDesc;

  /// No description provided for @aiLatestDecisionTitle.
  ///
  /// In en, this message translates to:
  /// **'AI Latest Decision'**
  String get aiLatestDecisionTitle;

  /// No description provided for @observationTitle.
  ///
  /// In en, this message translates to:
  /// **'Observation'**
  String get observationTitle;

  /// No description provided for @recommendationTitle.
  ///
  /// In en, this message translates to:
  /// **'Recommendation'**
  String get recommendationTitle;

  /// No description provided for @resourceConsumptionTitle.
  ///
  /// In en, this message translates to:
  /// **'Resource Consumption by Zone'**
  String get resourceConsumptionTitle;

  /// No description provided for @legendWaterShort.
  ///
  /// In en, this message translates to:
  /// **'WATER'**
  String get legendWaterShort;

  /// No description provided for @legendMoistureShort.
  ///
  /// In en, this message translates to:
  /// **'MOISTURE'**
  String get legendMoistureShort;

  /// No description provided for @legendTempShort.
  ///
  /// In en, this message translates to:
  /// **'TEMP'**
  String get legendTempShort;

  /// No description provided for @chartPeriodDay.
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get chartPeriodDay;

  /// No description provided for @chartPeriodWeek.
  ///
  /// In en, this message translates to:
  /// **'Week'**
  String get chartPeriodWeek;

  /// No description provided for @chartPeriodMonth.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get chartPeriodMonth;

  /// No description provided for @waterUsageTitle.
  ///
  /// In en, this message translates to:
  /// **'WATER USAGE (LITERS)'**
  String get waterUsageTitle;

  /// No description provided for @waterUsageTooltipLiters.
  ///
  /// In en, this message translates to:
  /// **'{value} L'**
  String waterUsageTooltipLiters(String value);

  /// No description provided for @chartWeekLabel.
  ///
  /// In en, this message translates to:
  /// **'W{week}'**
  String chartWeekLabel(int week);

  /// No description provided for @decisionLogsTitle.
  ///
  /// In en, this message translates to:
  /// **'Decision Logs'**
  String get decisionLogsTitle;

  /// No description provided for @columnId.
  ///
  /// In en, this message translates to:
  /// **'ID'**
  String get columnId;

  /// No description provided for @columnDate.
  ///
  /// In en, this message translates to:
  /// **'DATE'**
  String get columnDate;

  /// No description provided for @columnType.
  ///
  /// In en, this message translates to:
  /// **'TYPE'**
  String get columnType;

  /// No description provided for @columnDetails.
  ///
  /// In en, this message translates to:
  /// **'DETAILS'**
  String get columnDetails;

  /// No description provided for @filterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filterAll;

  /// No description provided for @filterIrrigation.
  ///
  /// In en, this message translates to:
  /// **'Irrigation'**
  String get filterIrrigation;

  /// No description provided for @filterAlerts.
  ///
  /// In en, this message translates to:
  /// **'Alerts'**
  String get filterAlerts;

  /// No description provided for @filterAdvice.
  ///
  /// In en, this message translates to:
  /// **'Advice'**
  String get filterAdvice;

  /// No description provided for @envStatsTitle.
  ///
  /// In en, this message translates to:
  /// **'ENV STATS'**
  String get envStatsTitle;

  /// No description provided for @envLegendTempShort.
  ///
  /// In en, this message translates to:
  /// **'Temp'**
  String get envLegendTempShort;

  /// No description provided for @envLegendHumShort.
  ///
  /// In en, this message translates to:
  /// **'Hum'**
  String get envLegendHumShort;

  /// No description provided for @envAvgTempLabel.
  ///
  /// In en, this message translates to:
  /// **'AVG TEMP'**
  String get envAvgTempLabel;

  /// No description provided for @zoneStatsTempLabel.
  ///
  /// In en, this message translates to:
  /// **'T : C°'**
  String get zoneStatsTempLabel;

  /// No description provided for @zoneStatsMoistureLabel.
  ///
  /// In en, this message translates to:
  /// **'M : g/m³'**
  String get zoneStatsMoistureLabel;

  /// No description provided for @zoneStatsWaterLabel.
  ///
  /// In en, this message translates to:
  /// **'Water : %'**
  String get zoneStatsWaterLabel;

  /// No description provided for @emergencyStatusOnline.
  ///
  /// In en, this message translates to:
  /// **'ONLINE'**
  String get emergencyStatusOnline;

  /// No description provided for @emergencyStatusOffline.
  ///
  /// In en, this message translates to:
  /// **'OFFLINE'**
  String get emergencyStatusOffline;

  /// No description provided for @emergencyStopConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm Emergency Stop'**
  String get emergencyStopConfirmTitle;

  /// No description provided for @emergencyStopConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'This will halt all irrigation immediately. Are you sure?'**
  String get emergencyStopConfirmBody;

  /// No description provided for @confirmEmergencyStop.
  ///
  /// In en, this message translates to:
  /// **'CONFIRM STOP'**
  String get confirmEmergencyStop;

  /// No description provided for @documentHelperTitle.
  ///
  /// In en, this message translates to:
  /// **'Document Helper'**
  String get documentHelperTitle;

  /// No description provided for @documentHelperBody.
  ///
  /// In en, this message translates to:
  /// **'The comprehensive user manual content will be rendered here.\nThis area is designed to handle embedded PDF viewers\nor rich text documentation.'**
  String get documentHelperBody;

  /// No description provided for @manualFooterMeta.
  ///
  /// In en, this message translates to:
  /// **'Last updated: Oct 24, 2024 • Version 2.0'**
  String get manualFooterMeta;

  /// No description provided for @manualPdfFileName.
  ///
  /// In en, this message translates to:
  /// **'manual_v2.0.pdf'**
  String get manualPdfFileName;

  /// No description provided for @emptyStateNoData.
  ///
  /// In en, this message translates to:
  /// **'No data available'**
  String get emptyStateNoData;

  /// No description provided for @emergencyStop.
  ///
  /// In en, this message translates to:
  /// **'EMERGENCY STOP'**
  String get emergencyStop;

  /// No description provided for @emergencyTitle.
  ///
  /// In en, this message translates to:
  /// **'Emergency Control'**
  String get emergencyTitle;

  /// No description provided for @emergencySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Monitor live independent device states. In case of system failure or hazard, initiate emergency stop immediately.'**
  String get emergencySubtitle;

  /// No description provided for @welcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back!'**
  String get welcomeTitle;

  /// No description provided for @welcomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'All agricultural systems are running within optimal parameters today.'**
  String get welcomeSubtitle;

  /// No description provided for @zoneOnline.
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get zoneOnline;

  /// No description provided for @zoneOffline.
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get zoneOffline;

  /// No description provided for @valveOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get valveOpen;

  /// No description provided for @valveClosed.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get valveClosed;

  /// No description provided for @showStats.
  ///
  /// In en, this message translates to:
  /// **'Show Stats'**
  String get showStats;

  /// No description provided for @hideStats.
  ///
  /// In en, this message translates to:
  /// **'Hide Stats'**
  String get hideStats;

  /// No description provided for @helpTitle.
  ///
  /// In en, this message translates to:
  /// **'Help Center'**
  String get helpTitle;

  /// No description provided for @helpSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Find answers and support for your dashboard.'**
  String get helpSubtitle;

  /// No description provided for @manualTitle.
  ///
  /// In en, this message translates to:
  /// **'User Manual'**
  String get manualTitle;

  /// No description provided for @manualSubtitle.
  ///
  /// In en, this message translates to:
  /// **'View documentation and operating procedures.'**
  String get manualSubtitle;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back!'**
  String get welcomeBack;

  /// No description provided for @systemStatus.
  ///
  /// In en, this message translates to:
  /// **'All agricultural systems are running within optimal parameters today.'**
  String get systemStatus;

  /// No description provided for @systemControls.
  ///
  /// In en, this message translates to:
  /// **'System Controls'**
  String get systemControls;

  /// No description provided for @reboot.
  ///
  /// In en, this message translates to:
  /// **'REBOOT'**
  String get reboot;

  /// No description provided for @shutdown.
  ///
  /// In en, this message translates to:
  /// **'SHUT DOWN'**
  String get shutdown;

  /// No description provided for @performanceMonitor.
  ///
  /// In en, this message translates to:
  /// **'Performance Monitor'**
  String get performanceMonitor;

  /// No description provided for @waterOutput.
  ///
  /// In en, this message translates to:
  /// **'WATER OUTPUT'**
  String get waterOutput;

  /// No description provided for @soilMoisture.
  ///
  /// In en, this message translates to:
  /// **'SOIL MOISTURE'**
  String get soilMoisture;

  /// No description provided for @temperature.
  ///
  /// In en, this message translates to:
  /// **'TEMPERATURE'**
  String get temperature;

  /// No description provided for @humidity.
  ///
  /// In en, this message translates to:
  /// **'HUMIDITY'**
  String get humidity;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'TIME'**
  String get time;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'TODAY'**
  String get today;

  /// No description provided for @noEvents.
  ///
  /// In en, this message translates to:
  /// **'No events scheduled'**
  String get noEvents;

  /// No description provided for @didYouKnow.
  ///
  /// In en, this message translates to:
  /// **'DID YOU KNOW?'**
  String get didYouKnow;

  /// No description provided for @zonesTitle.
  ///
  /// In en, this message translates to:
  /// **'Zones Monitoring'**
  String get zonesTitle;

  /// No description provided for @zonesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Monitor and control your irrigation zones.'**
  String get zonesSubtitle;

  /// No description provided for @deviceState.
  ///
  /// In en, this message translates to:
  /// **'DEVICE STATE'**
  String get deviceState;

  /// No description provided for @valveState.
  ///
  /// In en, this message translates to:
  /// **'VALVE STATE'**
  String get valveState;

  /// No description provided for @online.
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get online;

  /// No description provided for @offline.
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get offline;

  /// No description provided for @open.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get open;

  /// No description provided for @closed.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get closed;

  /// No description provided for @analyticsTitle.
  ///
  /// In en, this message translates to:
  /// **'Analytics'**
  String get analyticsTitle;

  /// No description provided for @analyticsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'View performance data and AI insights.'**
  String get analyticsSubtitle;

  /// No description provided for @userManualTitle.
  ///
  /// In en, this message translates to:
  /// **'User Manual'**
  String get userManualTitle;

  /// No description provided for @settingsApplied.
  ///
  /// In en, this message translates to:
  /// **'Settings applied successfully.'**
  String get settingsApplied;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
