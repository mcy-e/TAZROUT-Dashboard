# Tazrout Dashboard — User Manual
**Version 2.0 | Smart Irrigation Monitoring System**

---

## What is Tazrout?

Tazrout is a desktop application that lets you monitor and control your smart irrigation system in real time. It displays live sensor data from your agricultural zones, shows AI-generated irrigation decisions, and lets you manage system settings — all from one screen.

The app runs on your local computer and communicates directly with your field devices over your local network. No internet connection is required.

---

## Getting Started

When you open the app, the **Home screen** loads automatically. The left sidebar shows the navigation menu. Click any item to switch screens. Click the menu icon (☰) at the top of the sidebar to collapse or expand it.

---

## Screens

### 1. Home

The main dashboard. Shows a live overview of your entire system.

**System Controls (top left)**
- **REBOOT** — Restarts the backend system. A confirmation dialog appears before the action runs. The icon spins while the reboot is in progress.
- **SHUT DOWN** — Powers down the backend system. Also requires confirmation.

**Welcome Card (top center)**
- Shows system health status. When all zones are running normally you see a green check icon and "Welcome Back!" message.
- If a zone goes offline or a critical reading is detected, the icon changes to amber and the message updates.

**Did You Know (top right)**
- Displays a rotating agricultural fact. The highlighted percentage value is shown in green.

**Performance Monitor (bottom left)**
- Shows live sensor readings in four mini-charts:
  - **Water Output** — current water output percentage
  - **Soil Moisture** — soil moisture in g/m³
  - **Temperature** — current temperature in °C
  - **Humidity** — humidity percentage
- Hover over any sub-card to highlight it.

**Time Widget (bottom right, top)**
- Live analogue clock with a digital readout below.

**Calendar Widget (bottom right, bottom)**
- Shows today's date.

---

### 2. Zones

Shows all your agricultural zones as cards in a 3-column grid.

**Collapsed card** — shows the zone name and a decorative symbol. Click **SHOW STATS** to expand.

**Expanded card** shows:
- **Device State** — ONLINE (green) or OFFLINE (red)
- **T : C°** — current temperature
- **M : g/m³** — soil moisture
- **Water : %** — water level
- **Valve State** — OPEN (blue droplet) or CLOSED (lock icon)
- Click **HIDE STATS** to collapse.

Online zones have a green top border. Offline zones have a red top border.

---

### 3. Analytics

Shows historical data and AI decisions.

**AI Latest Decision** — the most recent action taken by the AI engine.

**Observation** — something the AI detected in the sensor data.

**Recommendation** — a practical action suggested for the farmer.

**Water Usage Chart** — bar chart of water consumption. Toggle Day / Month / Year.

**Decision Logs** — table of all AI decisions. Filter by: All / Irrigation / Alerts / Advice.

**Env Stats** — line chart showing temperature (red) and humidity (blue) trends.

**Resource Consumption by Zone** — stacked bar chart per zone. Toggle Day / Week / Month.

---

### 4. Emergency Control

Use this screen to monitor device states and trigger an emergency stop.

**Zone Status Grid** — shows all zones with ONLINE (green dot) or OFFLINE (red dot) badges.

**Emergency Stop Button**
- Large red button at the bottom: **E M E R G E N C Y  S T O P**
- A confirmation dialog appears before the stop signal is sent.
- **Only press this in case of a real emergency.**

The Emergency item in the sidebar shows a red dot when any zone is offline.

---

### 5. Settings

**Display Settings**
| Setting | Options |
|---|---|
| Language | EN / FR / AR |
| Theme | Light / Dark |
| Font Size | Small / Medium / Large |
| Date Format | DD/MM/YYYY / MM/DD/YYYY / YYYY-MM-DD |
| Time Format | 24H / 12H |

**System Settings**
| Setting | Options |
|---|---|
| Power Saving | Enabled / Disabled |
| Auto Sleep Timer | 5 / 10 / 15 / 30 minutes / Never |
| UI Animations | Enabled / Disabled |

**Notification Settings**
| Setting | Options |
|---|---|
| Sound Alerts | Enabled / Disabled |

- **Reset Default** — reverts all settings to factory defaults.
- **Apply Settings** — saves and applies all changes immediately.

---

### 6. Help Center

**System Offline?** — Check the gateway power and local network connection.

**Erratic Readings?** — Sensor calibration may be required. Inspect the affected zone.

**Data Not Syncing?** — Check your local network. Data updates once connection is restored.

**Access Denied?** — Contact your system administrator.

**Get Support** — Opens a contact card with a QR code, support website, and phone number. Click × or tap outside to close.

---

### 7. User Manual

Displays the documentation inside the app. Version and last-updated date are shown at the bottom.

---

## Notifications

Notification cards slide in from the top-right of the screen.

- **Orange border** — sensor alert (zone offline or critical reading)
- **Blue border** — AI decision (irrigation triggered automatically)

Notifications dismiss automatically after 5 seconds. Click × to dismiss early.

---

## Sleep Mode

If there is no mouse movement or touch input for the duration set in Settings > Auto Sleep Timer, the screen dims. Moving the mouse or touching the screen wakes it immediately.

---

## Theme & Language

Go to **Settings → apply the change → Apply Settings**. Theme and language apply immediately when you press Apply.
