/*
 * FILE: MqttConfig.java
 * PURPOSE: Configures connection to the Mosquitto MQTT broker.
 *          The broker is installed and managed by Mr. Lhacani (networking).
 *          Defines MqttConnectOptions, MqttPahoClientFactory,
 *          inbound/outbound channel adapters for Spring Integration MQTT.
 *          Reads broker IP and port from application.properties.
 * MQTT TOPICS: N/A (provides connection factory — topics are managed by MqttSubscriber/MqttPublisher)
 * DATABASE: N/A
 * DEPENDENCIES: spring-integration-mqtt, application.properties (mqtt.broker.url, mqtt.client.id)
 * IMPLEMENTED BY: Mr. Fehis
 */
