/*
 * FILE: SensorService.java
 * PURPOSE: Processes incoming sensor readings from the LoRa Gateway and
 *          persists every reading to the sensor_readings table for
 *          analytics history. Also relays live values to the zone snapshot.
 *
 * MQTT TOPICS:
 *   Receives (via MqttSubscriber): tazrout/zones/{zoneId}/sensors
 * DATABASE: sensor_readings (write), zones (update)
 * DEPENDENCIES: SensorReadingRepository, ZoneRepository, ZoneService
 * IMPLEMENTED BY: Mr. Fehis
 */
package dz.tazrout.dashboard.service;

import com.fasterxml.jackson.databind.JsonNode;
import dz.tazrout.dashboard.model.SensorReading;
import dz.tazrout.dashboard.model.Zone;
import dz.tazrout.dashboard.repository.SensorReadingRepository;
import dz.tazrout.dashboard.repository.ZoneRepository;
import java.time.Instant;
import java.util.Map;
import java.util.UUID;
import java.util.concurrent.ConcurrentHashMap;
import org.springframework.stereotype.Service;

@Service
public class SensorService {
    private final ZoneService zoneService;
    private final SensorReadingRepository sensorReadingRepository;
    private final ZoneRepository zoneRepository;
    private final AnalyticsService analyticsService;
    private final Map<String, JsonNode> latestByZone = new ConcurrentHashMap<>();

    public SensorService(ZoneService zoneService, SensorReadingRepository sensorReadingRepository, ZoneRepository zoneRepository, AnalyticsService analyticsService) {
        this.zoneService = zoneService;
        this.sensorReadingRepository = sensorReadingRepository;
        this.zoneRepository = zoneRepository;
        this.analyticsService = analyticsService;
    }

    public void handleSensorReading(String topic, JsonNode payload) {
        String zoneId = zoneService.extractZoneId(topic, payload);
        latestByZone.put(zoneId, payload);
        zoneService.updateZoneSnapshot(zoneId, payload);
        persistReading(zoneId, payload);
        analyticsService.publishAnalytics();
    }

    private void persistReading(String zoneId, JsonNode payload) {
        try {
            // Ensure the zone row exists — sensor_readings.zone_id has a FK constraint
            if (!zoneRepository.existsById(zoneId)) {
                Zone z = new Zone();
                z.setZoneId(zoneId);
                String zoneName = payload.path("zone_name").asText("");
                z.setZoneName(zoneName.isEmpty() ? zoneId : zoneName);
                z.setDeviceState("ONLINE");
                z.setValveState("CLOSED");
                z.setTemperature(0.0);
                z.setMoisture(0.0);
                z.setWaterLevel(0.0);
                zoneRepository.save(z);
            }

            JsonNode sensors = payload.has("sensors") ? payload.get("sensors") : payload;
            SensorReading reading = new SensorReading();
            reading.setReadingId(UUID.randomUUID().toString());
            reading.setZoneId(zoneId);
            String timestamp = payload.has("timestamp") && !payload.path("timestamp").asText().isEmpty() 
                ? payload.path("timestamp").asText() 
                : Instant.now().toString();
            reading.setTimestamp(timestamp);
            reading.setTemperature(sensors.path("temperature").path("value").asDouble(0.0));
            reading.setMoisture(sensors.path("soil_moisture").path("value").asDouble(0.0));
            reading.setWaterOutput(sensors.path("water_consumed").path("value").asDouble(0.0));
            reading.setHumidity(sensors.path("humidity").path("value").asDouble(0.0));
            sensorReadingRepository.save(reading);
        } catch (Exception e) {
            System.err.println("[SensorService] Failed to persist reading for zone " + zoneId + ": " + e.getMessage());
        }
    }

    public Map<String, JsonNode> getLatestByZone() {
        return latestByZone;
    }
}
