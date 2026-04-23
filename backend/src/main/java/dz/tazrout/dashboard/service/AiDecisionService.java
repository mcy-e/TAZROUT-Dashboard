/*
 * FILE: AiDecisionService.java
 * PURPOSE: Receives and stores AI irrigation decisions published by the
 *          AI Engine (a separate co-located service). The AI Engine
 *          subscribes to sensor topics, runs its trained model, and
 *          publishes decisions on tazrout/ai/decisions.
 *
 *          This service does NOT run the AI model — it only:
 *            - Persists incoming AI decisions to the ai_decisions table
 *            - Provides paginated query access for the dashboard
 *            - Relays the latest decision to Flutter via WebSocket bridge
 *
 * MQTT TOPICS:
 *   Receives (via MqttSubscriber):
 *     tazrout/ai/decisions              ← all AI decisions
 *     tazrout/ai/decisions/latest       ← latest decision (retained)
 *     tazrout/ai/alerts                 ← critical AI alerts
 * DATABASE: ai_decisions (read/write)
 * DEPENDENCIES: AiDecisionRepository, MqttPublisher
 * IMPLEMENTED BY: Mr. Fehis
 */
package dz.tazrout.dashboard.service;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ArrayNode;
import com.fasterxml.jackson.databind.node.ObjectNode;
import dz.tazrout.dashboard.mqtt.MqttPublisher;
import dz.tazrout.dashboard.mqtt.MqttTopics;
import java.util.Deque;
import java.util.concurrent.ConcurrentLinkedDeque;
import org.springframework.stereotype.Service;

@Service
public class AiDecisionService {
    private final Deque<JsonNode> decisions = new ConcurrentLinkedDeque<>();
    private final MqttPublisher mqttPublisher;
    private final ObjectMapper objectMapper;

    public AiDecisionService(MqttPublisher mqttPublisher, ObjectMapper objectMapper) {
        this.mqttPublisher = mqttPublisher;
        this.objectMapper = objectMapper;
    }

    public void handleDecision(JsonNode payload) {
        decisions.addFirst(payload);
        while (decisions.size() > 100) {
            decisions.removeLast();
        }
        publishLatestSnapshot();
    }

    private void publishLatestSnapshot() {
        ObjectNode latest = objectMapper.createObjectNode();
        ArrayNode array = latest.putArray("items");
        decisions.stream().limit(10).forEach(array::add);
        mqttPublisher.publish(MqttTopics.AI_DECISIONS_LATEST, latest.toString(), 1, true);
    }
}
