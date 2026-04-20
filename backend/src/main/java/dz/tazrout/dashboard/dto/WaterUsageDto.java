/*
 * FILE: WaterUsageDto.java
 * PURPOSE: Data transfer object for historical water usage chart data.
 *          Published on topic: tazrout/analytics/water-usage/{period}
 *
 *          JSON shape:
 *            {
 *              "period": "month",
 *              "data": [{ "label": "Jan", "value": 400 }, ...],
 *              "unit": "liters"
 *            }
 *
 * MQTT TOPICS: tazrout/analytics/water-usage/{period}
 * DATABASE: N/A (aggregated from sensor_readings)
 * DEPENDENCIES: AnalyticsService
 * IMPLEMENTED BY: Mr. Fehis
 */
