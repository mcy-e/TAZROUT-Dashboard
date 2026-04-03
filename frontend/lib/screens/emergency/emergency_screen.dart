//? Emergency control screen.
//? Displays live zone device states and emergency stop trigger.
//? EmergencyStopButton is frontend-managed — no backend endpoint.
// TODO :: Wire zone states to MQTT topic: tazrout/emergency/status
// TODO :: Update hasEmergencyAlertProvider when any zone is OFFLINE

//& Imports
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/localization/l10n/app_localizations.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/theme/app_colors.dart';
import 'package:tazrout_dashboard/core/utils/locale_text_direction.dart';
import '../../../core/theme/app_typography.dart';
import 'widgets/zone_status_grid.dart';
import 'widgets/emergency_stop_button.dart';

//& EmergencyScreen Widget
class EmergencyScreen extends StatelessWidget {
  //* StatelessWidget — composes the emergency control layout
  const EmergencyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    //* Static list of 9 zones with mixed online/offline states
    // TODO :: Replace with real MQTT data from topic: tazrout/emergency/status
    final List<Map<String, dynamic>> zones = [
      {'zoneName': 'Zone A', 'isOnline': true},
      {'zoneName': 'Zone B', 'isOnline': true},
      {'zoneName': 'Zone C', 'isOnline': true},
      {'zoneName': 'Zone D', 'isOnline': false},
      {'zoneName': 'Zone E', 'isOnline': false},
      {'zoneName': 'Zone F', 'isOnline': true},
      {'zoneName': 'Zone G', 'isOnline': true},
      {'zoneName': 'Zone H', 'isOnline': true},
      {'zoneName': 'Zone I', 'isOnline': true},
    ];

    return Scaffold(
      backgroundColor: AppColors.lightSurfaceCard.withValues(alpha: 0.0),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //* Page header Row (fixed height 64px)
            SizedBox(
              height: 64,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: isArabic(context)
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        IntrinsicHeight(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: isArabic(context)
                                ? [
                                    Text(
                                      l10n.emergencyTitle,
                                      textAlign: TextAlign.right,
                                      textDirection: textDirectionForUiLocale(context),
                                      style: AppTypography.headingM.copyWith(
                                        color: isDark
                                            ? AppColors.darkPrimaryText
                                            : AppColors.lightPrimaryText,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    SvgPicture.asset(
                                      isDark
                                          ? AppAssets.darkIconEmergencyIcon
                                          : AppAssets.lightIconEmergencyIcon,
                                      width: 22,
                                      height: 22,
                                    ),
                                  ]
                                : [
                                    SvgPicture.asset(
                                      isDark
                                          ? AppAssets.darkIconEmergencyIcon
                                          : AppAssets.lightIconEmergencyIcon,
                                      width: 22,
                                      height: 22,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      l10n.emergencyTitle,
                                      textAlign: TextAlign.left,
                                      textDirection: textDirectionForUiLocale(context),
                                      style: AppTypography.headingM.copyWith(
                                        color: isDark
                                            ? AppColors.darkPrimaryText
                                            : AppColors.lightPrimaryText,
                                      ),
                                    ),
                                  ],
                          ),
                        ),
                        Text(
                          l10n.emergencySubtitle,
                          textAlign: isArabic(context) ? TextAlign.right : TextAlign.left,
                          textDirection: textDirectionForUiLocale(context),
                          style: AppTypography.bodySRegular.copyWith(
                            color: isDark ? AppColors.darkMutedText : AppColors.lightMutedText,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            //* Expanded: ZoneStatusGrid (scrollable 4-column grid)
            Expanded(
              child: ZoneStatusGrid(zones: zones),
            ),
            const SizedBox(height: 16),
            //* EmergencyStopButton (fixed height 72px, full width)
            const EmergencyStopButton(),
          ],
        ),
      ),
    );
  }
}
