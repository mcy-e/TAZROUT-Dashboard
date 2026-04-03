//? Card for notification preferences.
//? Section header: bell icon + "Notification Settings".

//& Imports
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/localization/l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import 'package:tazrout_dashboard/core/utils/locale_text_direction.dart';
import '../../../../models/user_preferences_model.dart';
import 'settings_toggle_row.dart';

//& NotificationSettingsCard Widget
class NotificationSettingsCard extends StatelessWidget {
  final UserPreferencesModel prefs;
  final Function(UserPreferencesModel) onChange;

  //* StatelessWidget — receives prefs and onChange callback
  const NotificationSettingsCard({
    super.key,
    required this.prefs,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return Card(
      margin: EdgeInsets.zero,
      color: isDark ? AppColors.darkPanelCard : AppColors.lightSurfaceCard,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isDark ? AppColors.darkStrokeDivider : AppColors.lightStrokeDivider,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: isArabic(context)
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            //* Row header: Icon + Title
            Row(
              mainAxisSize: MainAxisSize.min,
              children: isArabic(context)
                  ? [
                      Text(
                        l10n.settingsNotificationTitle,
                        textAlign: TextAlign.right,
                        textDirection: textDirectionForUiLocale(context),
                        style: AppTypography.headingS.copyWith(
                          color: isDark ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                        ),
                      ),
                      const SizedBox(width: 8),
                      SvgPicture.asset(
                        isDark
                            ? AppAssets.darkIconNotificationSettings
                            : AppAssets.lightIconNotificationSettings,
                        width: 22,
                        height: 22,
                      ),
                    ]
                  : [
                      SvgPicture.asset(
                        isDark
                            ? AppAssets.darkIconNotificationSettings
                            : AppAssets.lightIconNotificationSettings,
                        width: 22,
                        height: 22,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        l10n.settingsNotificationTitle,
                        textAlign: TextAlign.left,
                        textDirection: textDirectionForUiLocale(context),
                        style: AppTypography.headingS.copyWith(
                          color: isDark ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                        ),
                      ),
                    ],
            ),
            const Divider(height: 24, color: AppColors.darkStrokeDivider),
            //* Sound Alerts Toggle
            SettingsToggleRow(
              label: l10n.settingsSoundAlerts,
              subtitle: l10n.settingsSoundAlertsSubtitle,
              value: prefs.soundAlerts,
              onChanged: (val) => onChange(prefs.copyWith(soundAlerts: val)),
            ),
          ],
        ),
      ),
    );
  }
}
