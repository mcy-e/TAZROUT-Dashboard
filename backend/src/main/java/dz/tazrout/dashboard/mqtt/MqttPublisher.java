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
