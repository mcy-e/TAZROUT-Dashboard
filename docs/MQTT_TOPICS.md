# MQTT Topics Reference

**Project**: Tazrout Smart Irrigation Dashboard

**Broker**: Mosquitto (LAN only)

**Version**: 2.0

**Date**: 2026-04-19

---

## Topic Naming Convention

```
tazrout/{layer}/{zone_or_entity}/{action}
```

- All topics are prefixed with `tazrout/`
- Layer groups: `zones`, `ai`, `system`, `dashboard`, `settings`, `analytics`, `support`
- Wildcard subscriptions: backend bridge subscribes to `tazrout/#`

## Direction Legend

| Symbol | Meaning                                      |
|--------|----------------------------------------------|
| →      | Publisher → Subscriber                       |
| ↔      | Bidirectional                                |

## QoS Strategy

| QoS | When Used                                         |
|-----|---------------------------------------------------|
| 0   | Gateway heartbeats (high frequency, loss OK)      |
| 1   | Sensor data, decisions, state changes (default)   |
| 2   | Valve commands, emergency alerts (exactly-once)   |

---

## Zone Topics

### tazrout/zones/{zoneId}/sensors

- **Direction:** LoRa Gateway → Backend, AI Engine
- **Trigger:** Every 30 seconds per zone (configurable)
- **QoS:** 1
- **Retained:** No
- **Payload:**
```json
{
  "packet_type": "SENSOR_READING",
  "zone_id": "zone_a",
  "zone_name": "Zone A",
  "device_id": "MCU-ZONE-A-001",
  "timestamp": "2026-02-15T10:30:00Z",
  "sensors": {
    "temperature": { "value": 28.4, "unit": "°C", "status": "OK" },
    "soil_moisture": { "value": 540.0, "unit": "g/m³", "status": "OK" },
    "water_level": { "value": 62.5, "unit": "%", "status": "OK" },
    "humidity": { "value": 67.2, "unit": "%", "status": "OK" }
  },
  "signal": {
    "rssi": -85,
    "snr": 7.2,
    "spreading_factor": 7
  }
}
```
- **Publisher:** LoRa Gateway (on behalf of each MCU)
- **Subscribers:** Spring Boot Backend (SensorService), AI Engine
- **Notes:** `status` per sensor: `"OK"` | `"OUT_OF_RANGE"` | `"SENSOR_FAULT"`. The `signal` block is LoRa-specific — RSSI and SNR diagnose field connectivity issues.

---

### tazrout/zones/{zoneId}/state

- **Direction:** LoRa Gateway → Backend, Dashboard
- **Trigger:** Device comes ONLINE, goes OFFLINE, or valve state changes
- **QoS:** 1
- **Retained:** Yes
- **Payload:**
```json
{
  "packet_type": "DEVICE_STATE_CHANGE",
  "zone_id": "zone_a",
  "device_id": "MCU-ZONE-A-001",
  "timestamp": "2026-02-15T10:32:00Z",
  "previous_device_state": "OFFLINE",
  "current_device_state": "ONLINE",
  "valve_state": "CLOSED",
  "firmware_version": "1.2.3",
  "battery_level": 87
}
```
- **Publisher:** LoRa Gateway
- **Subscribers:** Spring Boot Backend (ZoneService), Dashboard (via WebSocket bridge)
- **Notes:** Retained so a new subscriber (e.g. dashboard restart) immediately gets the last known state.

---

### tazrout/zones/{zoneId}/valve/command

- **Direction:** AI Engine → LoRa Gateway
- **Trigger:** AI Engine decides to irrigate
- **QoS:** 2
- **Retained:** No
- **Payload:**
```json
{
  "packet_type": "VALVE_COMMAND",
  "command_id": "CMD-2026-0112",
  "issued_by": "AI_ENGINE",
  "issued_at": "2026-02-15T10:31:06Z",
  "zone_id": "zone_a",
  "device_id": "MCU-ZONE-A-001",
  "command": "OPEN_VALVE",
  "duration_minutes": 20,
  "priority": "NORMAL",
  "linked_decision_id": "DEC-2026-0047",
  "reason": "AI irrigation decision — moisture below threshold"
}
```
- **Publisher:** AI Engine (sole valve controller)
- **Subscribers:** LoRa Gateway (forwards to MCU via LoRa downlink)
- **Notes:** `issued_by` is always `"AI_ENGINE"` — the dashboard cannot command valves. `priority`: `"NORMAL"` | `"EMERGENCY"`. QoS 2 ensures exactly-once delivery — a valve command executed twice could flood a zone. `linked_decision_id` creates a traceable link to the triggering AI decision.

---

### tazrout/zones/{zoneId}/valve/ack

- **Direction:** LoRa Gateway → Backend, AI Engine
- **Trigger:** MCU confirms it received and executed (or failed) a valve command
- **QoS:** 1
- **Retained:** No
- **Payload:**
```json
{
  "packet_type": "COMMAND_ACK",
  "command_id": "CMD-2026-0112",
  "zone_id": "zone_a",
  "device_id": "MCU-ZONE-A-001",
  "ack_timestamp": "2026-02-15T10:31:09Z",
  "status": "EXECUTED",
  "valve_state_after": "OPEN",
  "message": "Valve opened successfully. Timer set for 20 minutes."
}
```
- **Publisher:** LoRa Gateway (on behalf of MCU)
- **Subscribers:** Spring Boot Backend (ZoneService), AI Engine
- **Notes:** `status`: `"EXECUTED"` | `"FAILED"` | `"REJECTED"` | `"TIMEOUT"`. This closes the command loop — without it, there is no guarantee a valve actually moved.

---

### tazrout/zones/{zoneId}/alert

- **Direction:** LoRa Gateway or AI Engine → Backend, Dashboard
- **Trigger:** Zone-level anomaly detected by sensor threshold or AI evaluation
- **QoS:** 2
- **Retained:** No
- **Payload:**
```json
{
  "packet_type": "EMERGENCY_ALERT",
  "alert_id": "ALERT-2026-0008",
  "issued_at": "2026-02-15T11:00:00Z",
  "severity": "CRITICAL",
  "issued_by": "AI_ENGINE",
  "zone_id": "zone_c",
  "triggered_by": "SENSOR_THRESHOLD",
  "sensor_values": {
    "temperature": 58.1,
    "soil_moisture": 120.0,
    "water_level": 4.0,
    "humidity": 21.0
  },
  "message": "Critical temperature spike and water level dangerously low in Zone C.",
  "recommended_action": "EMERGENCY_IRRIGATION"
}
```
- **Publisher:** AI Engine or LoRa Gateway (first line of defense)
- **Subscribers:** Spring Boot Backend (NotificationService), Dashboard
- **Notes:** `issued_by`: `"AI_ENGINE"` | `"GATEWAY"`. The gateway can raise raw alerts before the AI processes data.

---

### tazrout/zones/all/sensors

- **Direction:** LoRa Gateway → Dashboard (optional)
- **Trigger:** Aggregated broadcast of all zone sensor readings
- **QoS:** 0
- **Retained:** No
- **Notes:** Optional aggregated feed. The backend can subscribe and use for bulk zone list updates to the dashboard.

---

## AI Topics

### tazrout/ai/decisions

- **Direction:** AI Engine → Backend, Dashboard
- **Trigger:** AI Engine generates a new irrigation decision
- **QoS:** 1
- **Retained:** No
- **Payload:**
```json
{
  "packet_type": "AI_DECISION",
  "decision_id": "DEC-2026-0047",
  "decision_date": "2026-02-15T10:31:05Z",
  "decision_type": "IRRIGATION",
  "confidence_score": 0.93,
  "affected_zones": ["zone_a", "zone_b"],
  "trigger_data": {
    "zone_id": "zone_a",
    "temperature": 28.4,
    "soil_moisture": 540.0,
    "water_level": 62.5,
    "humidity": 67.2
  },
  "action": {
    "command": "OPEN_VALVE",
    "duration_minutes": 20,
    "water_amount_liters": 150
  },
  "description": "Soil moisture below threshold in Zone A and B. Initiating 20-minute irrigation cycle.",
  "notes": "Temperature elevated — monitor for heat stress.",
  "farmer_advice": "Consider checking Zone B valve manually; moisture recovery was slower than expected last cycle."
}
```
- **Publisher:** AI Engine
- **Subscribers:** Spring Boot Backend (AiDecisionService), Dashboard (via WebSocket)
- **Notes:** `decision_type`: `"IRRIGATION"` | `"ALERT"` | `"ADVICE"` | `"CRITICAL"`. `confidence_score` is 0–1. Maps to Flutter's `AiDecisionModel`.

---

### tazrout/ai/decisions/latest

- **Direction:** AI Engine → Dashboard
- **Trigger:** AI Engine publishes the latest decision
- **QoS:** 1
- **Retained:** Yes
- **Payload:** Same structure as `tazrout/ai/decisions`
- **Notes:** Retained so a dashboard that reconnects immediately gets the last AI decision.

---

### tazrout/ai/alerts

- **Direction:** AI Engine → Backend, Dashboard
- **Trigger:** AI Engine detects CRITICAL-severity condition
- **QoS:** 2
- **Retained:** No
- **Payload:** Same structure as zone alert (`EMERGENCY_ALERT` packet type)
- **Notes:** Only CRITICAL-severity decisions trigger this topic. QoS 2 for guaranteed delivery.

---

## System Topics

### tazrout/system/gateway/heartbeat

- **Direction:** LoRa Gateway → Backend
- **Trigger:** Every 30 seconds
- **QoS:** 0
- **Retained:** No
- **Payload:**
```json
{
  "packet_type": "HEARTBEAT",
  "gateway_id": "GATEWAY-001",
  "timestamp": "2026-02-15T10:30:00Z",
  "status": "OPERATIONAL",
  "connected_zones": ["zone_a", "zone_b", "zone_c"],
  "offline_zones": ["zone_d"],
  "uptime_seconds": 86400,
  "broker_latency_ms": 12
}
```
- **Publisher:** LoRa Gateway
- **Subscribers:** Spring Boot Backend (NotificationService)
- **Notes:** If backend stops receiving heartbeats for >90 seconds, it marks the gateway as offline and alerts the dashboard.

---

### tazrout/system/gateway/status

- **Direction:** LoRa Gateway → Backend
- **Trigger:** Gateway comes online or goes offline
- **QoS:** 1
- **Retained:** Yes
- **Notes:** Used with MQTT Last Will and Testament (LWT) for automatic offline detection.

---

### tazrout/system/backend/status

- **Direction:** Backend → Dashboard
- **Trigger:** Backend startup or shutdown
- **QoS:** 1
- **Retained:** Yes (with LWT)
- **Payload:**
```json
{
  "status": "ONLINE",
  "timestamp": "2026-02-15T10:00:00Z",
  "version": "1.0.0"
}
```
- **Notes:** Configure MQTT LWT (Last Will and Testament) to auto-publish `"OFFLINE"` if backend disconnects unexpectedly.

---

### tazrout/system/control

- **Direction:** Flutter Dashboard → Backend
- **Trigger:** Farmer selects reboot or shutdown from HomeScreen
- **QoS:** 1
- **Retained:** No
- **Payload:**
```json
{
  "command": "REBOOT",
  "reason": "User initiated from dashboard",
  "timestamp": "2026-02-15T14:35:00Z"
}
```
- **Notes:** `command`: `"REBOOT"` | `"SHUTDOWN"`. Backend acknowledges via `tazrout/dashboard/notifications` before executing.

---

### tazrout/system/emergency/alert

- **Direction:** AI Engine or Gateway → All subscribers
- **Trigger:** Critical system event
- **QoS:** 2
- **Retained:** No
- **Payload:** Same as zone alert (`EMERGENCY_ALERT` packet type)
- **Notes:** QoS 2 ensures critical alerts are never lost. Broadcast to all subscribers.

---

### tazrout/system/emergency/stop

- **Direction:** Dashboard → Backend, Gateway, AI Engine
- **Trigger:** Farmer presses Emergency Stop button
- **QoS:** 2
- **Retained:** No
- **Payload:**
```json
{
  "packet_type": "EMERGENCY_STOP",
  "issued_by": "DASHBOARD_USER",
  "timestamp": "2026-02-15T15:00:00Z"
}
```
- **Notes:** This is the ONLY valve-affecting command the dashboard can send. When received, the AI Engine halts decisions and the Gateway/Backend immediately forces all field MCUs to CLOSE their valves.

---

### tazrout/system/emergency/status

- **Direction:** Backend → Dashboard
- **Trigger:** Emergency state change
- **QoS:** 1
- **Retained:** Yes
- **Payload:**
```json
{
  "zones": [
    { "zone_id": "zone_a", "zone_name": "Zone A", "device_state": "ONLINE" },
    { "zone_id": "zone_b", "zone_name": "Zone B", "device_state": "OFFLINE" }
  ],
  "system_status": "DEGRADED"
}
```
- **Notes:** `system_status`: `"OPERATIONAL"` (all zones ONLINE), `"DEGRADED"` (1+ zones OFFLINE), `"CRITICAL"` (50%+ zones OFFLINE). Retained so dashboard restart gets current state.

---

## Dashboard Topics

### tazrout/dashboard/summary

- **Direction:** Backend → Dashboard
- **Trigger:** Periodically (every 30 seconds) or on sensor update
- **QoS:** 1
- **Payload:**
```json
{
  "current_metrics": {
    "water_output": 75.5,
    "soil_moisture": 45.2,
    "temperature": 24.0,
    "humidity": 65.0
  },
  "system_info": {
    "server_time": "2026-02-15T14:30:00Z",
    "active_zones": 3,
    "total_zones": 7
  },
  "did_you_know": {
    "fact": "Drip irrigation can save up to 60% more water compared to traditional methods."
  }
}
```
- **DTO:** `DashboardSummaryDto`

---

### tazrout/dashboard/performance/{period}

- **Direction:** Backend → Dashboard
- **QoS:** 1
- **Path parameter:** `{period}` — `day`, `week`, `month`
- **Payload:**
```json
{
  "water_output": [{ "timestamp": "...", "value": 75.5 }],
  "soil_moisture": [{ "timestamp": "...", "value": 45.2 }],
  "temperature": [{ "timestamp": "...", "value": 22.5 }],
  "humidity": [{ "timestamp": "...", "value": 65.0 }]
}
```
- **DTO:** `PerformanceMetricsDto`

---

### tazrout/dashboard/notifications

- **Direction:** Backend → Dashboard
- **Trigger:** Backend generates a push notification for the Flutter UI
- **QoS:** 1
- **Retained:** No
- **Payload:**
```json
{
  "id": "NOTIF-2026-001",
  "type": "sensorAlert",
  "title": "Zone B Offline",
  "message": "Zone B device has not reported for 2 minutes",
  "timestamp": "2026-02-15T14:30:00Z"
}
```
- **Notes:** Maps to Flutter's `NotificationModel`. `type`: `"sensorAlert"` | `"aiDecision"`.

---

## Analytics Topics

### tazrout/analytics/water-usage/{period}

- **Direction:** Backend → Dashboard
- **QoS:** 1
- **Path parameter:** `{period}` — `day`, `month`, `year`
- **DTO:** `WaterUsageDto`
- **Payload:**
```json
{
  "period": "month",
  "data": [{ "label": "Jan", "value": 400 }, { "label": "Feb", "value": 600 }],
  "unit": "liters"
}
```

---

### tazrout/analytics/environmental/{period}

- **Direction:** Backend → Dashboard
- **QoS:** 1
- **Path parameter:** `{period}` — `day`, `week`, `month`
- **DTO:** `EnvStatsDto`

---

### tazrout/analytics/consumption/{period}

- **Direction:** Backend → Dashboard
- **QoS:** 1
- **Path parameter:** `{period}` — `day`, `month`, `year`
- **DTO:** `ConsumptionByZoneDto`

---

## Settings & Support Topics

### tazrout/settings/preferences

- **Direction:** Bidirectional (↔)
- **QoS:** 1
- **DTO:** `UserPreferencesDto`
- **Payload:**
```json
{
  "language": "en", "theme": "Light", "font_size": "Medium",
  "date_format": "DD/MM/YYYY", "time_format": "24 Hours",
  "power_saving": false, "sleep_timer_minutes": 15,
  "ui_animations": true, "sound_alerts": false
}
```
- **Notes:** Maps to Flutter's `UserPreferencesModel`. Backend persists and re-publishes as confirmation.

---

### tazrout/support/contact

- **Direction:** Backend → Dashboard
- **QoS:** 1
- **Notes:** Static contact info, published once on connection.

---

## Topic Summary Table

| Topic                                          | Publisher        | Subscriber(s)       | QoS | Retained |
|------------------------------------------------|------------------|---------------------|-----|----------|
| `tazrout/zones/{zoneId}/sensors`              | LoRa Gateway     | Backend, AI Engine  | 1   | No       |
| `tazrout/zones/{zoneId}/state`                | LoRa Gateway     | Backend, Dashboard  | 1   | Yes      |
| `tazrout/zones/{zoneId}/valve/command`        | AI Engine        | LoRa Gateway        | 2   | No       |
| `tazrout/zones/{zoneId}/valve/ack`            | LoRa Gateway     | Backend, AI Engine  | 1   | No       |
| `tazrout/zones/{zoneId}/alert`                | Gateway / AI     | Backend, Dashboard  | 2   | No       |
| `tazrout/zones/all/sensors`                    | LoRa Gateway     | Dashboard (opt.)    | 0   | No       |
| `tazrout/ai/decisions`                         | AI Engine        | Backend, Dashboard  | 1   | No       |
| `tazrout/ai/decisions/latest`                  | AI Engine        | Dashboard           | 1   | Yes      |
| `tazrout/ai/alerts`                            | AI Engine        | Backend, Dashboard  | 2   | No       |
| `tazrout/system/gateway/heartbeat`            | LoRa Gateway     | Backend             | 0   | No       |
| `tazrout/system/gateway/status`               | LoRa Gateway     | Backend             | 1   | Yes      |
| `tazrout/system/backend/status`               | Backend          | Dashboard           | 1   | Yes      |
| `tazrout/system/control`                       | Dashboard        | Backend             | 1   | No       |
| `tazrout/system/emergency/alert`              | AI / Gateway     | All                 | 2   | No       |
| `tazrout/system/emergency/stop`               | Dashboard        | Backend, AI, Gateway| 2   | No       |
| `tazrout/system/emergency/status`             | Backend          | Dashboard           | 1   | Yes      |
| `tazrout/dashboard/summary`                   | Backend          | Dashboard           | 1   | No       |
| `tazrout/dashboard/performance/{period}`      | Backend          | Dashboard           | 1   | No       |
| `tazrout/dashboard/notifications`             | Backend          | Dashboard           | 1   | No       |
| `tazrout/analytics/water-usage/{period}`      | Backend          | Dashboard           | 1   | No       |
| `tazrout/analytics/environmental/{period}`    | Backend          | Dashboard           | 1   | No       |
| `tazrout/analytics/consumption/{period}`      | Backend          | Dashboard           | 1   | No       |
| `tazrout/settings/preferences`                | Bidirectional    | Backend ↔ Dashboard | 1   | No       |
| `tazrout/support/contact`                      | Backend          | Dashboard           | 1   | No       |
