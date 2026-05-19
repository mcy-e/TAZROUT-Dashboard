//? Small card showing AI recommendation text.
//? Wrench or lightbulb icon top-left.
//? Wired to MQTT topic: tazrout/ai/latest-decision (farmerAdvice)

//& Imports
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/localization/l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import 'package:tazrout_dashboard/core/utils/locale_text_direction.dart';
import '../../../../providers/preferences_provider.dart';
import '../../../../providers/ai_decision_provider.dart';

//& RecommendationCard Widget
class RecommendationCard extends ConsumerStatefulWidget {
  //* StatefulWidget — displays AI recommendation details
  const RecommendationCard({super.key});

  @override
  ConsumerState<RecommendationCard> createState() => _RecommendationCardState();
}

//& _RecommendationCardState
class _RecommendationCardState extends ConsumerState<RecommendationCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    final animDuration = ref.watch(preferencesProvider).animDuration;

    // DATA from MQTT/API
    final decisionState = ref.watch(aiDecisionProvider);
    final recommendationText = decisionState.latest?.farmerAdvice ?? '';

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
        duration: animDuration,
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkPanelCard : AppColors.lightSurfaceCard,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: borderColor,
            width: _isHovered ? 1.5 : 1.0,
          ),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                backgroundColor: isDark ? AppColors.darkPanelCard : AppColors.lightSurfaceCard,
                title: Row(
                  children: [
                    SvgPicture.asset(
                      isDark ? AppAssets.darkIconRecommendation : AppAssets.lightIconRecommendation,
                      width: 24, height: 24,
                    ),
                    const SizedBox(width: 12),
                    Text(l10n.recommendationTitle, style: AppTypography.headingS),
                  ],
                ),
                content: Text(
                  recommendationText,
                  style: AppTypography.bodyMBold,
                  textDirection: textDirectionForUiLocale(context),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: Text(l10n.closeTooltip, style: TextStyle(color: AppColors.primary)),
                  ),
                ],
              ),
            );
          },
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
                    duration: animDuration,
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
                  crossAxisAlignment: isArabic(context)
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    //* Header row — constrained width
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: isArabic(context)
                          ? [
                              Flexible(
                                child: Text(
                                  l10n.recommendationTitle,
                                  textAlign: TextAlign.right,
                                  textDirection: textDirectionForUiLocale(context),
                                  style: AppTypography.headingXS.copyWith(
                                    color: isDark
                                        ? AppColors.darkPrimaryText
                                        : AppColors.lightPrimaryText,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                              const SizedBox(width: 8),
                              AnimatedScale(
                                scale: _isHovered ? 1.20 : 1.0,
                                duration: animDuration,
                                curve: Curves.easeInOut,
                                child: SvgPicture.asset(
                                  isDark
                                      ? AppAssets.darkIconRecommendation
                                      : AppAssets.lightIconRecommendation,
                                  width: 18,
                                  height: 18,
                                ),
                              ),
                            ]
                          : [
                              AnimatedScale(
                                scale: _isHovered ? 1.20 : 1.0,
                                duration: animDuration,
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
                                  l10n.recommendationTitle,
                                  textAlign: TextAlign.left,
                                  textDirection: textDirectionForUiLocale(context),
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
                          recommendationText,
                          textDirection: textDirectionForUiLocale(context),
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
      ),
    );
  }
}
