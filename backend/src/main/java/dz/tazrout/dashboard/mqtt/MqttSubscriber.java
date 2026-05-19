/*
 * FILE: MqttSubscriber.java
 * PURPOSE: Subscribes to inbound MQTT topics from the Mosquitto broker.
 *          Routes incoming messages to the appropriate service handlers.
 *
 *          Key data sources this subscribes to:
 *            - LoRa Gateway sensor readings (raw field data from ESP32 nodes)
 *            - AI Engine decisions and valve commands
 *            - AI Engine emergency alerts
 *            - Gateway heartbeats and state changes
 *            - Command acknowledgments from field MCUs (via gateway)
 *            - Flutter dashboard system control commands
 *            - Flutter dashboard preference updates
 *
 * MQTT TOPICS:
 *   Subscribes to:
 *     tazrout/zones/{zoneId}/sensors         ← LoRa Gateway publishes sensor readings
 *     tazrout/zones/{zoneId}/state           ← LoRa Gateway publishes device state changes
 *     tazrout/zones/{zoneId}/valve/ack       ← Gateway confirms valve command execution
 *     tazrout/ai/decisions                   ← AI Engine publishes irrigation decisions
 *     tazrout/ai/decisions/latest            ← AI Engine publishes latest decision (retained)
 *     tazrout/ai/alerts                      ← AI Engine publishes critical alerts
 *     tazrout/system/gateway/heartbeat       ← LoRa Gateway heartbeat
 *     tazrout/system/gateway/status          ← LoRa Gateway online/offline
 *     tazrout/system/control                 ← Flutter sends reboot/shutdown
 *     tazrout/system/emergency/stop          ← Flutter sends emergency stop
 *     tazrout/settings/preferences           ← Flutter sends preference updates
 *
 * DATABASE: N/A (delegates to service layer)
 * DEPENDENCIES: MqttConfig, MqttTopics, SensorService, ZoneService,
 *               AiDecisionService, PreferencesService, NotificationService
 * IMPLEMENTED BY: Mr. Fehis
 */
package dz.tazrout.dashboard.mqtt;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import dz.tazrout.dashboard.service.AiDecisionService;
import dz.tazrout.dashboard.service.NotificationService;
import dz.tazrout.dashboard.service.PreferencesService;
import dz.tazrout.dashboard.service.SensorService;
import dz.tazrout.dashboard.service.ZoneService;
import jakarta.annotation.PreDestroy;
import java.nio.charset.StandardCharsets;
import java.util.UUID;
import org.eclipse.paho.client.mqttv3.IMqttDeliveryToken;
import org.eclipse.paho.client.mqttv3.MqttAsyncClient;
import org.eclipse.paho.client.mqttv3.MqttCallback;
import org.eclipse.paho.client.mqttv3.MqttConnectOptions;
import org.eclipse.paho.client.mqttv3.MqttException;
import org.eclipse.paho.client.mqttv3.MqttMessage;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

@Component
public class MqttSubscriber implements MqttCallback {
    private static final Logger log = LoggerFactory.getLogger(MqttSubscriber.class);

    private final ObjectMapper objectMapper;
    private final SensorService sensorService;
    private final ZoneService zoneService;
    private final AiDecisionService aiDecisionService;
    private final PreferencesService preferencesService;
    private final NotificationService notificationService;
    private final MqttWebSocketBridge mqttWebSocketBridge;
    private final MqttAsyncClient client;
    private final MqttConnectOptions connectOptions;

    public MqttSubscriber(
            ObjectMapper objectMapper,
            SensorService sensorService,
            ZoneService zoneService,
            AiDecisionService aiDecisionService,
            PreferencesService preferencesService,
            NotificationService notificationService,
            MqttWebSocketBridge mqttWebSocketBridge,
            MqttConnectOptions connectOptions,
            @Value("${mqtt.broker.url:tcp://localhost:1883}") String brokerUrl,
            @Value("${mqtt.client.id:tazrout-backend}") String clientId) throws MqttException {
        this.objectMapper = objectMapper;
        this.sensorService = sensorService;
        this.zoneService = zoneService;
        this.aiDecisionService = aiDecisionService;
        this.preferencesService = preferencesService;
        this.notificationService = notificationService;
        this.mqttWebSocketBridge = mqttWebSocketBridge;
        this.connectOptions = connectOptions;
        this.client = new MqttAsyncClient(brokerUrl, clientId + "-" + UUID.randomUUID());
        initialize();
    }

    private void initialize() throws MqttException {
        client.setCallback(this);
        client.connect(connectOptions).waitForCompletion();
        client.subscribe(MqttTopics.ROOT_WILDCARD, 1).waitForCompletion();
        log.info("Connected to MQTT and subscribed to {}", MqttTopics.ROOT_WILDCARD);
    }

    public void publish(String topic, MqttMessage message) throws MqttException {
        client.publish(topic, message);
    }

    @Override
    public void connectionLost(Throwable cause) {
        log.warn("MQTT connection lost: {}", cause.getMessage());
    }

    @Override
    public void messageArrived(String topic, MqttMessage message) throws Exception {
        String payload = new String(message.getPayload(), StandardCharsets.UTF_8);
        mqttWebSocketBridge.forward(topic, payload);
        JsonNode json = parsePayload(payload);

        if (MqttTopics.isZoneSensorTopic(topic)) {
            sensorService.handleSensorReading(topic, json);
            return;
        }
        if (MqttTopics.isZoneStateTopic(topic) || MqttTopics.isZoneValveAckTopic(topic)) {
            zoneService.handleZoneEvent(topic, json);
            return;
        }
        // Process dashboard summary as a zone snapshot seed — skip if published by backend itself
        if (MqttTopics.DASHBOARD_SUMMARY.equals(topic)) {
            if ("backend".equals(json.path("_source").asText())) {
                return;
            }
            JsonNode zones = json.path("zones");
            if (zones.isArray()) {
                java.util.List<String> activeIds = new java.util.ArrayList<>();
                zones.forEach(z -> {
                    String zoneId = z.path("zone_id").asText();
                    if (!zoneId.isEmpty()) {
                        activeIds.add(zoneId);
                        zoneService.updateZoneSnapshot(zoneId, z);
                    }
                });
                // Remove ghost zones that are not in this live hardware summary
                zoneService.syncWithActiveZones(activeIds);
            }
            return;
        }
        if (MqttTopics.AI_DECISIONS.equals(topic) || MqttTopics.AI_DECISIONS_LATEST.equals(topic)) {
            aiDecisionService.handleDecision(json);
            return;
        }
        if (MqttTopics.AI_ALERTS.equals(topic) || MqttTopics.SYSTEM_EMERGENCY_ALERT.equals(topic)) {
            notificationService.handleEmergencyAlert(json);
            return;
        }
        if (MqttTopics.SYSTEM_GATEWAY_HEARTBEAT.equals(topic) || MqttTopics.SYSTEM_GATEWAY_STATUS.equals(topic)) {
            notificationService.handleGatewaySignal(json);
            return;
        }
        if (MqttTopics.SETTINGS_PREFERENCES.equals(topic)) {
            preferencesService.handlePreferencesUpdate(json);
            return;
        }
        if (MqttTopics.SYSTEM_CONTROL.equals(topic) || MqttTopics.SYSTEM_EMERGENCY_STOP.equals(topic)) {
            notificationService.handleSystemControl(topic, json);
            String cmd = json.path("command").asText("");
            if ("REBOOT".equalsIgnoreCase(cmd) || "SHUTDOWN".equalsIgnoreCase(cmd)) {
                System.out.println("[MqttSubscriber] REBOOT command received. Purging ghost data and resyncing...");
                zoneService.clearSnapshots();
            }
        }
    }

    @Override
    public void deliveryComplete(IMqttDeliveryToken token) {
    }

    private JsonNode parsePayload(String payload) {
        try {
            return objectMapper.readTree(payload);
        } catch (Exception ignored) {
            return objectMapper.createObjectNode().put("raw_payload", payload);
        }
    }

    @PreDestroy
    public void close() {
        try {
            if (client.isConnected()) {
                client.disconnect().waitForCompletion();
            }
            client.close();
        } catch (MqttException ex) {
            log.warn("Error closing MQTT client: {}", ex.getMessage());
        }
    }
}
