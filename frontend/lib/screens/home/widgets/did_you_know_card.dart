//? Rotating agricultural fact card.
//? Light bulb icon top-right. Label "DID YOU KNOW?" in overline style.
//? Highlighted percentage value in AppColors.primary bold.
// TODO :: Wire fact to MQTT topic: tazrout/dashboard/summary

//& Imports
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

//& DidYouKnowCard
class DidYouKnowCard extends StatelessWidget {
  //* Stack: lightbulb icon (PhosphorIcons.lightbulb) top-right, size 28, color AppColors.primary
  const DidYouKnowCard({super.key});

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
      child: Stack(
        children: [
          //* lightbulb icon top-right, size 28, color AppColors.primary
          Positioned(
            top: 12,
            right: 12,
            child: Icon(
              PhosphorIcons.lightbulb(PhosphorIconsStyle.fill),
              size: 28,
              color: AppColors.primary,
            ),
          ),
          //* Content Column
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //* Text "DID YOU KNOW?" using AppTypography.overlineS, color AppColors.primary, uppercase at widget level
                Text(
                  'DID YOU KNOW?',
                  style: AppTypography.overlineS.copyWith(
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 12),
                //* Static fact string with "50%" wrapped in a bold Text span using AppTypography.bodyMBold + AppColors.primary for the percentage, AppTypography.bodySRegular for the rest
                // TODO :: Wire to MQTT topic: tazrout/dashboard/summary
                RichText(
                  text: TextSpan(
                    style: AppTypography.bodySRegular.copyWith(
                      color: isDark ? AppColors.darkBodyText : AppColors.lightBodyText,
                      height: 1.5,
                    ),
                    children: [
                      const TextSpan(text: 'Precision irrigation can reduce water usage by up to '),
                      TextSpan(
                        text: '50%',
                        style: AppTypography.bodyMBold.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                      const TextSpan(text: ' while improving crop yields.'),
                    ],
                  ),
                ),
                //* No pattern background needed — card is clean
                //* Only the lightbulb icon top-right remains
              ],
            ),
          ),
        ],
      ),
    );
  }
}
