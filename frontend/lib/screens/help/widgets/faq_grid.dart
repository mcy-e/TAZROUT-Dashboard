//? 2x2 grid of FaqCard widgets , static content, no API needed.
//? FAQ content is frontend-managed

//& Imports
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'faq_card.dart';

//& FaqGrid Widget
class FaqGrid extends StatelessWidget {
  //* FaqGrid — displays 4 static FAQ cards in a grid
  const FaqGrid({super.key});

  @override
  Widget build(BuildContext context) {
    //* GridView.count crossAxisCount: 2
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        //* Card 1: System Offline?
        FaqCard(
          icon: PhosphorIcons.wifiSlash(),
          title: 'System Offline?',
          description: 'If zones appear offline, check the main power supply and ensure the gateway is connected to the network.',
        ),
        //* Card 2: Erratic Readings?
        FaqCard(
          icon: PhosphorIcons.chartLineUp(),
          title: 'Erratic Readings?',
          description: 'Sensor calibration may be required. Visit the Zones tab to run a diagnostic test on specific sensors.',
        ),
        //* Card 3: Data Not Syncing?
        FaqCard(
          icon: PhosphorIcons.cloudSlash(),
          title: 'Data Not Syncing?',
          description: 'Ensure your internet connection is stable. Data will cache locally and sync once connection is restored.',
        ),
        //* Card 4: Access Denied?
        FaqCard(
          icon: PhosphorIcons.lock(),
          title: 'Access Denied?',
          description: 'Contact your administrator to verify your permissions settings if you cannot access certain controls.',
        ),
      ],
    );
  }
}
