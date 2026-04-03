//? Local state model for user preference settings.
//? Stored locally via SharedPreferences until MQTT config is available.
// TODO :: Replace SharedPreferences with MQTT-synced config when backend is ready

//& UserPreferencesModel Class
class UserPreferencesModel {
  final String language; //? "en" | "fr" | "ar"
  final String theme; //? "Light" | "Dark"
  final String fontSize; //? "Small" | "Medium" | "Large"
  final String dateFormat; //? "DD/MM/YYYY" | "MM/DD/YYYY" | "YYYY/MM/DD"
  final String timeFormat; //? "24 Hours" | "12 Hours"
  final bool powerSaving;
  final int sleepTimerMinutes;
  final bool uiAnimations;
  final bool soundAlerts;

  //* Const constructor for UserPreferencesModel
  const UserPreferencesModel({
    required this.language,
    required this.theme,
    required this.fontSize,
    required this.dateFormat,
    required this.timeFormat,
    required this.powerSaving,
    required this.sleepTimerMinutes,
    required this.uiAnimations,
    required this.soundAlerts,
  });

  //* Default values matching the design
  static const UserPreferencesModel defaults = UserPreferencesModel(
    language: 'en',
    theme: 'Light',
    fontSize: 'Medium',
    dateFormat: 'DD/MM/YYYY',
    timeFormat: '24 Hours',
    powerSaving: false,
    sleepTimerMinutes: 15,
    uiAnimations: true,
    soundAlerts: false,
  );

  //* copyWith for immutable state updates
  UserPreferencesModel copyWith({
    String? language,
    String? theme,
    String? fontSize,
    String? dateFormat,
    String? timeFormat,
    bool? powerSaving,
    int? sleepTimerMinutes,
    bool? uiAnimations,
    bool? soundAlerts,
  }) {
    return UserPreferencesModel(
      language: language ?? this.language,
      theme: theme ?? this.theme,
      fontSize: fontSize ?? this.fontSize,
      dateFormat: dateFormat ?? this.dateFormat,
      timeFormat: timeFormat ?? this.timeFormat,
      powerSaving: powerSaving ?? this.powerSaving,
      sleepTimerMinutes: sleepTimerMinutes ?? this.sleepTimerMinutes,
      uiAnimations: uiAnimations ?? this.uiAnimations,
      soundAlerts: soundAlerts ?? this.soundAlerts,
    );
  }

  //* Back-compat getters for existing widgets/providers
  bool get powerOptimization => powerSaving;
  int get sleepAfterMinutes => sleepTimerMinutes;
  bool get animationsEnabled => uiAnimations;
  bool get soundNotifications => soundAlerts;
}
