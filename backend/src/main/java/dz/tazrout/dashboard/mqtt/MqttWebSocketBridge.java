/*
 * FILE: MqttWebSocketBridge.java
 * PURPOSE: Bridges MQTT broker events to WebSocket sessions so the Flutter
 *          desktop app receives real-time updates. Subscribes to all
 *          relevant MQTT topics — including those published by the AI Engine
 *          and LoRa Gateway — and forwards each message as a JSON
 *          WebSocket frame to the connected Flutter session.
 *
 *          This is the critical link between the MQTT backbone and the
 *          Flutter frontend. Without this bridge, the dashboard receives
 *          no live data.
 *
 *          Flow:
 *            LoRa Gateway ─┐
 *            AI Engine ────┤── MQTT Broker ──► this bridge ──► WebSocket ──► Flutter
 *            Backend ──────┘
 *
 * MQTT TOPICS:
 *   Subscribes to tazrout/# and relays to WebSocket
 * DATABASE: N/A
 * DEPENDENCIES: MqttConfig, WebSocketSessionManager, MqttTopics, Jackson
 * IMPLEMENTED BY: Mr. Fehis
 */
