//? Document viewer card with macOS window chrome at top.
//? Shows placeholder state when no document is loaded.
//? Placeholder: book icon + title + description centered.
//? Footer inside card: last updated + version metadata.
// TODO :: Wire to local assets — load PDF from docs/user-manuals/
// TODO :: Replace placeholder with flutter_pdfview when PDF is ready

//& Imports
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../core/localization/l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/locale_text_direction.dart';
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
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkElevatedCard : AppColors.lightElevatedCard,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      PhosphorIcons.bookOpen(),
                      size: 32,
                      color: AppColors.darkMutedText,
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
                  // TODO :: Replace with PDF viewer widget
                ],
              ),
            ),
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
