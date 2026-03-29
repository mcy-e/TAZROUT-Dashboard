//? Settings screen — composes all settings widgets.
//? State is managed locally in each card widget for now.
//? Apply Settings button collects state from all cards and persists.
// TODO :: Load initial preferences from Spring Boot on screen mount
// TODO :: Wire Apply to PUT /api/v1/user/preferences

//& Imports
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/app_logger.dart';
import '../../../models/user_preferences_model.dart';
import 'widgets/display_settings_card.dart';
import 'widgets/system_settings_card.dart';
import 'widgets/notification_settings_card.dart';
import 'widgets/settings_action_buttons.dart';

//& SettingsScreen Widget
class SettingsScreen extends StatefulWidget {
  //* StatefulWidget
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  UserPreferencesModel _currentPrefs = UserPreferencesModel.defaults;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    //* SingleChildScrollView wrapping
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            //* Centered content max width 800px
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //* Page header
                Text(
                  'Settings',
                  style: AppTypography.headingM.copyWith(
                    color: isDark ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                  ),
                ),
                Text(
                  'Manage your preferences and system configurations.',
                  style: AppTypography.bodySRegular.copyWith(
                    color: isDark ? AppColors.darkMutedText : AppColors.lightMutedText,
                  ),
                ),
                const SizedBox(height: 24),
                //* DisplaySettingsCard
                DisplaySettingsCard(
                  initialPrefs: _currentPrefs,
                  onChanged: (newPrefs) => setState(() => _currentPrefs = newPrefs),
                ),
                const SizedBox(height: 16),
                //* SystemSettingsCard
                SystemSettingsCard(
                  initialPrefs: _currentPrefs,
                  onChanged: (newPrefs) => setState(() => _currentPrefs = newPrefs),
                ),
                const SizedBox(height: 16),
                //* NotificationSettingsCard
                NotificationSettingsCard(
                  initialPrefs: _currentPrefs,
                  onChanged: (newPrefs) => setState(() => _currentPrefs = newPrefs),
                ),
                const SizedBox(height: 24),
                //* Footer Row (right-aligned)
                SettingsActionButtons(
                  onReset: () {
                    setState(() => _currentPrefs = UserPreferencesModel.defaults);
                    AppLogger.info('SETTINGS', 'Reset triggered');
                  },
                  onApply: () {
                    AppLogger.info('SETTINGS', 'Apply triggered');
                    //* TODO :: Persist via PUT /api/v1/user/preferences (Spring Boot REST)
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
