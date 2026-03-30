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
  String get settingsLanguage => 'Switch Language';

  @override
  String get settingsTheme => 'Switch Theme';

  @override
  String get settingsFontSize => 'Switch Font Size';

  @override
  String get settingsApply => 'Apply Settings';

  @override
  String get settingsReset => 'Reset Default';

  @override
  String get emergencyStop => 'EMERGENCY STOP';

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
}
