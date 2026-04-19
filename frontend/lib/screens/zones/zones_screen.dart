//? Zones screen — displays all agricultural zones in a 3-column grid.
//? ZoneCard handles its own expanded/collapsed state internally.
// TODO :: Replace static zone list with MQTT topic: tazrout/zones/all

//& Imports
import 'package:flutter/material.dart';
import '../../core/localization/l10n/app_localizations.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import 'package:tazrout_dashboard/core/utils/locale_text_direction.dart';
import '../../models/zone_model.dart';
import 'widgets/zone_card.dart';
import '../../widgets/common/empty_state_widget.dart';

//& ZonesScreen Widget
class ZonesScreen extends StatelessWidget {
  //* StatelessWidget — composes the layout of the Zones screen
  const ZonesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    //* Build a static list of 7 ZoneModel objects with varied states
    // TODO :: Replace with real MQTT data from topic: tazrout/zones
    final List<ZoneModel> zones = [
      const ZoneModel(
        zoneId: 'A',
        zoneName: 'Zone A',
        isOnline: true,
        isValveOpen: true,
        temperature: 24,
        moisture: 620,
        waterLevel: 0.45,
      ),
      const ZoneModel(
        zoneId: 'B',
        zoneName: 'Zone B',
        isOnline: true,
        isValveOpen: true,
        temperature: 22,
        moisture: 580,
        waterLevel: 0.38,
      ),
      const ZoneModel(
        zoneId: 'C',
        zoneName: 'Zone C',
        isOnline: false,
        isValveOpen: false,
        temperature: 0,
        moisture: 0,
        waterLevel: 0,
      ),
      const ZoneModel(
        zoneId: 'D',
        zoneName: 'Zone D',
        isOnline: true,
        isValveOpen: false,
        temperature: 26,
        moisture: 700,
        waterLevel: 0.52,
      ),
      const ZoneModel(
        zoneId: 'E',
        zoneName: 'Zone E',
        isOnline: false,
        isValveOpen: false,
        temperature: 0,
        moisture: 0,
        waterLevel: 0,
      ),
      const ZoneModel(
        zoneId: 'F',
        zoneName: 'Zone F',
        isOnline: true,
        isValveOpen: true,
        temperature: 21,
        moisture: 610,
        waterLevel: 0.41,
      ),
      const ZoneModel(
        zoneId: 'G',
        zoneName: 'Zone G',
        isOnline: true,
        isValveOpen: true,
        temperature: 23,
        moisture: 590,
        waterLevel: 0.44,
      ),
    ];

    //* Layout: Padding(24) → GridView.builder
    return Scaffold(
      backgroundColor: AppColors.lightSurfaceCard.withValues(alpha: 0.0),
      body: LayoutBuilder(
        builder: (context, constraints) {
          //* subtract 24px padding on each side, then 2 gaps of 16px between 3 columns
          final availableWidth = constraints.maxWidth - 48;
          final cardWidth = (availableWidth - 32) / 3;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: isArabic(context)
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.zonesTitle,
                  textAlign: isArabic(context) ? TextAlign.right : TextAlign.start,
                  textDirection: textDirectionForUiLocale(context),
                  style: AppTypography.headingM.copyWith(
                    color: isDark ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.zonesSubtitle,
                  textAlign: isArabic(context) ? TextAlign.right : TextAlign.start,
                  textDirection: textDirectionForUiLocale(context),
                  style: AppTypography.bodySRegular.copyWith(
                    color: isDark ? AppColors.darkMutedText : AppColors.lightMutedText,
                  ),
                ),
                const SizedBox(height: 24),
                if (zones.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 40),
                      child: EmptyStateWidget(message: l10n.emptyStateNoData),
                    ),
                  )
                else
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: zones.map((zone) {
                      return SizedBox(
                        width: cardWidth,
                        child: ZoneCard(zone: zone),
                      );
                    }).toList(),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
