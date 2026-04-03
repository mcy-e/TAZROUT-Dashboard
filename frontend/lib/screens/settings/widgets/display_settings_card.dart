//? Card grouping all display-related preferences.
//? Section header: monitor icon + "Display Settings".

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

//& DisplaySettingsCard Widget
class DisplaySettingsCard extends StatelessWidget {
  final UserPreferencesModel prefs;
  final Function(UserPreferencesModel) onChange;

  //* StatelessWidget — receives prefs and onChange callback
  const DisplaySettingsCard({
    super.key,
    required this.prefs,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    final languageLabel = _languageLabelFromCode(prefs.language);

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
                        l10n.settingsDisplayTitle,
                        textAlign: TextAlign.right,
                        textDirection: textDirectionForUiLocale(context),
                        style: AppTypography.headingS.copyWith(
                          color: isDark ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                        ),
                      ),
                      const SizedBox(width: 8),
                      SvgPicture.asset(
                        isDark
                            ? AppAssets.darkIconScreenSettings
                            : AppAssets.lightIconScreenSettings,
                        width: 22,
                        height: 22,
                      ),
                    ]
                  : [
                      SvgPicture.asset(
                        isDark
                            ? AppAssets.darkIconScreenSettings
                            : AppAssets.lightIconScreenSettings,
                        width: 22,
                        height: 22,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        l10n.settingsDisplayTitle,
                        textAlign: TextAlign.left,
                        textDirection: textDirectionForUiLocale(context),
                        style: AppTypography.headingS.copyWith(
                          color: isDark ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                        ),
                      ),
                    ],
            ),
            const Divider(height: 24, color: AppColors.darkStrokeDivider),
            //* Switch Language
            SettingsDropdownRow(
              label: l10n.settingsLanguage,
              subtitle: l10n.settingsLanguageSubtitle,
              value: languageLabel,
              options: const ['English', 'Français', 'العربية'],
              onChanged: (val) => onChange(
                prefs.copyWith(language: _languageCodeFromLabel(val)),
              ),
            ),
            const Divider(height: 24, color: AppColors.darkStrokeDivider),
            //* Switch Theme
            SettingsDropdownRow(
              label: l10n.settingsTheme,
              subtitle: l10n.settingsThemeSubtitle,
              value: prefs.theme,
              options: const ['Light', 'Dark'],
              onChanged: (val) => onChange(prefs.copyWith(theme: val)),
            ),
            const Divider(height: 24, color: AppColors.darkStrokeDivider),
            //* Switch Font Size
            SettingsDropdownRow(
              label: l10n.settingsFontSize,
              subtitle: l10n.settingsFontSizeSubtitle,
              value: prefs.fontSize,
              options: const ['Small', 'Medium', 'Large'],
              onChanged: (val) => onChange(prefs.copyWith(fontSize: val)),
            ),
            const Divider(height: 24, color: AppColors.darkStrokeDivider),
            //* Date Format
            SettingsDropdownRow(
              label: l10n.settingsDateFormat,
              subtitle: l10n.settingsDateFormatSubtitle,
              value: prefs.dateFormat,
              options: const ['DD/MM/YYYY', 'MM/DD/YYYY', 'YYYY/MM/DD'],
              onChanged: (val) => onChange(prefs.copyWith(dateFormat: val)),
            ),
            const Divider(height: 24, color: AppColors.darkStrokeDivider),
            //* Time Format
            SettingsDropdownRow(
              label: l10n.settingsTimeFormat,
              subtitle: l10n.settingsTimeFormatSubtitle,
              value: prefs.timeFormat,
              options: const ['24 Hours', '12 Hours'],
              onChanged: (val) => onChange(prefs.copyWith(timeFormat: val)),
            ),
          ],
        ),
      ),
    );
  }

  //* Language mapping (UI label <-> stored locale code)
  static String _languageLabelFromCode(String code) {
    switch (code) {
      case 'fr':
        return 'Français';
      case 'ar':
        return 'العربية';
      case 'en':
      default:
        return 'English';
    }
  }

  static String _languageCodeFromLabel(String label) {
    switch (label) {
      case 'Français':
        return 'fr';
      case 'العربية':
        return 'ar';
      case 'English':
      default:
        return 'en';
    }
  }
}
