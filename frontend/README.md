# Tazrout Dashboard — Frontend README

## Overview

The Tazrout Dashboard frontend is a Flutter desktop application built for Windows that serves as the primary monitoring and control interface for the Tazrout Smart Irrigation system. It operates entirely on the Local Area Network (LAN) and requires no internet connection.

All data flows in from the Spring Boot backend via a single persistent WebSocket connection. The backend acts as a bridge between this dashboard and the Mosquitto MQTT broker, which in turn connects to the physical ESP32 sensor nodes and LoRa gateway in the field.

## Tech Stack

| Layer | Technology | Why |
|---|---|---|
| Framework | Flutter 3.x (Windows Desktop) | Single codebase, hardware-grade performance |
| State Management | Riverpod 2.x | Strict separation of UI and logic |
| Navigation | GoRouter | Declarative URL-based routing with ShellRoute |
| Data Transport | WebSocket (web_socket_channel) | Persistent connection to the Spring Boot backend |
| Charts | fl_chart | Lightweight, customizable chart library |
| Local Storage | shared_preferences | Persist user settings across restarts |
| Localization | Flutter ARB (intl) | English, French, Arabic with RTL support |
| PDF Viewer | syncfusion_flutter_pdfviewer | User manual rendering |
| Icons | phosphor_flutter + custom SVGs | Design-system-aligned icon set |

## Architecture

The application is organized into strict layers. Each layer has a single responsibility and communicates only with the layer directly below it.

```
UI (screens/widgets)
    ↓ reads from
Providers (Riverpod state)
    ↓ calls
Repositories (system actions)
    ↓ uses
Services (WebSocketService)
    ↓ connects to
Spring Boot Backend (WS Bridge)
    ↓ bridges to
MQTT Broker (Mosquitto)
    ↓ receives from
Field Hardware (ESP32 / LoRa Gateway)
```

## Project Structure

```
lib/
├── main.dart                    # App entry point
├── core/
│   ├── constants/               # MqttTopics, AppAssets (all paths)
│   ├── localization/l10n/       # ARB translation files (en, fr, ar)
│   ├── router/                  # GoRouter configuration
│   ├── theme/                   # AppColors, AppTypography, AppTheme
│   └── utils/                   # AppLogger, NotificationSound, locale helpers
├── models/                      # Pure data classes (ZoneModel, AiDecisionModel, etc.)
├── providers/                   # Riverpod Notifiers and state holders
├── repositories/                # SystemRepository (reboot, shutdown, emergency stop)
├── services/                    # WebSocketService (connection, parse, publish)
├── screens/
│   ├── home/                    # WelcomeCard, Clock, Calendar, SystemControls, PerformanceMonitor
│   ├── zones/                   # ZoneCard grid with live sensor data
│   ├── analytics/               # AI decision cards, charts, logs
│   ├── emergency/               # Zone device status grid + Emergency Stop
│   ├── settings/                # User preference panels
│   ├── help/                    # FAQ cards, QR contact, support banner
│   └── manual/                  # PDF viewer for user manual
└── widgets/
    └── common/                  # AppSidebar, EmptyStateWidget, SleepOverlay, NotificationToast
```

## Running Locally

### Prerequisites
- Flutter SDK >= 3.11.0
- Visual Studio Build Tools (Windows Desktop target)

### Setup
```powershell
cd D:\TAZROUT-Dashboard\frontend
flutter pub get
```

Copy `.env.example` to `.env` and set the WebSocket URL to point to your backend:
```
WS_URL=ws://192.168.1.x:8085/ws/dashboard
```

### Run
```powershell
flutter run -d windows
```

## Design System

- **Typography:** Poppins for headings, Inter for body text (via Google Fonts).
- **Themes:** Full dark and light mode support. Colors defined in `AppColors`.
- **Icons:** Two icon sets (Dark theme, Light theme). All paths centralized in `AppAssets`.
- **Patterns:** Amazigh (Berber) geometric patterns used as decorative overlays.
- **Symbols:** Named Berber symbols (Wisdom, Balance, Life, Unity, Eye) used in card accents.
- **Localization:** Arabic text direction is handled per-widget using `locale_text_direction.dart`. The global layout stays LTR to preserve the sidebar position.

## Environment Variables

| Variable | Description |
|---|---|
| `WS_URL` | WebSocket URL of the Spring Boot backend |

## For Detailed Documentation

- [Frontend Architecture](../docs/FRONTEND_ARCHITECTURE.md)
- [Frontend Developer Guide](../docs/FRONTEND_DEVELOPER_GUIDE.md)
- [Design System](../docs/FRONTEND_DESIGN_SYSTEM.md)
- [MQTT Topics Reference](../docs/MQTT_TOPICS.md)
