//? 2x2 grid of FaqCard widgets , static content, no API needed.
//? FAQ content is frontend-managed

//& Imports
import 'package:flutter/material.dart';
import '../../../../core/localization/l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_assets.dart';
import 'faq_card.dart';

//& FaqGrid Widget
class FaqGrid extends StatelessWidget {
  //* FaqGrid — displays 4 static FAQ cards in a grid
  const FaqGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return GridView(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 3.8,
      ),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        FaqCard(
          // Chosen asset: AppAssets.darkIconShutDownI
          iconAsset: AppAssets.darkIconShutDownI,
          iconColor: AppColors.errorSolid,
          title: l10n.faqOfflineTitle,
          description: l10n.faqOfflineDesc,
          detailedText: l10n.faqOfflineDetailed,
        ),
        FaqCard(
          // Chosen asset: AppAssets.darkIconAnalyticsI
          iconAsset: AppAssets.darkIconAnalyticsI,
          iconColor: AppColors.series2Blue,
          title: l10n.faqErraticTitle,
          description: l10n.faqErraticDesc,
          detailedText: l10n.faqErraticDetailed,
        ),
        FaqCard(
          // Chosen asset: AppAssets.darkIconData
          iconAsset: AppAssets.darkIconData,
          iconColor: AppColors.series3Amber,
          title: l10n.faqSyncTitle,
          description: l10n.faqSyncDesc,
          detailedText: l10n.faqSyncDetailed,
        ),
        FaqCard(
          // Chosen asset: AppAssets.darkIconAccess
          iconAsset: AppAssets.darkIconAccess,
          iconColor: AppColors.series6Purple,
          title: l10n.faqAccessTitle,
          description: l10n.faqAccessDesc,
          detailedText: l10n.faqAccessDetailed,
        ),
      ],
    );
  }
}
