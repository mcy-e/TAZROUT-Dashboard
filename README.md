# TAZROUT Dashboard

A modern, cross-platform smart irrigation system built for LAN-only, offline agricultural environments. Designed for flexibility, performance, and real-time control without relying on the cloud.

---

## Overview

Tazrout is a complete IoT solution consisting of field sensors, a localized LoRa network, an AI decision engine, a Spring Boot backend, and a Flutter desktop dashboard. All software components run on a **single central server** to guarantee ultra-low latency and absolute offline capability.

### Key Features
- **`Real-time data visualization`** - Live updates via MQTT and WebSocket
- **`AI-Driven Irrigation`** - Automated valve control based on a trained machine learning model
- **`Multi-zone monitoring`** - Track multiple agricultural zones simultaneously  
- **`Analytics & insights`** - Historical data analysis via PostgreSQL
- **`Emergency controls`** - Quick-action stops and system status monitoring
- **`Multi-language support`** - English, French, and Arabic with RTL layout

---

## Architecture

The entire software stack runs co-located on the same physical machine:

```text
┌────────────────────────────────────────────────────────┐
│               CENTRAL SERVER / PC                      │
│                                                        │
│  ┌─────────────────┐       ┌────────────────────────┐  │
│  │ Mosquitto Broker│◀──TCP─┤ Spring Boot Backend    │  │
│  │ (Mr. Lhacani)   │       │ (Mr. Fehis)            │  │
│  └────────┬────────┘       │ Persists to PostgreSQL │  │
│           │                │ Bridges MQTT to WS     │  │
│           │ MQTT           └───────────┬────────────┘  │
│           │                            │ WebSocket     │
│  ┌────────▼────────┐       ┌───────────▼────────────┐  │
│  │ AI Engine       │       │ Flutter Desktop App    │  │
│  │ (Mr. Salah)     │       │ (Mr. Chouaib)          │  │
│  │ Controls Valves │       │ Read-only monitoring   │  │
│  └─────────────────┘       └────────────────────────┘  │
└─────────────────────────────────▲──────────────────────┘
                                  │ 
                            ┌─────────────────────────────────┐
                            |    LoRa Gateway                 |
                            |    Field Sensors (ESP32)        |
                            |    (Mr. Khanfri)                |
                            └─────────────────────────────────┘                
```

**Single-Server Hosting**: The Broker, AI, Backend, Database, and UI share the same hardware.

---

## Team

- **Mr. Chouaib** — Frontend (Flutter Desktop App)
- **Mr. Fehis** — Backend (Spring Boot, PostgreSQL, WebSocket Bridge)
- **Mr. Salah** — AI Engine (Trained Model, Valve Command logic)
- **Mr. Lhacani** — Networking (Mosquitto MQTT Broker)
- **Mr. Khanfri** — Embede System (EPS32 Sensors)

---

## Tech Stack

### Frontend

- **Flutter Desktop** - Native cross-platform UI (Windows/Linux)
- **Riverpod** - Reactive state management watching WebSocket streams
- **fl_chart** - Interactive charts
- **flutter_intl** - Internationalization

### Backend  
- **Spring Boot 3** - High-performance Java backend
- **Spring Integration MQTT** - Native Mosquitto bridging
- **Spring WebSocket** - Real-time client streaming
- **Spring Data JPA / PostgreSQL** - Robust data persistence

### AI & Networking
- **Python / paho-mqtt** - AI Engine logic
- **Mosquitto** - MQTT Pub/Sub broker

---

## Project Structure

```text
TAZROUT-Dashboard/
│
├── README.md                       # Project overview
├── docs/                           # Central Documentation
│   ├── ARCHITECTURE.md             # Detailed system architecture
│   ├── MQTT_TOPICS.md              # All 23 MQTT topic contracts
│   ├── SETUP_GUIDE.md              # Installation instructions
│   ├── BACKEND_DEVELOPER_BRIEF.md  # Roadmap for Mr. Fehis
│   └── BACKEND_DATA_REQUIREMENTS.md# Data models & validation rules
│
├── backend/                        # Spring Boot Backend Code
│   ├── src/main/java/...           # Java application code
│   ├── src/main/resources/         # application.properties & schema.sql
│   ├── mock_data/                  # Python MQTT simulator
│   └── pom.xml                     # Maven dependencies
│
└── frontend/                       # Flutter Desktop App
    ├── lib/                        # Dart source code
    │   ├── core/                   # Routing, theme, i18n
    │   ├── models/                 # Data classes mapping to backend DTOs
    │   ├── providers/              # Riverpod state managers
    │   ├── screens/                # UI screens (Home, Zones, AI Log)
    │   └── widgets/                # Reusable UI components
    ├── pubspec.yaml                # Flutter dependencies
    └── windows/linux/macos/        # Platform configurations
```

---

## 🛠️ Quick Start

### 1. Database & MQTT Setup
Ensure PostgreSQL and Mosquitto are running locally.
```bash
# Set up PostgreSQL schema
psql -U postgres -c "CREATE DATABASE tazrout;"
psql -U postgres -d tazrout -f backend/src/main/resources/schema.sql
```

### 2. Run the Backend
```bash
cd backend
mvn clean install
mvn spring-boot:run
```

### 3. Run the Mock Simulator (Testing without Hardware/AI)
```bash
cd backend/mock_data
pip install paho-mqtt
python mqtt_simulator.py --broker localhost --port 1883
```

### 4. Run the Frontend
```bash
cd frontend
flutter pub get
flutter run -d windows
```

---

## 📖 Documentation

For developers joining the project, please review:
- [Architecture & Data Flows](./docs/ARCHITECTURE.md)
- [MQTT Topic Registry](./docs/MQTT_TOPICS.md)
- [Backend Developer Brief](./docs/BACKEND_DEVELOPER_BRIEF.md)

---

## Project Status

**Version**: 2.0.0  
**Status**: Backend Implementation Phase  
**Last Updated**: 20 April 2026
