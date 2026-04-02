//? Small card showing AI recommendation text.
//? Wrench or lightbulb icon top-left.
// TODO :: Wire to MQTT topic: tazrout/ai/latest-decision (farmerAdvice)

//& Imports
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

//& RecommendationCard Widget
class RecommendationCard extends StatefulWidget {
  //* StatefulWidget — displays AI recommendation details
  const RecommendationCard({super.key});

  @override
  State<RecommendationCard> createState() => _RecommendationCardState();
}

//& _RecommendationCardState
class _RecommendationCardState extends State<RecommendationCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final borderColor = _isHovered
        ? AppColors.primary.withValues(alpha: 0.60)
        : (isDark ? AppColors.darkStrokeDivider : AppColors.lightStrokeDivider);

    final patternTint = ColorFilter.mode(
      AppColors.primary.withValues(alpha: 0.35),
      BlendMode.srcIn,
    );

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkPanelCard : AppColors.lightSurfaceCard,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: borderColor,
            width: _isHovered ? 1.5 : 1.0,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              //* Pattern — TOP horizontal strip
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    child: ImageFiltered(
                      imageFilter: _isHovered
                          ? ImageFilter.blur(sigmaX: 3, sigmaY: 3)
                          : ImageFilter.blur(sigmaX: 0, sigmaY: 0),
                      child: Opacity(
                        opacity: 0.50,
                        child: SvgPicture.asset(
                          AppAssets.patternArrowChevron,
                          height: 20,
                          fit: BoxFit.fitWidth,
                          colorFilter: patternTint,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              //* Content
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 28, 12, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    //* Header row — constrained width
                    Row(
                      children: [
                        AnimatedScale(
                          scale: _isHovered ? 1.20 : 1.0,
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeInOut,
                          child: SvgPicture.asset(
                            isDark
                                ? AppAssets.darkIconRecommendation
                                : AppAssets.lightIconRecommendation,
                            width: 18,
                            height: 18,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            'Recommendation',
                            style: AppTypography.headingXS.copyWith(
                              color: isDark
                                  ? AppColors.darkPrimaryText
                                  : AppColors.lightPrimaryText,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    //* Inner box — let it shrink, never overflow
                    Flexible(
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isDark
                                ? AppColors.darkStrokeDivider
                                : AppColors.lightStrokeDivider,
                          ),
                        ),
                        child: Text(
                          'Inspect irrigation valves in Zone D manually for blockage.',
                          style: AppTypography.bodySRegular.copyWith(
                            color: isDark
                                ? AppColors.darkBodyText
                                : AppColors.lightBodyText,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                          textAlign: TextAlign.center,
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
    );
  }
}
