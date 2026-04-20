# Tazrout System Architecture

**Project**: Tazrout Smart Irrigation Dashboard
**Version**: 2.1
**Date**: 2026-04-19

---

## System Architecture Diagram

```
╔══════════════════════════════════════════════════════════════════════════════╗
║                        TAZROUT SMART IRRIGATION SYSTEM                       ║
║                                                                              ║
╠══════════════════════════════════════════════════════════════════════════════╣
║                                                                              ║
║  ┌─────────────────────────────────────────────────────────────────────┐     ║
║  │                      LAYER 1 — FIELD HARDWARE                       │     ║
║  │                                                                     │     ║
║  │   ┌──────────────┐  ┌──────────────┐       ┌──────────────┐       │       ║
║  │   │   Zone A     │  │   Zone B     │  ...  │   Zone N     │       │       ║
║  │   │              │  │              │       │              │       │       ║
║  │   │ • Temp       │  │ • Temp       │       │ • Temp       │       │       ║
║  │   │ • Moisture   │  │ • Moisture   │       │ • Moisture   │       │       ║
║  │   │ • Water Lvl  │  │ • Water Lvl  │       │ • Water Lvl  │       │       ║
║  │   │ • Humidity   │  │ • Humidity   │       │ • Humidity   │       │       ║
║  │   │      ↓       │  │      ↓       │       │      ↓       │       │       ║
║  │   │  MCU (ESP32) │  │  MCU (ESP32) │       │  MCU (ESP32) │       │       ║
║  │   │  + Relay     │  │  + Relay     │       │  + Relay     │       │       ║
║  │   │  + Valve     │  │  + Valve     │       │  + Valve     │       │       ║
║  │   │      ↓       │  │      ↓       │       │      ↓       │       │       ║
║  │   │  LoRa HAT    │  │  LoRa HAT    │       │  LoRa HAT    │       │       ║
║  │   └──────┬───────┘  └──────┬───────┘       └──────┬───────┘       │       ║
║  │          │   LoRa Radio    │  (long-range,        │               │       ║
║  │          └─────────────────┴───low-power)──────────┘               │      ║
║  └──────────────────────────────┬────────────────────────────────────┘       ║
║                                 │ LoRa Radio                                 ║
║  ┌──────────────────────────────┼────────────────────────────────────┐    ║
║  │                      LAYER 2 — GATEWAY                            │    ║
║  │                              ▼                                    │    ║
║  │              ┌───────────────────────────────┐                    │    ║
║  │              │  LoRa Gateway                 │                    │    ║
║  │              │  + LoRa HAT (radio receiver)  │                    │    ║
║  │              │                               │                    │    ║
║  │              │  • Receives LoRa frames       │                    │    ║
║  │              │  • Decodes → JSON packets     │                    │    ║
║  │              │  • Publishes to MQTT Broker    │                    │    ║
║  │              │  • Forwards valve commands     │                    │    ║
║  │              │    back to MCUs via LoRa       │                    │    ║
║  │              │  • Sends heartbeat every 30s   │                    │    ║
║  │              └───────────────┬───────────────┘                    │    ║
║  └──────────────────────────────┼────────────────────────────────────┘    ║
║                                 │ (LAN)                                   ║
║  ┌──────────────────────────────┼────────────────────────────────────┐    ║
║  │      CENTRAL SERVER MACHINE (ALL RUNNING ON SAME PHYSICAL HOST)   │    ║
║  │                                                                    │    ║
║  │  ┌─────────────────────────────────────────────────────────────┐  │    ║
║  │  │                     LAYER 3 — MQTT BROKER                 │  │    ║
║  │  │                   (Managed by Mr. Lhacani)                  │  │    ║
║  │  │                             ▼                               │  │    ║
║  │  │             ┌───────────────────────────────┐               │  │    ║
║  │  │             │     Mosquitto MQTT Broker      │               │  │    ║
║  │  │             │                                │               │  │    ║
║  │  │             │                                │               │  │    ║
║  │  │             └─┬─────────────┬────────────┬──┘               │  │    ║
║  │  └───────────────┼─────────────┼────────────┼──────────────────┘  │    ║
║  │                  │             │            │                     │    ║
║  │  ┌───────────────┼─────────────┼────────────┼──────────────────┐  │    ║
║  │  │               │ LAYER 4 — BACKEND & AI   │                  │  │    ║
║  │  │               ▼             ▼            ▼                  │  │    ║
║  │  │ ┌──────────────────┐ ┌─────────────────────────────────────┐│  │    ║
║  │  │ │   AI ENGINE      │ │       SPRING BOOT BACKEND           ││  │    ║
║  │  │ │ (by Mr. Salah)   │ │                                     ││  │    ║
║  │  │ │                  │ │                                     ││  │    ║
║  │  │ │ • Subscribes to  │ │  • Subscribes to sensor topics     ││  │    ║
║  │  │ │   sensor topics  │ │  • Subscribes to AI decisions      ││  │    ║
║  │  │ │ • Runs trained   │ │  • Persists to PostgreSQL          ││  │    ║
║  │  │ │   model          │ │  • Aggregates analytics            ││  │    ║
║  │  │ │ • Publishes      │ │  • Bridges MQTT → WebSocket        ││  │    ║
║  │  │ │   decisions      │ │  • Serves dashboard data           ││  │    ║
║  │  │ │ • Publishes      │ │                                     ││  │    ║
║  │  │ │   valve commands │ │  ┌───────────────────┐             ││  │    ║
║  │  │ │ • Publishes      │ │  │  PostgreSQL DB    │             ││  │    ║
║  │  │ │   alerts         │ │  │                   │             ││  │    ║
║  │  │ │                  │ │  └───────────────────┘             ││  │    ║
║  │  │ │ SOLE VALVE       │ │  ┌───────────────────┐             ││  │    ║
║  │  │ │ CONTROLLER       │ │  │  WebSocket Bridge │             ││  │    ║
║  │  │ └──────────────────┘ │  └────────┬──────────┘             ││  │    ║
║  │  └──────────────────────┴───────────┼──────────────────────────┘  │    ║
║  │                                     │ WebSocket                   │    ║
║  │  ┌──────────────────────────────────┼──────────────────────────┐  │    ║
║  │  │                      LAYER 5 — FRONTEND                     │  │    ║
║  │  │                                  ▼                          │  │    ║
║  │  │            ┌───────────────────────────────┐                │  │    ║
║  │  │            │   Flutter Desktop Dashboard   │                │  │    ║
║  │  │            │   (Running locally on server) │                │  │    ║
║  │  │            │                               │                │  │    ║
║  │  │            │   READ-ONLY monitoring        │                │  │    ║
║  │  │            │   Cannot control individual   │                │  │    ║
║  │  │            │   valves — but CAN trigger a  │                │  │    ║
║  │  │            │   GLOBAL EMERGENCY STOP.      │                │  │    ║
║  │  │            └───────────────────────────────┘                │  │    ║
║  │  └─────────────────────────────────────────────────────────────┘  │    ║
║  └───────────────────────────────────────────────────────────────────┘    ║
║                                                                            ║
╚══════════════════════════════════════════════════════════════════════════════╝
```

---

## Layer Descriptions

### Layer 1 — Field Hardware (Sensor Nodes)

| Component        | Role                                                          |
|------------------|---------------------------------------------------------------|
| Sensors          | Measure temperature (°C), soil moisture (g/m³), water level (%), humidity (%) |
| Microcontroller  | Reads sensors via ADC, packages JSON, controls relay/valve    |
| LoRa HAT         | Radio transceiver — transmits data up, relays commands down   |

Each agricultural zone has a **sensor node**: a microcontroller (ESP32/Arduino)
connected to sensors and a LoRa radio module. The MCU reads sensor values,
packages them into structured JSON, and transmits via LoRa radio.
The MCU also controls a relay for the irrigation valve — it executes valve
commands received via LoRa downlink from the gateway.

### Layer 2 — Gateway (LoRa Receiver)

| Component        | Role                                                          |
|------------------|---------------------------------------------------------------|
| LoRa HAT         | Receives LoRa radio frames from all field sensor nodes        |
| Gateway Bridge   | Bridges LoRa ↔ TCP/IP — decodes frames, publishes to MQTT    |

The gateway is the **only bridge** between the LoRa radio network and the IP
network. It receives all LoRa frames, decodes them to JSON, and publishes
to the MQTT broker. It also subscribes to valve command topics and forwards
commands back to field MCUs via LoRa downlink. Sends a heartbeat every 30
seconds so the backend can detect if the gateway goes offline.

### Central Server Machine (Layers 3, 4, and 5)

**IMPORTANT**: The MQTT Broker, AI Engine, Spring Boot Backend, PostgreSQL Database, and Flutter Desktop Dashboard **all run on the same physical server machine**. This ensures ultra-low latency and guarantees offline, LAN-only operation.

#### Layer 3 — MQTT Broker 

| Component        | Role                                                          |
|------------------|---------------------------------------------------------------|
| Mosquitto        | Central publish/subscribe message router                      |

The broker has **no intelligence** — it simply matches topic strings and
forwards messages to subscribers. Network Dev is responsible for its installation, port setup, QoS, and security configuration.

#### Layer 4 — Backend Services

| Component          | Role                                                        |
|--------------------|-------------------------------------------------------------|
| AI Engine          | Subscribes to sensor data, runs trained model, publishes decisions and valve commands |
| Spring Boot Backend| Persists data, aggregates analytics, bridges MQTT → WebSocket |
| PostgreSQL         | Stores zones, sensor history, AI decisions, preferences     |

**AI Engine**: Subscribes to sensor topics, runs the trained model, and publishes decisions and valve commands back to the MQTT broker. It is the **sole valve controller**.

**Spring Boot Backend**: Subscribes to sensor data AND AI decisions from the broker. It persists everything to PostgreSQL, computes analytics aggregations, and bridges all MQTT events to the Flutter dashboard via WebSocket.

#### Layer 5 — Frontend (Flutter Desktop)

| Component          | Role                                                        |
|--------------------|-------------------------------------------------------------|
| Flutter App        | Desktop dashboard for a single farmer operator              |

The Flutter app runs locally on the central server and connects to the backend's WebSocket endpoint. It is **read-only for daily irrigation control** — monitoring zones, AI decisions, and analytics. However, it **CAN issue an Emergency Stop** (`tazrout/system/emergency/stop`) to immediately close all valves and halt the AI Engine.

---

## Data Flow Walkthrough

### Sensor Reading → Dashboard Display

```
1. Sensors in Zone A measure temperature, moisture, water level, humidity
2. ESP32 MCU reads sensors, packages JSON with status flags
3. LoRa HAT transmits radio frame to gateway
4. Gateway receives frame, decodes to JSON, publishes to MQTT:
     Topic:   tazrout/zones/zone_a/sensors
     Payload: { "packet_type": "SENSOR_READING", "zone_id": "zone_a",
                "sensors": { "temperature": { "value": 28.4, "status": "OK" }, ... },
                "signal": { "rssi": -85, "snr": 7.2 } }

5. AI Engine receives the sensor reading
6. Spring Boot MqttSubscriber receives the reading
7. SensorService validates status flags, persists to DB
8. ZoneService updates Zone A entity
9. MqttWebSocketBridge forwards to Flutter via local WebSocket
10. Flutter dashboard updates instantly
```

### AI Decision → Valve Open → Confirmation

```
1. AI Engine receives sensor data for Zone A
2. AI model decides IRRIGATION is needed
3. AI Engine publishes decision:
     Topic:   tazrout/ai/decisions
4. AI Engine publishes valve command:
     Topic:   tazrout/zones/zone_a/valve/command
5. Gateway receives valve command, forwards to MCU via LoRa downlink
6. MCU opens valve, water flows
7. MCU sends acknowledgment back via LoRa:
     Topic:   tazrout/zones/zone_a/valve/ack
8. Spring Boot persists the decision and ACK
9. Dashboard shows the AI decision and valve state change
```

---

## LAN-Only Architecture Notes

- **No internet connection** — the entire system operates locally.
- **Single Server Hosting** — AI, Backend, DB, Broker, and UI all share the same hardware.
- **No user accounts** — single operator, no login screen.
- **No manual valve control** — only Mr. Salah's AI Engine controls irrigation.

---

## Team Responsibilities

| Person           | Role                      | Scope                                              |
|------------------|---------------------------|-----------------------------------------------------|
| Mr. Lhacani      | Networking                | Mosquitto broker setup, topic ACLs, QoS             |
| Mr. Salah        | AI Developer              | AI Engine (trained model, decision publishing, valve control) |
| Mr. Fehis        | Backend Developer         | Spring Boot backend, DB persistence, WebSocket bridge, simulator |
| Mr. Reffas   | Frontend Developer        | Flutter desktop dashboard                           |
| Mr. Khanfri | Micro-controller Developer | Programes the micro-controllers and sensors reading packet forwarding
---

## Packet Types (7 total)

| Packet Type          | Publisher            | Subscribers              | QoS |
|----------------------|----------------------|--------------------------|-----|
| SENSOR_READING       | LoRa Gateway         | Backend, AI Engine       | 1   |
| AI_DECISION          | AI Engine            | Backend, Dashboard       | 1   |
| VALVE_COMMAND        | AI Engine            | LoRa Gateway             | 2   |
| COMMAND_ACK          | LoRa Gateway         | Backend, AI Engine       | 1   |
| DEVICE_STATE_CHANGE  | LoRa Gateway         | Backend, Dashboard       | 1   |
| EMERGENCY_ALERT      | AI Engine / Gateway  | Backend, Dashboard       | 2   |
| HEARTBEAT            | LoRa Gateway         | Backend                  | 0   |
