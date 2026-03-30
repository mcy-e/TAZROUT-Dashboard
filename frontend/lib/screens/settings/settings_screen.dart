//? Settings screen — composes all settings widgets.
//? State is managed locally in each card widget for now.
//? Apply Settings button collects state from all cards and persists.
// TODO :: Load initial preferences from MQTT on screen mount
// TODO :: Wire Apply to MQTT publish: tazrout/settings/preferences

//& Imports
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/app_logger.dart';
import '../../../models/user_preferences_model.dart';
import '../../../providers/preferences_provider.dart';
import '../../../providers/theme_provider.dart';
import '../../../providers/locale_provider.dart';
import 'widgets/display_settings_card.dart';
import 'widgets/system_settings_card.dart';
import 'widgets/notification_settings_card.dart';
import 'widgets/settings_action_buttons.dart';

//& SettingsScreen Widget
class SettingsScreen extends ConsumerStatefulWidget {
  //* ConsumerStatefulWidget
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  //* Local draft state — user edits here before applying
  late UserPreferencesModel _draft;
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      //* Initialize draft from preferencesProvider on first build
      _draft = ref.read(preferencesProvider);
      _isInitialized = true;
    }
  }

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
                  prefs: _draft,
                  onChange: (updated) => setState(() => _draft = updated),
                ),
                const SizedBox(height: 16),
                //* SystemSettingsCard
                SystemSettingsCard(
                  prefs: _draft,
                  onChange: (updated) => setState(() => _draft = updated),
                ),
                const SizedBox(height: 16),
                //* NotificationSettingsCard
                NotificationSettingsCard(
                  prefs: _draft,
                  onChange: (updated) => setState(() => _draft = updated),
                ),
                const SizedBox(height: 24),
                //* Footer Row (right-aligned)
                SettingsActionButtons(
                  onReset: () {
                    //* Reset draft to factory defaults, not saved preferences
                    setState(() => _draft = UserPreferencesModel.defaults);
                    AppLogger.info('SETTINGS', 'Preferences reset to factory defaults');
                  },
                  onApply: () {
                    //* Commit draft to global provider
                    ref.read(preferencesProvider.notifier).state = _draft;
                    //* Apply theme change immediately
                    ref.read(themeModeProvider.notifier).state =
                        _draft.theme == 'DARK' ? ThemeMode.dark : ThemeMode.light;
                    
                    //* Apply locale change immediately on Apply Settings
                    final localeMap = {'EN': 'en', 'FR': 'fr', 'AR': 'ar'};
                    final code = localeMap[_draft.language] ?? 'en';
                    ref.read(localeProvider.notifier).state = Locale(code);
                    AppLogger.state('SETTINGS', 'Locale set to $code');

                    AppLogger.info('SETTINGS', 'Preferences applied: ${_draft.theme}');
                    // TODO :: Publish _draft to MQTT topic: tazrout/settings/preferences
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
