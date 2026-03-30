//? Holds the current user preferences state app-wide.
//? Settings screen reads and writes to this provider.
//? Apply Settings commits local card state to this provider.
// TODO :: On app startup load from MQTT retained message: tazrout/settings/preferences
// TODO :: On apply publish to MQTT: tazrout/settings/preferences

//& Imports
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_preferences_model.dart';

//& Preferences Provider
//* Holds full UserPreferencesModel as mutable state
final preferencesProvider = StateProvider<UserPreferencesModel>(
  (ref) => UserPreferencesModel.defaults,
);
