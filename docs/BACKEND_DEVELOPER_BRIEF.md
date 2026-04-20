# Backend Developer Brief

**For**: Mr. Fehis (Backend Developer)
**From**: Reffas Chouaib (Frontend Developer)
**Project**: Tazrout
**Date**: 2026-04-19

---

## 1. System Overview

Tazrout is a **LAN-only smart irrigation monitoring system** for farmers.
There is **no internet connection**, **no cloud**, **no user accounts**, and
**no login screen**. 

**IMPORTANT ARCHITECTURE NOTE:**
The entire software stack — the MQTT Broker, the AI Engine, your Spring Boot Backend, the PostgreSQL database, and the Flutter Desktop app — **all run on the exact same physical central server**.

The physical data flow:

```
LoRa Sensors → ESP32 Nodes → LoRa Gateway
    → Mosquitto MQTT Broker (on central server)
    → AI Engine (on central server)
    → Spring Boot Backend (on central server)
    → Flutter Desktop Dashboard (on central server)
```

### Team Roles

| Person           | Role                              | Status       |
|------------------|-----------------------------------|--------------|
| Mr. Lhacani      | Networking — MQTT broker setup    | **Done**     |
| Mr. Salah        | AI Engine — Trained model + decisions| In Progress  |
| Mr. Fehis        | Backend — Spring Boot        | Starting     |
| Mr. Reffas   | Frontend — Flutter dashboard      | **Complete** |
| Mr. Khanfri | Embedded Systems — Sensors readings + Valve actions | **Complete**

---

## 2. Your Responsibility

**You are responsible for the Spring Boot backend only.**

The Flutter frontend is complete.

Your job is to:

1. Implement the Spring Boot backend that connects to local Mosquitto
2. Build the WebSocket bridge so Flutter receives real-time data
3. Subscribe to sensor data from the LoRa Gateway AND decisions from AI Engine
4. Persist sensor data, AI decisions, and user preferences to PostgreSQL
5. Aggregate analytics data for the dashboard charts
6. Build a Python mock data simulator that simulates both the Gateway and the AI Engine for testing **(IMPORTANT)**.

**You do NOT need to:**

- Touch any file in the `frontend/` directory

---

## 3. How Flutter Talks to the Backend

All communication happens through an **MQTT → WebSocket bridge**:

```
┌──────────────┐   ┌──────────────┐   ┌─────────────────────────────────┐
│ LoRa Gateway │   │  AI Engine   │   │       Spring Boot Backend       │
│              │   │              │   │                                 │
│ Publishes:   │   │ Publishes:   │   │  ┌───────────────────┐         │
│ • sensors    │   │ • decisions  │   │  │ MqttSubscriber    │         │
│ • state      │──▶│ • valve cmds │──▶│  │ (receives all)    │         │
│ • heartbeat  │   │ • alerts     │   │  └────────┬──────────┘         │
│ • valve ACKs │   │              │   │           │                    │
└──────────────┘   └──────────────┘   │  ┌────────▼──────────┐         │
                                      │  │ Services          │         │
                                      │  │ (process + persist)│         │
                                      │  └────────┬──────────┘         │
                                      │           │                    │
                                      │  ┌────────▼──────────┐         │
                                      │  │ MqttWebSocket     │         │
                                      │  │ Bridge            │──────────┐
                                      │  └───────────────────┘         │ │
                                      └─────────────────────────────────┘ │
                                                                          │
                                      ┌─────────────────────────────────┐ │
                                      │   Flutter Desktop Dashboard     │◀┘
                                      │   (WebSocket client)            │
                                      │   READ-ONLY for irrigation      │
                                      └─────────────────────────────────┘
```

The bridge subscribes to `tazrout/#` on the local MQTT broker and forwards every message as a WebSocket frame to Flutter.

---

## 4. Data Contracts

All JSON payload formats are documented in:
- **MQTT topic payloads**: [`docs/MQTT_TOPICS.md`](./MQTT_TOPICS.md)
- **Data requirements**: [`docs/BACKEND_DATA_REQUIREMENTS.md`](./BACKEND_DATA_REQUIREMENTS.md)

### Flutter Model Mapping

| Flutter Model              | Backend DTO              | Key Fields                                          |
|----------------------------|--------------------------|-----------------------------------------------------|
| `ZoneModel`                | `ZoneDto`                | zone_id, zone_name, device_state, valve_state, temperature, moisture, water_level |
| `AiDecisionModel`          | `AiDecisionDto`          | decision_id, decision_date, decision_type, affected_zones, description, notes, farmer_advice |
| `NotificationModel`        | Dashboard notification   | id, type, title, message, timestamp                 |

**Critical:** JSON field names must match exactly (`snake_case`).

---

## 5. Implementation Priority

Work in this order:

### PRIORITY 1 — MQTT Broker Connection + WebSocket Bridge
**Files:** `MqttConfig.java`, `WebSocketConfig.java`, `MqttWebSocketBridge.java`, `DashboardWebSocketHandler.java`, `WebSocketSessionManager.java`

Connect to local broker.

Bridge `tazrout/#` to `/api/v1/ws/realtime`.

### PRIORITY 2 — Mock Data Simulator
**Files:** `mock_data/mqtt_simulator.py`

Simulate both the Gateway and AI Engine to test Flutter UI.

### PRIORITY 3 — Zone Status Processing
**Files:** `ZoneService.java`, `SensorService.java`, Repositories & Entities

Process `SENSOR_READING`, `DEVICE_STATE_CHANGE`, and `COMMAND_ACK`. Persist to DB.

### PRIORITY 4 — Dashboard Summary
Aggregate current zone data and publish on `tazrout/dashboard/summary`.

### PRIORITY 5 — Emergency Status + Gateway Monitoring
Monitor gateway heartbeats. Publish on `tazrout/system/emergency/status`.

### PRIORITY 6 — Analytics Aggregation
Aggregate historical data for charts (`tazrout/analytics/*`).

### PRIORITY 7 — AI Decision Storage
Persist `AI_DECISION` packets from Mr. Salah's AI Engine. **You do NOT run the model**.

### PRIORITY 8 — Settings Persistence
Bidirectional sync on `tazrout/settings/preferences`.

---

## 6. What NOT to Build

- MQTT broker setup 
- AI model / decision engine 
- Valve command publishing (Only AI Engine controls valves)
- REST API controllers (All communication is MQTT/WebSocket)

---

## 7. Database Notes
- PostgreSQL 15+ (Running locally)
- Timestamps: ISO 8601 UTC
- Schema DDL: `backend/src/main/resources/schema.sql`

## 8. Quick Reference
```
backend/
├── src/main/java/dz/tazrout/dashboard/
├── src/main/resources/application.properties  ← Broker IP (localhost)
├── src/main/resources/schema.sql              ← PostgreSQL DB
├── mock_data/mqtt_simulator.py                ← Simulates Gateway + AI Engine
└── pom.xml
```
