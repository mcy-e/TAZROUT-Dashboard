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
package dz.tazrout.dashboard.config;

import org.springframework.util.StringUtils;
import org.eclipse.paho.client.mqttv3.MqttConnectOptions;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class MqttConfig {

    @Bean
    public MqttConnectOptions mqttConnectOptions(
            @Value("${mqtt.broker.url:tcp://localhost:1883}") String brokerUrl,
            @Value("${mqtt.username:}") String username,
            @Value("${mqtt.password:}") String password,
            @Value("${mqtt.connection.timeout:30}") int timeoutSeconds,
            @Value("${mqtt.keep.alive.interval:60}") int keepAliveSeconds) {
        MqttConnectOptions options = new MqttConnectOptions();
        options.setServerURIs(new String[]{brokerUrl});
        options.setAutomaticReconnect(true);
        options.setCleanSession(false);
        options.setConnectionTimeout(timeoutSeconds);
        options.setKeepAliveInterval(keepAliveSeconds);
        if (StringUtils.hasText(username)) {
            options.setUserName(username);
        }
        if (StringUtils.hasText(password)) {
            options.setPassword(password.toCharArray());
        }
        
        // Setup Last Will and Testament (LWT)
        String lwtPayload = "{\"status\":\"OFFLINE\"}";
        options.setWill("tazrout/system/backend/status", lwtPayload.getBytes(), 1, true);
        
        return options;
    }
}
