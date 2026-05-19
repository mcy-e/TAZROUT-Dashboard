/*
 * FILE: PreferencesService.java
 * PURPOSE: Persists and retrieves user preference settings from the
 *          single-row user_preferences table. Handles bidirectional
 *          sync: Flutter publishes updates, backend persists and
 *          re-publishes confirmed state.
 * MQTT TOPICS:
 *   Subscribes (via MqttSubscriber): tazrout/settings/preferences (inbound from Flutter)
 *   Triggers publish on: tazrout/settings/preferences (confirmed state back to Flutter)
 * DATABASE: user_preferences (read/write)
 * DEPENDENCIES: UserPreferencesRepository, MqttPublisher
 * IMPLEMENTED BY: Mr. Fehis
 */
package dz.tazrout.dashboard.service;

import com.fasterxml.jackson.databind.JsonNode;
import dz.tazrout.dashboard.mqtt.MqttPublisher;
import dz.tazrout.dashboard.mqtt.MqttTopics;
import org.springframework.stereotype.Service;

@Service
public class PreferencesService {
    private final MqttPublisher mqttPublisher;
    private volatile JsonNode latestPreferences;

    public PreferencesService(MqttPublisher mqttPublisher) {
        this.mqttPublisher = mqttPublisher;
    }

    public void handlePreferencesUpdate(JsonNode payload) {
        latestPreferences = payload;
        mqttPublisher.publish(MqttTopics.SETTINGS_PREFERENCES, payload.toString(), 1, false);
    }

    public JsonNode getLatestPreferences() {
        return latestPreferences;
    }
}
