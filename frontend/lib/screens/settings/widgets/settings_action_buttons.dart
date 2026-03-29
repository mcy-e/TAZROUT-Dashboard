//? Reset Default and Apply Settings buttons.
//? Reset Default: outlined button, reverts all local state to defaults.
//? Apply Settings: filled green button, saves preferences.
//? Both use hover states and confirmation where appropriate.
// TODO :: Apply Settings triggers PUT /api/v1/user/preferences

//& Imports
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/app_logger.dart';

//& SettingsActionButtons Widget
class SettingsActionButtons extends StatelessWidget {
  final VoidCallback onReset;
  final VoidCallback onApply;

  //* SettingsActionButtons Parameters
  const SettingsActionButtons({
    super.key,
    required this.onReset,
    required this.onApply,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        //* Reset Default Button
        OutlinedButton(
          onPressed: () {
            AppLogger.info('SETTINGS', 'Reset to defaults');
            onReset();
          },
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(120, 44),
            side: const BorderSide(color: AppColors.darkStrokeDivider),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ).copyWith(
            side: WidgetStateProperty.resolveWith<BorderSide>((states) {
              if (states.contains(WidgetState.hovered)) {
                return const BorderSide(color: AppColors.primary);
              }
              return const BorderSide(color: AppColors.darkStrokeDivider);
            }),
          ),
          child: Text(
            'Reset Default',
            style: AppTypography.bodySMedium.copyWith(
              color: Theme.of(context).brightness == Brightness.dark
                  ? AppColors.darkPrimaryText
                  : AppColors.lightPrimaryText,
            ),
          ),
        ),
        const SizedBox(width: 16),
        //* Apply Settings Button
        ElevatedButton(
          onPressed: () {
            AppLogger.info('SETTINGS', 'Settings applied');
            onApply();
          },
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(140, 44),
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            elevation: 0,
          ).copyWith(
            backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
              if (states.contains(WidgetState.hovered)) {
                return AppColors.primaryDark;
              }
              return AppColors.primary;
            }),
          ),
          child: Text(
            'Apply Settings',
            style: AppTypography.bodySBold,
          ),
        ),
      ],
    );
  }
}
