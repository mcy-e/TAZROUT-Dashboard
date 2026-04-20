/*
 * FILE: ConsumptionByZoneDto.java
 * PURPOSE: Data transfer object for per-zone resource consumption
 *          breakdown on the Analytics screen bar charts.
 *          Published on topic: tazrout/analytics/consumption/{period}
 *
 *          JSON shape:
 *            {
 *              "zones": [
 *                { "zone_id", "zone_name", "water", "moisture_avg", "temperature_avg" },
 *                ...
 *              ]
 *            }
 *
 * MQTT TOPICS: tazrout/analytics/consumption/{period}
 * DATABASE: N/A (aggregated from sensor_readings + zones)
 * DEPENDENCIES: AnalyticsService
 * IMPLEMENTED BY: Mr. Fehis
 */
