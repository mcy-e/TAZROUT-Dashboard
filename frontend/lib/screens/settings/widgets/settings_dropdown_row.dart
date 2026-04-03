//? Reusable settings row with a label, subtitle, and dropdown field.
//? Used for Language, Theme, Font Size, Date Format, Time Format.
//? Dropdown field: full-width rounded container showing current value.
//? Hover: border color → AppColors.focusedBorder, shows arrow icon.

//& Imports
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/localization/l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/app_logger.dart';
import '../../../../core/utils/locale_text_direction.dart';
import '../../../../providers/preferences_provider.dart';

//& _localizeDropdownDisplay
//* Maps stored English/raw values to localized labels for display only.
String _localizeDropdownDisplay(String raw, AppLocalizations l10n) {
  return switch (raw) {
    'Light' => l10n.themeLight,
    'Dark' => l10n.themeDark,
    'Small' => l10n.fontSmall,
    'Medium' => l10n.fontMedium,
    'Large' => l10n.fontLarge,
    '24 Hours' => l10n.time24h,
    '12 Hours' => l10n.time12h,
    '5 Minutes' => l10n.min5,
    '10 Minutes' => l10n.min10,
    '15 Minutes' => l10n.min15,
    '30 Minutes' => l10n.min30,
    '1 Hour' => l10n.hour1,
    'English' => l10n.langEnglish,
    'Français' => l10n.langFrench,
    'العربية' => l10n.langArabic,
    'DD/MM/YYYY' => l10n.dateFormatDDMMYYYY,
    'MM/DD/YYYY' => l10n.dateFormatMMDDYYYY,
    'YYYY/MM/DD' => l10n.dateFormatYYYYMMDD,
    _ => raw,
  };
}

//& SettingsDropdownRow Widget
class SettingsDropdownRow extends ConsumerStatefulWidget {
  final String label;
  final String subtitle;
  final String value;
  final List<String> options;
  final Function(String) onChanged;

  //* SettingsDropdownRow Parameters
  const SettingsDropdownRow({
    super.key,
    required this.label,
    required this.subtitle,
    required this.value,
    required this.options,
    required this.onChanged,
  });

  @override
  ConsumerState<SettingsDropdownRow> createState() => _SettingsDropdownRowState();
}

class _SettingsDropdownRowState extends ConsumerState<SettingsDropdownRow> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final animDuration = ref.watch(preferencesProvider).animDuration;
    final l10n = AppLocalizations.of(context)!;
    final displayValue = _localizeDropdownDisplay(widget.value, l10n);

    //* Row crossAxisAlignment: center, minHeight 56px
    return Container(
      constraints: const BoxConstraints(minHeight: 56),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: isArabic(context)
            ? [
                //* Expanded(flex:2) for the dropdown field
                Expanded(
                  flex: 2,
                  child: _buildDropdownField(context, l10n, animDuration, isDark, displayValue),
                ),
                const SizedBox(width: 24),
                //* Expanded(flex:2) Column for labels
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      //* Text(label) AppTypography.bodySBold
                      Text(
                        widget.label,
                        textAlign: TextAlign.right,
                        textDirection: textDirectionForUiLocale(context),
                        style: AppTypography.bodySBold.copyWith(
                          color: isDark ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                        ),
                      ),
                      //* Text(subtitle) AppTypography.labelXSRegular muted
                      Text(
                        widget.subtitle,
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
                //* Expanded(flex:2) Column for labels
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      //* Text(label) AppTypography.bodySBold
                      Text(
                        widget.label,
                        textAlign: TextAlign.left,
                        textDirection: textDirectionForUiLocale(context),
                        style: AppTypography.bodySBold.copyWith(
                          color: isDark ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                        ),
                      ),
                      //* Text(subtitle) AppTypography.labelXSRegular muted
                      Text(
                        widget.subtitle,
                        textAlign: TextAlign.left,
                        textDirection: textDirectionForUiLocale(context),
                        style: AppTypography.labelXSRegular.copyWith(
                          color: isDark ? AppColors.darkMutedText : AppColors.lightMutedText,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 24),
                //* Expanded(flex:2) for the dropdown field
                Expanded(
                  flex: 2,
                  child: _buildDropdownField(context, l10n, animDuration, isDark, displayValue),
                ),
              ],
      ),
    );
  }

  Widget _buildDropdownField(
    BuildContext context,
    AppLocalizations l10n,
    Duration animDuration,
    bool isDark,
    String displayValue,
  ) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: InkWell(
        onTap: () => _showDropdownMenu(context, l10n),
        borderRadius: BorderRadius.circular(10),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: AnimatedContainer(
            duration: animDuration,
            curve: Curves.easeInOut,
            //* Minimum 48px tap target for touch screen compatibility
            constraints: const BoxConstraints(minHeight: 48),
            decoration: BoxDecoration(
              color: _isHovered
                  ? (isDark ? AppColors.darkHoverSurface : AppColors.lightElevatedCard)
                  : (isDark ? AppColors.darkPanelCard : AppColors.lightSurfaceCard),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isDark ? AppColors.darkStrokeDivider : AppColors.lightStrokeDivider,
              ),
            ),
            child: Stack(
              children: [
                //* symbolLife texture — appears on hover, right-aligned behind content
                Positioned.fill(
                  child: AnimatedOpacity(
                    opacity: _isHovered ? 1.0 : 0.0,
                    duration: animDuration,
                    curve: Curves.easeInOut,
                    child: Align(
                      alignment: isArabic(context)
                          ? Alignment.centerLeft
                          : Alignment.centerRight,
                      child: ImageFiltered(
                        imageFilter: ImageFilter.blur(sigmaX: 0.8, sigmaY: 0.8),
                        child: SvgPicture.asset(
                          AppAssets.symbolLife,
                          height: 44,
                          colorFilter: ColorFilter.mode(
                            isDark
                                ? AppColors.darkMutedText.withValues(alpha: 0.20)
                                : AppColors.lightStrokeDivider.withValues(alpha: 0.70),
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                //* Content row
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          displayValue,
                          textAlign: isArabic(context) ? TextAlign.right : TextAlign.left,
                          textDirection: textDirectionForUiLocale(context),
                          style: AppTypography.bodySRegular.copyWith(
                            color: isDark ? AppColors.darkBodyText : AppColors.lightBodyText,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //* On tap: show dropdown menu with options
  Future<void> _showDropdownMenu(BuildContext context, AppLocalizations l10n) async {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    await showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppColors.darkElevatedCard : AppColors.lightSurfaceCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              //* Handle bar
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkStrokeDivider : AppColors.lightStrokeDivider,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              //* Label
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  widget.label,
                  textDirection: textDirectionForUiLocale(context),
                  style: AppTypography.headingXS.copyWith(
                    color: isDark ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                  ),
                ),
              ),
              const Divider(),
              //* Options list
              ...widget.options.map(
                (option) => ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                  title: Text(
                    _localizeDropdownDisplay(option, l10n),
                    textDirection: textDirectionForUiLocale(context),
                    style: AppTypography.bodySRegular.copyWith(
                      color: isDark ? AppColors.darkBodyText : AppColors.lightBodyText,
                    ),
                  ),
                  trailing: option == widget.value
                      ? SvgPicture.asset(
                          isDark ? AppAssets.darkIconChecked : AppAssets.lightIconChecked,
                          width: 18,
                          height: 18,
                        )
                      : null,
                  onTap: () {
                    widget.onChanged(option);
                    AppLogger.state('SETTINGS', '${widget.label} changed to $option');
                    Navigator.pop(context);
                  },
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}
