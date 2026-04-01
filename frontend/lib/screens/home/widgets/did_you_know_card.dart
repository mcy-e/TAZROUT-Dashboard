//? Rotating agricultural fact card.
//? Light bulb icon top-right. Label "DID YOU KNOW?" in overline style.
//? Highlighted percentage value in AppColors.primary bold.
// TODO :: Wire fact to MQTT topic: tazrout/dashboard/summary

//& Imports
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

//& DidYouKnowCard
class DidYouKnowCard extends StatefulWidget {
  const DidYouKnowCard({super.key});

  @override
  State<DidYouKnowCard> createState() => _DidYouKnowCardState();
}

class _DidYouKnowCardState extends State<DidYouKnowCard> {
  bool _isHovered = false;

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
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [

            //* Background symbol — bottom center, fades in on hover
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                opacity: _isHovered ? 1.0 : 0.0,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: SvgPicture.asset(
                      AppAssets.symbolUnity,
                      height: 55,
                      colorFilter: ColorFilter.mode(
                        AppColors.primary.withValues(alpha: 0.12),
                        BlendMode.srcIn,
                      ),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
            //* Lightbulb icon — top right, clipped
            Positioned(
              top: -8,
              right: -8,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: _isHovered
                      ? AppColors.primary.withValues(alpha: 0.12)
                      : AppColors.primary.withValues(alpha: 0.07),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 4, right: 4),
                    child: SvgPicture.asset(
                      isDark
                          ? AppAssets.darkIconFactLamp
                          : AppAssets.lightIconFactLamp,
                      height: 18,
                    ),
                  ),
                ),
              ),
            ),
            //* Foreground content — full card, stays on top
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  //* Header row: fertility sparkle on hover + label + lightbulb with circular bg
                  Row(
                    children: [
                      //* Fertility symbol — amber, always visible
                      Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: SvgPicture.asset(
                          isDark
                              ? AppAssets.darkIconFactStar
                              : AppAssets.lightIconFactStar,
                          height: 16,
                          colorFilter: const ColorFilter.mode(
                            AppColors.series3Amber,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                      Text(
                        'DID YOU KNOW?',
                        style: AppTypography.overlineS.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  //* Fact text with quoted wrapper and bold percentage
                  // TODO :: Wire to MQTT topic: tazrout/dashboard/summary
                  RichText(
                    text: TextSpan(
                      style: AppTypography.bodySRegular.copyWith(
                        color: isDark ? AppColors.darkBodyText : AppColors.lightBodyText,
                        height: 1.5,
                      ),
                      children: [
                        const TextSpan(text: '“Precision irrigation can reduce water usage by up to '),
                        TextSpan(
                          text: '50%',
                          style: AppTypography.bodyMBold.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                        const TextSpan(text: ' while improving crop yields.”'),
                      ],
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
