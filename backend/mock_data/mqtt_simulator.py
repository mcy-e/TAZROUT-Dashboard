# FILE: mqtt_simulator.py
# PURPOSE: Python script that simulates the LoRa Gateway and AI Engine
#          by publishing fake MQTT data to the Mosquitto broker.
#          Enables testing the Flutter dashboard without real
#          LoRa/ESP32 hardware or a running AI model.
#
# WHAT IT SIMULATES:
#   1. LoRa Gateway — publishes sensor readings per zone
#      Topic: tazrout/zones/{zoneId}/sensors
#      Packet type: SENSOR_READING (with signal.rssi, signal.snr)
#
#   2. LoRa Gateway — publishes device state changes
#      Topic: tazrout/zones/{zoneId}/state
#      Packet type: DEVICE_STATE_CHANGE
#
#   3. LoRa Gateway — publishes heartbeats
#      Topic: tazrout/system/gateway/heartbeat
#      Packet type: HEARTBEAT (every 30 seconds)
#
#   4. AI Engine — publishes irrigation decisions
#      Topic: tazrout/ai/decisions, tazrout/ai/decisions/latest
#      Packet type: AI_DECISION (with confidence_score, trigger_data, action)
#
#   5. AI Engine — publishes valve commands
#      Topic: tazrout/zones/{zoneId}/valve/command
#      Packet type: VALVE_COMMAND (issued_by: AI_ENGINE)
#
#   6. AI Engine — publishes emergency alerts on critical thresholds
#      Topic: tazrout/system/emergency/alert
#      Packet type: EMERGENCY_ALERT
#
# BEHAVIOR:
#   - Publishes sensor readings every 30 seconds (configurable)
#   - Default zone count: 7 (configurable via --zones flag)
#   - Generates random but realistic sensor values:
#       temperature: 18.0 - 38.0 °C
#       moisture:    200.0 - 800.0 g/m³
#       water_level: 10.0 - 95.0 %
#       humidity:    30.0 - 80.0 %
#   - Randomly flips zones OFFLINE/ONLINE to test emergency alerts
#   - Generates AI decisions when moisture drops below threshold
#   - Simulates valve command → ACK cycle
#   - Sends gateway heartbeat every 30 seconds
#
# USAGE:
#   python mqtt_simulator.py --broker 192.168.1.100 --port 1883 --zones 7 --interval 30
#
# DEPENDENCIES: paho-mqtt (pip install paho-mqtt)
# IMPLEMENTED BY: Mr. Fehis
