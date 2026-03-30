//? Controls app-wide display language.
//? Written by Settings screen on language change + Apply.
// TODO :: Persist locale preference via MQTT retained message

//& Imports
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//& Locale Provider
final localeProvider = StateProvider<Locale>(
  (ref) => const Locale('en'),
);
