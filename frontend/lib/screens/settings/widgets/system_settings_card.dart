//? Card grouping power and UI system preferences.
//? Section header: gear icon + "System Settings".

//& Imports
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
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
                  PhosphorIcons.gear(),
                  size: 20,
                  color: isDark ? AppColors.darkMutedText : AppColors.lightMutedText,
                ),
                const SizedBox(width: 8),
                Text(
                  'System Settings',
                  style: AppTypography.headingS.copyWith(
                    color: isDark ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                  ),
                ),
              ],
            ),
            const Divider(height: 24, color: AppColors.darkStrokeDivider),
            //* Power Saving Toggle
            SettingsToggleRow(
              label: 'Power Saving',
              subtitle: 'Reduce performance to save energy.',
              value: prefs.powerOptimization,
              onChanged: (val) => onChange(prefs.copyWith(powerOptimization: val)),
            ),
            const Divider(height: 24, color: AppColors.darkStrokeDivider),
            //* Auto Sleep Timer Dropdown
            SettingsDropdownRow(
              label: 'Auto Sleep Timer',
              subtitle: 'Duration before entering sleep mode.',
              value: prefs.sleepAfterMinutes == 0 ? 'Never' : '${prefs.sleepAfterMinutes} Minutes',
              options: const ['5 Minutes', '10 Minutes', '15 Minutes', '30 Minutes', 'Never'],
              onChanged: (val) {
                int minutes = 0;
                if (val != 'Never') {
                  minutes = int.parse(val.split(' ')[0]);
                }
                onChange(prefs.copyWith(sleepAfterMinutes: minutes));
              },
            ),
            const Divider(height: 24, color: AppColors.darkStrokeDivider),
            //* UI Animations Toggle
            SettingsToggleRow(
              label: 'UI Animations',
              subtitle: 'Enable smooth transitions and effects.',
              value: prefs.animationsEnabled,
              onChanged: (val) => onChange(prefs.copyWith(animationsEnabled: val)),
            ),
          ],
        ),
      ),
    );
  }
}
