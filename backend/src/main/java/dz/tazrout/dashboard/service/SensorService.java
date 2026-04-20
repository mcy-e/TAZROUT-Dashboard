/*
 * FILE: SensorService.java
 * PURPOSE: Processes incoming sensor readings from the LoRa Gateway.
 *          The gateway receives LoRa packets from ESP32 nodes in the field,
 *          decodes them to JSON, and publishes on tazrout/zones/{zoneId}/sensors.
 *
 *          This service:
 *            - Validates sensor status flags (OK / OUT_OF_RANGE / SENSOR_FAULT)
 *            - Validates reading ranges (temperature, moisture, water level)
 *            - Persists valid readings to sensor_readings table
 *            - Updates the parent Zone entity with latest values
 *            - Triggers zone status re-publish for the dashboard
 *            - Triggers NotificationService if thresholds are exceeded
 *
 * MQTT TOPICS:
 *   Receives (via MqttSubscriber): tazrout/zones/{zoneId}/sensors
 *   Triggers publish on: tazrout/dashboard/summary (via aggregation)
 * DATABASE: sensor_readings (write), zones (update)
 * DEPENDENCIES: SensorReadingRepository, ZoneRepository, MqttPublisher, NotificationService
 * IMPLEMENTED BY: Mr. Fehis
 */
