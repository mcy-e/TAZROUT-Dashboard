//? Single FAQ issue card with icon, title, and description.
//? Has default and hover states.
//? Hover: background brightens slightly, border shows.
//? Each card has a unique phosphor icon and title.
//? Background carries subtle Amazigh pattern

//& Imports
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/utils/locale_text_direction.dart';
import '../../../../core/localization/l10n/app_localizations.dart';
import '../../../../providers/preferences_provider.dart';

//& FaqCard Widget
class FaqCard extends ConsumerStatefulWidget {
  final String iconAsset;
  final Color iconColor;
  final String title;
  final String description;
  final String detailedText;

  //* FaqCard Parameters
  const FaqCard({
    super.key,
    required this.iconAsset,
    required this.iconColor,
    required this.title,
    required this.description,
    required this.detailedText,
  });

  @override
  ConsumerState<FaqCard> createState() => _FaqCardState();
}

class _FaqCardState extends ConsumerState<FaqCard> {
  bool _isHovered = false;

  void _showDetailsDialog() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? AppColors.darkElevatedCard : AppColors.lightSurfaceCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: widget.iconColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: SvgPicture.asset(
                  widget.iconAsset,
                  width: 20,
                  height: 20,
                  colorFilter: ColorFilter.mode(widget.iconColor, BlendMode.srcIn),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                widget.title,
                style: AppTypography.headingS.copyWith(
                  color: isDark ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                ),
              ),
            ),
          ],
        ),
        content: Text(
          widget.detailedText,
          style: AppTypography.bodySRegular.copyWith(
            color: isDark ? AppColors.darkMutedText : AppColors.lightMutedText,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              l10n.ok,
              style: AppTypography.bodySMedium.copyWith(color: AppColors.primary),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final animDuration = ref.watch(preferencesProvider).animDuration;

    //* MouseRegion + InkWell dual input
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: InkWell(
        onTap: _showDetailsDialog,
        borderRadius: BorderRadius.circular(12),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              //* 1 Card background
              Positioned.fill(
                child: AnimatedContainer(
                  duration: animDuration,
                  decoration: BoxDecoration(
                    color: _isHovered
                        ? (isDark ? AppColors.darkHoverSurface : AppColors.lightElevatedCard)
                        : (isDark ? AppColors.darkPanelCard : AppColors.lightSurfaceCard),
                    border: Border.all(
                      color: _isHovered ? AppColors.primary : (isDark ? AppColors.darkStrokeDivider : AppColors.lightStrokeDivider),
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              //* 2 Top pattern strip (BEHIND content)
              Positioned(
                top: 0, left: 0, right: 0,
                child: ClipRect(
                  child: AnimatedOpacity(
                    opacity: _isHovered ? 0.0 : 1.0,
                    duration: animDuration,
                    curve: Curves.easeInOut,
                    child: Transform.rotate(
                      angle: 0,
                      child: SvgPicture.asset(
                        AppAssets.patternTriangleWave,
                        height: 24,
                        fit: BoxFit.fitWidth,
                        colorFilter: ColorFilter.mode(
                          isDark
                              ? AppColors.darkMutedText.withValues(alpha: 0.08)
                              : AppColors.lightStrokeDivider.withValues(alpha: 0.35),
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              //* 3 Bottom pattern strip (BEHIND content)
              Positioned(
                bottom: 0, left: 0, right: 0,
                child: ClipRect(
                  child: AnimatedOpacity(
                    opacity: _isHovered ? 0.0 : 1.0,
                    duration: animDuration,
                    curve: Curves.easeInOut,
                    child: Transform.rotate(
                      angle: 0,
                      child: SvgPicture.asset(
                        AppAssets.patternTriangleWave,
                        height: 24,
                        fit: BoxFit.fitWidth,
                        colorFilter: ColorFilter.mode(
                          isDark
                              ? AppColors.darkMutedText.withValues(alpha: 0.08)
                              : AppColors.lightStrokeDivider.withValues(alpha: 0.35),
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              //* 4 Content (ALWAYS ON TOP — last child)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 32, 16, 32),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //* Icon box — same row as title
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: widget.iconColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          widget.iconAsset,
                          width: 20,
                          height: 20,
                          colorFilter: ColorFilter.mode(widget.iconColor, BlendMode.srcIn),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            widget.title,
                            textDirection: textDirectionForUiLocale(context),
                            style: AppTypography.bodySMedium.copyWith(
                              color: isDark ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.description,
                            textDirection: textDirectionForUiLocale(context),
                            style: AppTypography.bodySRegular.copyWith(
                              color: isDark ? AppColors.darkMutedText : AppColors.lightMutedText,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
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
