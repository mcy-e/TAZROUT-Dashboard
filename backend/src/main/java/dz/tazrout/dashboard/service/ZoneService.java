/*
 * FILE: ZoneService.java
 * PURPOSE: Business logic for zone management. Processes zone state updates
 *          from the LoRa Gateway, tracks device online/offline transitions,
 *          and publishes processed zone data to the dashboard.
 *
 *          Valve commands are published exclusively by the AI Engine —
 *          the dashboard is read-only for valve control. This service
 *          receives and persists valve command acknowledgments from the
 *          field MCUs (via Gateway) to close the command loop.
 *
 * MQTT TOPICS:
 *   Receives (via MqttSubscriber):
 *     tazrout/zones/{zoneId}/state           ← device state changes from gateway
 *     tazrout/zones/{zoneId}/valve/ack       ← command ACK from MCU via gateway
 *   Triggers publish on:
 *     tazrout/dashboard/summary              ← aggregated zone data
 *     tazrout/system/emergency/status        ← if zone goes offline
 * DATABASE: zones (read/write)
 * DEPENDENCIES: ZoneRepository, MqttPublisher, NotificationService
 * IMPLEMENTED BY: Mr. Fehis
 */
