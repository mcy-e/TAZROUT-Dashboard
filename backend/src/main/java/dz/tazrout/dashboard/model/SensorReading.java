/*
 * FILE: SensorReading.java
 * PURPOSE: JPA entity representing a single historical sensor data point.
 *          Stores timestamped readings per zone for analytics graphs.
 *          Maps to the "sensor_readings" PostgreSQL table.
 *
 *          Fields:
 *            reading_id    VARCHAR(36)   PK   — UUID
 *            zone_id       VARCHAR(20)   FK   — references zones.zone_id
 *            timestamp     TIMESTAMP          — ISO 8601 UTC
 *            temperature   DOUBLE             — °C
 *            moisture      DOUBLE             — g/m³
 *            water_output  DOUBLE             — %
 *            humidity      DOUBLE             — %
 *
 * MQTT TOPICS: N/A (data layer — populated by SensorService)
 * DATABASE: sensor_readings
 * DEPENDENCIES: Jakarta Persistence, Zone entity (FK relationship)
 * IMPLEMENTED BY: Mr. Fehis
 */
