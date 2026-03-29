//? Data model for a single agricultural zone.
//? Matches the Zone entity in BACKEND_DATA_REQUIREMENTS.md.
// TODO :: Deserialize from MQTT JSON payload on topic: tazrout/zones/{zoneId}

//& ZoneModel Class
class ZoneModel {
  final String zoneId;
  final String zoneName;
  final bool isOnline;
  final bool isValveOpen;
  final double temperature;
  final double moisture;
  final double waterLevel;

  //* Const constructor for ZoneModel
  const ZoneModel({
    required this.zoneId,
    required this.zoneName,
    required this.isOnline,
    required this.isValveOpen,
    required this.temperature,
    required this.moisture,
    required this.waterLevel,
  });
}
