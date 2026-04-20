/*
 * FILE: MqttTopics.java
 * PURPOSE: Central registry of all MQTT topic string constants used
 *          throughout the backend. Prevents hardcoded topic strings
 *          in publishers/subscribers. See docs/MQTT_TOPICS.md for
 *          full topic documentation.
 *
 *          Convention: tazrout/{layer}/{zone_or_entity}/{action}
 *
 *          Topics to define:
 *
 *          --- Zone Topics (field ↔ backend ↔ dashboard) ---
 *            tazrout/zones/{zoneId}/sensors          ← gateway publishes sensor readings
 *            tazrout/zones/{zoneId}/state             ← gateway publishes device state (retained)
 *            tazrout/zones/{zoneId}/valve/command      ← AI Engine publishes valve commands
 *            tazrout/zones/{zoneId}/valve/ack          ← gateway publishes command ACK
 *            tazrout/zones/{zoneId}/alert              ← gateway or AI on zone-level anomaly
 *            tazrout/zones/all/sensors                 ← aggregated sensor feed (optional)
 *
 *          --- AI Topics ---
 *            tazrout/ai/decisions                     ← AI Engine publishes all decisions
 *            tazrout/ai/decisions/latest               ← AI Engine publishes latest (retained)
 *            tazrout/ai/alerts                         ← AI Engine publishes critical alerts
 *
 *          --- System Topics ---
 *            tazrout/system/gateway/heartbeat          ← gateway heartbeat (QoS 0)
 *            tazrout/system/gateway/status             ← gateway state (retained)
 *            tazrout/system/backend/status             ← backend status (retained, LWT)
 *            tazrout/system/control                    ← dashboard → backend commands
 *            tazrout/system/emergency/alert            ← AI/gateway critical events (QoS 2)
 *            tazrout/system/emergency/stop             ← dashboard → forces all valves closed
 *            tazrout/system/emergency/status           ← backend → dashboard (retained)
 *
 *          --- Dashboard Topics ---
 *            tazrout/dashboard/summary                ← backend aggregated summary
 *            tazrout/dashboard/performance/{period}    ← backend performance metrics
 *            tazrout/dashboard/notifications           ← backend push notifications
 *
 *          --- Settings & Support ---
 *            tazrout/settings/preferences             ← bidirectional preference sync
 *            tazrout/support/contact                  ← backend → dashboard contact info
 *
 *          --- Analytics ---
 *            tazrout/analytics/water-usage/{period}
 *            tazrout/analytics/environmental/{period}
 *            tazrout/analytics/consumption/{period}
 *
 * MQTT TOPICS: All topics listed above (constants only — no pub/sub logic)
 * DATABASE: N/A
 * DEPENDENCIES: None
 * IMPLEMENTED BY: Mr. Fehis
 */
