/*
 * FILE: MqttPublisherTest.java
 * PURPOSE: Unit tests for MqttPublisher message publishing.
 *          Test cases to implement:
 *            - publish sends JSON payload to correct topic
 *            - publish uses configured QoS level
 *            - publish handles broker disconnect gracefully
 *            - publish serializes DTO to valid JSON
 *            - topic string matches MqttTopics constants
 * MQTT TOPICS: N/A (mocked broker in tests)
 * DATABASE: N/A
 * DEPENDENCIES: MqttPublisher, MqttConfig (mock), MqttTopics, JUnit 5, Mockito
 * IMPLEMENTED BY: Mr. Fehis
 */
