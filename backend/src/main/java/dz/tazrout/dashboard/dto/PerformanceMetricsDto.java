/*
 * FILE: PerformanceMetricsDto.java
 * PURPOSE: Data transfer object for Task Manager-style performance graphs
 *          on the home dashboard. Contains time-series arrays for each metric.
 *          Published on topic: tazrout/dashboard/performance/{period}
 *
 *          JSON shape:
 *            {
 *              "water_output":  [{ "timestamp", "value" }, ...],
 *              "soil_moisture": [{ "timestamp", "value" }, ...],
 *              "temperature":   [{ "timestamp", "value" }, ...],
 *              "humidity":      [{ "timestamp", "value" }, ...]
 *            }
 *
 * MQTT TOPICS: tazrout/dashboard/performance/{period}
 * DATABASE: N/A (aggregated from sensor_readings)
 * DEPENDENCIES: AnalyticsService
 * IMPLEMENTED BY: Mr. Fehis
 */
