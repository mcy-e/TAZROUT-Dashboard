/*
 * FILE: DashboardSummaryDto.java
 * PURPOSE: Data transfer object for the home dashboard summary card.
 *          Aggregates current system metrics for topic: tazrout/dashboard/summary
 *
 *          JSON shape:
 *            {
 *              "current_metrics": { "water_output", "soil_moisture", "temperature", "humidity" },
 *              "system_info": { "server_time", "active_zones", "total_zones" },
 *              "did_you_know": { "fact" }
 *            }
 *
 * MQTT TOPICS: tazrout/dashboard/summary
 * DATABASE: N/A (aggregated from zones + sensor_readings)
 * DEPENDENCIES: ZoneService, SensorService
 * IMPLEMENTED BY: Mr. Fehis
 */
