/*
 * FILE: DatabaseConfig.java
 * PURPOSE: Spring Boot auto-configures the DataSource from application.properties.
 *          This class is retained as the configuration anchor for future
 *          customization (connection pool sizing, schema validation, etc).
 *          No explicit bean definitions are needed — Spring Boot's
 *          DataSourceAutoConfiguration handles everything.
 * DATABASE: PostgreSQL (all tables: zones, sensor_readings, ai_decisions, user_preferences)
 * DEPENDENCIES: spring-boot-starter-data-jpa, application.properties
 * IMPLEMENTED BY: Mr. Fehis
 */
package dz.tazrout.dashboard.config;

import org.springframework.context.annotation.Configuration;

@Configuration
public class DatabaseConfig {
}
