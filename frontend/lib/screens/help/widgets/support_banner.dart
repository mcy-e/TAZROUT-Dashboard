//? Full-width dark support banner with CTA button.
//? Dark green background (AppColors.darkSidebar both themes).
//? Amazigh symbol decorations on corners.
//? Has a large muted lifesaver/lifebuoy icon on the right side.
//? Get Support button triggers QrContactCard dialog.

//& Imports
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/localization/l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/utils/app_logger.dart';
import '../../../../core/utils/locale_text_direction.dart';


//& SupportBanner Widget
class SupportBanner extends ConsumerStatefulWidget {
  final VoidCallback onGetSupport;

  //* SupportBanner Parameters
  const SupportBanner({
    super.key,
    required this.onGetSupport,
  });

  @override
  ConsumerState<SupportBanner> createState() => _SupportBannerState();
}

class _SupportBannerState extends ConsumerState<SupportBanner> {
  bool _isButtonHovered = false;
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSidebar : AppColors.darkElevatedCard,
        borderRadius: BorderRadius.circular(12),
      ),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: Stack(
        children: [
          //* TOP-LEFT: star dotted
          Positioned(
            top: 16, left: 20,
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: _isHovered ? 0.25 : 0.0),
              duration: const Duration(milliseconds: 350),
              curve: Curves.easeInOut,
              builder: (context, angle, child) => Transform.rotate(
                angle: angle,
                child: child,
              ),
              child: AnimatedScale(
                scale: _isHovered ? 1.20 : 1.0,
                duration: const Duration(milliseconds: 350),
                curve: Curves.easeInOut,
                child: AnimatedOpacity(
                  opacity: _isHovered ? 1.0 : 0.45,
                  duration: const Duration(milliseconds: 350),
                  child: SvgPicture.asset(
                    AppAssets.berberIconStarDotted,
                    width: 48, height: 48,
                  ),
                ),
              ),
            ),
          ),
          //* BOTTOM-LEFT: diamond outline
          Positioned(
            bottom: 16, left: 20,
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: _isHovered ? -0.25 : 0.0),
              duration: const Duration(milliseconds: 350),
              curve: Curves.easeInOut,
              builder: (context, angle, child) => Transform.rotate(
                angle: angle,
                child: child,
              ),
              child: AnimatedScale(
                scale: _isHovered ? 1.20 : 1.0,
                duration: const Duration(milliseconds: 350),
                curve: Curves.easeInOut,
                child: AnimatedOpacity(
                  opacity: _isHovered ? 1.0 : 0.45,
                  duration: const Duration(milliseconds: 350),
                  child: SvgPicture.asset(
                    AppAssets.berberIconDiamondOutline,
                    width: 48, height: 48,
                  ),
                ),
              ),
            ),
          ),
          //* Background right-side icon
          Positioned(
            right: 16,
            top: 0,
            bottom: 0,
            child: Center(
              child: Opacity(
                opacity: 0.15,
                child: SvgPicture.asset(
                  AppAssets.lightIconAssistanceBg,
                  width: 100,
                  height: 100,
                ),
              ),
            ),
          ),
          //* Foreground content — centered in stack
          Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    l10n.supportStillNeedTitle,
                    textDirection: textDirectionForUiLocale(context),
                    style: AppTypography.headingS.copyWith(color: AppColors.lightSurfaceCard),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.supportTeamAvailable,
                    textAlign: TextAlign.center,
                    textDirection: textDirectionForUiLocale(context),
                    style: AppTypography.bodySRegular.copyWith(
                      color: AppColors.lightSurfaceCard.withValues(alpha: 0.7),
                    ),
                  ),
                  const SizedBox(height: 16),
                  MouseRegion(
                    onEnter: (_) => setState(() => _isButtonHovered = true),
                    onExit: (_) => setState(() => _isButtonHovered = false),
                    child: InkWell(
                      onTap: () {
                        AppLogger.info('HELP', 'Get Support button tapped');
                        widget.onGetSupport();
                      },
                      borderRadius: BorderRadius.circular(24),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeInOut,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        decoration: BoxDecoration(
                          color: _isButtonHovered
                              ? AppColors.primary.withValues(alpha: 0.15)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              l10n.supportGetSupport,
                              textDirection: textDirectionForUiLocale(context),
                              style: AppTypography.bodySRegular.copyWith(
                                color: _isButtonHovered ? Colors.white : AppColors.darkBase,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 8),
                            AnimatedSlide(
                              offset: _isButtonHovered ? const Offset(0.35, 0) : Offset.zero,
                              duration: const Duration(milliseconds: 200),
                              curve: Curves.easeInOut,
                              child: SvgPicture.asset(
                                AppAssets.darkIconArrowRight,
                                width: 14, height: 14,
                                colorFilter: ColorFilter.mode(
                                  _isButtonHovered ? Colors.white : AppColors.darkBase,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      ),
    );
  }
}
