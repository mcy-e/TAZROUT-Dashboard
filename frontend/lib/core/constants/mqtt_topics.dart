//? Central registry of all MQTT topic strings used in the Flutter frontend.
//? Must stay in sync with docs/MQTT_TOPICS.md and backend MqttTopics.java.

//& MqttTopics Constants
abstract final class MqttTopics {
  //& Zone Topics
  static const String zonePrefix = 'tazrout/zones/';
  static const String zoneSensorsSuffix = '/sensors';
  static const String zoneStateSuffix = '/state';
  static const String zoneValveAckSuffix = '/valve/ack';

  //& AI Topics
  static const String aiDecisions = 'tazrout/ai/decisions';
  static const String aiDecisionsLatest = 'tazrout/ai/decisions/latest';
  static const String aiAlerts = 'tazrout/ai/alerts';

  //& Dashboard Topics
  static const String dashboardSummary = 'tazrout/dashboard/summary';
  static const String dashboardNotifications = 'tazrout/dashboard/notifications';

  //& System Topics
  static const String systemControl = 'tazrout/system/control';
  static const String systemEmergencyStop = 'tazrout/system/emergency/stop';
  static const String systemEmergencyStatus = 'tazrout/system/emergency/status';
  static const String systemEmergencyAlert = 'tazrout/system/emergency/alert';
  static const String systemGatewayHeartbeat = 'tazrout/system/gateway/heartbeat';
  static const String systemGatewayStatus = 'tazrout/system/gateway/status';
  static const String systemBackendStatus = 'tazrout/system/backend/status';

  //& Analytics Topics
  static const String analyticsWaterUsagePrefix = 'tazrout/analytics/water-usage/';
  static const String analyticsEnvPrefix = 'tazrout/analytics/environmental/';
  static const String analyticsConsumptionPrefix = 'tazrout/analytics/consumption/';

  //& Settings & Support
  static const String settingsPreferences = 'tazrout/settings/preferences';
  static const String supportContact = 'tazrout/support/contact';

  //& Topic Matchers
  static bool isZoneSensorTopic(String topic) =>
      topic.startsWith(zonePrefix) && topic.endsWith(zoneSensorsSuffix);

  static bool isZoneStateTopic(String topic) =>
      topic.startsWith(zonePrefix) && topic.endsWith(zoneStateSuffix);

  static String zoneIdFrom(String topic) {
    final parts = topic.split('/');
    return parts.length > 2 ? parts[2] : 'unknown';
  }
}
