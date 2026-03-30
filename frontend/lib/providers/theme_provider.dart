//? Controls app-wide theme mode.
//? Reads initial value from UserPreferencesModel defaults.
//? Settings screen writes to this provider on theme change.

//& Imports
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//& Theme Provider
//* StateProvider — holds current ThemeMode
//* Default theme is light — matches design spec initial state
final themeModeProvider = StateProvider<ThemeMode>(
  (ref) => ThemeMode.light,
);
