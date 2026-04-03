//? Settings screen — composes all settings widgets.
//? State is managed locally in each card widget for now.
//? Apply Settings button collects state from all cards and persists.
// TODO :: Load initial preferences from MQTT on screen mount
// TODO :: Wire Apply to MQTT publish: tazrout/settings/preferences

//& Imports
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/localization/l10n/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import 'package:tazrout_dashboard/core/utils/locale_text_direction.dart';
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
  //* Local pending state — user edits here before applying
  late UserPreferencesModel _pending;
  bool _hasSeededPending = false;

  @override
  void initState() {
    super.initState();
    _pending = ref.read(preferencesProvider);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentPrefs = ref.watch(preferencesProvider);
    final l10n = AppLocalizations.of(context)!;

    if (!_hasSeededPending) {
      //* Seed pending once from provider (after async load completes)
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        setState(() {
          _pending = currentPrefs;
          _hasSeededPending = true;
        });
      });
    }

    //* SingleChildScrollView wrapping
    return Scaffold(
      backgroundColor: AppColors.lightSurfaceCard.withValues(alpha: 0.0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            //* Centered content max width 800px
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              crossAxisAlignment: isArabic(context)
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                //* Page header
                Text(
                  l10n.settingsTitle,
                  textAlign: isArabic(context) ? TextAlign.right : TextAlign.left,
                  style: AppTypography.headingM.copyWith(
                    color: isDark ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                  ),
                ),
                Text(
                  l10n.settingsSubtitle,
                  textAlign: isArabic(context) ? TextAlign.right : TextAlign.left,
                  style: AppTypography.bodySRegular.copyWith(
                    color: isDark ? AppColors.darkMutedText : AppColors.lightMutedText,
                  ),
                ),
                const SizedBox(height: 24),
                //* DisplaySettingsCard
                DisplaySettingsCard(
                  prefs: _pending,
                  onChange: (updated) => setState(() => _pending = updated),
                ),
                const SizedBox(height: 16),
                //* SystemSettingsCard
                SystemSettingsCard(
                  prefs: _pending,
                  onChange: (updated) => setState(() => _pending = updated),
                ),
                const SizedBox(height: 16),
                //* NotificationSettingsCard
                NotificationSettingsCard(
                  prefs: _pending,
                  onChange: (updated) => setState(() => _pending = updated),
                ),
                const SizedBox(height: 24),
                //* Footer Row (right-aligned)
                SettingsActionButtons(
                  onReset: () {
                    //* Reset pending to defaults, not saved preferences
                    setState(() => _pending = UserPreferencesModel.defaults);
                    AppLogger.info('SETTINGS', 'Preferences reset to factory defaults');
                  },
                  onApply: () {
                    //* Commit pending to global provider + persist
                    ref.read(preferencesProvider.notifier).applyAll(_pending);

                    //* Apply theme change immediately
                    ref.read(themeModeProvider.notifier).state =
                        _pending.theme == 'Dark' ? ThemeMode.dark : ThemeMode.light;

                    //* Apply locale change immediately
                    ref.read(localeProvider.notifier).state = Locale(_pending.language);
                    AppLogger.state('SETTINGS', 'Locale set to ${_pending.language}');

                    AppLogger.info('SETTINGS', 'Preferences applied: ${_pending.theme}');
                    // TODO :: Publish _pending to MQTT topic: tazrout/settings/preferences
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
