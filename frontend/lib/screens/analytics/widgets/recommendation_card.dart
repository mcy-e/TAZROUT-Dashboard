//? Small card showing AI recommendation text.
//? Wrench or lightbulb icon top-left.
// TODO :: Wire to MQTT topic: tazrout/ai/latest-decision (farmerAdvice)

//& Imports
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

//& RecommendationCard Widget
class RecommendationCard extends StatelessWidget {
  //* StatelessWidget — displays AI recommendation details
  const RecommendationCard({super.key});

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
                  PhosphorIcons.wrench(),
                  size: 16,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Recommendation',
                  style: AppTypography.headingXS.copyWith(
                    fontSize: 14,
                    color: isDark ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            //* Recommendation Text
            // TODO :: Replace with real MQTT data from topic: tazrout/ai/latest-decision
            Text(
              'Inspect irrigation valves in Zone D manually for blockage.',
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
