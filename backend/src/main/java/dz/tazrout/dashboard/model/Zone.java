/*
 * FILE: Zone.java
 * PURPOSE: JPA entity representing a physical agricultural zone with its
 *          current sensor readings and device state.
 *          Maps to the "zones" PostgreSQL table.
 *
 *          Fields:
 *            zone_id       VARCHAR(20)   PK   — e.g. "zone_a"
 *            zone_name     VARCHAR(50)        — e.g. "Zone A"
 *            device_state  VARCHAR(10)        — ONLINE | OFFLINE
 *            valve_state   VARCHAR(10)        — OPEN | CLOSED
 *            temperature   DOUBLE             — °C (-50 to 60)
 *            moisture      DOUBLE             — g/m³ (0 to 2000)
 *            water_level   DOUBLE             — % (0 to 100)
 *            last_updated  TIMESTAMP          — ISO 8601 UTC
 *
 * MQTT TOPICS: N/A (data layer — consumed by ZoneService)
 * DATABASE: zones
 * DEPENDENCIES: Jakarta Persistence (JPA annotations)
 * IMPLEMENTED BY: Mr. Fehis
 */
