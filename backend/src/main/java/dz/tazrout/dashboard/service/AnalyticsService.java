/*
 * FILE: AnalyticsService.java
 * PURPOSE: Aggregates historical sensor data into chart-ready payloads.
 *          Computes water usage trends, environmental statistics
 *          (temperature/moisture averages), and per-zone consumption
 *          breakdowns for the Analytics screen.
 *          Supports day/week/month/year period granularity.
 * MQTT TOPICS:
 *   Triggers publish on:
 *     tazrout/analytics/water-usage/{period}
 *     tazrout/analytics/environmental/{period}
 *     tazrout/analytics/consumption/{period}
 * DATABASE: sensor_readings (read), zones (read)
 * DEPENDENCIES: SensorReadingRepository, ZoneRepository, MqttPublisher
 * IMPLEMENTED BY: Mr. Fehis
 */
package dz.tazrout.dashboard.service;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ArrayNode;
import com.fasterxml.jackson.databind.node.ObjectNode;
import dz.tazrout.dashboard.mqtt.MqttPublisher;
import dz.tazrout.dashboard.mqtt.MqttTopics;
import org.springframework.stereotype.Service;

@Service
public class AnalyticsService {
    private final MqttPublisher mqttPublisher;
    private final ObjectMapper objectMapper;

    public AnalyticsService(MqttPublisher mqttPublisher, ObjectMapper objectMapper) {
        this.mqttPublisher = mqttPublisher;
        this.objectMapper = objectMapper;
    }

    public void publishEmptyAnalytics(String period) {
        publishSeries(MqttTopics.ANALYTICS_WATER_USAGE_PREFIX + period, "liters");
        publishSeries(MqttTopics.ANALYTICS_ENV_PREFIX + period, "index");
        publishSeries(MqttTopics.ANALYTICS_CONSUMPTION_PREFIX + period, "liters");
    }

    private void publishSeries(String topic, String unit) {
        ObjectNode dto = objectMapper.createObjectNode();
        dto.put("unit", unit);
        ArrayNode data = dto.putArray("data");
        data.add(objectMapper.createObjectNode().put("label", "N/A").put("value", 0));
        mqttPublisher.publish(topic, dto.toString(), 1, false);
    }
}
