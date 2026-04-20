/*
 * FILE: ZoneServiceTest.java
 * PURPOSE: Unit tests for ZoneService business logic.
 *          Test cases to implement:
 *            - getAllZones returns all zones from repository
 *            - getZoneById returns correct zone
 *            - getZoneById throws when zone not found
 *            - processValveCommand updates valve_state and publishes via MQTT
 *            - updateZoneFromSensor updates zone fields and last_updated
 *            - offline zone detection triggers NotificationService alert
 * MQTT TOPICS: N/A (mocked in tests)
 * DATABASE: N/A (mocked in tests)
 * DEPENDENCIES: ZoneService, ZoneRepository (mock), MqttPublisher (mock), JUnit 5, Mockito
 * IMPLEMENTED BY: Mr. Fehis
 */
