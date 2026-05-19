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
import dz.tazrout.dashboard.model.AiDecision;
import dz.tazrout.dashboard.mqtt.MqttPublisher;
import dz.tazrout.dashboard.mqtt.MqttTopics;
import dz.tazrout.dashboard.mqtt.MqttWebSocketBridge;
import dz.tazrout.dashboard.repository.AiDecisionRepository;
import java.util.Deque;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ConcurrentLinkedDeque;
import jakarta.annotation.PostConstruct;
import org.springframework.stereotype.Service;

@Service
public class AiDecisionService {
    private final Deque<JsonNode> decisions = new ConcurrentLinkedDeque<>();
    private final Map<String, Integer> lastZoneDecision = new ConcurrentHashMap<>();
    private final MqttPublisher mqttPublisher;
    private final MqttWebSocketBridge bridge;
    private final ObjectMapper objectMapper;
    private final AiDecisionRepository aiDecisionRepository;
    private final NotificationService notificationService;

    public AiDecisionService(MqttPublisher mqttPublisher, MqttWebSocketBridge bridge, ObjectMapper objectMapper, AiDecisionRepository aiDecisionRepository, NotificationService notificationService) {
        this.mqttPublisher = mqttPublisher;
        this.bridge = bridge;
        this.objectMapper = objectMapper;
        this.aiDecisionRepository = aiDecisionRepository;
        this.notificationService = notificationService;
    }

    @PostConstruct
    public void initFromDatabase() {
        aiDecisionRepository.findTop100ByOrderByDecisionDateDesc().forEach(decision -> {
            try {
                ObjectNode node = objectMapper.createObjectNode();
                node.put("decision_id", decision.getDecisionId());
                node.put("decision_date", decision.getDecisionDate());
                node.put("decision_type", decision.getDecisionType());
                node.putArray("affected_zones").add(decision.getAffectedZones());
                node.put("description", decision.getDescription());
                node.put("notes", decision.getNotes());
                node.put("farmer_advice", decision.getFarmerAdvice());
                // findTop100 returns latest first, so addLast to preserve order in Deque
                decisions.addLast(node);
            } catch (Exception e) {}
        });
        System.out.println("[AiDecisionService] Loaded " + decisions.size() + " decisions from database.");
    }

    public void pushSnapshotToSession(org.springframework.web.socket.WebSocketSession session) {
        if (decisions.isEmpty()) return;
        try {
            ObjectNode latest = objectMapper.createObjectNode();
            ArrayNode array = latest.putArray("items");
            // Send at most 50 to keep the message size small
            decisions.stream().limit(50).forEach(array::add);
            String snapshotJson = latest.toString();
            session.sendMessage(new org.springframework.web.socket.TextMessage(
                objectMapper.writeValueAsString(java.util.Map.of("topic", MqttTopics.AI_DECISIONS_LATEST, "payload", snapshotJson))
            ));
        } catch (Exception e) {}
    }

    public void handleDecision(JsonNode payload) {
        // Accept both camelCase (simulator) and snake_case (AI Engine)
        String zoneId = payload.has("zoneId") ? payload.path("zoneId").asText() : payload.path("zone_id").asText();
        int irrigate = payload.path("irrigate").asInt(
            "IRRIGATE".equalsIgnoreCase(payload.path("action").asText()) ? 1 : 0
        );
        
        Integer lastDecision = lastZoneDecision.get(zoneId);
        if (irrigate == 0 && lastDecision != null && lastDecision == 0) {
            return;
        }
        lastZoneDecision.put(zoneId, irrigate);

        ObjectNode flutterPayload = buildFlutterPayload(payload);

        decisions.addFirst(flutterPayload);
        while (decisions.size() > 100) {
            decisions.removeLast();
        }

        try {
            AiDecision decision = new AiDecision();
            decision.setDecisionId(flutterPayload.path("decision_id").asText());
            decision.setDecisionDate(flutterPayload.path("decision_date").asText());
            decision.setDecisionType(flutterPayload.path("decision_type").asText());
            decision.setAffectedZones(zoneId);
            decision.setDescription(flutterPayload.path("description").asText());
            decision.setNotes(flutterPayload.path("notes").asText());
            decision.setFarmerAdvice(flutterPayload.path("farmer_advice").asText());
            aiDecisionRepository.save(decision);
        } catch (Exception e) {
            System.err.println("[AiDecisionService] Failed to save decision: " + e.getMessage());
        }

        bridge.forward(MqttTopics.AI_DECISIONS, flutterPayload.toString());
        publishLatestSnapshot();
    }

    private ObjectNode buildFlutterPayload(JsonNode raw) {
        ObjectNode out = objectMapper.createObjectNode();
        String zoneId = raw.has("zoneId") ? raw.path("zoneId").asText() : raw.path("zone_id").asText();
        int irrigate = 0;
        if (raw.has("irrigate")) {
            irrigate = raw.path("irrigate").asInt(0);
        } else if (raw.has("action")) {
            irrigate = "IRRIGATE".equalsIgnoreCase(raw.path("action").asText()) ? 1 : 0;
        }
        double waterAmount = Math.abs(raw.path("waterAmount").asDouble(raw.path("water_amount").asDouble(0.0)));
        double confidence = raw.path("confidenceScore").asDouble(raw.path("confidence").asDouble(1.0));

        // IRRIGATION: AI says irrigate. ALERT: very low confidence = critical uncertainty.
        // ADVICE: AI confirms chill conditions — no action needed.
        String decisionType;
        if (irrigate == 1 && confidence < 0.5) {
            decisionType = "ALERT";
        } else if (irrigate == 1) {
            decisionType = "IRRIGATION";
        } else {
            decisionType = "ADVICE";
        }

        String description = irrigate == 1
            ? String.format("Irrigate %s — apply %.1f L", zoneId, waterAmount)
            : String.format("Conditions normal for %s — no irrigation needed.", zoneId);
        String notes = raw.has("notes") && !raw.path("notes").asText().trim().isEmpty() 
            ? raw.path("notes").asText().trim() 
            : (irrigate == 1
                ? "Soil moisture is below the critical threshold."
                : "Conditions are within normal range.");
            
        String advice;
        if (raw.has("farmerAdvice") && !raw.path("farmerAdvice").asText().trim().isEmpty()) {
            advice = raw.path("farmerAdvice").asText().trim();
        } else if (raw.has("farmer_advice") && !raw.path("farmer_advice").asText().trim().isEmpty()) {
            advice = raw.path("farmer_advice").asText().trim();
        } else {
            advice = irrigate == 1
                ? "Check the fertilizer tank levels before the next cycle."
                : "Continue monitoring; review weather forecast before next check.";
        }

        // Irrigation: user-friendly info notification
        if ("IRRIGATION".equals(decisionType)) {
            notificationService.publishNotification(
                "aiDecision",
                "Irrigation Triggered: " + zoneId,
                String.format("AI ordered %.1f L for %s.", waterAmount, zoneId)
            );
        }
        // Alert: critical warning
        if ("ALERT".equals(decisionType)) {
            notificationService.publishNotification(
                "sensorAlert",
                "AI Critical Alert: " + zoneId,
                "Low confidence irrigation decision — manual inspection recommended."
            );
        }

        out.put("decision_id", java.util.UUID.randomUUID().toString());
        out.put("decision_date", java.time.Instant.now().toString());
        out.put("decision_type", decisionType);
        out.putArray("affected_zones").add(zoneId);
        out.put("description", description);
        out.put("notes", notes);
        out.put("farmer_advice", advice);
        return out;
    }

    private void publishLatestSnapshot() {
        ObjectNode latest = objectMapper.createObjectNode();
        ArrayNode array = latest.putArray("items");
        decisions.stream().limit(10).forEach(array::add);
        String snapshotJson = latest.toString();
        mqttPublisher.publish(MqttTopics.AI_DECISIONS_LATEST, snapshotJson, 1, true);
        // Forward retained snapshot to WebSocket so reconnecting clients get history
        bridge.forward(MqttTopics.AI_DECISIONS_LATEST, snapshotJson);
    }
}
