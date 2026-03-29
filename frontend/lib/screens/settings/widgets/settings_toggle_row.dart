//? Reusable settings row with a label, subtitle, and toggle switch.
//? Used for Power Saving, UI Animations, Sound Alerts.
//? Toggle: green when enabled (AppColors.primary), grey when disabled.
//? Disabled toggle thumb shows arrow/chevron icon per design.

//& Imports
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/app_logger.dart';

//& SettingsToggleRow Widget
class SettingsToggleRow extends StatelessWidget {
  final String label;
  final String subtitle;
  final bool value;
  final Function(bool) onChanged;

  //* SettingsToggleRow Parameters
  const SettingsToggleRow({
    super.key,
    required this.label,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    //* Row crossAxisAlignment: center, minHeight 56px
    return Container(
      constraints: const BoxConstraints(minHeight: 56),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //* Expanded Column for labels
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                //* Text(label) AppTypography.bodySBold
                Text(
                  label,
                  style: AppTypography.bodySBold.copyWith(
                    color: isDark ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                  ),
                ),
                //* Text(subtitle) AppTypography.labelXSRegular muted
                Text(
                  subtitle,
                  style: AppTypography.labelXSRegular.copyWith(
                    color: isDark ? AppColors.darkMutedText : AppColors.lightMutedText,
                  ),
                ),
              ],
            ),
          ),
          //* Switch widget
          Switch(
            value: value,
            onChanged: (newValue) {
              onChanged(newValue);
              //* AppLogger.state('SETTINGS', '$label toggled to $value')
              AppLogger.state('SETTINGS', '$label toggled to $newValue');
            },
            activeThumbColor: AppColors.primary,
            activeTrackColor: AppColors.primary20,
            inactiveThumbColor: AppColors.darkMutedText,
            inactiveTrackColor: isDark ? AppColors.darkHoverSurface : AppColors.lightStrokeDivider,
          ),
        ],
      ),
    );
  }
}
