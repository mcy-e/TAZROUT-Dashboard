/*
 * FILE: ZoneDto.java
 * PURPOSE: Data transfer object for zone data sent to Flutter via MQTT/WebSocket.
 *          Serialized as JSON matching the payload format in docs/MQTT_TOPICS.md
 *          for topics: tazrout/zones/{zoneId}/status, tazrout/zones/all
 *
 *          JSON shape:
 *            { "zone_id", "zone_name", "device_state", "valve_state",
 *              "temperature", "moisture", "water_level", "last_updated" }
 *
 * MQTT TOPICS: tazrout/zones/{zoneId}/status, tazrout/zones/all
 * DATABASE: N/A (maps from Zone entity)
 * DEPENDENCIES: Zone entity (source mapping)
 * IMPLEMENTED BY: Mr. Fehis
 */
