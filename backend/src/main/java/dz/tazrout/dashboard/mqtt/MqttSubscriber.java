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
