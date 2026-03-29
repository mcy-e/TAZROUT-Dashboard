//? Center card showing system health status.
//? Background carries a subtle Amazigh pattern overlay at low opacity.
//? Icon is green check (healthy) or amber warning based on status.
// TODO :: Wire to MQTT topic: tazrout/dashboard/summary

//& Imports
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

//& WelcomeCard
class WelcomeCard extends StatelessWidget {
  //* Stack layout: background pattern + foreground content
  const WelcomeCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      color: isDark ? AppColors.darkPanelCard : AppColors.lightSurfaceCard,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isDark ? AppColors.darkStrokeDivider : AppColors.lightStrokeDivider,
        ),
      ),
      child: Stack(
        children: [
          //* WelcomeCard background pattern: Use AppAssets.patternCrossDiamondGrid at opacity 0.06
          //* The pattern runs horizontally across the card background
          Positioned.fill(
            child: Opacity(
              opacity: 0.06,
              child: SvgPicture.asset(
                AppAssets.patternCrossDiamondGrid,
                fit: BoxFit.cover,
              ),
            ),
          ),
          //* Foreground Column (centered)
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //* Green check circle icon (PhosphorIcons.checkCircle, size 32, color AppColors.primary)
                  Icon(
                    PhosphorIcons.checkCircle(PhosphorIconsStyle.fill),
                    size: 32,
                    color: AppColors.primary,
                  ),
                  const SizedBox(height: 12),
                  //* Welcome title
                  // TODO :: Wire to MQTT topic: tazrout/dashboard/summary
                  Text(
                    'Welcome Back!',
                    style: AppTypography.headingM.copyWith(
                      color: isDark ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                    ),
                  ),
                  const SizedBox(height: 8),
                  //* Status description text
                  // TODO :: Wire to MQTT topic: tazrout/dashboard/summary
                  Text(
                    'All agricultural systems are running within optimal parameters today.',
                    textAlign: TextAlign.center,
                    style: AppTypography.bodySRegular.copyWith(
                      color: isDark ? AppColors.darkMutedText : AppColors.lightBodyText,
                    ),
                  ),
                  //* Static status: healthy
                  // TODO :: Drive icon color and subtitle from MQTT summary
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
