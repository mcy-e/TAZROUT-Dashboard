/*
 * FILE: EnvStatsDto.java
 * PURPOSE: Data transfer object for environmental statistics (temperature
 *          and moisture trends) on the Analytics screen.
 *          Published on topic: tazrout/analytics/environmental/{period}
 *
 *          JSON shape:
 *            {
 *              "temperature": {
 *                "average": 24.0, "unit": "°C",
 *                "trend": [{ "timestamp", "value" }, ...]
 *              },
 *              "moisture": {
 *                "average": 45.0, "unit": "%",
 *                "trend": [{ "timestamp", "value" }, ...]
 *              }
 *            }
 *
 * MQTT TOPICS: tazrout/analytics/environmental/{period}
 * DATABASE: N/A (aggregated from sensor_readings)
 * DEPENDENCIES: AnalyticsService
 * IMPLEMENTED BY: Mr. Fehis
 */
