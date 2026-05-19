/*
 * FILE: schema.sql
 * PURPOSE: PostgreSQL DDL for all Tazrout backend tables.
 *          Run once during initial database setup.
 *          See docs/SETUP_GUIDE.md for database creation commands.
 * IMPLEMENTED BY: Mr. Fehis
 *
 * Tables:
 *   zones              — agricultural zones with current sensor state
 *   sensor_readings    — historical sensor data for analytics
 *   ai_decisions       — AI-generated irrigation decisions
 *   user_preferences   — single-row operator preferences
 */

-- ============================================================
-- TABLE: zones
-- ============================================================
CREATE TABLE zones (
    zone_id        VARCHAR(20)  PRIMARY KEY,
    zone_name      VARCHAR(50)  NOT NULL,
    device_state   VARCHAR(10)  NOT NULL DEFAULT 'OFFLINE',
    valve_state    VARCHAR(10)  NOT NULL DEFAULT 'CLOSED',
    temperature    DOUBLE PRECISION NOT NULL DEFAULT 0.0,
    moisture       DOUBLE PRECISION NOT NULL DEFAULT 0.0,
    water_level    DOUBLE PRECISION NOT NULL DEFAULT 0.0,
    last_updated   TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT chk_device_state CHECK (device_state IN ('ONLINE', 'OFFLINE')),
    CONSTRAINT chk_valve_state  CHECK (valve_state  IN ('OPEN', 'CLOSED')),
    CONSTRAINT chk_temperature  CHECK (temperature  BETWEEN -50 AND 60),
    CONSTRAINT chk_moisture     CHECK (moisture     BETWEEN 0 AND 2000),
    CONSTRAINT chk_water_level  CHECK (water_level  BETWEEN 0 AND 100)
);

-- ============================================================
-- TABLE: sensor_readings
-- ============================================================
CREATE TABLE sensor_readings (
    reading_id     VARCHAR(36)  PRIMARY KEY,
    zone_id        VARCHAR(20)  NOT NULL REFERENCES zones(zone_id),
    timestamp      TIMESTAMP    NOT NULL,
    temperature    DOUBLE PRECISION NOT NULL,
    moisture       DOUBLE PRECISION NOT NULL,
    water_output   DOUBLE PRECISION NOT NULL,
    humidity       DOUBLE PRECISION NOT NULL
);
--
CREATE INDEX idx_readings_zone_ts ON sensor_readings(zone_id, timestamp DESC);

-- ============================================================
-- TABLE: ai_decisions
-- ============================================================
CREATE TABLE ai_decisions (
    decision_id    VARCHAR(20)  PRIMARY KEY,
    decision_date  TIMESTAMP    NOT NULL,
    decision_type  VARCHAR(15)  NOT NULL,
    affected_zones TEXT         NOT NULL,
    description    TEXT         NOT NULL,
    notes          TEXT,
    farmer_advice  TEXT,

    CONSTRAINT chk_decision_type CHECK (
        decision_type IN ('IRRIGATION', 'ALERT', 'ADVICE', 'CRITICAL')
    )
);
--
CREATE INDEX idx_decisions_date ON ai_decisions(decision_date DESC);
CREATE INDEX idx_decisions_type ON ai_decisions(decision_type);

-- ============================================================
-- TABLE: user_preferences
-- ============================================================
CREATE TABLE user_preferences (
    id                  INTEGER      PRIMARY KEY DEFAULT 1,
    language            VARCHAR(5)   NOT NULL DEFAULT 'en',
    theme               VARCHAR(10)  NOT NULL DEFAULT 'Light',
    font_size           VARCHAR(10)  NOT NULL DEFAULT 'Medium',
    date_format         VARCHAR(15)  NOT NULL DEFAULT 'DD/MM/YYYY',
    time_format         VARCHAR(10)  NOT NULL DEFAULT '24 Hours',
    power_saving        BOOLEAN      NOT NULL DEFAULT FALSE,
    sleep_timer_minutes INTEGER      NOT NULL DEFAULT 15,
    ui_animations       BOOLEAN      NOT NULL DEFAULT TRUE,
    sound_alerts        BOOLEAN      NOT NULL DEFAULT FALSE,

    CONSTRAINT chk_single_row CHECK (id = 1)
);

-- INSERT INTO user_preferences (id) VALUES (1);
