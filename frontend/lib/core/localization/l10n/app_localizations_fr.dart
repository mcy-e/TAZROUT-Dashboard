// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Tazrout';

  @override
  String get navHome => 'Accueil';

  @override
  String get navZones => 'Zones';

  @override
  String get navAnalytics => 'Analytique';

  @override
  String get navEmergency => 'Urgence';

  @override
  String get navSettings => 'Paramètres';

  @override
  String get navHelp => 'Aide';

  @override
  String get navUserManual => 'Manuel';

  @override
  String get settingsTitle => 'Paramètres';

  @override
  String get settingsLanguage => 'Langue';

  @override
  String get settingsTheme => 'Thème';

  @override
  String get settingsFontSize => 'Taille du texte';

  @override
  String get settingsApply => 'Appliquer';

  @override
  String get settingsReset => 'Réinitialiser';

  @override
  String get emergencyStop => 'ARRÊT D\'URGENCE';

  @override
  String get welcomeTitle => 'Bienvenue !';

  @override
  String get welcomeSubtitle =>
      'Tous les systèmes agricoles fonctionnent dans des paramètres optimaux.';

  @override
  String get zoneOnline => 'En ligne';

  @override
  String get zoneOffline => 'Hors ligne';

  @override
  String get valveOpen => 'Ouverte';

  @override
  String get valveClosed => 'Fermée';

  @override
  String get showStats => 'Voir les stats';

  @override
  String get hideStats => 'Masquer les stats';

  @override
  String get helpTitle => 'Centre d\'aide';

  @override
  String get helpSubtitle => 'Trouvez des réponses et du support.';

  @override
  String get manualTitle => 'Manuel utilisateur';

  @override
  String get manualSubtitle => 'Consultez la documentation.';
}
