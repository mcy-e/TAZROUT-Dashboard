//? Document viewer card with macOS window chrome at top.
//? Shows placeholder state when no document is loaded.
//? Placeholder: book icon + title + description centered.
//? Footer inside card: last updated + version metadata.
// TODO :: Wire to local assets — load PDF from docs/user-manuals/
// TODO :: Replace placeholder with flutter_pdfview when PDF is ready

//& Imports
import 'package:flutter/material.dart';
import '../../../../core/localization/l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/locale_text_direction.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/constants/app_assets.dart';
import 'mac_window_chrome.dart';

//& DocumentViewerCard Widget
class DocumentViewerCard extends StatelessWidget {
  //* Card borderRadius 12px, no padding on outer card
  const DocumentViewerCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return Card(
      margin: EdgeInsets.zero,
      color: isDark ? AppColors.darkPanelCard : AppColors.lightSurfaceCard,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isDark ? AppColors.darkStrokeDivider : AppColors.lightStrokeDivider,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          MacWindowChrome(fileName: l10n.manualPdfFileName),
          Expanded(
            child: _EmptyStatePlaceholder(),
          ),
          Divider(
            color: isDark ? AppColors.darkStrokeDivider : AppColors.lightStrokeDivider,
            height: 1,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              l10n.manualFooterMeta,
              textDirection: textDirectionForUiLocale(context),
              style: AppTypography.labelXSRegular.copyWith(
                color: isDark ? AppColors.darkMutedText : AppColors.lightMutedText,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

//& _EmptyStatePlaceholder (private, same file)
class _EmptyStatePlaceholder extends StatefulWidget {
  @override
  State<_EmptyStatePlaceholder> createState() => _EmptyStatePlaceholderState();
}

class _EmptyStatePlaceholderState extends State<_EmptyStatePlaceholder> {
  bool _isHovered = false;

  Widget _buildTealDiamond(double angle) {
    return AnimatedScale(
      scale: _isHovered ? 1.0 : 0.8,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutBack,
      child: AnimatedOpacity(
        opacity: _isHovered ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 350),
        child: Transform.rotate(
          angle: angle,
          child: SvgPicture.asset(
            AppAssets.berberIconDiamondTealOutline,
            width: 38, height: 38,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Center(
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            //* Core column
            Column(
              mainAxisSize: MainAxisSize.min, // Shrink-wrap for tight stack
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 64, height: 64,
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkElevatedCard : AppColors.lightElevatedCard,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: AnimatedScale(
                      scale: _isHovered ? 1.15 : 1.0, // only the icon gets big
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      child: SvgPicture.asset(
                        isDark ? AppAssets.darkIconManual : AppAssets.lightIconManual,
                        width: 32, height: 32,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.documentHelperTitle,
                  textDirection: textDirectionForUiLocale(context),
                  style: AppTypography.headingS.copyWith(
                    color: isDark ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Text(
                    l10n.documentHelperBody,
                    textAlign: TextAlign.center,
                    textDirection: textDirectionForUiLocale(context),
                    style: AppTypography.bodySRegular.copyWith(
                      color: isDark ? AppColors.darkMutedText : AppColors.lightMutedText,
                    ),
                  ),
                ),
              ],
            ),
            //* Teal Diamond 1 — Above title, close to the icon
            Positioned(
              top: -8, right: 32, // Next to the 64x64 icon wrapper
              child: IgnorePointer(child: _buildTealDiamond(0.20)),
            ),
            //* Teal Diamond 2 — Bottom of the writing
            Positioned(
              bottom: -24, left: 24, // Below the descriptive text
              child: IgnorePointer(child: _buildTealDiamond(-0.25)),
            ),
          ],
        ),
      ),
    );
  }
}
