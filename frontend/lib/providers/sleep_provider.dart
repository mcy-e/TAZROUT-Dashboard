//? Tracks whether the app is currently in sleep mode.
//? Reset on any user input event.

//& Imports
import 'package:flutter_riverpod/flutter_riverpod.dart';

//& Sleep Provider
//* Simple bool — true = sleeping, false = awake
final isSleepingProvider = StateProvider<bool>((ref) => false);
