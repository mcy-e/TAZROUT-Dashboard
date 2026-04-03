//? Holds the current user preferences state app-wide.
//? Settings screen reads and writes to this provider.
//? Apply Settings commits local card state to this provider.
// TODO :: On app startup load from MQTT retained message: tazrout/settings/preferences
// TODO :: On apply publish to MQTT: tazrout/settings/preferences

//& Imports
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_preferences_model.dart';

//& Preferences Provider
//* StateNotifierProvider — persists to SharedPreferences
final preferencesProvider =
    StateNotifierProvider<PreferencesNotifier, UserPreferencesModel>(
  (ref) => PreferencesNotifier(),
);

//& PreferencesNotifier Class
class PreferencesNotifier extends StateNotifier<UserPreferencesModel> {
  PreferencesNotifier() : super(UserPreferencesModel.defaults) {
    //* Load persisted preferences on init
    loadFromPrefs();
  }

  //& Storage keys
  static const _kLanguage = 'prefs.language';
  static const _kTheme = 'prefs.theme';
  static const _kFontSize = 'prefs.fontSize';
  static const _kDateFormat = 'prefs.dateFormat';
  static const _kTimeFormat = 'prefs.timeFormat';
  static const _kPowerSaving = 'prefs.powerSaving';
  static const _kSleepTimerMinutes = 'prefs.sleepTimerMinutes';
  static const _kUiAnimations = 'prefs.uiAnimations';
  static const _kSoundAlerts = 'prefs.soundAlerts';

  //* Update methods (used by future screens if needed)
  void updateFontSize(String size) => state = state.copyWith(fontSize: size);
  void updateDateFormat(String format) => state = state.copyWith(dateFormat: format);
  void updateTimeFormat(String format) => state = state.copyWith(timeFormat: format);
  void togglePowerSaving(bool value) => state = state.copyWith(powerSaving: value);
  void updateSleepTimer(int minutes) =>
      state = state.copyWith(sleepTimerMinutes: minutes);
  void toggleUiAnimations(bool value) => state = state.copyWith(uiAnimations: value);
  void toggleSoundAlerts(bool value) => state = state.copyWith(soundAlerts: value);

  void resetToDefaults() {
    state = UserPreferencesModel.defaults;
    _saveToStorage(state);
  }

  //* Applies a full pending copy and persists it
  void applyAll(UserPreferencesModel pending) {
    state = pending;
    _saveToStorage(state);
  }

  //* Reserved for future (MQTT apply semantics)
  void applySettings() {
    _saveToStorage(state);
  }

  //* Load from SharedPreferences
  Future<void> loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final loaded = UserPreferencesModel(
      language: prefs.getString(_kLanguage) ?? UserPreferencesModel.defaults.language,
      theme: prefs.getString(_kTheme) ?? UserPreferencesModel.defaults.theme,
      fontSize: prefs.getString(_kFontSize) ?? UserPreferencesModel.defaults.fontSize,
      dateFormat:
          prefs.getString(_kDateFormat) ?? UserPreferencesModel.defaults.dateFormat,
      timeFormat:
          prefs.getString(_kTimeFormat) ?? UserPreferencesModel.defaults.timeFormat,
      powerSaving:
          prefs.getBool(_kPowerSaving) ?? UserPreferencesModel.defaults.powerSaving,
      sleepTimerMinutes: prefs.getInt(_kSleepTimerMinutes) ??
          UserPreferencesModel.defaults.sleepTimerMinutes,
      uiAnimations:
          prefs.getBool(_kUiAnimations) ?? UserPreferencesModel.defaults.uiAnimations,
      soundAlerts:
          prefs.getBool(_kSoundAlerts) ?? UserPreferencesModel.defaults.soundAlerts,
    );

    state = loaded;
  }

  //* Save to SharedPreferences
  Future<void> _saveToStorage(UserPreferencesModel prefsState) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kLanguage, prefsState.language);
    await prefs.setString(_kTheme, prefsState.theme);
    await prefs.setString(_kFontSize, prefsState.fontSize);
    await prefs.setString(_kDateFormat, prefsState.dateFormat);
    await prefs.setString(_kTimeFormat, prefsState.timeFormat);
    await prefs.setBool(_kPowerSaving, prefsState.powerSaving);
    await prefs.setInt(_kSleepTimerMinutes, prefsState.sleepTimerMinutes);
    await prefs.setBool(_kUiAnimations, prefsState.uiAnimations);
    await prefs.setBool(_kSoundAlerts, prefsState.soundAlerts);
  }
}

//& Preferences extensions
extension PreferencesX on UserPreferencesModel {
  double get fontScaleFactor {
    switch (fontSize) {
      case 'Small':
        return 0.85;
      case 'Large':
        return 1.15;
      case 'Medium':
      default:
        return 1.0;
    }
  }

  Duration get animDuration {
    if (powerSaving || !uiAnimations) return Duration.zero;
    return const Duration(milliseconds: 200);
  }
}
