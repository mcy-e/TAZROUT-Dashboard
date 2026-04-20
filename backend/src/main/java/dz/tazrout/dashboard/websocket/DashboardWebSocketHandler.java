/*
 * FILE: DashboardWebSocketHandler.java
 * PURPOSE: Handles incoming WebSocket connections from the Flutter desktop app.
 *          Processes handshake, receives client messages (subscriptions, commands),
 *          and delegates session lifecycle to WebSocketSessionManager.
 *          Endpoint: /api/v1/ws/realtime
 * MQTT TOPICS: N/A (receives relayed data from MqttWebSocketBridge)
 * DATABASE: N/A
 * DEPENDENCIES: WebSocketSessionManager, Jackson (JSON parsing)
 * IMPLEMENTED BY: Mr. Fehis
 */
