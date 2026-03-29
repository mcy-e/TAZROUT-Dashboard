//? Shows the most recent AI decision with an Amazigh symbol top-right.
//? Card has a subtle background pattern at low opacity.
// TODO :: Wire to MQTT topic: tazrout/ai/latest-decision

//& Imports
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

//& AiLatestDecisionCard Widget
class AiLatestDecisionCard extends StatelessWidget {
  //* StatelessWidget — displays latest AI decision with symbol background
  const AiLatestDecisionCard({super.key});

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
          //* Background: SvgPicture.asset(AppAssets.symbolWisdom)
          //* positioned top-right, height 64, opacity 0.08
          Positioned(
            top: 16,
            right: 16,
            child: Opacity(
              opacity: 0.08,
              child: SvgPicture.asset(
                AppAssets.symbolWisdom,
                height: 64,
                colorFilter: ColorFilter.mode(
                  isDark ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
          //* Foreground Column
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //* Header Row
                Row(
                  children: [
                    Icon(
                      PhosphorIcons.robot(),
                      size: 18,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'AI Latest Decision',
                      style: AppTypography.headingXS.copyWith(
                        color: isDark ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                //* Description text with bold zone names
                // TODO :: Replace with real MQTT data from topic: tazrout/ai/latest-decision
                Center(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: AppTypography.bodySRegular.copyWith(
                        color: isDark ? AppColors.darkBodyText : AppColors.lightBodyText,
                        fontStyle: FontStyle.italic,
                        height: 1.5,
                      ),
                      children: [
                        const TextSpan(text: 'Initiated precision irrigation sequence for '),
                        TextSpan(
                          text: 'Zone A, B, and C',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isDark ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                          ),
                        ),
                        const TextSpan(text: '. Soil moisture analysis indicated levels below critical threshold (< 30%).'),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
