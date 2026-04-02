//? Shows the most recent AI decision with an Amazigh symbol top-right.
//? Card has a subtle background pattern at low opacity.
// TODO :: Wire to MQTT topic: tazrout/ai/latest-decision

//& Imports
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

//& AiLatestDecisionCard Widget
class AiLatestDecisionCard extends StatefulWidget {
  const AiLatestDecisionCard({super.key});

  @override
  State<AiLatestDecisionCard> createState() => _AiLatestDecisionCardState();
}

class _AiLatestDecisionCardState extends State<AiLatestDecisionCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final strokeDivider =
        isDark ? AppColors.darkStrokeDivider : AppColors.lightStrokeDivider;
    final panelColor =
        isDark ? AppColors.darkPanelCard : AppColors.lightSurfaceCard;

    // TODO :: Replace with MQTT topic: tazrout/ai/latest-decision
    final decisionText =
        'Initiated precision irrigation sequence for Zone A, B, and C. Soil moisture analysis indicated levels below critical threshold (< 30%).';

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
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    top: 0,
                    left: 0,
                    bottom: 0,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      width: _isHovered ? 5.0 : 3.5,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          bottomLeft: Radius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  //* Pattern — full-height right side
                  Positioned(
                    top: 0,
                    right: 0,
                    bottom: 0,
                    width: 72,
                    child: Transform.flip(
                      flipX: true,
                      child: Opacity(
                        opacity: 1.0,
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
                    padding: const EdgeInsets.fromLTRB(18, 14, 14, 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        //* Header
                        Row(
                          children: [
                            AnimatedScale(
                              scale: _isHovered ? 1.20 : 1.0,
                              duration: const Duration(milliseconds: 200),
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
                              'AI Latest Decision',
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
                            child: Text(
                              '"$decisionText"',
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
