//? Help Center screen — composes FAQ grid and support banner.
//? QR contact card is shown as a dialog overlay.
//? FAQ content is entirely frontend-managed static content.

//& Imports
import 'package:flutter/material.dart';
import '../../core/localization/l10n/app_localizations.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import 'package:tazrout_dashboard/core/utils/locale_text_direction.dart';
import 'widgets/faq_grid.dart';
import 'widgets/support_banner.dart';
import 'widgets/qr_contact_card.dart';

//& HelpScreen Widget
class HelpScreen extends StatelessWidget {
  //* StatelessWidget — composes the Help Center layout
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.lightSurfaceCard.withValues(alpha: 0.0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: isArabic(context)
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            //* Page header
            Text(
              l10n.helpTitle,
              textAlign: isArabic(context) ? TextAlign.right : TextAlign.left,
              textDirection: textDirectionForUiLocale(context),
              style: AppTypography.headingM.copyWith(
                color: isDark ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
              ),
            ),
            Text(
              l10n.helpSubtitle,
              textAlign: isArabic(context) ? TextAlign.right : TextAlign.left,
              textDirection: textDirectionForUiLocale(context),
              style: AppTypography.bodySRegular.copyWith(
                color: isDark ? AppColors.darkMutedText : AppColors.lightMutedText,
              ),
            ),
            const SizedBox(height: 24),
            //* FaqGrid (2x2 grid of issue cards)
            const FaqGrid(),
            const SizedBox(height: 148),
            //* SupportBanner (narrower with horizontal breathing room)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: SupportBanner(
                onGetSupport: () => showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (_) => const Dialog(
                    backgroundColor: Colors.transparent,
                    insetPadding: EdgeInsets.symmetric(horizontal: 24),
                    child: QrContactCard(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
