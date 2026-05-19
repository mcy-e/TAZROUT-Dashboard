import argparse
import paho.mqtt.client as mqtt
import time
import json
import random
import uuid
from datetime import datetime

def on_connect(client, userdata, flags, rc):
    if rc == 0:
        print(f"[INIT] Connected to Mosquitto at {userdata['broker']}:{userdata['port']}")
    else:
        print(f"[ERROR] Connection refused, return code {rc}")

def random_sensor_data(valve_state="CLOSED"):
    # Consumption only happens if valve is OPEN
    # In a real scenario, this would be a rate * interval.
    # For the demo, we use a small realistic volume per pulse.
    water_consumed = 0.0
    if valve_state == "OPEN":
        water_consumed = round(random.uniform(0.1, 0.4), 2) # Small realistic consumption

    # 30% chance of a "dry/hot" scenario
    if random.random() < 0.3:
        return {
            "temperature": round(random.uniform(35.0, 42.0), 1),
            "moisture":    round(random.uniform(50.0, 150.0), 1), # Very dry
            "humidity":    round(random.uniform(10.0, 25.0), 1),
            "waterLevel":  round(random.uniform(5.0, 20.0), 1),
            "water_consumed": water_consumed,
        }
    else:
        # Normal "chill" scenario
        return {
            "temperature": round(random.uniform(20.0, 28.0), 1),
            "moisture":    round(random.uniform(400.0, 800.0), 1),
            "humidity":    round(random.uniform(40.0, 70.0), 1),
            "waterLevel":  round(random.uniform(50.0, 95.0), 1),
            "water_consumed": water_consumed,
        }

def publish_dashboard_summary(client, zones):
    zones_payload = []
    for z in zones:
        v_state = random.choice(["OPEN", "CLOSED"])
        sensor = random_sensor_data(v_state)
        zones_payload.append({
            "zone_id":      z["id"],
            "zone_name":    z["name"],
            "device_state": z["state"],
            "valve_state":  v_state,
            "temperature":  sensor["temperature"],
            "moisture":     sensor["moisture"],
            "water_level":  sensor["waterLevel"],
        })

    payload = json.dumps({"zones": zones_payload})
    client.publish("tazrout/dashboard/summary", payload, qos=1, retain=True)
    print("[PUBLISHED] tazrout/dashboard/summary")

def publish_zone_sensors(client, zones):
    for z in zones:
        if z["state"] == "OFFLINE":
            continue # Don't send sensor data if offline
            
        v_state = random.choice(["OPEN", "CLOSED"])
        sensor = random_sensor_data(v_state)
        payload = json.dumps({
            "packetType": "SENSOR_READING",
            "timestamp":  datetime.now().isoformat(),
            "valve_state": v_state,
            "sensors": {
                "temperature": {"value": sensor["temperature"], "unit": "C"},
                "soil_moisture": {"value": sensor["moisture"], "unit": "g/m3"},
                "humidity": {"value": sensor["humidity"], "unit": "%"},
                "water_level": {"value": sensor["waterLevel"], "unit": "%"},
                "water_consumed": {"value": sensor["water_consumed"], "unit": "L"},
            },
        })
        topic = f"tazrout/zones/{z['id']}/sensors"
        client.publish(topic, payload, qos=1)
        print(f"[PUBLISHED] {topic}")

def update_and_publish_zone_states(client, zones):
    # Removed 10% random flip logic to ensure stable demonstration.
    # Now only publishes the initial state of the zones.
    for z in zones:
        # Only publish state periodically to keep backend in sync
        payload = json.dumps({
            "zone_id": z["id"],
            "current_device_state": z["state"],
            "valve_state": random.choice(["OPEN", "CLOSED"]),
            "timestamp": datetime.now().isoformat()
        })
        topic = f"tazrout/zones/{z['id']}/state"
        client.publish(topic, payload, qos=1)
        # print(f"[PUBLISHED STATE] {topic} -> {z['state']}")

def publish_ai_decision(client, zones):
    zone = random.choice(zones)
    payload = json.dumps({
        "decisionId":      str(uuid.uuid4()),
        "zoneId":          zone["id"],
        "timestamp":       datetime.now().isoformat(),
        "action":          "IRRIGATE",
        "waterAmount":     round(random.uniform(5.0, 25.0), 1),
        "confidenceScore": round(random.uniform(0.85, 0.99), 2),
        "notes":           "Soil moisture is below the critical threshold.",
        "farmerAdvice":    "Check the fertilizer tank levels before the next cycle.",
    })
    client.publish("tazrout/ai/decisions", payload, qos=1)
    client.publish("tazrout/ai/decisions/latest", payload, qos=1, retain=True)
    print("[PUBLISHED] tazrout/ai/decisions/latest")

def publish_gateway_heartbeat(client):
    payload = json.dumps({
        "packetType": "HEARTBEAT",
        "timestamp":  datetime.now().isoformat(),
        "status":     "ONLINE",
    })
    client.publish("tazrout/system/gateway/heartbeat", payload, qos=0)
    print("[PUBLISHED] tazrout/system/gateway/heartbeat")

def run():
    parser = argparse.ArgumentParser(description="Tazrout Dynamic MQTT Simulator")
    parser.add_argument("--broker", default="127.0.0.1", help="Mosquitto broker IP")
    parser.add_argument("--port", type=int, default=1883, help="Mosquitto port")
    parser.add_argument("--interval", type=int, default=10, help="Publish interval in seconds")
    parser.add_argument("--zones", type=int, default=4, help="Number of zones to generate")
    parser.add_argument("--zone-type", default="Zone", help="Type/Prefix for zone names (e.g. Orchard, Greenhouse)")
    parser.add_argument("--no-ai", action="store_true", help="Disable AI decision publishing (use this when running the real AI engine)")
    parser.add_argument("--offline-percent", type=int, default=0, help="Percentage of zones to force offline (0 to 100)")
    args = parser.parse_args()

    # Generate zones dynamically
    zones = [{"id": f"zone-{i+1}", "name": f"{args.zone_type} {chr(65+i)}", "state": "ONLINE"} for i in range(args.zones)]
    
    if args.offline_percent > 0:
        num_offline = max(0, int((args.offline_percent / 100.0) * len(zones)))
        for i in range(num_offline):
            zones[i]["state"] = "OFFLINE"
        print(f"!!! FORCING {args.offline_percent}% ({num_offline}) ZONES OFFLINE !!!")

    print(f"--- Configuration ---")
    print(f"Zones: {len(zones)} ({args.zone_type} A - {chr(65+len(zones)-1)})")
    print(f"AI Simulation: {'DISABLED' if args.no_ai else 'ENABLED'}")

    client = mqtt.Client(userdata={"broker": args.broker, "port": args.port})
    client.on_connect = on_connect

    try:
        client.connect(args.broker, args.port, keepalive=60)
        client.loop_start()
    except Exception as e:
        print(f"==================================================")
        print(f"[ERROR] CRITICAL STARTUP FAILURE")
        print(f"[ERROR] Could not connect to MQTT Broker at {args.broker}:{args.port}.")
        print(f"[ERROR] Please ensure Mosquitto is running BEFORE starting the simulator.")
        print(f"==================================================")
        import sys
        sys.exit(1)

    print("[INIT] Tazrout MQTT Simulator running. Press Ctrl+C to stop.\n")

    while True:
        update_and_publish_zone_states(client, zones)
        publish_dashboard_summary(client, zones)
        publish_zone_sensors(client, zones)
        if not args.no_ai:
            publish_ai_decision(client, zones)
        publish_gateway_heartbeat(client)
        print(f"--- Pulse complete. Waiting {args.interval}s ---\n")
        time.sleep(args.interval)

if __name__ == "__main__":
    run()
