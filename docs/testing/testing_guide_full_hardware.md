# Tazrout System Testing Guide (Full Hardware Integration)

Follow this exact startup sequence when testing the system with the physical ESP32 nodes and LoRa Gateway.

## Prerequisites
- **Comprehensive Setup:** If you are on a fresh computer, follow the full environment setup in [docs/PRESENTATION_GUIDE.md](../PRESENTATION_GUIDE.md).
- **Python 3.11:** The AI Engine and simulation scripts require Python 3.11.
- **Dependencies:** Install required Python libraries for any local scripts:
  ```powershell
  pip install paho-mqtt
  ```
- Mr. Lhacani has added the required `read`/`write` permissions to the Mosquitto `acl` file.
- Mr. Salah has updated the AI Engine to be an MQTT subscriber/publisher script instead of a Flask HTTP server.

## Startup Sequence

### Step 1: Start Mosquitto Broker
The broker must start first because all components depend on it.
```powershell
mosquitto -c "C:\Users\reffa\Downloads\Telegram Desktop\mqtt setup\mqtt setup\mosquitto.conf"
```

### Step 2: Power On Hardware
Power on the Raspberry Pi LoRa Gateway and all ESP32 nodes. Ensure they connect to the LAN and begin publishing telemetry to Mosquitto on port `1883`.

### Step 3: Start Spring Boot Backend
Run the Java backend to bridge MQTT to WebSockets and enable PostgreSQL database logging.
```powershell
cd D:\TAZROUT-Dashboard\backend
mvn spring-boot:run
```

### Step 4: Start AI Engine
Run the updated AI script. It will listen to the live sensor data from the gateway and automatically publish `IRRIGATE` commands.
```powershell
cd C:\Users\reffa\Downloads\Irrigation_ml\Irrigation_ml
python app.py
```

### Step 5: Launch Flutter Dashboard
Run the frontend to view the live environment.
```powershell
cd D:\TAZROUT-Dashboard\frontend
flutter run -d windows
```

### Verification Checklist
- [ ] The dashboard populates with live ESP32 sensor readings.
- [ ] The "Decision Logs" card populates with real AI decisions.
- [ ] **Emergency Test:** Press the "Emergency Stop" button on the dashboard. You should immediately hear the physical relays/valves on the ESP32s click shut.
