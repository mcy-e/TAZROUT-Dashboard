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
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "user_preferences")
public class UserPreferences {
    @Id
    private Integer id = 1;
    
    private String language;
    private String theme;
    private String fontSize;
    private String dateFormat;
    private String timeFormat;
    private Boolean powerSaving;
    private Integer sleepTimerMinutes;
    private Boolean uiAnimations;
    private Boolean soundAlerts;

    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }
    public String getLanguage() { return language; }
    public void setLanguage(String language) { this.language = language; }
    public String getTheme() { return theme; }
    public void setTheme(String theme) { this.theme = theme; }
    public String getFontSize() { return fontSize; }
    public void setFontSize(String fontSize) { this.fontSize = fontSize; }
    public String getDateFormat() { return dateFormat; }
    public void setDateFormat(String dateFormat) { this.dateFormat = dateFormat; }
    public String getTimeFormat() { return timeFormat; }
    public void setTimeFormat(String timeFormat) { this.timeFormat = timeFormat; }
    public Boolean getPowerSaving() { return powerSaving; }
    public void setPowerSaving(Boolean powerSaving) { this.powerSaving = powerSaving; }
    public Integer getSleepTimerMinutes() { return sleepTimerMinutes; }
    public void setSleepTimerMinutes(Integer sleepTimerMinutes) { this.sleepTimerMinutes = sleepTimerMinutes; }
    public Boolean getUiAnimations() { return uiAnimations; }
    public void setUiAnimations(Boolean uiAnimations) { this.uiAnimations = uiAnimations; }
    public Boolean getSoundAlerts() { return soundAlerts; }
    public void setSoundAlerts(Boolean soundAlerts) { this.soundAlerts = soundAlerts; }
}
