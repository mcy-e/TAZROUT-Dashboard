# Tazrout System Testing Guide (Software-Only / No Hardware)

Use this guide to test the integration of the Backend, Frontend, and AI Engine *without* the physical ESP32 sensors or LoRa Gateway. We will use the Python simulator to act as the hardware gateway.

## Prerequisites
- **Comprehensive Setup:** If you are on a fresh computer, follow the full environment setup in [docs/PRESENTATION_GUIDE.md](../PRESENTATION_GUIDE.md).
- **Python 3.11:** Ensure you have Python 3.11 installed.
- **Dependencies:** Install required Python libraries:
  ```powershell
  cd D:\TAZROUT-Dashboard\backend\mock_data
  pip install -r requirements.txt
  ```
- **Important:** Since you are testing with the *real* AI engine, you must write `--no-ai` option with the  `mqtt_simulator.py` (more details below). If you don't do this, both the real AI and the simulator will fight over publishing conflicting decisions to the dashboard!

## Startup Sequence

### Step 1: Start Mosquitto Broker
```powershell
mosquitto -c "mqtt_setup/mosquitto.conf"
```

### Step 2: Seed Historical Data (Optional)
If you want to test the **Analytics** screen immediately with historical charts, run the backfill script. This generates 30 days of data in seconds.
```powershell
cd D:\TAZROUT-Dashboard\backend\mock_data
python backfill_simulator.py --days 30 --zones 6
```

### Step 3: Start Spring Boot Backend
```powershell
cd TAZROUT-Dashboard\backend
mvn spring-boot:run
```

### Step 4: Start AI Engine
Run the real AI engine. It will connect to Mosquitto and wait silently for sensor data to arrive.
```powershell
cd Irrigation_ml\Irrigation_ml
python3.11 app.py 
```

### Step 5: Start the Hardware Simulator
Run the simulator to generate fake sensor readings. The real AI Engine will read this fake data, calculate the necessary water amount, and publish real decisions back!
```powershell
cd TAZROUT-Dashboard\backend\mock_data
python mqtt_simulator.py
```

### Step 6: Launch Flutter Dashboard
```powershell
cd TAZROUT-Dashboard\frontend
flutter run -d windows
```

### Verification Checklist
- [ ] Dashboard displays the simulated zone data (Temperature, Moisture, etc.) coming from `mqtt_simulator.py`.
- [ ] The real AI Engine processes the simulated data and you see its actual calculated decisions appearing in the UI.
- [ ] Clicking "Emergency Stop" triggers the UI warning state (even though there are no physical valves to close).
