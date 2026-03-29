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
class SystemSettingsCard extends StatefulWidget {
  final UserPreferencesModel initialPrefs;
  final Function(UserPreferencesModel) onChanged;

  //* StatefulWidget — owns local system preference state
  const SystemSettingsCard({
    super.key,
    required this.initialPrefs,
    required this.onChanged,
  });

  @override
  State<SystemSettingsCard> createState() => _SystemSettingsCardState();
}

class _SystemSettingsCardState extends State<SystemSettingsCard> {
  late UserPreferencesModel _prefs;

  @override
  void initState() {
    super.initState();
    _prefs = widget.initialPrefs;
  }

  void _updatePrefs(UserPreferencesModel newPrefs) {
    setState(() => _prefs = newPrefs);
    widget.onChanged(newPrefs);
  }

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
              value: _prefs.powerOptimization,
              onChanged: (val) => _updatePrefs(_prefs.copyWith(powerOptimization: val)),
            ),
            const Divider(height: 24, color: AppColors.darkStrokeDivider),
            //* Auto Sleep Timer Dropdown
            SettingsDropdownRow(
              label: 'Auto Sleep Timer',
              subtitle: 'Duration before entering sleep mode.',
              value: _prefs.sleepAfterMinutes == 0 ? 'Never' : '${_prefs.sleepAfterMinutes} Minutes',
              options: const ['5 Minutes', '10 Minutes', '15 Minutes', '30 Minutes', 'Never'],
              onChanged: (val) {
                int minutes = 0;
                if (val != 'Never') {
                  minutes = int.parse(val.split(' ')[0]);
                }
                _updatePrefs(_prefs.copyWith(sleepAfterMinutes: minutes));
              },
            ),
            const Divider(height: 24, color: AppColors.darkStrokeDivider),
            //* UI Animations Toggle
            SettingsToggleRow(
              label: 'UI Animations',
              subtitle: 'Enable smooth transitions and effects.',
              value: _prefs.animationsEnabled,
              onChanged: (val) => _updatePrefs(_prefs.copyWith(animationsEnabled: val)),
            ),
          ],
        ),
      ),
    );
  }
}
