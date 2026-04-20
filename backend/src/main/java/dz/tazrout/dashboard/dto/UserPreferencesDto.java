/*
 * FILE: UserPreferencesDto.java
 * PURPOSE: Data transfer object for user preferences synced bidirectionally
 *          between Flutter and backend via MQTT.
 *          Published on topic: tazrout/settings/preferences
 *
 *          JSON shape:
 *            {
 *              "language", "theme", "font_size", "date_format",
 *              "time_format", "power_saving", "sleep_timer_minutes",
 *              "ui_animations", "sound_alerts"
 *            }
 *
 * MQTT TOPICS: tazrout/settings/preferences (bidirectional)
 * DATABASE: N/A (maps from/to UserPreferences entity)
 * DEPENDENCIES: UserPreferences entity (source mapping)
 * IMPLEMENTED BY: Mr. Fehis
 */
