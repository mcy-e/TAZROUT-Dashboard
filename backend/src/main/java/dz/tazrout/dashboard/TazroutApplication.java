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
package dz.tazrout.dashboard;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class TazroutApplication {

	public static void main(String[] args) {
		try {
			SpringApplication.run(TazroutApplication.class, args);
			System.out.println("==================================================");
			System.out.println("[SUCCESS] TAZROUT BACKEND IS RUNNING");
			System.out.println("[INFO] Connected to PostgreSQL at localhost:5432");
			System.out.println("[INFO] Connected to MQTT Broker at localhost:1883");
			System.out.println("[INFO] Listening for Dashboard on ws://localhost:8080/api/v1/ws/realtime");
			System.out.println("==================================================");
		} catch (Exception e) {
			if (e.getClass().getName().contains("SilentExitException")) {
				throw (RuntimeException) e;
			}
			System.err.println("==================================================");
			System.err.println("[ERROR] CRITICAL STARTUP FAILURE");
			System.err.println("[ERROR] The backend failed to start. Please check:");
			System.err.println("  1. Is PostgreSQL running on localhost:5432?");
			System.err.println("  2. Is Mosquitto (MQTT) running on localhost:1883?");
			System.err.println("[ERROR] These services MUST be running BEFORE starting the backend.");
			System.err.println("==================================================");
			System.exit(1);
		}
	}

}