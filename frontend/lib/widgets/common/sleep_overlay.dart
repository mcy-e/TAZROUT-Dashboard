//? Full-screen dim overlay shown during sleep mode.
//? Covers all content including sidebar and notifications.
//? Any interaction wakes the app immediately.

//& Imports
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/constants/app_assets.dart';
import '../../core/utils/app_logger.dart';
import '../../providers/sleep_provider.dart';

//& SleepOverlay Widget
class SleepOverlay extends ConsumerWidget {
  //* ConsumerWidget — watches isSleepingProvider
  const SleepOverlay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSleeping = ref.watch(isSleepingProvider);

    //* If not sleeping: return invisible
    if (!isSleeping) return const SizedBox.shrink();

    //* If sleeping: dark overlay with logo
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _wakeUp(ref),
      onPanDown: (_) => _wakeUp(ref),
      child: MouseRegion(
        onHover: (_) => _wakeUp(ref),
        child: AnimatedOpacity(
          opacity: 0.85,
          duration: const Duration(milliseconds: 500),
          //* Dark overlay — farmer sees a nearly black screen
          child: Container(
            color: Colors.black,
            //* Centered Tazrout logo — subtle presence during sleep
            child: Center(
              child: Opacity(
                opacity: 0.15,
                child: SvgPicture.asset(
                  AppAssets.logoDarkDefault,
                  height: 48,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _wakeUp(WidgetRef ref) {
    if (ref.read(isSleepingProvider)) {
      ref.read(isSleepingProvider.notifier).state = false;
      AppLogger.info('SLEEP', 'App woken by user input');
    }
  }
}
