//? Shows today's date with Amazigh cross-stitch pattern as border decoration.
//? Top accent bar in AppColors.primaryDark (3px height).
//? Label "TODAY", large day number, month + year in green.
// TODO :: Wire to MQTT topic: tazrout/dashboard/summary

//& Imports
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

//& CalendarWidget
class CalendarWidget extends StatefulWidget {
  const CalendarWidget({super.key});

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    //* Date computation
    final now = DateTime.now();
    final dayNumber = DateFormat('d').format(now);
    final monthYear = DateFormat('MMMM y').format(now);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Card(
        margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      color: isDark ? AppColors.darkPanelCard : AppColors.lightSurfaceCard,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isDark ? AppColors.darkStrokeDivider : AppColors.lightStrokeDivider,
        ),
      ),
      child: Column(
        children: [
          //* Top accent bar: grows on hover
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            height: _isHovered ? 6 : 3,
            decoration: const BoxDecoration(
              color: AppColors.primaryDark,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
          ),
          //* Content area
          //* Wrap the Stack in an Expanded widget inside the Column
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Stack(
                children: [
                  //* CalendarWidget border decoration:
                  //* Use AppAssets.patternCrossDiamondGrid on LEFT and RIGHT edges only
                  //* Width: 28px each side, full card height, opacity 0.18
                  //* Pattern is a horizontal SVG — rotate 90° to render vertically
                  Positioned(
                    left: 0,
                    top: 0,
                    bottom: 0,
                    child: SizedBox(
                      width: 68,
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        opacity: _isHovered ? 0.30 : 0.18,
                        child: RotatedBox(
                          quarterTurns: 1,
                          child: SvgPicture.asset(
                            AppAssets.patternCrossDiamondGrid,
                            fit: BoxFit.cover,
                            colorFilter: const ColorFilter.mode(
                              AppColors.primary,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  //* Foreground centered Column
                Center(
                  child: AnimatedPadding(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    padding: _isHovered
                        ? const EdgeInsets.only(left: 64, right: 16, top: 16, bottom: 12)
                        : const EdgeInsets.only(left: 60, right: 16, top: 12, bottom: 12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //* Label: Text("TODAY") AppTypography.overlineXS muted uppercase
                        Text(
                          'TODAY',
                          style: AppTypography.overlineXS.copyWith(
                            color: isDark ? AppColors.darkMutedText : AppColors.lightMutedText,
                          ),
                        ),
                        //* Day number: Text(day) AppTypography.displayL Poppins Bold
                        Text(
                          dayNumber,
                          style: AppTypography.displayL.copyWith(
                            color: isDark ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                          ),
                        ),
                        //* Month + Year: Text(monthYear) AppTypography.headingXS color AppColors.primary
                        Text(
                          monthYear,
                          style: AppTypography.headingXS.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        //* Events label
                        // TODO :: Wire to MQTT topic: tazrout/dashboard/summary
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              isDark ? AppAssets.darkIconCalendar : AppAssets.lightIconCalendar,
                              height: 12,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'No events scheduled',
                              style: AppTypography.labelXSRegular.copyWith(
                                color: isDark ? AppColors.darkMutedText : AppColors.lightMutedText,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          ),
        ],
      ),
    ),
    );
  }
}
