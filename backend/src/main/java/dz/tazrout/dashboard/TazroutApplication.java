/*
 * FILE: TazroutApplication.java
 * PURPOSE: Spring Boot entry point for the Tazrout Smart Irrigation backend.
 *          Bootstraps MQTT, WebSocket, JPA, and all service beans.
 *          The backend sits between the MQTT broker (managed by Mr. Lhacani)
 *          and the Flutter desktop dashboard. The AI Engine is a separate
 *          co-located service that also connects to the same MQTT broker.
 * MQTT TOPICS: N/A (delegates to MqttSubscriber and MqttPublisher)
 * DATABASE: N/A (delegates to repository layer)
 * DEPENDENCIES: Spring Boot auto-configuration, MqttConfig, DatabaseConfig, WebSocketConfig
 * IMPLEMENTED BY: Mr. Fehis
 */
