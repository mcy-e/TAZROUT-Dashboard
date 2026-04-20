//? Provider for managing agricultural zones state.
//? Holds the current list of zones and their real-time sensor/device states.
// TODO :: Wire to MQTT topic: tazrout/zones/#

//& Imports
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/zone_model.dart';

//& ZoneNotifier Class
class ZoneNotifier extends Notifier<List<ZoneModel>> {
  @override
  List<ZoneModel> build() {
    //* Initial static placeholder list
    return const [
      ZoneModel(
        zoneId: 'A',
        zoneName: 'Zone A',
        isOnline: true,
        isValveOpen: true,
        temperature: 24,
        moisture: 620,
        waterLevel: 0.45,
      ),
      ZoneModel(
        zoneId: 'B',
        zoneName: 'Zone B',
        isOnline: true,
        isValveOpen: true,
        temperature: 22,
        moisture: 580,
        waterLevel: 0.38,
      ),
      ZoneModel(
        zoneId: 'C',
        zoneName: 'Zone C',
        isOnline: false,
        isValveOpen: false,
        temperature: 0,
        moisture: 0,
        waterLevel: 0,
      ),
      ZoneModel(
        zoneId: 'D',
        zoneName: 'Zone D',
        isOnline: true,
        isValveOpen: false,
        temperature: 26,
        moisture: 700,
        waterLevel: 0.52,
      ),
      ZoneModel(
        zoneId: 'E',
        zoneName: 'Zone E',
        isOnline: false,
        isValveOpen: false,
        temperature: 0,
        moisture: 0,
        waterLevel: 0,
      ),
      ZoneModel(
        zoneId: 'F',
        zoneName: 'Zone F',
        isOnline: true,
        isValveOpen: true,
        temperature: 21,
        moisture: 610,
        waterLevel: 0.41,
      ),
      ZoneModel(
        zoneId: 'G',
        zoneName: 'Zone G',
        isOnline: true,
        isValveOpen: true,
        temperature: 23,
        moisture: 590,
        waterLevel: 0.44,
      ),
    ];
  }

  //* Sets all zones to offline state and closes their valves
  //* Used primarily during emergency stops
  void setAllZonesOffline() {
    state = state.map((zone) {
      return zone.copyWith(
        isOnline: false,
        isValveOpen: false,
      );
    }).toList();
  }
}

//& Provider instance
final zonesProvider = NotifierProvider<ZoneNotifier, List<ZoneModel>>(() {
  return ZoneNotifier();
});
