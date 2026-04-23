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
package dz.tazrout.dashboard.websocket;

import java.io.IOException;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;

@Component
public class WebSocketSessionManager {
    private static final Logger log = LoggerFactory.getLogger(WebSocketSessionManager.class);

    private final Set<WebSocketSession> sessions = ConcurrentHashMap.newKeySet();

    public void addSession(WebSocketSession session) {
        sessions.add(session);
        log.info("WebSocket session connected: {}", session.getId());
    }

    public void removeSession(WebSocketSession session) {
        sessions.remove(session);
        log.info("WebSocket session disconnected: {}", session.getId());
    }

    public int activeCount() {
        return sessions.size();
    }

    public void broadcast(String payload) {
        TextMessage message = new TextMessage(payload);
        sessions.removeIf(session -> !session.isOpen());
        for (WebSocketSession session : sessions) {
            try {
                synchronized (session) {
                    session.sendMessage(message);
                }
            } catch (IOException ex) {
                log.warn("Failed to send to session {}: {}", session.getId(), ex.getMessage());
            }
        }
    }
}
