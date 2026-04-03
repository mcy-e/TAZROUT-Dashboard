//? Card grouping power and UI system preferences.
//? Section header: gear icon + "System Settings".

//& Imports
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/localization/l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import 'package:tazrout_dashboard/core/utils/locale_text_direction.dart';
import '../../../../models/user_preferences_model.dart';
import 'settings_dropdown_row.dart';
import 'settings_toggle_row.dart';

//& SystemSettingsCard Widget
class SystemSettingsCard extends StatelessWidget {
  final UserPreferencesModel prefs;
  final Function(UserPreferencesModel) onChange;

  //* StatelessWidget — receives prefs and onChange callback
  const SystemSettingsCard({
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
                        l10n.settingsSystemTitle,
                        textAlign: TextAlign.right,
                        textDirection: textDirectionForUiLocale(context),
                        style: AppTypography.headingS.copyWith(
                          color: isDark ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                        ),
                      ),
                      const SizedBox(width: 8),
                      SvgPicture.asset(
                        isDark
                            ? AppAssets.darkIconSystemSettings
                            : AppAssets.lightIconSystemSettings,
                        width: 22,
                        height: 22,
                      ),
                    ]
                  : [
                      SvgPicture.asset(
                        isDark
                            ? AppAssets.darkIconSystemSettings
                            : AppAssets.lightIconSystemSettings,
                        width: 22,
                        height: 22,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        l10n.settingsSystemTitle,
                        textAlign: TextAlign.left,
                        textDirection: textDirectionForUiLocale(context),
                        style: AppTypography.headingS.copyWith(
                          color: isDark ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                        ),
                      ),
                    ],
            ),
            const Divider(height: 24, color: AppColors.darkStrokeDivider),
            //* Power Saving Toggle
            SettingsToggleRow(
              label: l10n.settingsPowerSaving,
              subtitle: l10n.settingsPowerSavingSubtitle,
              value: prefs.powerSaving,
              onChanged: (val) => onChange(prefs.copyWith(powerSaving: val)),
            ),
            const Divider(height: 24, color: AppColors.darkStrokeDivider),
            //* Auto Sleep Timer Dropdown
            SettingsDropdownRow(
              label: l10n.settingsAutoSleep,
              subtitle: l10n.settingsAutoSleepSubtitle,
              value: _sleepTimerLabel(prefs.sleepTimerMinutes),
              options: const ['5 Minutes', '10 Minutes', '15 Minutes', '30 Minutes', '1 Hour'],
              onChanged: (val) {
                onChange(prefs.copyWith(sleepTimerMinutes: _sleepTimerMinutes(val)));
                // TODO :: Update activity_detector.dart inactivity duration
              },
            ),
            const Divider(height: 24, color: AppColors.darkStrokeDivider),
            //* UI Animations Toggle
            SettingsToggleRow(
              label: l10n.settingsUiAnimations,
              subtitle: l10n.settingsUiAnimationsSubtitle,
              value: prefs.uiAnimations,
              onChanged: (val) => onChange(prefs.copyWith(uiAnimations: val)),
            ),
          ],
        ),
      ),
    );
  }

  static String _sleepTimerLabel(int minutes) {
    switch (minutes) {
      case 5:
        return '5 Minutes';
      case 10:
        return '10 Minutes';
      case 15:
        return '15 Minutes';
      case 30:
        return '30 Minutes';
      case 60:
        return '1 Hour';
      default:
        return '15 Minutes';
    }
  }

  static int _sleepTimerMinutes(String label) {
    switch (label) {
      case '5 Minutes':
        return 5;
      case '10 Minutes':
        return 10;
      case '15 Minutes':
        return 15;
      case '30 Minutes':
        return 30;
      case '1 Hour':
        return 60;
      default:
        return 15;
    }
  }
}
