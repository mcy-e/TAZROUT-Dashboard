//? Zones screen — displays all agricultural zones in a 3-column grid.
//? ZoneCard handles its own expanded/collapsed state internally.
// TODO :: Replace static zone list with MQTT topic: tazrout/zones/all

//& Imports
import 'package:flutter/material.dart';
import '../../../models/zone_model.dart';
import 'widgets/zone_card.dart';

//& ZonesScreen Widget
class ZonesScreen extends StatelessWidget {
  //* StatelessWidget — composes the layout of the Zones screen
  const ZonesScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
      backgroundColor: Colors.transparent,
      body: GridView.builder(
        padding: const EdgeInsets.all(24),
        itemCount: zones.length,
        //* SliverGridDelegateWithFixedCrossAxisCount
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          //* childAspectRatio: 0.85 ← collapsed default ratio
          childAspectRatio: 0.85,
        ),
        itemBuilder: (context, index) {
          return ZoneCard(zone: zones[index]);
        },
      ),
    );
  }
}
