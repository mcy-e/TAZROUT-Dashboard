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
        child: TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 800),
          tween: Tween<double>(begin: 0.0, end: 0.92),
          builder: (context, opacity, child) {
            return Opacity(
              opacity: opacity,
              child: Container(
                color: Colors.black,
                //* Centered Tazrout logo — subtle presence during sleep
                child: const Center(
                  child: _PulsingLogo(),
                ),
              ),
            );
          },
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

//& _PulsingLogo Widget
class _PulsingLogo extends StatefulWidget {
  const _PulsingLogo();

  @override
  State<_PulsingLogo> createState() => _PulsingLogoState();
}

class _PulsingLogoState extends State<_PulsingLogo> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    
    _animation = Tween<double>(begin: 0.1, end: 0.3).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Opacity(
          opacity: _animation.value,
          child: child,
        );
      },
      child: SvgPicture.asset(
        AppAssets.logoDarkIconDefault,
        height: 80,
      ),
    );
  }
}
