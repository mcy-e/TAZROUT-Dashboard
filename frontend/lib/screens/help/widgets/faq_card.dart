//? Single FAQ issue card with icon, title, and description.
//? Has default and hover states.
//? Hover: background brightens slightly, border shows.
//? Each card has a unique phosphor icon and title.
//? Background carries subtle Amazigh pattern

//& Imports
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/locale_text_direction.dart';

//& FaqCard Widget
class FaqCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String description;

  //* FaqCard Parameters
  const FaqCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  State<FaqCard> createState() => _FaqCardState();
}

class _FaqCardState extends State<FaqCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    //* MouseRegion + InkWell dual input
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: InkWell(
        onTap: () {}, //* FAQ cards are informational for now
        borderRadius: BorderRadius.circular(8),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.all(16),
          //* Minimum 48px tap target for touch screen compatibility
          constraints: const BoxConstraints(minHeight: 100),
          decoration: BoxDecoration(
            //* Default bg: AppColors.darkPanelCard (dark) / AppColors.lightSurfaceCard (light)
            //* Hover bg:   AppColors.darkHoverSurface (dark) / AppColors.lightElevatedCard (light)
            color: _isHovered
                ? (isDark ? AppColors.darkHoverSurface : AppColors.lightElevatedCard)
                : (isDark ? AppColors.darkPanelCard : AppColors.lightSurfaceCard),
            //* border: 1px AppColors.darkStrokeDivider default, 1px AppColors.primary on hover
            border: Border.all(
              color: _isHovered ? AppColors.primary : AppColors.darkStrokeDivider,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //* Container 36x36 borderRadius 8px
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  //* bg: AppColors.darkElevatedCard (dark) / AppColors.lightElevatedCard (light)
                  color: isDark ? AppColors.darkElevatedCard : AppColors.lightElevatedCard,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  widget.icon,
                  size: 18,
                  color: AppColors.darkMutedText,
                ),
              ),
              const SizedBox(width: 12),
              //* Expanded Column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    //* Text(title) AppTypography.bodySBold
                    Text(
                      widget.title,
                      textDirection: textDirectionForUiLocale(context),
                      style: AppTypography.bodySBold.copyWith(
                        color: isDark ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                      ),
                    ),
                    const SizedBox(height: 4),
                    //* Text(description) AppTypography.bodySRegular muted
                    Text(
                      widget.description,
                      textDirection: textDirectionForUiLocale(context),
                      style: AppTypography.bodySRegular.copyWith(
                        color: isDark ? AppColors.darkMutedText : AppColors.lightMutedText,
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
