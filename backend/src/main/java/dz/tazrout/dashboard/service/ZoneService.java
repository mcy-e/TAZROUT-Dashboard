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
 *     tazrout/dashboard/summary              ← aggregated zone data (MQTT + WebSocket)
 *     tazrout/system/emergency/status        ← if zone goes offline
 * DATABASE: zones (read/write)
 * DEPENDENCIES: ZoneRepository, MqttPublisher, MqttWebSocketBridge, NotificationService
 * IMPLEMENTED BY: Mr. Fehis
 */
package dz.tazrout.dashboard.service;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ArrayNode;
import com.fasterxml.jackson.databind.node.ObjectNode;
import dz.tazrout.dashboard.model.Zone;
import dz.tazrout.dashboard.mqtt.MqttPublisher;
import dz.tazrout.dashboard.mqtt.MqttTopics;
import dz.tazrout.dashboard.mqtt.MqttWebSocketBridge;
import dz.tazrout.dashboard.repository.ZoneRepository;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import jakarta.annotation.PostConstruct;
import org.springframework.stereotype.Service;

@Service
public class ZoneService {
    private final MqttPublisher mqttPublisher;
    private final MqttWebSocketBridge bridge;
    private final ObjectMapper objectMapper;
    private final ZoneRepository zoneRepository;
    private final NotificationService notificationService;
    private final Map<String, ObjectNode> zoneSnapshots = new ConcurrentHashMap<>();

    public ZoneService(MqttPublisher mqttPublisher, MqttWebSocketBridge bridge, ObjectMapper objectMapper, ZoneRepository zoneRepository, NotificationService notificationService) {
        this.mqttPublisher = mqttPublisher;
        this.bridge = bridge;
        this.objectMapper = objectMapper;
        this.zoneRepository = zoneRepository;
        this.notificationService = notificationService;
    }

    @PostConstruct
    public void initFromDatabase() {
        zoneRepository.findAll().forEach(z -> {
            ObjectNode snapshot = objectMapper.createObjectNode();
            snapshot.put("zone_id", z.getZoneId());
            snapshot.put("zone_name", z.getZoneName());
            snapshot.put("current_device_state", z.getDeviceState());
            snapshot.put("valve_state", z.getValveState());
            snapshot.put("temperature", z.getTemperature());
            snapshot.put("moisture", z.getMoisture());
            snapshot.put("water_level", z.getWaterLevel());
            zoneSnapshots.put(z.getZoneId(), snapshot);
        });
        System.out.println("[ZoneService] Loaded " + zoneSnapshots.size() + " zones from database.");
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
        
        String oldState = snapshot.path("current_device_state").asText("UNKNOWN");

        // Accept zone_name, device_state, valve_state from flat payloads (summary / state)
        if (payload.has("zone_name")) snapshot.put("zone_name", payload.path("zone_name").asText());
        if (payload.has("current_device_state")) snapshot.put("current_device_state", payload.path("current_device_state").asText());
        if (payload.has("device_state")) snapshot.put("current_device_state", payload.path("device_state").asText());
        if (payload.has("valve_state")) snapshot.put("valve_state", payload.path("valve_state").asText());

        // Accept sensor values from flat payloads (dashboard summary)
        if (payload.has("temperature")) snapshot.put("temperature", payload.path("temperature").asDouble(0.0));
        if (payload.has("moisture")) snapshot.put("moisture", payload.path("moisture").asDouble(0.0));
        if (payload.has("water_level")) snapshot.put("water_level", payload.path("water_level").asDouble(0.0));

        // Accept sensor values from nested sensor payloads (tazrout/zones/{id}/sensors)
        if (payload.has("sensors")) {
            // A zone sending sensors is implicitly ONLINE
            snapshot.put("current_device_state", "ONLINE");
            
            JsonNode sensors = payload.get("sensors");
            if (sensors.has("temperature")) snapshot.put("temperature", sensors.path("temperature").path("value").asDouble(0.0));
            if (sensors.has("soil_moisture")) snapshot.put("moisture", sensors.path("soil_moisture").path("value").asDouble(0.0));
            if (sensors.has("water_level")) snapshot.put("water_level", sensors.path("water_level").path("value").asDouble(0.0));
            if (sensors.has("humidity")) snapshot.put("humidity", sensors.path("humidity").path("value").asDouble(0.0));
        }
        if (payload.has("valve_state") == false && payload.has("sensors")) {
            // valve_state from sensor pulse
            if (payload.has("valve_state")) snapshot.put("valve_state", payload.path("valve_state").asText("UNKNOWN"));
        }

        String newState = snapshot.path("current_device_state").asText("UNKNOWN");
        
        if (!oldState.equalsIgnoreCase(newState) && !"UNKNOWN".equals(oldState)) {
            String zoneName = snapshot.path("zone_name").asText(zoneId);
            if ("OFFLINE".equalsIgnoreCase(newState)) {
                notificationService.publishNotification(
                    "sensorAlert",
                    "Zone Offline: " + zoneName,
                    "Zone " + zoneName + " lost connection. Check field hardware."
                );
            } else if ("ONLINE".equalsIgnoreCase(newState)) {
                notificationService.publishNotification(
                    "aiDecision",
                    "Zone Reconnected: " + zoneName,
                    "Zone " + zoneName + " is back online."
                );
            }
        }
        
        publishSummaryAndEmergencyStatus();
    }

    public void handleZoneEvent(String topic, JsonNode payload) {
        String zoneId = extractZoneId(topic, payload);
        updateZoneSnapshot(zoneId, payload);
    }

    public void syncWithActiveZones(java.util.List<String> activeIds) {
        if (activeIds == null || activeIds.isEmpty()) return;
        
        // Remove zones from memory that are no longer in the active hardware list
        java.util.Set<String> currentIds = new java.util.HashSet<>(zoneSnapshots.keySet());
        for (String id : currentIds) {
            if (!activeIds.contains(id)) {
                zoneSnapshots.remove(id);
                System.out.println("[ZoneService] Hardware change detected: Removed zone " + id + " from active view.");
            }
        }
        publishSummaryAndEmergencyStatus();
    }

    public void clearSnapshots() {
        zoneSnapshots.clear();
        initFromDatabase(); // Refresh from DB
        publishSummaryAndEmergencyStatus();
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
            zoneNode.put("temperature", snapshot.path("temperature").asDouble(0.0));
            zoneNode.put("moisture", snapshot.path("moisture").asDouble(0.0));
            zoneNode.put("water_level", snapshot.path("water_level").asDouble(0.0));
            zones.add(zoneNode);
            
            try {
                Zone z = new Zone();
                z.setZoneId(zoneId);
                z.setZoneName(zoneNode.path("zone_name").asText());
                z.setDeviceState(zoneNode.path("device_state").asText());
                z.setValveState(zoneNode.path("valve_state").asText());
                z.setTemperature(zoneNode.path("temperature").asDouble());
                z.setMoisture(zoneNode.path("moisture").asDouble());
                z.setWaterLevel(zoneNode.path("water_level").asDouble());
                zoneRepository.save(z);
            } catch (Exception e) {}
        });
        summary.put("total_zones", zoneSnapshots.size());
        summary.put("_source", "backend");
        String summaryJson = summary.toString();
        mqttPublisher.publish(MqttTopics.DASHBOARD_SUMMARY, summaryJson, 1, false);
        bridge.forward(MqttTopics.DASHBOARD_SUMMARY, summaryJson);

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
        String emergencyJson = emergency.toString();
        mqttPublisher.publish(MqttTopics.SYSTEM_EMERGENCY_STATUS, emergencyJson, 1, true);
        bridge.forward(MqttTopics.SYSTEM_EMERGENCY_STATUS, emergencyJson);
    }

    public void pushSnapshotToSession(org.springframework.web.socket.WebSocketSession session) {
        if (zoneSnapshots.isEmpty()) return;
        try {
            ObjectNode summary = objectMapper.createObjectNode();
            ArrayNode zones = summary.putArray("zones");
            zoneSnapshots.forEach((id, snap) -> zones.add(snap.deepCopy()));
            summary.put("total_zones", zoneSnapshots.size());
            session.sendMessage(new org.springframework.web.socket.TextMessage(
                objectMapper.writeValueAsString(java.util.Map.of("topic", MqttTopics.DASHBOARD_SUMMARY, "payload", summary.toString()))
            ));

            ObjectNode emergency = objectMapper.createObjectNode();
            emergency.set("zones", zones.deepCopy());
            long offline = zoneSnapshots.values().stream()
                    .filter(v -> "OFFLINE".equalsIgnoreCase(v.path("current_device_state").asText()))
                    .count();
            String systemStatus = "OPERATIONAL";
            if (zoneSnapshots.size() > 0 && offline * 2 >= zoneSnapshots.size()) systemStatus = "CRITICAL";
            else if (offline > 0) systemStatus = "DEGRADED";
            emergency.put("system_status", systemStatus);
            
            session.sendMessage(new org.springframework.web.socket.TextMessage(
                objectMapper.writeValueAsString(java.util.Map.of("topic", MqttTopics.SYSTEM_EMERGENCY_STATUS, "payload", emergency.toString()))
            ));
        } catch (Exception e) {}
    }
}
