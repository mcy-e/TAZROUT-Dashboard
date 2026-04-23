/*
 * FILE: MqttPublisher.java
 * PURPOSE: Publishes JSON messages to the Mosquitto MQTT broker on
 *          specific topics. Used by service layer to push processed data
 *          to the dashboard and other MQTT subscribers.
 *
 *          The backend publishes data it has processed/aggregated.
 *          The AI Engine and LoRa Gateway publish their own topics
 *          independently (they are separate MQTT clients).
 *
 * MQTT TOPICS:
 *   Publishes to:
 *     tazrout/dashboard/summary                 ← aggregated dashboard data
 *     tazrout/dashboard/performance/{period}     ← performance graph data
 *     tazrout/dashboard/notifications            ← push notifications to Flutter
 *     tazrout/analytics/water-usage/{period}
 *     tazrout/analytics/environmental/{period}
 *     tazrout/analytics/consumption/{period}
 *     tazrout/system/backend/status              ← backend online/offline (retained, LWT)
 *     tazrout/system/emergency/status            ← current emergency state (retained)
 *     tazrout/settings/preferences               ← confirmed preference state
 *     tazrout/support/contact                    ← contact info
 *
 * DATABASE: N/A
 * DEPENDENCIES: MqttConfig (connection factory), MqttTopics (topic constants), Jackson (JSON serialization)
 * IMPLEMENTED BY: Mr. Fehis
 */
package dz.tazrout.dashboard.mqtt;

import jakarta.annotation.PreDestroy;
import java.util.UUID;
import org.eclipse.paho.client.mqttv3.MqttAsyncClient;
import org.eclipse.paho.client.mqttv3.MqttConnectOptions;
import org.eclipse.paho.client.mqttv3.MqttException;
import org.eclipse.paho.client.mqttv3.MqttMessage;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

@Component
public class MqttPublisher {
    private static final Logger log = LoggerFactory.getLogger(MqttPublisher.class);
    private final MqttAsyncClient client;

    public MqttPublisher(
            MqttConnectOptions connectOptions,
            @Value("${mqtt.broker.url:tcp://localhost:1883}") String brokerUrl,
            @Value("${mqtt.client.id:tazrout-backend}") String clientId) throws MqttException {
        this.client = new MqttAsyncClient(brokerUrl, clientId + "-publisher-" + UUID.randomUUID());
        this.client.connect(connectOptions).waitForCompletion();
    }

    public void publish(String topic, String payload) {
        publish(topic, payload, 1, false);
    }

    public void publish(String topic, String payload, int qos, boolean retained) {
        try {
            MqttMessage message = new MqttMessage(payload.getBytes());
            message.setQos(qos);
            message.setRetained(retained);
            client.publish(topic, message);
        } catch (MqttException ex) {
            log.error("Failed to publish MQTT topic {}: {}", topic, ex.getMessage(), ex);
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
            log.warn("Error closing MQTT publisher: {}", ex.getMessage());
        }
    }
}
