//? 4-column responsive grid of ZoneStatusCard widgets.
//? Scrollable — zones list can grow dynamically.
// TODO :: Replace static list with MQTT-driven zone states

//& Imports
import 'package:flutter/material.dart';
import '../../../../core/utils/app_logger.dart';
import 'zone_status_card.dart';

//& ZoneStatusGrid Widget
class ZoneStatusGrid extends StatelessWidget {
  final List<Map<String, dynamic>> zones;

  //* ZoneStatusGrid Parameters
  const ZoneStatusGrid({
    super.key,
    required this.zones,
  });

  @override
  Widget build(BuildContext context) {
    //* AppLogger.debug('EMERGENCY', 'Rendering ${zones.length} zone cards')
    AppLogger.debug('EMERGENCY', 'Rendering ${zones.length} zone cards');

    //* GridView.builder
    return GridView.builder(
      itemCount: zones.length,
      //* SliverGridDelegateWithFixedCrossAxisCount
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 2.2,
      ),
      itemBuilder: (context, index) {
        final zone = zones[index];
        return ZoneStatusCard(
          zoneName: zone['zoneName'] as String,
          isOnline: zone['isOnline'] as bool,
        );
      },
    );
  }
}
