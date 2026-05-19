//? Shows the most recent AI decision with an Amazigh symbol top-right.
//? Card has a subtle background pattern at low opacity.
//? Wired to MQTT topic: tazrout/ai/latest-decision via aiDecisionProvider.

//& Imports
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
import '../../../../widgets/common/empty_state_widget.dart';

//& AiLatestDecisionCard Widget
class AiLatestDecisionCard extends ConsumerStatefulWidget {
  const AiLatestDecisionCard({super.key});

  @override
  ConsumerState<AiLatestDecisionCard> createState() => _AiLatestDecisionCardState();
}

class _AiLatestDecisionCardState extends ConsumerState<AiLatestDecisionCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    final animDuration = ref.watch(preferencesProvider).animDuration;
    final strokeDivider =
        isDark ? AppColors.darkStrokeDivider : AppColors.lightStrokeDivider;
    final panelColor =
        isDark ? AppColors.darkPanelCard : AppColors.lightSurfaceCard;

    // DATA from MQTT/API
    final decisionState = ref.watch(aiDecisionProvider);
    final decisionText = decisionState.latest?.description ?? '';

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: (isDark ? AppColors.darkBodyText : AppColors.lightBodyText)
                  .withValues(alpha: isDark ? 0.3 : 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {},
              child: Stack(
                children: [
                  //* Card background (uniform border avoids Flutter paint crash)
                  Container(
                    decoration: BoxDecoration(
                      color: panelColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: strokeDivider),
                    ),
                  ),
                  //* Left accent bar — separate widget, no border conflict
                  AnimatedPositioned(
                    duration: animDuration,
                    curve: Curves.easeInOut,
                    top: 0,
                    left: isArabic(context) ? null : 0,
                    right: isArabic(context) ? 0 : null,
                    bottom: 0,
                    child: AnimatedContainer(
                      duration: animDuration,
                      curve: Curves.easeInOut,
                      width: _isHovered ? 5.0 : 3.5,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.only(
                          topLeft: isArabic(context) ? Radius.zero : const Radius.circular(12),
                          bottomLeft: isArabic(context) ? Radius.zero : const Radius.circular(12),
                          topRight: isArabic(context) ? const Radius.circular(12) : Radius.zero,
                          bottomRight: isArabic(context) ? const Radius.circular(12) : Radius.zero,
                        ),
                      ),
                    ),
                  ),
                  //* Top pattern
                  Positioned(
                    top: 0,
                    left: isArabic(context) ? 0 : null,
                    right: isArabic(context) ? null : 0,
                    width: 64,
                    height: 64,
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: isArabic(context) ? const Radius.circular(12) : Radius.zero,
                        topRight: isArabic(context) ? Radius.zero : const Radius.circular(12),
                      ),
                      child: Transform.flip(
                        flipX: isArabic(context),
                        child: SvgPicture.asset(
                          AppAssets.patternCircleMedallion,
                          fit: BoxFit.cover,
                          colorFilter: const ColorFilter.mode(
                            AppColors.primary,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                  ),
                  //* Bottom pattern
                  Positioned(
                    bottom: 0,
                    left: isArabic(context) ? 0 : null,
                    right: isArabic(context) ? null : 0,
                    width: 64,
                    height: 64,
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        bottomLeft: isArabic(context) ? const Radius.circular(12) : Radius.zero,
                        bottomRight: isArabic(context) ? Radius.zero : const Radius.circular(12),
                      ),
                      child: Transform.flip(
                        flipX: isArabic(context),
                        child: SvgPicture.asset(
                          AppAssets.patternCircleMedallion,
                          fit: BoxFit.cover,
                          colorFilter: const ColorFilter.mode(
                            AppColors.primary,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                  ),
                  //* Main content
                  Padding(
                    padding: EdgeInsets.only(
                      left: isArabic(context) ? 14 : 18,
                      right: isArabic(context) ? 18 : 14,
                      top: 14,
                      bottom: 14,
                    ),
                    child: Column(
                      crossAxisAlignment: isArabic(context)
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        //* Header
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: isArabic(context)
                              ? [
                                  Text(
                                    l10n.aiLatestDecisionTitle,
                                    textAlign: TextAlign.right,
                                    textDirection: textDirectionForUiLocale(context),
                                    style: AppTypography.headingXS.copyWith(
                                      color: isDark
                                          ? AppColors.darkPrimaryText
                                          : AppColors.lightPrimaryText,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  AnimatedScale(
                                    scale: _isHovered ? 1.20 : 1.0,
                                    duration: animDuration,
                                    curve: Curves.easeInOut,
                                    child: SvgPicture.asset(
                                      isDark
                                          ? AppAssets.darkIconAiDecision
                                          : AppAssets.lightIconAiDecision,
                                      width: 20,
                                      height: 20,
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
                                          ? AppAssets.darkIconAiDecision
                                          : AppAssets.lightIconAiDecision,
                                      width: 20,
                                      height: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    l10n.aiLatestDecisionTitle,
                                    textAlign: TextAlign.left,
                                    textDirection: textDirectionForUiLocale(context),
                                    style: AppTypography.headingXS.copyWith(
                                      color: isDark
                                          ? AppColors.darkPrimaryText
                                          : AppColors.lightPrimaryText,
                                    ),
                                  ),
                                ],
                        ),
                        const SizedBox(height: 12),
                        //* Decision text in elevated inner box
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? AppColors.darkBase
                                  : AppColors.lightElevatedCard,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: isDark
                                    ? AppColors.darkStrokeDivider
                                    : AppColors.lightStrokeDivider,
                              ),
                            ),
                            child: decisionText.isEmpty
                                ? EmptyStateWidget(message: l10n.emptyStateNoData)
                                : Text(
                                    '"$decisionText"',
                                    textDirection: textDirectionForUiLocale(context),
                                    style: AppTypography.bodySRegular.copyWith(
                                      color: isDark
                                          ? AppColors.darkBodyText
                                          : AppColors.lightBodyText,
                                      fontStyle: FontStyle.italic,
                                    ),
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
      ),
    );
  }
}
