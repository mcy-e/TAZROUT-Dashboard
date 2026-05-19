/*
 * FILE: NotificationService.java
 * PURPOSE: Triggers MQTT alert messages and push notifications to the
 *          Flutter dashboard. Evaluates incoming data from multiple sources:
 *
 *          - Sensor thresholds (temperature, moisture out of range)
 *          - Device state changes (zone goes OFFLINE)
 *          - AI Engine alerts (critical decisions, emergency irrigation)
 *          - Gateway heartbeat timeouts (no heartbeat > 90 seconds)
 *
 *          Publishes push notifications to the dashboard and updates
 *          the emergency status.
 *
 * MQTT TOPICS:
 *   Triggers publish on:
 *     tazrout/dashboard/notifications     ← push notifications to Flutter UI
 *     tazrout/system/emergency/status     ← emergency state updates (retained)
 *   Receives (via MqttSubscriber):
 *     tazrout/ai/alerts                   ← critical alerts from AI Engine
 *     tazrout/system/emergency/alert      ← emergency broadcasts
 *     tazrout/system/gateway/heartbeat    ← monitors gateway liveness
 * DATABASE: zones (read — for threshold evaluation)
 * DEPENDENCIES: ZoneRepository, MqttPublisher
 * IMPLEMENTED BY: Mr. Fehis
 */
package dz.tazrout.dashboard.service;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;
import dz.tazrout.dashboard.mqtt.MqttPublisher;
import dz.tazrout.dashboard.mqtt.MqttTopics;
import dz.tazrout.dashboard.mqtt.MqttWebSocketBridge;
import java.time.Instant;
import java.util.UUID;
import org.springframework.stereotype.Service;

@Service
public class NotificationService {
    private final MqttPublisher mqttPublisher;
    private final MqttWebSocketBridge bridge;
    private final ObjectMapper objectMapper;

    public NotificationService(MqttPublisher mqttPublisher, MqttWebSocketBridge bridge, ObjectMapper objectMapper) {
        this.mqttPublisher = mqttPublisher;
        this.bridge = bridge;
        this.objectMapper = objectMapper;
    }

    public void handleEmergencyAlert(JsonNode payload) {
        String payloadStr = payload.toString();
        mqttPublisher.publish(MqttTopics.SYSTEM_EMERGENCY_STATUS, payloadStr, 1, true);
        bridge.forward(MqttTopics.SYSTEM_EMERGENCY_STATUS, payloadStr);
        publishNotification("sensorAlert", "Emergency alert", payload.path("message").asText("Emergency reported"));
    }

    public void handleGatewaySignal(JsonNode payload) {
        if ("OFFLINE".equalsIgnoreCase(payload.path("status").asText())) {
            publishNotification("sensorAlert", "Gateway offline", "Gateway reported offline status");
        }
    }

    public void handleSystemControl(String topic, JsonNode payload) {
        String message = payload.path("command").asText("EMERGENCY_STOP");
        publishNotification("aiDecision", "System control received", topic + ": " + message);
    }

    public void publishNotification(String type, String title, String message) {
        ObjectNode node = objectMapper.createObjectNode();
        node.put("id", "NOTIF-" + UUID.randomUUID());
        node.put("type", type);
        node.put("title", title);
        node.put("message", message);
        node.put("timestamp", Instant.now().toString());
        String notificationStr = node.toString();
        mqttPublisher.publish(MqttTopics.DASHBOARD_NOTIFICATIONS, notificationStr, 1, false);
        bridge.forward(MqttTopics.DASHBOARD_NOTIFICATIONS, notificationStr);
    }
}
