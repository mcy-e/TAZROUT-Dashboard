//? Data model for a single agricultural zone.
//? Matches the Zone entity in BACKEND_DATA_REQUIREMENTS.md.
//? Deserialized from tazrout/dashboard/summary and tazrout/zones/{zoneId}/sensors frames.

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

  //* Deserializes from the dashboard/summary zone entry (device_state + valve_state)
  factory ZoneModel.fromSummaryJson(Map<String, dynamic> json) {
    return ZoneModel(
      zoneId: json['zone_id'] as String? ?? 'unknown',
      zoneName: json['zone_name'] as String? ?? 'Zone',
      isOnline: (json['device_state'] as String?)?.toUpperCase() == 'ONLINE',
      isValveOpen: (json['valve_state'] as String?)?.toUpperCase() == 'OPEN',
      temperature: (json['temperature'] as num?)?.toDouble() ?? 0.0,
      moisture: (json['moisture'] as num?)?.toDouble() ?? 0.0,
      waterLevel: (json['water_level'] as num?)?.toDouble() ?? 0.0,
    );
  }

  //* Merges sensor reading payload onto an existing zone snapshot
  ZoneModel withSensorJson(Map<String, dynamic> sensors) {
    final temp = sensors['temperature'] as Map<String, dynamic>?;
    final moisture = sensors['soil_moisture'] as Map<String, dynamic>?;
    final water = sensors['water_level'] as Map<String, dynamic>?;
    return copyWith(
      temperature: (temp?['value'] as num?)?.toDouble() ?? temperature,
      moisture: (moisture?['value'] as num?)?.toDouble() ?? this.moisture,
      waterLevel: (water?['value'] as num?)?.toDouble() ?? waterLevel,
    );
  }

  //* copyWith method for state updates
  ZoneModel copyWith({
    String? zoneId,
    String? zoneName,
    bool? isOnline,
    bool? isValveOpen,
    double? temperature,
    double? moisture,
    double? waterLevel,
  }) {
    return ZoneModel(
      zoneId: zoneId ?? this.zoneId,
      zoneName: zoneName ?? this.zoneName,
      isOnline: isOnline ?? this.isOnline,
      isValveOpen: isValveOpen ?? this.isValveOpen,
      temperature: temperature ?? this.temperature,
      moisture: moisture ?? this.moisture,
      waterLevel: waterLevel ?? this.waterLevel,
    );
  }
}
