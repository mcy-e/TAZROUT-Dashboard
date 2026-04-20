# Tazrout Backend — Setup Guide

**Project**: Tazrout Smart Irrigation Dashboard
**Date**: 2026-04-19

**This will be implemented only when everything is finished ie when the connection phase arrives.**

---

## Prerequisites

**Should be Present**
Install all of the following on the development machine or Raspberry Pi:

| Tool            | Minimum Version | Purpose                              | Install Command (Debian/Ubuntu)              |
|-----------------|-----------------|--------------------------------------|----------------------------------------------|
| Java JDK        | 17+             | Spring Boot runtime                  | `sudo apt install openjdk-17-jdk`            |
| Maven           | 3.8+            | Build tool                           | `sudo apt install maven`                     |
| PostgreSQL      | 15+             | Database                             | `sudo apt install postgresql postgresql-contrib` |
| Python          | 3.10+           | Mock data simulator                  | `sudo apt install python3 python3-pip`       |
| paho-mqtt (pip) | 1.6+            | Python MQTT client for simulator     | `pip3 install paho-mqtt`                     |

**Note:** The Mosquitto MQTT broker is installed and managed by networking dev .
You do not need to install or configure Mosquitto yourself.

---

## Step 1 — Clone and Branch

```bash
git clone https://github.com/mcy-e/TAZROUT-Dashboard
cd TAZROUT-Dashboard

git checkout -b backend/spring-boot-setup
```

All backend work happens inside the `backend/` directory.

---

## Step 2 — Configure application.properties

Edit `backend/src/main/resources/application.properties`:

| Property                         | Description                              | Example Value                              |
|----------------------------------|------------------------------------------|--------------------------------------------|
| `server.port`                    | Spring Boot server port                  | `8080`                                     |
| `spring.datasource.url`         | PostgreSQL JDBC connection URL           | `jdbc:postgresql://localhost:5432/tazrout`  |
| `spring.datasource.username`    | Database username                        | `tazrout_user`                             |
| `spring.datasource.password`    | Database password                        | `your_secure_password`                     |
| `mqtt.broker.url`               | Mosquitto broker address (from Mr. Lhacani) | `tcp://192.168.1.100:1883`              |
| `mqtt.client.id`                | MQTT client identifier                   | `tazrout-backend`                          |
| `mqtt.default.qos`              | Default MQTT QoS level                   | `1`                                        |
| `mqtt.connection.timeout`       | Broker connection timeout (sec)          | `30`                                       |
| `mqtt.keep.alive.interval`      | MQTT keep-alive interval (sec)           | `60`                                       |
| `websocket.endpoint`            | WebSocket path for Flutter               | `/api/v1/ws/realtime`                      |
| `websocket.allowed.origins`     | Allowed WebSocket origins                | `*` (LAN only, safe)                      |
| `gateway.heartbeat.timeout.seconds` | Seconds before marking gateway offline | `90`                                    |

---

## Step 3 — PostgreSQL Database Setup

### Create the database and user

```bash
sudo -u postgres psql
```

```sql
CREATE USER tazrout_user WITH PASSWORD 'your_secure_password';
CREATE DATABASE tazrout OWNER tazrout_user;
GRANT ALL PRIVILEGES ON DATABASE tazrout TO tazrout_user;
\q
```

### Run the schema

```bash
cd backend/
psql -U tazrout_user -d tazrout -f src/main/resources/schema.sql
```

### Verify tables

```bash
psql -U tazrout_user -d tazrout -c "\dt"
```

Expected output:

```
           List of relations
 Schema |       Name        | Type  |    Owner
--------+-------------------+-------+-------------
 public | zones             | table | tazrout_user
 public | sensor_readings   | table | tazrout_user
 public | ai_decisions      | table | tazrout_user
 public | user_preferences  | table | tazrout_user
```

---

## Step 4 — Verify MQTT Broker Connectivity


The broker is managed by Mr. Lhacani. Verify you can connect:

```bash
# Test subscription (in one terminal)
mosquitto_sub -h <BROKER_IP> -t "tazrout/#" -v

# Test publish (in another terminal)
mosquitto_pub -h <BROKER_IP> -t "tazrout/test" -m "hello from backend"
```

You should see `tazrout/test hello from backend` in the subscriber terminal.
If this fails, contact Mr. Lhacani for broker status and credentials.

---

## Step 5 — Build and Run the Backend

```bash
cd backend/

mvn clean install

mvn spring-boot:run
```

### Verify the backend is running

Check the console output for:

```
Started TazroutApplication in X seconds
MQTT connected to broker: tcp://<BROKER_IP>:1883
WebSocket endpoint registered: /api/v1/ws/realtime
```

---

## Step 6 — Run the Mock Data Simulator

The simulator replaces both the LoRa Gateway and the AI Engine — it
publishes fake sensor data, AI decisions, valve commands, and heartbeats
so you can test the full system without hardware.

```bash
cd backend/mock_data/

python3 mqtt_simulator.py --broker <BROKER_IP> --port 1883 --zones 7 --interval 30
```

### Simulator options

| Flag         | Default          | Description                                |
|--------------|------------------|--------------------------------------------|
| `--broker`   | `localhost`      | Mosquitto broker IP (from Mr. Lhacani)     |
| `--port`     | `1883`           | Mosquitto broker port                      |
| `--zones`    | `7`              | Number of zones to simulate                |
| `--interval` | `30`             | Seconds between sensor publishes           |

The simulator will:
- Publish `SENSOR_READING` packets every `--interval` seconds per zone
- Publish `HEARTBEAT` packets every 30 seconds
- Randomly flip zones between ONLINE and OFFLINE (`DEVICE_STATE_CHANGE`)
- Generate `AI_DECISION` packets when moisture drops below threshold
- Publish `VALVE_COMMAND` packets linked to AI decisions
- Simulate `COMMAND_ACK` responses from MCUs
- Publish `EMERGENCY_ALERT` on critical thresholds

---

## Step 7 — Connect Flutter Frontend

On the development machine running the Flutter desktop app:

```
WEBSOCKET_URL=ws://<BACKEND_IP>:8080/api/v1/ws/realtime
```

```bash
cd frontend/
flutter run -d windows
```

The dashboard connects to the WebSocket endpoint and receives real-time
data from either the mock simulator or real hardware.

---

## Troubleshooting

| Problem                              | Solution                                                       |
|--------------------------------------|----------------------------------------------------------------|
| `Connection refused` on MQTT         | Contact Mr. Lhacani — check broker is running                  |
| `Connection refused` on PostgreSQL   | Check PostgreSQL is running: `systemctl status postgresql`      |
| MQTT messages not reaching Flutter   | Verify MqttWebSocketBridge subscribes to `tazrout/#`           |
| Database tables missing              | Re-run `schema.sql` against the `tazrout` database             |
| `Port 8080 already in use`           | Change `server.port` in `application.properties`               |
| Simulator not publishing             | Check `--broker` IP matches the broker Mr. Lhacani set up      |
| Flutter shows no data                | Check WebSocket URL matches backend IP and port                |
| No gateway heartbeat                 | Simulator not running, or `--broker` IP is wrong               |

---

## Network Diagram (LAN)

```
┌──────────────────────────────────────────────────────────┐
│                    LAN (192.168.1.0/24)                  │
│                                                          │
│  ┌────────────────┐                                      │
│  │ ESP32 Nodes    │──LoRa──┐                             │
│  │ (Field)        │        │                             │
│  └────────────────┘        ▼                             │
│                   ┌────────────────────────┐              │
│                   │ Raspberry Pi Gateway   │              │
│                   │ + LoRa HAT             │              │
│                   │ 192.168.1.x            │              │
│                   └──────────┬─────────────┘              │
│                              │ TCP/IP                     │
│                              ▼                            │
│                   ┌────────────────────────┐              │
│                   │ MQTT Broker (Mosquitto)│              │
│                   │ (managed by Mr. Lhacani)│             │
│                   │ 192.168.1.100:1883     │              │
│                   └──┬──────────────┬──────┘              │
│                      │              │                     │
│           ┌──────────┘              └──────────┐          │
│           ▼                                    ▼          │
│  ┌────────────────┐              ┌────────────────────┐   │
│  │ AI Engine      │              │ Spring Boot Backend│   │
│  │ (co-located)   │              │ :8080              │   │
│  │                │              │ + PostgreSQL :5432  │   │
│  └────────────────┘              │ + WebSocket :8080/ws│  │
│                                  └─────────┬──────────┘   │
│                                            │ WebSocket    │
│                                            ▼              │
│                                  ┌────────────────────┐   │
│                                  │ Desktop PC         │   │
│                                  │ Flutter Dashboard  │   │
│                                  │ (read-only)        │   │
│                                  └────────────────────┘   │
│                                                          │
│  ❌ No Internet Gateway                                   │
└──────────────────────────────────────────────────────────┘
```
