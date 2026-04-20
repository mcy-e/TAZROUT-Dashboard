/*
 * FILE: SensorReadingDto.java
 * PURPOSE: Data transfer object for individual sensor reading data points.
 *          Used in performance metrics and analytics responses.
 *
 *          JSON shape:
 *            { "reading_id", "zone_id", "timestamp",
 *              "temperature", "moisture", "water_output", "humidity" }
 *
 * MQTT TOPICS: Embedded in tazrout/dashboard/performance/{period} payloads
 * DATABASE: N/A (maps from SensorReading entity)
 * DEPENDENCIES: SensorReading entity (source mapping)
 * IMPLEMENTED BY: Mr. Fehis
 */
