import argparse
import paho.mqtt.client as mqtt
import time
import json
import random
from datetime import datetime, timedelta

def on_connect(client, userdata, flags, rc):
    print(f"[BACKFILL] Connected with result code {rc}")

def run():
    parser = argparse.ArgumentParser(description="Tazrout Historical Data Backfiller")
    parser.add_argument("--broker", default="127.0.0.1", help="Mosquitto broker IP")
    parser.add_argument("--port", type=int, default=1883, help="Mosquitto port")
    parser.add_argument("--days", type=int, default=30, help="Days of history to backfill")
    parser.add_argument("--zones", type=int, default=6, help="Number of zones")
    args = parser.parse_args()

    client = mqtt.Client()
    client.on_connect = on_connect
    client.connect(args.broker, args.port, 60)
    client.loop_start()

    print(f"[BACKFILL] Generating {args.days} days of historical data for {args.zones} zones...")
    
    now = datetime.now()
    
    # Generate 1 reading per 4 hours for each day
    for day_offset in range(args.days, -1, -1):
        for hour in [2, 6, 10, 14, 18, 22]:
            sim_time = now - timedelta(days=day_offset)
            sim_time = sim_time.replace(hour=hour, minute=0, second=0, microsecond=0)
            
            # Skip future times if today
            if sim_time > now:
                continue
                
            for z_idx in range(args.zones):
                zone_id = f"zone-{z_idx+1}"
                
                # Small chance of having consumed water in the past bucket
                water_consumed = 0.0
                if random.random() < 0.2:
                    water_consumed = round(random.uniform(0.5, 2.5), 2)

                # Create fake sensor reading
                payload = {
                    "packetType": "SENSOR_READING",
                    "timestamp": sim_time.isoformat(),
                    "valve_state": "CLOSED",
                    "sensors": {
                        "temperature": {"value": round(random.uniform(15.0, 35.0), 1), "unit": "C"},
                        "soil_moisture": {"value": round(random.uniform(300.0, 700.0), 1), "unit": "g/m3"},
                        "humidity": {"value": round(random.uniform(30.0, 80.0), 1), "unit": "%"},
                        "water_level": {"value": round(random.uniform(5.0, 20.0), 1), "unit": "%"},
                        "water_consumed": {"value": water_consumed, "unit": "L"},
                    }
                }
                
                topic = f"tazrout/zones/{zone_id}/sensors"
                client.publish(topic, json.dumps(payload), qos=1)
                
            print(f"Published data for {sim_time.strftime('%Y-%m-%d %H:%00')}", end="\r")
            time.sleep(0.01) # Tiny sleep to avoid overwhelming broker

    print("\n[BACKFILL] Complete! Check your dashboard.")
    client.loop_stop()

if __name__ == "__main__":
    run()
