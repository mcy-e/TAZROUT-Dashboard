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
package dz.tazrout.dashboard.websocket;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

@Component
public class DashboardWebSocketHandler extends TextWebSocketHandler {
    private static final Logger log = LoggerFactory.getLogger(DashboardWebSocketHandler.class);
    private final WebSocketSessionManager sessionManager;

    public DashboardWebSocketHandler(WebSocketSessionManager sessionManager) {
        this.sessionManager = sessionManager;
    }

    @Override
    public void afterConnectionEstablished(WebSocketSession session) {
        sessionManager.addSession(session);
    }

    @Override
    protected void handleTextMessage(WebSocketSession session, TextMessage message) {
        log.debug("Received dashboard WS message from {}: {}", session.getId(), message.getPayload());
    }

    @Override
    public void afterConnectionClosed(WebSocketSession session, CloseStatus status) {
        sessionManager.removeSession(session);
    }
}
