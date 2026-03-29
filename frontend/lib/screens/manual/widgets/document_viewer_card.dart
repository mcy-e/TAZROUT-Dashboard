//? Document viewer card with macOS window chrome at top.
//? Shows placeholder state when no document is loaded.
//? Placeholder: book icon + title + description centered.
//? Footer inside card: last updated + version metadata.
// TODO :: Wire to local assets — load PDF from docs/user-manuals/
// TODO :: Replace placeholder with flutter_pdfview when PDF is ready

//& Imports
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import 'mac_window_chrome.dart';

//& DocumentViewerCard Widget
class DocumentViewerCard extends StatelessWidget {
  //* Card borderRadius 12px, no padding on outer card
  const DocumentViewerCard({super.key});

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
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          //* macOS-style window chrome
          const MacWindowChrome(fileName: 'manual_v2.0.pdf'),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //* Icon placeholder for empty state
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      //* bg: AppColors.darkElevatedCard (dark) / AppColors.lightElevatedCard (light)
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
                  //* Title
                  Text(
                    'Document Helper',
                    style: AppTypography.headingS.copyWith(
                      color: isDark ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                    ),
                  ),
                  const SizedBox(height: 8),
                  //* Description
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      'The comprehensive user manual content will be rendered here.\n'
                      'This area is designed to handle embedded PDF viewers\n'
                      'or rich text documentation.',
                      textAlign: TextAlign.center,
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
          //* Internal card footer
          Divider(
            color: isDark ? AppColors.darkStrokeDivider : AppColors.lightStrokeDivider,
            height: 1,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'Last updated: Oct 24, 2024 • Version 2.0',
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
