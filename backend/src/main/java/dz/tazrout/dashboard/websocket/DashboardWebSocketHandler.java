/*
 * FILE: DashboardWebSocketHandler.java
 * PURPOSE: Handles incoming WebSocket connections from the Flutter desktop app.
 *          Processes handshake, receives client messages (subscriptions, commands),
 *          and delegates session lifecycle to WebSocketSessionManager.
 *          Endpoint: /api/v1/ws/realtime
 * MQTT TOPICS: N/A (receives relayed data from MqttWebSocketBridge)
 * DATABASE: N/A
 * DEPENDENCIES: WebSocketSessionManager, Jackson (JSON parsing)
 * IMPLEMENTED BY: Mr. Fehis
 */
package dz.tazrout.dashboard.websocket;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import dz.tazrout.dashboard.mqtt.MqttPublisher;
import dz.tazrout.dashboard.mqtt.MqttTopics;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

@Component
public class DashboardWebSocketHandler extends TextWebSocketHandler {
    private static final Logger log = LoggerFactory.getLogger(DashboardWebSocketHandler.class);
    private final WebSocketSessionManager sessionManager;
    private final MqttPublisher mqttPublisher;
    private final ObjectMapper objectMapper;

    public DashboardWebSocketHandler(
            WebSocketSessionManager sessionManager,
            MqttPublisher mqttPublisher,
            ObjectMapper objectMapper) {
        this.sessionManager = sessionManager;
        this.mqttPublisher = mqttPublisher;
        this.objectMapper = objectMapper;
    }

    @Override
    public void afterConnectionEstablished(WebSocketSession session) {
        sessionManager.addSession(session);
    }

    @Override
    protected void handleTextMessage(WebSocketSession session, TextMessage message) {
        try {
            JsonNode root = objectMapper.readTree(message.getPayload());
            JsonNode topicNode = root.get("topic");
            JsonNode payloadNode = root.get("payload");
            if (topicNode == null || topicNode.isNull() || payloadNode == null || payloadNode.isNull()) {
                log.warn("Ignoring WS command from {} due to missing topic/payload", session.getId());
                return;
            }

            String topic = topicNode.asText();
            if (!isAllowedDashboardTopic(topic)) {
                log.warn("Rejected WS publish from {} to unauthorized topic {}", session.getId(), topic);
                return;
            }

            int qos = root.path("qos").asInt(1);
            boolean retained = root.path("retained").asBoolean(false);
            String payload = payloadNode.isTextual() ? payloadNode.asText() : payloadNode.toString();
            mqttPublisher.publish(topic, payload, qos, retained);
            log.info("Relayed WS command from {} to MQTT topic {}", session.getId(), topic);
        } catch (Exception ex) {
            log.warn("Failed to process WS command from {}: {}", session.getId(), ex.getMessage());
        }
    }

    @Override
    public void afterConnectionClosed(WebSocketSession session, CloseStatus status) {
        sessionManager.removeSession(session);
    }

    private boolean isAllowedDashboardTopic(String topic) {
        return MqttTopics.SYSTEM_CONTROL.equals(topic)
                || MqttTopics.SYSTEM_EMERGENCY_STOP.equals(topic)
                || MqttTopics.SETTINGS_PREFERENCES.equals(topic);
    }
}
