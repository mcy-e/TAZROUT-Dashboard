/*
 * FILE: WebSocketSessionManager.java
 * PURPOSE: Tracks all active WebSocket sessions from Flutter desktop clients.
 *          Provides methods to broadcast messages to all sessions or send
 *          targeted messages. Handles session cleanup on disconnect.
 *          Since this is a LAN-only single-operator system, typically
 *          only one session is active at a time.
 * MQTT TOPICS: N/A
 * DATABASE: N/A
 * DEPENDENCIES: Spring WebSocket API
 * IMPLEMENTED BY: Mr. Fehis
 */
