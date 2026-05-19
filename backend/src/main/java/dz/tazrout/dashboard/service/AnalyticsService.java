/*
 * FILE: AnalyticsService.java
 * PURPOSE: Aggregates historical sensor data from the database into
 *          chart-ready payloads for the Analytics screen.
 *          Called on every new sensor reading. Queries the last N
 *          readings per zone and computes averages per time window.
 * MQTT TOPICS:
 *   Triggers publish on:
 *     tazrout/analytics/water-usage/day
 *     tazrout/analytics/environmental/day
 *     tazrout/analytics/consumption/day
 * DATABASE: sensor_readings (read), zones (read)
 * DEPENDENCIES: SensorReadingRepository, ZoneRepository, MqttPublisher, MqttWebSocketBridge
 * IMPLEMENTED BY: Mr. Fehis
 */
package dz.tazrout.dashboard.service;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ArrayNode;
import com.fasterxml.jackson.databind.node.ObjectNode;
import dz.tazrout.dashboard.model.SensorReading;
import dz.tazrout.dashboard.mqtt.MqttPublisher;
import dz.tazrout.dashboard.mqtt.MqttTopics;
import dz.tazrout.dashboard.mqtt.MqttWebSocketBridge;
import dz.tazrout.dashboard.repository.SensorReadingRepository;
import dz.tazrout.dashboard.repository.ZoneRepository;
import java.util.List;
import org.springframework.stereotype.Service;

@Service
public class AnalyticsService {
    private final MqttPublisher mqttPublisher;
    private final MqttWebSocketBridge bridge;
    private final ObjectMapper objectMapper;
    private final SensorReadingRepository sensorReadingRepository;
    private final ZoneRepository zoneRepository;

    public AnalyticsService(
            MqttPublisher mqttPublisher,
            MqttWebSocketBridge bridge,
            ObjectMapper objectMapper,
            SensorReadingRepository sensorReadingRepository,
            ZoneRepository zoneRepository) {
        this.mqttPublisher = mqttPublisher;
        this.bridge = bridge;
        this.objectMapper = objectMapper;
        this.sensorReadingRepository = sensorReadingRepository;
        this.zoneRepository = zoneRepository;
    }

    public void publishAnalytics() {
        // Fetch ALL readings from the last 365 days to guarantee full historical accuracy
        String yearAgo = java.time.ZonedDateTime.now().minusDays(365)
                .format(java.time.format.DateTimeFormatter.ISO_OFFSET_DATE_TIME);
        List<SensorReading> readings = sensorReadingRepository.findByTimestampGreaterThanEqual(yearAgo);
        
        // Multi-scale Water Usage
        publishWaterUsage(readings, "day", 6, "4-hours");
        publishWaterUsage(readings, "week", 7, "days");
        publishWaterUsage(readings, "month", 6, "months");

        // Environmental (Always shows trend of latest 7)
        publishEnvironmental(readings);

        // Multi-scale Zone Consumption
        publishConsumptionPerZone(readings, "day", 24);
        publishConsumptionPerZone(readings, "week", 7);
        publishConsumptionPerZone(readings, "month", 30);
    }

    private void publishWaterUsage(List<SensorReading> readings, String period, int bucketCount, String bucketUnit) {
        ObjectNode dto = objectMapper.createObjectNode();
        dto.put("unit", "liters");
        dto.put("period", period);
        ArrayNode data = dto.putArray("data");

        double[] buckets = new double[bucketCount];
        String[] labels = new String[bucketCount];
        
        java.time.ZonedDateTime now = java.time.ZonedDateTime.now();
        
        for (int i = 0; i < bucketCount; i++) {
            if ("hours".equals(bucketUnit)) labels[i] = now.minusHours(bucketCount - 1 - i).format(java.time.format.DateTimeFormatter.ofPattern("HH:00"));
            else if ("4-hours".equals(bucketUnit)) labels[i] = now.minusHours((bucketCount - 1 - i) * 4).format(java.time.format.DateTimeFormatter.ofPattern("HH:00"));
            else if ("days".equals(bucketUnit)) labels[i] = now.minusDays(bucketCount - 1 - i).getDayOfWeek().name().substring(0, 3);
            else if ("weeks".equals(bucketUnit)) labels[i] = "W" + (i + 1);
            else if ("months".equals(bucketUnit)) labels[i] = now.minusMonths(bucketCount - 1 - i).format(java.time.format.DateTimeFormatter.ofPattern("MMM"));
        }

        for (SensorReading r : readings) {
            try {
                java.time.ZonedDateTime rTime = java.time.ZonedDateTime.parse(r.getTimestamp());
                int index = -1;
                if ("hours".equals(bucketUnit)) {
                    long hoursAgo = java.time.Duration.between(rTime, now).toHours();
                    if (hoursAgo >= 0 && hoursAgo < bucketCount) {
                        index = bucketCount - 1 - (int) hoursAgo;
                    }
                } else if ("4-hours".equals(bucketUnit)) {
                    long hoursAgo = java.time.Duration.between(rTime, now).toHours();
                    if (hoursAgo >= 0 && hoursAgo < bucketCount * 4) {
                        index = bucketCount - 1 - (int) (hoursAgo / 4);
                    }
                } else if ("days".equals(bucketUnit)) {
                    long daysAgo = java.time.Duration.between(rTime.truncatedTo(java.time.temporal.ChronoUnit.DAYS), now.truncatedTo(java.time.temporal.ChronoUnit.DAYS)).toDays();
                    if (daysAgo >= 0 && daysAgo < bucketCount) {
                        index = bucketCount - 1 - (int) daysAgo;
                    }
                } else if ("weeks".equals(bucketUnit)) {
                    long daysAgo = java.time.Duration.between(rTime.truncatedTo(java.time.temporal.ChronoUnit.DAYS), now.truncatedTo(java.time.temporal.ChronoUnit.DAYS)).toDays();
                    long weeksAgo = daysAgo / 7;
                    if (weeksAgo >= 0 && weeksAgo < bucketCount) {
                        index = bucketCount - 1 - (int) weeksAgo;
                    }
                } else if ("months".equals(bucketUnit)) {
                    long monthsAgo = java.time.temporal.ChronoUnit.MONTHS.between(java.time.YearMonth.from(rTime), java.time.YearMonth.from(now));
                    if (monthsAgo >= 0 && monthsAgo < bucketCount) {
                        index = bucketCount - 1 - (int) monthsAgo;
                    }
                }
                
                if (index >= 0 && index < bucketCount && r.getWaterOutput() != null) {
                    buckets[index] += r.getWaterOutput();
                }
            } catch (Exception e) {}
        }

        for (int i = 0; i < bucketCount; i++) {
            data.add(objectMapper.createObjectNode()
                .put("label", labels[i])
                .put("value", Math.round(buckets[i] * 10.0) / 10.0));
        }

        broadcastAnalytics(MqttTopics.ANALYTICS_WATER_USAGE_PREFIX + period, dto.toString());
    }

    private void publishEnvironmental(List<SensorReading> readings) {
        ObjectNode dto = objectMapper.createObjectNode();
        dto.put("unit", "°C");
        ArrayNode data = dto.putArray("data");

        int count = 0;
        for (int i = 0; i < readings.size() && count < 7; i++) {
            SensorReading r = readings.get(i);
            double temp = r.getTemperature() != null ? r.getTemperature() : 0.0;
            String timeLabel = "";
            try {
                java.time.ZonedDateTime rTime = java.time.ZonedDateTime.parse(r.getTimestamp());
                timeLabel = rTime.format(java.time.format.DateTimeFormatter.ofPattern("HH:mm"));
            } catch (Exception e) { timeLabel = "T"+i; }

            data.insert(0, objectMapper.createObjectNode()
                .put("label", timeLabel)
                .put("value", Math.round(temp * 10.0) / 10.0));
            count++;
        }

        broadcastAnalytics(MqttTopics.ANALYTICS_ENV_PREFIX + "day", dto.toString());
    }

    private void publishConsumptionPerZone(List<SensorReading> readings, String period, int days) {
        ObjectNode dto = objectMapper.createObjectNode();
        dto.put("unit", "liters");
        dto.put("period", period);
        ArrayNode data = dto.putArray("data");

        zoneRepository.findAll().stream()
            .filter(zone -> !"OFFLINE".equals(zone.getDeviceState()))
            .forEach(zone -> {
            java.time.ZonedDateTime startTime = java.time.ZonedDateTime.now().minusDays(days);
            
            double zoneTotal = readings.stream()
                .filter(r -> zone.getZoneId().equals(r.getZoneId()))
                .filter(r -> {
                    try {
                        return java.time.ZonedDateTime.parse(r.getTimestamp()).isAfter(startTime);
                    } catch (Exception e) { return false; }
                })
                .mapToDouble(r -> r.getWaterOutput() != null ? r.getWaterOutput() : 0.0)
                .sum();
                
            if (zoneTotal > 0) {
                data.add(objectMapper.createObjectNode()
                    .put("label", zone.getZoneName() != null ? zone.getZoneName() : zone.getZoneId())
                    .put("value", Math.round(zoneTotal * 10.0) / 10.0));
            }
        });

        broadcastAnalytics(MqttTopics.ANALYTICS_CONSUMPTION_PREFIX + period, dto.toString());
    }

    private void broadcastAnalytics(String topic, String payload) {
        mqttPublisher.publish(topic, payload, 1, false);
        bridge.forward(topic, payload);
    }
}
