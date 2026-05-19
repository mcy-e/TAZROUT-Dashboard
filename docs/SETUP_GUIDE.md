# Tazrout System — Full Hardware Setup & Deployment Guide

**Project**: Tazrout Smart Irrigation Dashboard
**Date**: 2026-04-30
**Target**: Production Server (Hardware Deployment Phase)

This guide is designed for the final phase of the project: deploying the software stack to the central server and connecting the physical field hardware (LoRa gateways, AI engine, and Flutter dashboard).

**Important Note on Hardware vs. Simulator:**
Because the entire system communicates exclusively via MQTT, **the backend and frontend do not care whether the data comes from the Python simulator or the real hardware**. As long as your physical LoRa Gateway and Mr. Salah's AI Engine publish to the exact same MQTT topics with the exact same JSON format (as documented in `MQTT_TOPICS.md`), everything will work exactly as it does now.

---

## Prerequisites (Central Server)

Install all of the following on the central server machine:

| Tool            | Minimum Version | Purpose                              | Install Command (Debian/Ubuntu)              |
|-----------------|-----------------|--------------------------------------|----------------------------------------------|
| Java JDK        | 17+             | Spring Boot runtime                  | `sudo apt install openjdk-17-jdk`            |
| PostgreSQL      | 15+             | Database                             | `sudo apt install postgresql postgresql-contrib` |
| Mosquitto MQTT  | 2.0+            | Local Message Broker                 | `sudo apt install mosquitto mosquitto-clients`|
| Python          | 3.11            | AI Engine & Simulation Scripts       | `sudo apt install python3.11`                |

**Network Configuration:**
Ensure the central server has a static LAN IP address (e.g., `192.168.1.100`). All field hardware (LoRa Gateway) and the AI Engine will need this IP to connect to the MQTT broker.

---

## Step 1 — PostgreSQL Database Setup

The backend requires the database to exist before it boots.

### 1. Create the database and user

```bash
sudo -u postgres psql
```

```sql
CREATE USER tazrout_user WITH PASSWORD 'your_secure_password';
CREATE DATABASE tazrout OWNER tazrout_user;
GRANT ALL PRIVILEGES ON DATABASE tazrout TO tazrout_user;
\q
```

### 2. Run the schema

Navigate to your cloned repository:

```bash
cd TAZROUT-Dashboard/backend/
psql -U tazrout_user -d tazrout -f src/main/resources/schema.sql
```

---

## Step 2 — Configure the Backend

Edit `backend/src/main/resources/application.properties` to ensure it points to your local Mosquitto broker and the newly created database:

```properties
# Database
spring.datasource.url=jdbc:postgresql://localhost:5432/tazrout
spring.datasource.username=tazrout_user
spring.datasource.password=your_secure_password

# MQTT Broker (Running locally on the server)
mqtt.broker.url=tcp://localhost:1883
mqtt.client.id=tazrout-backend
# Uncomment and set if Mosquitto requires auth:
# mqtt.username=tazrout_backend
# mqtt.password=change_me
```

---

## Step 3 — Boot the Infrastructure

Start the software components in the following order:

### 1. Start the Spring Boot Backend

```bash
cd backend/
mvn clean install
mvn spring-boot:run
```

Wait until you see in the console:
`Started TazroutApplication in X seconds`
`MQTT connected to broker: tcp://localhost:1883`

### 2. Turn on Field Hardware (LoRa Gateway & Nodes)

Power on your physical LoRa Gateway.
Ensure the gateway is configured to publish its MQTT packets to the central server's IP (e.g., `192.168.1.100:1883`).
Once powered, the gateway will immediately begin transmitting `SENSOR_READING` packets to `tazrout/zones/{zoneId}/sensors`.
**The backend will automatically detect new zones and save them to the database.**

### 3. Turn on the AI Engine

Have Mr. Salah start the AI Engine.
Ensure it connects to the same central server IP (`192.168.1.100:1883`).
It will begin listening to the sensor readings and publishing `AI_DECISION` packets to `tazrout/ai/decisions`.

---

## Step 4 — Launch the Flutter Dashboard

The dashboard is the final piece. Because it runs on the exact same server machine, it can connect via `localhost`.

### 1. Verify Environment

Ensure your `frontend/.env` file points to the local backend:

```env
WEBSOCKET_URL=ws://localhost:8080/api/v1/ws/realtime
```

### 2. Run the App

```bash
cd frontend/
flutter run -d windows
```

As soon as the dashboard opens, it will connect to the backend WebSocket. You will instantly see all the physical zones populating on the screen, reflecting the live data streaming from your actual hardware.

---

## Troubleshooting the Hardware Switch

If data isn't showing up on the dashboard after switching from the simulator to real hardware:

1.  **Check MQTT Connectivity:**
    On the central server, listen to the broker to see if the hardware is actually sending data:
    `mosquitto_sub -h localhost -t "tazrout/#" -v`
    If you see nothing, the physical Gateway is not reaching the server's network.

2.  **Check JSON Formatting:**
    If you see packets in `mosquitto_sub`, but the dashboard is empty, your hardware is sending the wrong JSON keys. Compare the packets from the physical hardware directly against the `MQTT_TOPICS.md` definitions. **Field names must be exactly the same (e.g., `soil_moisture` not `Moisture`).**

3.  **Check AI Engine Logs:**
    If zones are updating but valves are never opening, check if the AI Engine is publishing to `tazrout/zones/{zoneId}/valve/command`.

## Single-Server Architecture

Remember that this is a **LAN-only system**.
There is no internet connection required. The AI, Backend, DB, Broker, and Flutter UI all live on one machine. Only the LoRa Gateway communicates across the local area network.
