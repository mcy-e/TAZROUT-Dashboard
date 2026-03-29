//? Small card showing AI observation text.
//? Checkmark or info icon top-left.
// TODO :: Wire to MQTT topic: tazrout/ai/latest-decision (notes field)

//& Imports
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

//& ObservationCard Widget
class ObservationCard extends StatelessWidget {
  //* StatelessWidget — displays AI observation details
  const ObservationCard({super.key});

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
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //* Header
            Row(
              children: [
                Icon(
                  PhosphorIcons.notepad(),
                  size: 16,
                  color: isDark ? AppColors.darkMutedText : AppColors.lightMutedText,
                ),
                const SizedBox(width: 8),
                Text(
                  'Observation',
                  style: AppTypography.headingXS.copyWith(
                    fontSize: 14,
                    color: isDark ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            //* Observation Text
            // TODO :: Replace with real MQTT data from topic: tazrout/ai/latest-decision
            Text(
              'Detected high temperature variance in Zone D sensor array.',
              style: AppTypography.bodySRegular.copyWith(
                color: isDark ? AppColors.darkMutedText : AppColors.lightBodyText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
