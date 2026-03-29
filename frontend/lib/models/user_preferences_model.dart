//? Local state model for user preference settings.
//? Matches GET /api/v1/user/preferences response structure.
// TODO :: Load initial values from Spring Boot REST on app startup
// TODO :: Persist changes via PUT /api/v1/user/preferences

//& UserPreferencesModel Class
class UserPreferencesModel {
  final String language; //? "EN" | "FR" | "AR"
  final String theme; //? "LIGHT" | "DARK"
  final String fontSize; //? "SMALL" | "MEDIUM" | "LARGE"
  final String dateFormat; //? "DD/MM/YYYY" | "MM/DD/YYYY"
  final String timeFormat; //? "24H" | "12H"
  final bool powerOptimization;
  final int sleepAfterMinutes;
  final bool animationsEnabled;
  final bool soundNotifications;

  //* Const constructor for UserPreferencesModel
  const UserPreferencesModel({
    required this.language,
    required this.theme,
    required this.fontSize,
    required this.dateFormat,
    required this.timeFormat,
    required this.powerOptimization,
    required this.sleepAfterMinutes,
    required this.animationsEnabled,
    required this.soundNotifications,
  });

  //* Default values matching the design
  static const UserPreferencesModel defaults = UserPreferencesModel(
    language: 'EN',
    theme: 'LIGHT',
    fontSize: 'MEDIUM',
    dateFormat: 'DD/MM/YYYY',
    timeFormat: '24H',
    powerOptimization: false,
    sleepAfterMinutes: 15,
    animationsEnabled: true,
    soundNotifications: false,
  );

  //* copyWith for immutable state updates
  UserPreferencesModel copyWith({
    String? language,
    String? theme,
    String? fontSize,
    String? dateFormat,
    String? timeFormat,
    bool? powerOptimization,
    int? sleepAfterMinutes,
    bool? animationsEnabled,
    bool? soundNotifications,
  }) {
    return UserPreferencesModel(
      language: language ?? this.language,
      theme: theme ?? this.theme,
      fontSize: fontSize ?? this.fontSize,
      dateFormat: dateFormat ?? this.dateFormat,
      timeFormat: timeFormat ?? this.timeFormat,
      powerOptimization: powerOptimization ?? this.powerOptimization,
      sleepAfterMinutes: sleepAfterMinutes ?? this.sleepAfterMinutes,
      animationsEnabled: animationsEnabled ?? this.animationsEnabled,
      soundNotifications: soundNotifications ?? this.soundNotifications,
    );
  }
}
