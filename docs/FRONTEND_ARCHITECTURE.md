# Tazrout Frontend — Architecture Reference

## 1. System Context

This document describes the internal architecture of the Tazrout Dashboard Flutter application. It covers how the application is structured, how data flows through it, and why each architectural decision was made.

The frontend is a read-mostly interface. It receives live data from the field and displays it. The only write operations it performs are system commands (Reboot, Shutdown, Emergency Stop), which it sends outbound via WebSocket.

---

## 2. Communication Layer

### How data arrives

The frontend does not connect to MQTT directly. It maintains a single persistent WebSocket connection to the Spring Boot backend. The backend subscribes to all `tazrout/#` MQTT topics and re-broadcasts every message it receives as a JSON frame to all connected WebSocket clients.

Every frame follows the `WsFrame` structure:
```json
{ "topic": "tazrout/zones/zone-1/sensors", "timestamp": "...", "payload": "{...}" }
```

The `WebSocketService` class receives these raw frames, parses them into `WsFrame` objects, and broadcasts them on an internal stream. All Riverpod providers listen to that stream and filter for the topics they care about.

### How commands are sent

When the user presses Reboot, Shutdown, or Emergency Stop, the `SystemRepository` calls `WebSocketService.publish()`. This sends a `{topic, payload}` frame outbound over the WebSocket. The Spring Boot backend receives it and must relay it as an MQTT publish to the broker.

---

## 3. State Management (Riverpod)

The project uses Riverpod as its exclusive state management solution. There are no `setState` calls except inside purely local animation controllers.

### Provider Types Used

| Type | When to use |
|---|---|
| `Provider` | Provides a service instance (e.g., `WebSocketService`) |
| `NotifierProvider` | Complex state that needs methods (e.g., `ZoneNotifier`) |
| `StateNotifierProvider` | Settings/preferences (legacy Riverpod 1.x pattern still used) |
| `StateProvider` | Simple single-value flags (e.g., theme mode, locale) |

### Data Flow Pattern

Every data provider follows the same pattern:
1. Watch `webSocketServiceProvider` to get the service instance.
2. Subscribe to the `frames` stream in the `build()` method.
3. Register `ref.onDispose()` to cancel the subscription when the provider is destroyed.
4. Filter frames by topic in `_handleFrame()` and update state.

```
webSocketServiceProvider (Stream<WsFrame>)
    ↓ listened to by
ZoneNotifier         → filters tazrout/dashboard/summary, tazrout/zones/+/sensors
AiDecisionNotifier   → filters tazrout/ai/decisions, tazrout/ai/decisions/latest
NotificationNotifier → filters tazrout/dashboard/notifications, tazrout/system/emergency/alert
```

---

## 4. Routing (GoRouter)

The router uses a `ShellRoute` to wrap all pages in a shared shell layout. This means the sidebar, notification overlay, and sleep overlay are mounted once and persist across all route changes.

### Shell Layout Stack (bottom to top)
1. `AppSidebar` + `Expanded(child: child)` — the main content area
2. `NotificationOverlay` — sits above content, shows toast messages
3. `SleepOverlay` — topmost, covers everything when idle timer fires

### Route Map

| Path | Screen |
|---|---|
| `/` | HomeScreen |
| `/zones` | ZonesScreen |
| `/analytics` | AnalyticsScreen |
| `/emergency` | EmergencyScreen |
| `/settings` | SettingsScreen |
| `/help` | HelpScreen |
| `/manual` | UserManualScreen |

### Screen Transitions

All route transitions use `FadeTransition` + `ScaleTransition` (scale from 0.96 to 1.0). If Power Saving mode is enabled in settings, the transition duration is forced to `Duration.zero` for an instant snap.

---

## 5. Layer Responsibilities

### `core/`
Foundation code. Nothing in `core` imports from `screens`, `providers`, or `models`.

- `constants/app_assets.dart` — Every SVG/PNG path in one place. Never hardcode an asset path outside this file.
- `constants/mqtt_topics.dart` — Every topic string in one place. Includes helper methods like `isZoneSensorTopic()` and `zoneIdFrom()`.
- `theme/app_colors.dart` — All color tokens for dark and light themes.
- `theme/app_typography.dart` — All text style definitions.
- `theme/app_theme.dart` — Assembles `ThemeData` for both themes.
- `router/app_router.dart` — GoRouter configuration and shell layout.
- `utils/app_logger.dart` — Structured logger with severity levels. Used everywhere instead of `print()`.
- `utils/locale_text_direction.dart` — Helpers `isArabic()` and `textDirectionForUiLocale()` used by every widget that renders text.
- `utils/notification_sound.dart` — Plays the notification audio file using `dart:ffi`.
- `localization/l10n/` — ARB translation files for English, French, and Arabic.

### `models/`
Pure data classes. No Flutter imports allowed here. No logic beyond parsing and copying.

- `zone_model.dart` — Represents one irrigation zone. Has `fromSummaryJson()`, `withSensorJson()`, and `copyWith()`.
- `ai_decision_model.dart` — Represents one AI irrigation decision from the engine.
- `notification_model.dart` — Represents a dashboard notification (alert, advice, system).
- `user_preferences_model.dart` — Holds all user-configurable settings with defaults.
- `ws_frame.dart` — The parsed form of every message that arrives over WebSocket.

### `services/`
Infrastructure code. One class per external system.

- `web_socket_service.dart` — Manages the single WebSocket connection. Parses raw strings into `WsFrame` objects. Broadcasts on a stream. Handles connection, error, and close events.

### `repositories/`
Business logic for outbound operations. Takes service instances via constructor injection.

- `system_repository.dart` — Implements `rebootSystem()`, `shutdownSystem()`, and `emergencyStop()`. Each method publishes one or more command frames via `WebSocketService`.

### `providers/`
The bridge between data and UI. Nothing in `screens` accesses `services` or `repositories` directly.

- `zone_provider.dart` — Holds `List<ZoneModel>`. Updated from `dashboard/summary` and `zones/+/sensors` frames.
- `ai_decision_provider.dart` — Holds `AiDecisionState` (latest decision + rolling log of 100).
- `notification_provider.dart` — Holds the notification queue shown in the `NotificationOverlay`.
- `preferences_provider.dart` — Holds `UserPreferencesModel`. Persists to and loads from `SharedPreferences`.
- `theme_provider.dart` — `StateProvider<ThemeMode>` toggled by settings.
- `locale_provider.dart` — `StateProvider<Locale>` toggled by settings.
- `navigation_provider.dart` — Holds current nav index and `hasEmergencyAlertProvider`.
- `sleep_provider.dart` — `StateProvider<bool>` toggled by the `ActivityDetector`.
- `system_provider.dart` — Wires `SystemRepository` with `WebSocketService` and exposes it to UI.

### `screens/`
Feature screens. Each screen owns a `widgets/` subfolder. Screen files only compose widgets together.

### `widgets/common/`
Reusable widgets used across multiple screens.

- `app_sidebar.dart` — Left navigation sidebar. Renders nav items with active, hover, and idle states. Handles locale-aware icon ordering.
- `empty_state_widget.dart` — Standard "no data yet" view shown in all data cards while waiting for WebSocket data.
- `notification_overlay.dart` — Listens to `notificationProvider` and renders `NotificationToast`.
- `notification_toast.dart` — Animated slide-in/out notification card.
- `sleep_overlay.dart` — Full-screen overlay triggered by idle timer.
- `activity_detector.dart` — Wraps the shell layout. Detects pointer/keyboard events to reset the sleep timer.

---

## 6. Localization Strategy

The app supports three languages: English (`en`), French (`fr`), and Arabic (`ar`).

Translation strings live in `lib/core/localization/l10n/*.arb` files. The Flutter build system auto-generates the typed `AppLocalizations` class from these files.

**Arabic layout approach:** The global app layout is always LTR (Left to Right) to keep the sidebar on the left. Individual widgets that render text check `isArabic(context)` and apply `textDirectionForUiLocale(context)` to their `Text` widgets and `CrossAxisAlignment` values. This prevents the entire layout from flipping while still rendering Arabic text correctly.

---

## 7. Empty State Strategy

Every data-driven card follows this pattern:
1. Watch the relevant provider.
2. Check if the data is empty/null.
3. If empty, render `EmptyStateWidget(message: l10n.emptyStateNoData)`.
4. If data exists, render the actual chart or content.

This ensures no card ever shows stale mock data. When the backend is not running, every card shows the empty state cleanly.

---

## 8. Emergency Sync Strategy

The `EmergencyScreen` and `ZonesScreen` both read from the same `zonesProvider`. This ensures the zone list is always identical between screens. When `hasEmergencyAlertProvider` is `true`, the Emergency Screen maps all zones to `isOnline: false` locally without mutating provider state.

---

## 9. Pending Work (TODOs)

- Analytics chart topics (`tazrout/analytics/water-usage/`, `tazrout/analytics/environmental/`, `tazrout/analytics/consumption/`) are not yet wired. Charts show `EmptyStateWidget` until backend publishes to these topics.
- `PerformanceMonitorCard` is pending wiring to `tazrout/dashboard/performance`.
- Preferences are currently saved only to `SharedPreferences`. The TODO to sync them via `tazrout/settings/preferences` is not yet implemented.
- Backend must implement `handleTextMessage` in `DashboardWebSocketHandler` to relay outbound commands to MQTT.
