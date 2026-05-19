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
  String get settingsSubtitle =>
      'Gerez vos preferences et configurations systeme.';

  @override
  String get settingsDisplayTitle => 'Affichage';

  @override
  String get settingsSystemTitle => 'Systeme';

  @override
  String get settingsNotificationTitle => 'Notifications';

  @override
  String get settingsLanguage => 'Langue';

  @override
  String get settingsLanguageSubtitle =>
      'Selectionnez votre langue d interface.';

  @override
  String get settingsTheme => 'Thème';

  @override
  String get settingsThemeSubtitle =>
      'Basculez entre les modes clair et sombre.';

  @override
  String get settingsFontSize => 'Taille du texte';

  @override
  String get settingsFontSizeSubtitle =>
      'Ajustez la taille du texte pour une meilleure lisibilite.';

  @override
  String get settingsDateFormat => 'Format de date';

  @override
  String get settingsDateFormatSubtitle => 'Choisissez l affichage des dates.';

  @override
  String get settingsTimeFormat => 'Format horaire';

  @override
  String get settingsTimeFormatSubtitle =>
      'Choisissez entre horloge 12h et 24h.';

  @override
  String get settingsPowerSaving => 'Economie d energie';

  @override
  String get settingsPowerSavingSubtitle =>
      'Reduire les performances pour economiser l energie.';

  @override
  String get settingsAutoSleep => 'Mise en veille';

  @override
  String get settingsAutoSleepSubtitle =>
      'Duree avant l activation du mode veille.';

  @override
  String get settingsUiAnimations => 'Animations';

  @override
  String get settingsUiAnimationsSubtitle =>
      'Activer les transitions et effets fluides.';

  @override
  String get settingsSoundAlerts => 'Alertes sonores';

  @override
  String get settingsSoundAlertsSubtitle =>
      'Jouer un son quand une notification arrive.';

  @override
  String get settingsApply => 'Appliquer';

  @override
  String get resetDefault => 'Réinitialiser';

  @override
  String get settingsReset =>
      'Paramètres réinitialisés aux valeurs par défaut.';

  @override
  String get themeLight => 'Clair';

  @override
  String get themeDark => 'Sombre';

  @override
  String get fontSmall => 'Petit';

  @override
  String get fontMedium => 'Moyen';

  @override
  String get fontLarge => 'Grand';

  @override
  String get time24h => '24 heures';

  @override
  String get time12h => '12 heures';

  @override
  String get min5 => '5 minutes';

  @override
  String get min10 => '10 minutes';

  @override
  String get min15 => '15 minutes';

  @override
  String get min30 => '30 minutes';

  @override
  String get hour1 => '1 heure';

  @override
  String get langEnglish => 'Anglais';

  @override
  String get langFrench => 'Français';

  @override
  String get langArabic => 'العربية';

  @override
  String get dateFormatDDMMYYYY => 'JJ/MM/AAAA';

  @override
  String get dateFormatMMDDYYYY => 'MM/JJ/AAAA';

  @override
  String get dateFormatYYYYMMDD => 'AAAA/MM/JJ';

  @override
  String get cancel => 'Annuler';

  @override
  String get confirm => 'Confirmer';

  @override
  String get confirmActionTitle => 'Confirmer l action';

  @override
  String get confirmRebootBody =>
      'Voulez-vous vraiment redémarrer le système ?';

  @override
  String get confirmShutdownBody =>
      'Voulez-vous vraiment éteindre le système ?';

  @override
  String get tooltipTestNotification => 'Notification test';

  @override
  String get testNotificationTitle => 'Zone C hors ligne';

  @override
  String get testNotificationMessage =>
      'Appareil déconnecté. Vérifiez la passerelle.';

  @override
  String get closeTooltip => 'Fermer';

  @override
  String get helpMoreHelpTitle => 'Plus d aide ?';

  @override
  String get helpScanCodeCall =>
      'Scannez le code ci-dessous ou appelez le numéro suivant pour plus d aide.';

  @override
  String get helpSupportFooterBold => 'Besoin d aide ? ';

  @override
  String get helpSupportFooterRest =>
      'Notre équipe est disponible 24h/24 et 7j/7...';

  @override
  String get supportStillNeedTitle => 'Besoin d aide ?';

  @override
  String get supportTeamAvailable =>
      'Notre équipe support est disponible 24h/24 et 7j/7 pour vous aider à résoudre tout problème concernant le système.';

  @override
  String get supportGetSupport => 'Obtenir de l aide';

  @override
  String get faqOfflineTitle => 'Capteurs hors ligne ?';

  @override
  String get faqOfflineDesc =>
      'Si des zones semblent hors ligne, vérifiez l\'alimentation du nœud ESP32 et la connexion LoRa.';

  @override
  String get faqErraticTitle => 'Mesures erratiques ?';

  @override
  String get faqErraticDesc =>
      'Étalonnage requis. Vérifiez si les sondes d\'humidité et de température sont endommagées.';

  @override
  String get faqSyncTitle => 'Tableau déconnecté ?';

  @override
  String get faqSyncDesc =>
      'Vérifiez votre connexion LAN au serveur central. Le système fonctionne sans Internet.';

  @override
  String get faqAccessTitle => 'Arrêt d\'urgence ?';

  @override
  String get faqAccessDesc =>
      'Le tableau de bord est en lecture seule. Utilisez l\'arrêt d\'urgence uniquement en cas de panne.';

  @override
  String get faqOfflineDetailed =>
      'Assurez-vous que tous les contrôleurs ESP32 sont sous tension et à portée de la passerelle LoRa. Vérifiez que la passerelle Raspberry Pi est active et publie sur le broker Mosquitto (port 1883).';

  @override
  String get faqErraticDetailed =>
      'La dérive du capteur peut être causée par des dommages physiques ou une infiltration d\'eau. Inspectez les capteurs. Le moteur IA nécessite une télémétrie précise pour prendre des décisions d\'irrigation optimales.';

  @override
  String get faqSyncDetailed =>
      'Tazrout est un système LAN uniquement et ne nécessite pas Internet. Vérifiez que votre appareil est sur le même réseau local que le serveur central et que le backend Spring Boot fonctionne.';

  @override
  String get faqAccessDetailed =>
      'Pour éviter les commandes conflictuelles, le tableau de bord est en lecture seule. Le moteur IA autonome contrôle toutes les vannes. L\'arrêt d\'urgence est la seule commande manuelle disponible.';

  @override
  String get aiLatestDecisionTitle => 'Dernière décision IA';

  @override
  String get observationTitle => 'Observation';

  @override
  String get recommendationTitle => 'Recommandation';

  @override
  String get resourceConsumptionTitle => 'Consommation par zone';

  @override
  String get legendWaterShort => 'EAU';

  @override
  String get legendMoistureShort => 'HUMIDITÉ';

  @override
  String get legendTempShort => 'TEMP';

  @override
  String get chartPeriodDay => 'Jour';

  @override
  String get chartPeriodWeek => 'Semaine';

  @override
  String get chartPeriodMonth => 'Mois';

  @override
  String get waterUsageTitle => 'CONSOMMATION D EAU (LITRES)';

  @override
  String waterUsageTooltipLiters(String value) {
    return '$value L';
  }

  @override
  String chartWeekLabel(int week) {
    return 'S$week';
  }

  @override
  String get decisionLogsTitle => 'Journal des décisions';

  @override
  String get columnId => 'ID';

  @override
  String get columnDate => 'DATE';

  @override
  String get columnType => 'TYPE';

  @override
  String get columnDetails => 'DÉTAILS';

  @override
  String get filterAll => 'Tous';

  @override
  String get filterIrrigation => 'Irrigation';

  @override
  String get filterAlerts => 'Alertes';

  @override
  String get filterAdvice => 'Conseils';

  @override
  String get envStatsTitle => 'STATS ENV';

  @override
  String get envLegendTempShort => 'Temp';

  @override
  String get envLegendHumShort => 'Hum';

  @override
  String get envAvgTempLabel => 'TEMP MOY';

  @override
  String get zoneStatsTempLabel => 'T : C°';

  @override
  String get zoneStatsMoistureLabel => 'M : g/m³';

  @override
  String get zoneStatsWaterLabel => 'Eau : %';

  @override
  String get emergencyStatusOnline => 'EN LIGNE';

  @override
  String get emergencyStatusOffline => 'HORS LIGNE';

  @override
  String get emergencyStopConfirmTitle => 'Confirmer l arrêt d urgence';

  @override
  String get emergencyStopConfirmBody =>
      'Cela arrêtera immédiatement toute irrigation. Continuer ?';

  @override
  String get confirmEmergencyStop => 'CONFIRMER L ARRÊT';

  @override
  String get documentHelperTitle => 'Aide document';

  @override
  String get documentHelperBody =>
      'Le contenu complet du manuel utilisateur s affichera ici.\nCette zone est prévue pour un lecteur PDF intégré\nou une documentation enrichie.';

  @override
  String get manualFooterMeta =>
      'Dernière mise à jour : 19 avr. 2026 • Version 1.0-BETA';

  @override
  String get manualPdfFileName => 'manual_v1.0-BETA.pdf';

  @override
  String get emptyStateNoData => 'Aucune donnée disponible';

  @override
  String get emergencyStop => 'ARRÊT D\'URGENCE';

  @override
  String get emergencyTitle => 'Controle d urgence';

  @override
  String get emergencySubtitle =>
      'Surveillez l etat des appareils en direct. En cas de danger, declenchez immediatement l arret d urgence.';

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

  @override
  String get welcomeBack => 'Bon retour !';

  @override
  String get systemStatus =>
      'Tous les systemes agricoles fonctionnent dans les parametres optimaux.';

  @override
  String get systemControls => 'Controles systeme';

  @override
  String get reboot => 'REDEMARRER';

  @override
  String get shutdown => 'ETEINDRE';

  @override
  String get performanceMonitor => 'Moniteur de performance';

  @override
  String get waterOutput => 'DEBIT D EAU';

  @override
  String get soilMoisture => 'HUMIDITE DU SOL';

  @override
  String get temperature => 'TEMPERATURE';

  @override
  String get humidity => 'HUMIDITE';

  @override
  String get time => 'HEURE';

  @override
  String get today => 'AUJOURD HUI';

  @override
  String get noEvents => 'Aucun evenement prevu';

  @override
  String get didYouKnow => 'LE SAVIEZ VOUS ?';

  @override
  String get zonesTitle => 'Surveillance des zones';

  @override
  String get zonesSubtitle => 'Surveillez et controlez vos zones d irrigation.';

  @override
  String get deviceState => 'ETAT DU DISPOSITIF';

  @override
  String get valveState => 'ETAT DE LA VANNE';

  @override
  String get online => 'En ligne';

  @override
  String get offline => 'Hors ligne';

  @override
  String get open => 'Ouvert';

  @override
  String get closed => 'Ferme';

  @override
  String get analyticsTitle => 'Analytique';

  @override
  String get analyticsSubtitle => 'Consultez les donnees de performance.';

  @override
  String get userManualTitle => 'Manuel';

  @override
  String get settingsApplied => 'Parametres appliques avec succes.';

  @override
  String get ok => 'OK';

  @override
  String get viewAll => 'Voir tout';
}
