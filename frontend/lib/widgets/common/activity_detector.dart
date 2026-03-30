//? Wraps the entire app shell and tracks user inactivity.
//? Resets a countdown timer on every input event.
//? When timer expires → sets isSleepingProvider to true.
//? Reads sleep duration from preferencesProvider.

//& Imports
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/utils/app_logger.dart';
import '../../providers/preferences_provider.dart';
import '../../providers/sleep_provider.dart';

//& ActivityDetector Widget
class ActivityDetector extends ConsumerStatefulWidget {
  final Widget child;

  //* Tracks user inactivity to trigger sleep mode
  const ActivityDetector({
    super.key,
    required this.child,
  });

  @override
  ConsumerState<ActivityDetector> createState() => _ActivityDetectorState();
}

class _ActivityDetectorState extends ConsumerState<ActivityDetector> {
  Timer? _sleepTimer;

  @override
  void initState() {
    super.initState();
    //* Start the timer on init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _resetTimer();
    });
  }

  @override
  void dispose() {
    //* Cancel existing timer on dispose
    _sleepTimer?.cancel();
    super.dispose();
  }

  void _resetTimer() {
    //* Wake app if currently sleeping
    if (ref.read(isSleepingProvider)) {
      ref.read(isSleepingProvider.notifier).state = false;
      AppLogger.info('SLEEP', 'App woken from sleep');
    }

    //* Cancel existing timer
    _sleepTimer?.cancel();

    //* Restart countdown from preferences
    final minutes = ref.read(preferencesProvider).sleepAfterMinutes;
    
    //* Only start timer if sleep mode is enabled (minutes > 0)
    if (minutes > 0) {
      _sleepTimer = Timer(Duration(minutes: minutes), () {
        ref.read(isSleepingProvider.notifier).state = true;
        AppLogger.info('SLEEP', 'App entered sleep mode');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    //* Listener for mouse movement and touch events
    return Listener(
      onPointerDown: (_) => _resetTimer(),
      onPointerMove: (_) => _resetTimer(),
      child: KeyboardListener(
        focusNode: FocusNode(),
        autofocus: false,
        onKeyEvent: (_) => _resetTimer(),
        child: widget.child,
      ),
    );
  }
}
