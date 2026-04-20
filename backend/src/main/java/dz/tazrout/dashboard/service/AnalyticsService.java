/*
 * FILE: AnalyticsService.java
 * PURPOSE: Aggregates historical sensor data into chart-ready payloads.
 *          Computes water usage trends, environmental statistics
 *          (temperature/moisture averages), and per-zone consumption
 *          breakdowns for the Analytics screen.
 *          Supports day/week/month/year period granularity.
 * MQTT TOPICS:
 *   Triggers publish on:
 *     tazrout/analytics/water-usage/{period}
 *     tazrout/analytics/environmental/{period}
 *     tazrout/analytics/consumption/{period}
 * DATABASE: sensor_readings (read), zones (read)
 * DEPENDENCIES: SensorReadingRepository, ZoneRepository, MqttPublisher
 * IMPLEMENTED BY: Mr. Fehis
 */
