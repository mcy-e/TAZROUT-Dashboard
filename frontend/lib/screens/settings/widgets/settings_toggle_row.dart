//? Reusable settings row with a label, subtitle, and toggle switch.
//? Used for Power Saving, UI Animations, Sound Alerts.
//? Toggle: green when enabled (AppColors.primary), grey when disabled.
//? Disabled toggle thumb shows arrow/chevron icon per design.

//& Imports
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import 'package:tazrout_dashboard/core/utils/locale_text_direction.dart';
import '../../../../core/utils/app_logger.dart';
import '../../../../providers/preferences_provider.dart';

//& SettingsToggleRow Widget
class SettingsToggleRow extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    //* Row crossAxisAlignment: center, minHeight 56px
    return Container(
      constraints: const BoxConstraints(minHeight: 56),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: isArabic(context)
            ? [
                //* Switch widget
                _SettingsThumbToggle(
                  value: value,
                  onChanged: (newValue) {
                    onChanged(newValue);
                    //* AppLogger.state('SETTINGS', '$label toggled to $value')
                    AppLogger.state('SETTINGS', '$label toggled to $newValue');
                  },
                ),
                const SizedBox(width: 16),
                //* Expanded Column for labels
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      //* Text(label) AppTypography.bodySBold
                      Text(
                        label,
                        textAlign: TextAlign.right,
                        textDirection: textDirectionForUiLocale(context),
                        style: AppTypography.bodySBold.copyWith(
                          color: isDark ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                        ),
                      ),
                      //* Text(subtitle) AppTypography.labelXSRegular muted
                      Text(
                        subtitle,
                        textAlign: TextAlign.right,
                        textDirection: textDirectionForUiLocale(context),
                        style: AppTypography.labelXSRegular.copyWith(
                          color: isDark ? AppColors.darkMutedText : AppColors.lightMutedText,
                        ),
                      ),
                    ],
                  ),
                ),
              ]
            : [
                //* Expanded Column for labels
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      //* Text(label) AppTypography.bodySBold
                      Text(
                        label,
                        textAlign: TextAlign.left,
                        textDirection: textDirectionForUiLocale(context),
                        style: AppTypography.bodySBold.copyWith(
                          color: isDark ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                        ),
                      ),
                      //* Text(subtitle) AppTypography.labelXSRegular muted
                      Text(
                        subtitle,
                        textAlign: TextAlign.left,
                        textDirection: textDirectionForUiLocale(context),
                        style: AppTypography.labelXSRegular.copyWith(
                          color: isDark ? AppColors.darkMutedText : AppColors.lightMutedText,
                        ),
                      ),
                    ],
                  ),
                ),
                //* Switch widget
                _SettingsThumbToggle(
                  value: value,
                  onChanged: (newValue) {
                    onChanged(newValue);
                    //* AppLogger.state('SETTINGS', '$label toggled to $value')
                    AppLogger.state('SETTINGS', '$label toggled to $newValue');
                  },
                ),
              ],
      ),
    );
  }
}

//& _SettingsThumbToggle
class _SettingsThumbToggle extends ConsumerStatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SettingsThumbToggle({
    required this.value,
    required this.onChanged,
  });

  @override
  ConsumerState<_SettingsThumbToggle> createState() => _SettingsThumbToggleState();
}

class _SettingsThumbToggleState extends ConsumerState<_SettingsThumbToggle> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isEnabled = widget.value;
    final animDuration = ref.watch(preferencesProvider).animDuration;

    final trackColor = isEnabled
        ? AppColors.primary
        : (isDark ? AppColors.darkHoverSurface : AppColors.lightStrokeDivider);

    final thumbBg = AppColors.lightSurfaceCard;
    final glyphColor = isEnabled
        ? AppColors.primary
        : (isDark ? AppColors.darkMutedText : AppColors.lightStrokeDivider);

    return GestureDetector(
      onTap: () => widget.onChanged(!widget.value),
      child: AnimatedContainer(
        duration: animDuration,
        curve: Curves.easeInOut,
        width: 52,
        height: 28,
        decoration: BoxDecoration(
          color: trackColor,
          borderRadius: BorderRadius.circular(14),
        ),
        child: AnimatedAlign(
          duration: animDuration,
          curve: Curves.easeInOut,
          alignment: isEnabled ? Alignment.centerRight : Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.all(3),
            child: Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: thumbBg,
                borderRadius: BorderRadius.circular(11),
              ),
              child: Center(
                child: SvgPicture.asset(
                  isEnabled ? AppAssets.glyphActive : AppAssets.glyphInActive,
                  width: 12,
                  height: 12,
                  colorFilter: ColorFilter.mode(
                    glyphColor,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
