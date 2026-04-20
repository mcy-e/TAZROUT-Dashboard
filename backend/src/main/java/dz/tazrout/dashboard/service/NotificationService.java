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
