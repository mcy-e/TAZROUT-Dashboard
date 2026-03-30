//? Card grouping all display-related preferences.
//? Section header: monitor icon + "Display Settings".

//& Imports
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //* Row header: Icon + Title
            Row(
              children: [
                Icon(
                  PhosphorIcons.monitor(),
                  size: 20,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Display Settings',
                  style: AppTypography.headingS.copyWith(
                    color: isDark ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                  ),
                ),
              ],
            ),
            const Divider(height: 24, color: AppColors.darkStrokeDivider),
            //* Switch Language
            SettingsDropdownRow(
              label: 'Switch Language',
              subtitle: 'Select your preferred interface language.',
              value: prefs.language,
              options: const ['EN', 'FR', 'AR'],
              onChanged: (val) => onChange(prefs.copyWith(language: val)),
            ),
            const Divider(height: 24, color: AppColors.darkStrokeDivider),
            //* Switch Theme
            SettingsDropdownRow(
              label: 'Switch Theme',
              subtitle: 'Toggle between Light and Dark mode.',
              value: prefs.theme,
              options: const ['LIGHT', 'DARK'],
              onChanged: (val) => onChange(prefs.copyWith(theme: val)),
            ),
            const Divider(height: 24, color: AppColors.darkStrokeDivider),
            //* Switch Font Size
            SettingsDropdownRow(
              label: 'Switch Font Size',
              subtitle: 'Adjust the text size for better readability.',
              value: prefs.fontSize,
              options: const ['SMALL', 'MEDIUM', 'LARGE'],
              onChanged: (val) => onChange(prefs.copyWith(fontSize: val)),
            ),
            const Divider(height: 24, color: AppColors.darkStrokeDivider),
            //* Date Format
            SettingsDropdownRow(
              label: 'Date Format',
              subtitle: 'Choose how dates are displayed.',
              value: prefs.dateFormat,
              options: const ['DD/MM/YYYY', 'MM/DD/YYYY', 'YYYY-MM-DD'],
              onChanged: (val) => onChange(prefs.copyWith(dateFormat: val)),
            ),
            const Divider(height: 24, color: AppColors.darkStrokeDivider),
            //* Time Format
            SettingsDropdownRow(
              label: 'Time Format',
              subtitle: 'Choose between 12-hour and 24-hour clocks.',
              value: prefs.timeFormat,
              options: const ['24H', '12H'],
              onChanged: (val) => onChange(prefs.copyWith(timeFormat: val)),
            ),
          ],
        ),
      ),
    );
  }
}
