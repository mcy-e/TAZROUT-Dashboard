//? Analogue clock with live ticking hands and digital readout.
//? Amazigh diamond motifs top and bottom as decorative accents.
//? Label "TIME" in overline style top-left.

//& Imports
import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/localization/l10n/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/app_logger.dart';
import '../../../providers/preferences_provider.dart';

//& ClockWidget
class ClockWidget extends ConsumerStatefulWidget {
  //* StatefulWidget with a Timer.periodic(1 second) to update time
  const ClockWidget({super.key});

  @override
  ConsumerState<ClockWidget> createState() => _ClockWidgetState();
}

class _ClockWidgetState extends ConsumerState<ClockWidget> {
  late Timer _timer;
  late DateTime _currentTime;
  bool _isHovered = false;
  Duration _tickInterval = const Duration(seconds: 1);

  @override
  void initState() {
    super.initState();
    _currentTime = DateTime.now();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(_tickInterval, (timer) {
      if (mounted) {
        setState(() {
          _currentTime = DateTime.now();
        });
        AppLogger.debug('CLOCK', 'Tick: $_currentTime');
      }
    });
  }

  void _updateTimerForPowerSaving(bool powerSaving) {
    final nextInterval = powerSaving
        ? const Duration(seconds: 10)
        : const Duration(seconds: 1);
    debugPrint('[PowerSaving] tick interval: $nextInterval, powerSaving: $powerSaving');
    // TODO :: Remove this temporary power-saving debug log after QA confirmation.
    if (nextInterval == _tickInterval) return;
    _tickInterval = nextInterval;
    _timer.cancel();
    _startTimer();
  }

  @override
  void dispose() {
    //* Dispose timer in dispose()
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final prefs = ref.watch(preferencesProvider);
    final l10n = AppLocalizations.of(context)!;
    _updateTimerForPowerSaving(prefs.powerSaving);
    final use24h = prefs.timeFormat == '24 Hours';
    final digitalTime = use24h
        ? DateFormat('HH:mm:ss').format(_currentTime)
        : DateFormat('hh:mm:ss a').format(_currentTime);

    return Card(
      margin: EdgeInsets.zero,
      color: isDark ? AppColors.darkPanelCard : AppColors.lightSurfaceCard,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isDark ? AppColors.darkStrokeDivider : AppColors.lightStrokeDivider,
        ),
      ),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              //* ClockWidget decorative accents:
              //* Top-right symbol — larger, animates on hover
              Positioned(
                top: 8, right: 8,
                child: AnimatedRotation(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                  turns: _isHovered ? 0.08 : 0.0,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 350),
                    curve: Curves.easeInOut,
                    opacity: _isHovered ? 0.45 : 0.20,
                    child: SvgPicture.asset(
                      AppAssets.symbolEye,
                      height: 64,
                      colorFilter: const ColorFilter.mode(
                        AppColors.primary,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
              ),
              //* Bottom-left symbol — same asset, slightly smaller
              Positioned(
                bottom: 8, left: 8,
                child: AnimatedRotation(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                  turns: _isHovered ? -0.08 : 0.0,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 350),
                    curve: Curves.easeInOut,
                    opacity: _isHovered ? 0.45 : 0.20,
                    child: SvgPicture.asset(
                      AppAssets.symbolEye,
                      height: 56,
                      colorFilter: const ColorFilter.mode(
                        AppColors.primary,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
              ),
              //* Main Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //* Text("TIME") AppTypography.overlineXS muted
                Text(
                  l10n.time,
                  style: AppTypography.overlineXS.copyWith(
                    color: isDark ? AppColors.darkMutedText : AppColors.lightMutedText,
                  ),
                ),
                //* Expanded clock face
                //* Wrap in Expanded inside the Column to fix unbounded height
                Expanded(
                  child: Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        //* CustomPaint(painter: _ClockFacePainter) fills available space
                        //* Explicit size prevents unbounded constraint crash
                        AspectRatio(
                          aspectRatio: 1,
                          child: CustomPaint(
                            size: Size.infinite,
                            painter: _ClockFacePainter(
                              _currentTime,
                              isDark: isDark,
                            ),
                          ),
                        ),
                        //* Center dot: AppColors.primary, radius 4
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                //* Digital time: Text(digitalTime) AppTypography.captionMedium centered
                Center(
                  child: Text(
                    digitalTime,
                    style: AppTypography.captionMedium.copyWith(
                      color: isDark ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                    ),
                  ),
                ),
              ],
            ),
          ),
            ],
          ),
        ),
      ),
    );
  }
}

//& _ClockFacePainter extends CustomPainter
class _ClockFacePainter extends CustomPainter {
  final DateTime dateTime;
  final bool isDark;

  _ClockFacePainter(this.dateTime, {required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final radius = math.min(centerX, centerY);

    //* Draw clock face background
    if (!isDark) {
      final path = Path()
        ..addOval(Rect.fromCircle(center: Offset(centerX, centerY), radius: radius));
      canvas.drawShadow(path, Colors.black.withValues(alpha: 0.1), 4.0, false);
    }
    final Paint facePaint = Paint()
      ..color = isDark ? AppColors.darkElevatedCard : AppColors.lightSurfaceCard
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(centerX, centerY), radius, facePaint);

    final Paint tickPaint = Paint()
      ..color = isDark ? AppColors.darkStrokeDivider : AppColors.lightStrokeDivider
      ..strokeWidth = 2;

    //* Draws tick marks at 12, 3, 6, 9 positions
    for (var i = 0; i < 4; i++) {
      final angle = i * math.pi / 2;
      final start = Offset(
        centerX + (radius - 10) * math.cos(angle),
        centerY + (radius - 10) * math.sin(angle),
      );
      final end = Offset(
        centerX + radius * math.cos(angle),
        centerY + radius * math.sin(angle),
      );
      canvas.drawLine(start, end, tickPaint);
    }

    final hour = dateTime.hour % 12;
    final minute = dateTime.minute;
    final second = dateTime.second;

    //* Hour hand: AppColors.darkBodyText (dark) or black (light)
    final hourAngle = (hour + minute / 60) * math.pi / 6;
    final hourHandLength = radius * 0.5;
    final hourPaint = Paint()
      ..color = isDark ? AppColors.darkBodyText : Colors.black87
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(centerX, centerY),
      Offset(
        centerX + hourHandLength * math.sin(hourAngle),
        centerY - hourHandLength * math.cos(hourAngle),
      ),
      hourPaint,
    );

    //* Minute hand: AppColors.primary
    final minuteAngle = (minute + second / 60) * math.pi / 30;
    final minuteHandLength = radius * 0.7;
    final minutePaint = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(centerX, centerY),
      Offset(
        centerX + minuteHandLength * math.sin(minuteAngle),
        centerY - minuteHandLength * math.cos(minuteAngle),
      ),
      minutePaint,
    );

    //* Second hand: thin, AppColors.primary
    final secondAngle = second * math.pi / 30;
    final secondHandLength = radius * 0.8;
    final secondPaint = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(centerX, centerY),
      Offset(
        centerX + secondHandLength * math.sin(secondAngle),
        centerY - secondHandLength * math.cos(secondAngle),
      ),
      secondPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _ClockFacePainter oldDelegate) {
    return oldDelegate.dateTime != dateTime;
  }
}
