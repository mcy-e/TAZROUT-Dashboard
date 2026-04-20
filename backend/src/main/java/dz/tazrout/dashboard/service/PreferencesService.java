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
