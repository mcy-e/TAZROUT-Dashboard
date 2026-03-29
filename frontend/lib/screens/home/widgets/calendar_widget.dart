//? Shows today's date with Amazigh cross-stitch pattern as border decoration.
//? Top accent bar in AppColors.primaryDark (3px height).
//? Label "TODAY", large day number, month + year in green.
// TODO :: Wire to MQTT topic: tazrout/dashboard/summary

//& Imports
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

//& CalendarWidget
class CalendarWidget extends StatelessWidget {
  //* StatelessWidget — date computed from DateTime.now()
  const CalendarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    //* Date computation
    final now = DateTime.now();
    final dayNumber = DateFormat('d').format(now);
    final monthYear = DateFormat('MMMM y').format(now);

    return Card(
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
          //* Top accent bar: Container(height: 3, color: AppColors.primaryDark)
          Container(
            height: 3,
            color: AppColors.primaryDark,
          ),
          //* Content area
          //* Wrap the Stack in an Expanded widget inside the Column
          Expanded(
            child: Stack(
              children: [
                //* CalendarWidget border decoration:
                //* Use AppAssets.patternCrossDiamondGrid on LEFT and RIGHT edges only
                //* Width: 28px each side, full card height, opacity 0.20
                Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  child: Opacity(
                    opacity: 0.20,
                    child: SvgPicture.asset(
                      AppAssets.patternCrossDiamondGrid,
                      width: 28,
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  bottom: 0,
                  child: Opacity(
                    opacity: 0.20,
                    child: SvgPicture.asset(
                      AppAssets.patternCrossDiamondGrid,
                      width: 28,
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ),
                //* Foreground centered Column
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
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
                            Icon(
                              PhosphorIcons.calendar(),
                              size: 12,
                              color: isDark ? AppColors.darkMutedText : AppColors.lightMutedText,
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
        ],
      ),
    );
  }
}
