//? Card for notification preferences.
//? Section header: bell icon + "Notification Settings".

//& Imports
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
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
                  PhosphorIcons.bell(),
                  size: 20,
                  color: isDark ? AppColors.darkMutedText : AppColors.lightMutedText,
                ),
                const SizedBox(width: 8),
                Text(
                  'Notification Settings',
                  style: AppTypography.headingS.copyWith(
                    color: isDark ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                  ),
                ),
              ],
            ),
            const Divider(height: 24, color: AppColors.darkStrokeDivider),
            //* Sound Alerts Toggle
            SettingsToggleRow(
              label: 'Sound Alerts',
              subtitle: 'Play a sound when a notification arrives.',
              value: prefs.soundNotifications,
              onChanged: (val) => onChange(prefs.copyWith(soundNotifications: val)),
            ),
          ],
        ),
      ),
    );
  }
}
