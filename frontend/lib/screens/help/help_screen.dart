//? Help Center screen — composes FAQ grid and support banner.
//? QR contact card is shown as a dialog overlay.
//? FAQ content is entirely frontend-managed static content.

//& Imports
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
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

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //* Page header
            Text(
              'Help Center',
              style: AppTypography.headingM.copyWith(
                color: isDark ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
              ),
            ),
            Text(
              'Find answers and support for your dashboard.',
              style: AppTypography.bodySRegular.copyWith(
                color: isDark ? AppColors.darkMutedText : AppColors.lightMutedText,
              ),
            ),
            const SizedBox(height: 24),
            //* FaqGrid (2x2 grid of issue cards)
            const FaqGrid(),
            const SizedBox(height: 24),
            //* SupportBanner (full width dark green banner)
            SupportBanner(
              onGetSupport: () => showDialog(
                context: context,
                builder: (_) => const Dialog(
                  backgroundColor: Colors.transparent,
                  insetPadding: EdgeInsets.symmetric(horizontal: 24),
                  child: QrContactCard(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
