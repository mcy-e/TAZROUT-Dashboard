//? Reusable settings row with a label, subtitle, and dropdown field.
//? Used for Language, Theme, Font Size, Date Format, Time Format.
//? Dropdown field: full-width rounded container showing current value.
//? Hover: border color → AppColors.focusedBorder, shows arrow icon.

//& Imports
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/app_logger.dart';

//& SettingsDropdownRow Widget
class SettingsDropdownRow extends StatefulWidget {
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
  State<SettingsDropdownRow> createState() => _SettingsDropdownRowState();
}

class _SettingsDropdownRowState extends State<SettingsDropdownRow> {
  bool _isHovered = false;

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
                  style: AppTypography.bodySBold.copyWith(
                    color: isDark ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                  ),
                ),
                //* Text(subtitle) AppTypography.labelXSRegular muted
                Text(
                  widget.subtitle,
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
            child: MouseRegion(
              onEnter: (_) => setState(() => _isHovered = true),
              onExit: (_) => setState(() => _isHovered = false),
              child: InkWell(
                onTap: () => _showDropdownMenu(context),
                borderRadius: BorderRadius.circular(8),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  //* Minimum 48px tap target for touch screen compatibility
                  constraints: const BoxConstraints(minHeight: 48),
                  decoration: BoxDecoration(
                    //* bg: AppColors.darkPanelCard (dark) / AppColors.lightSurfaceCard (light)
                    color: isDark ? AppColors.darkPanelCard : AppColors.lightSurfaceCard,
                    borderRadius: BorderRadius.circular(8),
                    //* border: 1px AppColors.defaultBorder default, 1px AppColors.primary on hover
                    border: Border.all(
                      color: _isHovered ? AppColors.primary : AppColors.defaultBorder,
                    ),
                  ),
                  child: Row(
                    children: [
                      //* Expanded: Text(value) AppTypography.bodySMedium
                      Expanded(
                        child: Text(
                          widget.value,
                          style: AppTypography.bodySMedium.copyWith(
                            color: isDark ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                          ),
                        ),
                      ),
                      //* Icon(PhosphorIcons.caretDown, size:16, muted)
                      Icon(
                        PhosphorIcons.caretDown(),
                        size: 16,
                        color: isDark ? AppColors.darkMutedText : AppColors.lightMutedText,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  //* On tap: show dropdown menu with options
  void _showDropdownMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? AppColors.darkPanelCard
          : AppColors.lightSurfaceCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: widget.options.map((option) {
              return ListTile(
                title: Text(
                  option,
                  style: AppTypography.bodySMedium.copyWith(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? AppColors.darkPrimaryText
                        : AppColors.lightPrimaryText,
                  ),
                ),
                onTap: () {
                  widget.onChanged(option);
                  //* AppLogger.state('SETTINGS', '$label changed to $value')
                  AppLogger.state('SETTINGS', '${widget.label} changed to $option');
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
