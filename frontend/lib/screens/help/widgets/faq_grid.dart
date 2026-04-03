//? 2x2 grid of FaqCard widgets , static content, no API needed.
//? FAQ content is frontend-managed

//& Imports
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../core/localization/l10n/app_localizations.dart';
import 'faq_card.dart';

//& FaqGrid Widget
class FaqGrid extends StatelessWidget {
  //* FaqGrid — displays 4 static FAQ cards in a grid
  const FaqGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    //* GridView.count crossAxisCount: 2
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        FaqCard(
          icon: PhosphorIcons.wifiSlash(),
          title: l10n.faqOfflineTitle,
          description: l10n.faqOfflineDesc,
        ),
        FaqCard(
          icon: PhosphorIcons.chartLineUp(),
          title: l10n.faqErraticTitle,
          description: l10n.faqErraticDesc,
        ),
        FaqCard(
          icon: PhosphorIcons.cloudSlash(),
          title: l10n.faqSyncTitle,
          description: l10n.faqSyncDesc,
        ),
        FaqCard(
          icon: PhosphorIcons.lock(),
          title: l10n.faqAccessTitle,
          description: l10n.faqAccessDesc,
        ),
      ],
    );
  }
}
