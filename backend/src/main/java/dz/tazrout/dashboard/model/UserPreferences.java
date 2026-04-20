/*
 * FILE: UserPreferences.java
 * PURPOSE: JPA entity for persisting user preference settings.
 *          Maps to the "user_preferences" PostgreSQL table.
 *          Single-row table (one operator, no accounts).
 *
 *          Fields:
 *            id                  INTEGER    PK   — always 1 (single user)
 *            language            VARCHAR(5)       — "en" | "fr" | "ar"
 *            theme               VARCHAR(10)      — "Light" | "Dark"
 *            font_size           VARCHAR(10)      — "Small" | "Medium" | "Large"
 *            date_format         VARCHAR(15)      — "DD/MM/YYYY" | "MM/DD/YYYY" | "YYYY/MM/DD"
 *            time_format         VARCHAR(10)      — "24 Hours" | "12 Hours"
 *            power_saving        BOOLEAN          — power optimization toggle
 *            sleep_timer_minutes INTEGER          — minutes before sleep mode
 *            ui_animations       BOOLEAN          — animation toggle
 *            sound_alerts        BOOLEAN          — sound notification toggle
 *
 * MQTT TOPICS: N/A (data layer — consumed by PreferencesService)
 * DATABASE: user_preferences
 * DEPENDENCIES: Jakarta Persistence
 * IMPLEMENTED BY: Mr. Fehis
 */
