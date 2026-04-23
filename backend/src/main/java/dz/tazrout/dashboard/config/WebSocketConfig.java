/*
 * FILE: WebSocketConfig.java
 * PURPOSE: Registers the WebSocket endpoint (/api/v1/ws/realtime) that the
 *          Flutter desktop app connects to. Configures allowed origins
 *          (LAN only) and handshake interceptors.
 * MQTT TOPICS: N/A
 * DATABASE: N/A
 * DEPENDENCIES: spring-boot-starter-websocket, DashboardWebSocketHandler, WebSocketSessionManager
 * IMPLEMENTED BY: Mr. Fehis
 */
package dz.tazrout.dashboard.config;

import dz.tazrout.dashboard.websocket.DashboardWebSocketHandler;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.socket.config.annotation.EnableWebSocket;
import org.springframework.web.socket.config.annotation.WebSocketConfigurer;
import org.springframework.web.socket.config.annotation.WebSocketHandlerRegistry;

@Configuration
@EnableWebSocket
public class WebSocketConfig implements WebSocketConfigurer {
    private final DashboardWebSocketHandler handler;

    @Value("${websocket.endpoint:/api/v1/ws/realtime}")
    private String endpoint;

    @Value("${websocket.allowed.origins:*}")
    private String allowedOrigins;

    public WebSocketConfig(DashboardWebSocketHandler handler) {
        this.handler = handler;
    }

    @Override
    public void registerWebSocketHandlers(WebSocketHandlerRegistry registry) {
        registry.addHandler(handler, endpoint).setAllowedOriginPatterns(allowedOrigins);
    }
}
