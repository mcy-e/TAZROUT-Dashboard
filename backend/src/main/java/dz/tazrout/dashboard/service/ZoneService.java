/*
 * FILE: ZoneService.java
 * PURPOSE: Business logic for zone management. Processes zone state updates
 *          from the LoRa Gateway, tracks device online/offline transitions,
 *          and publishes processed zone data to the dashboard.
 *
 *          Valve commands are published exclusively by the AI Engine —
 *          the dashboard is read-only for valve control. This service
 *          receives and persists valve command acknowledgments from the
 *          field MCUs (via Gateway) to close the command loop.
 *
 * MQTT TOPICS:
 *   Receives (via MqttSubscriber):
 *     tazrout/zones/{zoneId}/state           ← device state changes from gateway
 *     tazrout/zones/{zoneId}/valve/ack       ← command ACK from MCU via gateway
 *   Triggers publish on:
 *     tazrout/dashboard/summary              ← aggregated zone data
 *     tazrout/system/emergency/status        ← if zone goes offline
 * DATABASE: zones (read/write)
 * DEPENDENCIES: ZoneRepository, MqttPublisher, NotificationService
 * IMPLEMENTED BY: Mr. Fehis
 */
package dz.tazrout.dashboard.service;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ArrayNode;
import com.fasterxml.jackson.databind.node.ObjectNode;
import dz.tazrout.dashboard.mqtt.MqttPublisher;
import dz.tazrout.dashboard.mqtt.MqttTopics;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import org.springframework.stereotype.Service;

@Service
public class ZoneService {
    private final MqttPublisher mqttPublisher;
    private final ObjectMapper objectMapper;
    private final Map<String, ObjectNode> zoneSnapshots = new ConcurrentHashMap<>();

    public ZoneService(MqttPublisher mqttPublisher, ObjectMapper objectMapper) {
        this.mqttPublisher = mqttPublisher;
        this.objectMapper = objectMapper;
    }

    public String extractZoneId(String topic, JsonNode payload) {
        JsonNode zoneIdNode = payload.get("zone_id");
        if (zoneIdNode != null && !zoneIdNode.isNull()) {
            return zoneIdNode.asText();
        }
        String[] parts = topic.split("/");
        return parts.length > 2 ? parts[2] : "unknown";
    }

    public void updateZoneSnapshot(String zoneId, JsonNode payload) {
        ObjectNode snapshot = zoneSnapshots.computeIfAbsent(zoneId, k -> objectMapper.createObjectNode());
        snapshot.setAll((ObjectNode) payload.deepCopy());
        publishSummaryAndEmergencyStatus();
    }

    public void handleZoneEvent(String topic, JsonNode payload) {
        String zoneId = extractZoneId(topic, payload);
        updateZoneSnapshot(zoneId, payload);
    }

    private void publishSummaryAndEmergencyStatus() {
        ObjectNode summary = objectMapper.createObjectNode();
        ArrayNode zones = summary.putArray("zones");
        zoneSnapshots.forEach((zoneId, snapshot) -> {
            ObjectNode zoneNode = objectMapper.createObjectNode();
            zoneNode.put("zone_id", zoneId);
            zoneNode.put("zone_name", snapshot.path("zone_name").asText(zoneId));
            zoneNode.put("device_state", snapshot.path("current_device_state").asText("ONLINE"));
            zoneNode.put("valve_state", snapshot.path("valve_state").asText("UNKNOWN"));
            zones.add(zoneNode);
        });
        summary.put("total_zones", zoneSnapshots.size());
        mqttPublisher.publish(MqttTopics.DASHBOARD_SUMMARY, summary.toString(), 1, false);

        long offline = zoneSnapshots.values().stream()
                .filter(v -> "OFFLINE".equalsIgnoreCase(v.path("current_device_state").asText()))
                .count();
        String systemStatus = "OPERATIONAL";
        if (zoneSnapshots.size() > 0 && offline * 2 >= zoneSnapshots.size()) {
            systemStatus = "CRITICAL";
        } else if (offline > 0) {
            systemStatus = "DEGRADED";
        }
        ObjectNode emergency = objectMapper.createObjectNode();
        emergency.set("zones", zones.deepCopy());
        emergency.put("system_status", systemStatus);
        mqttPublisher.publish(MqttTopics.SYSTEM_EMERGENCY_STATUS, emergency.toString(), 1, true);
    }
}
