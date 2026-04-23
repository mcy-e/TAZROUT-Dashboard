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
package dz.tazrout.dashboard.service;

import com.fasterxml.jackson.databind.JsonNode;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import org.springframework.stereotype.Service;

@Service
public class SensorService {
    private final ZoneService zoneService;
    private final Map<String, JsonNode> latestByZone = new ConcurrentHashMap<>();

    public SensorService(ZoneService zoneService) {
        this.zoneService = zoneService;
    }

    public void handleSensorReading(String topic, JsonNode payload) {
        String zoneId = zoneService.extractZoneId(topic, payload);
        latestByZone.put(zoneId, payload);
        zoneService.updateZoneSnapshot(zoneId, payload);
    }

    public Map<String, JsonNode> getLatestByZone() {
        return latestByZone;
    }
}
