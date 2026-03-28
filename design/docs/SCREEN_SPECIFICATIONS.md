# Tazrout Dashboard — Screen Specifications

> **Project:** Tazrout Agricultural IoT Monitoring Dashboard (Flutter Desktop)
> **Frontend Developer:** Reffas Chouaib
> **Backend Developer:** Mr. Fehis
> **Spec Version:** 1.0 — 2026-02-15
> **Themes:** Dark & Light (controlled via Settings)
> **Navigation:** Persistent left sidebar present on all screens

---

## Table of Contents

1. [Home (Dashboard)](#1-home-dashboard)
2. [Zones](#2-zones)
3. [Analytics](#3-analytics)
4. [Emergency Control](#4-emergency-control)
5. [Settings](#5-settings)
6. [Help Center](#6-help-center)
7. [User Manual](#7-user-manual)
8. [QR Code / Contact Card](#8-qr-code--contact-card)
9. [Appendix A: WebSocket Event Summary](#appendix-a-websocket-event-summary)
10. [Appendix B: API Endpoint Quick Reference](#appendix-b-api-endpoint-quick-reference)
11. [Appendix C: Frontend-Managed Items](#appendix-c-frontend-managed-items-backend-do-not-implement)

---

## Global: Sidebar Navigation

**Present on all screens. Not a standalone screen.**

### Components

| Component | Description |
|-----------|-------------|
| Logo | Tazrout plant icon + wordmark (top-left) |
| Hamburger menu icon | Collapses/expands sidebar |
| Nav items | Home, Zones, Analytics, Emergency, Settings, Help, User Manual |
| Active state | Green highlighted pill background on current page item |
| Inactive state | Muted icon + label, no background |

### Notes

- Emergency nav item gains a red accent icon when any zone reports OFFLINE or a CRITICAL decision is active.
- No API calls are made by the sidebar itself; state is driven by parent screen data.

---

## 1. Home (Dashboard)

### Screen Name
`HomeScreen`

### Layout Description

Three-column layout at the top, followed by a large two-column performance monitor section with a right-side widget column.

**Top row (3 columns):**
- Left: System Controls card
- Centre: Welcome / system status card
- Right: "Did You Know" fact card

**Middle / main area (2 columns):**
- Left (wide): Performance Monitor card containing a 2x2 grid of metric mini-graphs
- Right (narrow, stacked): Analogue Clock widget (top), Calendar / date widget (bottom)

### UI Components

| Component | Details |
|-----------|---------|
| **System Controls card** | Contains two full-width buttons: `REBOOT` (refresh icon) and `SHUT DOWN` (power icon). Card title "System Controls". |
| **Welcome card** | Circular check icon (green = healthy), bold heading "Welcome Back!", subtitle text describing system status. Background carries a subtle decorative pattern. |
| **Did You Know card** | Light-bulb icon (top-right), label "DID YOU KNOW?", rotating agricultural fact string with a highlighted percentage figure. |
| **Performance Monitor card** | Card header "Performance Monitor" with a green pulse icon and three pagination dots (swipeable pages). Contains four metric sub-cards in a 2x2 grid. |
| **Water Output sub-card** | Label "WATER OUTPUT", current value (e.g., `42%`), refresh icon button, area/line graph in green. |
| **Soil Moisture sub-card** | Label "SOIL MOISTURE", current value (e.g., `620 g/kg`), settings/filter icon button, area/line graph in blue. |
| **Temperature sub-card** | Label "TEMPERATURE", current value (e.g., `24 degrees C`), thermometer icon button, area/line graph in red/pink. |
| **Humidity sub-card** | Label "HUMIDITY", current value (e.g., `45%`), cloud icon button, area/line graph in amber/orange. |
| **Clock widget** | Analogue clock face with hour/minute/second hands, digital time readout below (HH:MM:SS), decorative diamond pattern motifs. Label "TIME". |
| **Calendar widget** | Shows "TODAY" label, large day number, month + year string in green, event indicator ("No events scheduled"). Decorative cross-stitch border pattern. |

### Interactive States

| State | Behaviour |
|-------|-----------|
| **Loading** | Each sub-card shows a skeleton/shimmer placeholder for the graph area and value. System Controls buttons are disabled. |
| **Healthy (default)** | Welcome card shows green check icon and "optimal parameters" message. |
| **Degraded** | Welcome card check icon turns amber; subtitle reflects the issue (e.g., "1 zone offline"). |
| **Error** | If `/dashboard/summary` fails, an inline error banner appears within the Welcome card with a retry button. Individual metric sub-cards show a "-" value and a greyed graph. |
| **Reboot / Shutdown confirming** | On button tap, a confirmation modal dialog appears before executing the command. Buttons show a loading spinner while the POST is in flight. |
| **Empty metrics** | If no historical readings exist, graphs display a flat baseline with a "No data available" micro-label. |

### API Endpoints Consumed

| Method | Endpoint | Purpose |
|--------|----------|---------|
| `GET` | `/api/v1/dashboard/summary` | Populates Welcome card status, Did You Know fact, current metric values in sub-card headers |
| `GET` | `/api/v1/dashboard/performance-metrics?period=day` | Populates the four mini line/area graphs inside Performance Monitor |
| `POST` | `/api/v1/system/control` | Triggered by REBOOT or SHUT DOWN button confirmation |
| `WS` | `ws://.../api/v1/ws/realtime` | Live updates for sensor values in sub-cards (`SENSOR_UPDATE` events) |

---

## 2. Zones

### Screen Name
`ZonesScreen`

### Layout Description

Full-width scrollable content area with no page header. Zones are arranged in a **responsive 3-column grid**, each rendered as a card. Cards vary in height depending on whether stats are expanded or collapsed.

### UI Components

| Component | Details |
|-----------|---------|
| **Zone card (collapsed)** | Zone name title (e.g., "Zone A"), decorative Tazrout cross-stitch logo centred, "Show stats" outlined button at bottom. Card border colour: neutral. |
| **Zone card (expanded — Online)** | Zone name, "Hide stats" button (top-right, outlined). Inner dark sub-card: "DEVICE STATE" label + green WiFi icon + "Online". Right column: `T : C°` value, `M : g/m3` value, `Water : %` value. Bottom bar: "VALVE STATE" label + droplet icon + state text. Card top border: **green** accent stripe. |
| **Zone card (expanded — Offline)** | Same as Online layout but device state shows red WiFi-slash icon + "Offline" text in red. "Hide stats" button has red text/border. Card top border: **red** accent stripe. Valve state text is muted. |
| **Zone card (error / critical)** | Decorative icon turns red, "Show stats" button text turns red, card border turns red. |
| **Device state badge** | Small label "DEVICE STATE" + icon + status text. Green = ONLINE, Red = OFFLINE. |
| **Valve state bar** | Full-width bottom bar. Droplet icon + "Open" (blue) or lock icon + "Closed" (muted). |
| **Stats row** | Three data points: Temperature (C), Moisture (g/m3), Water level (%). |

### Interactive States

| State | Behaviour |
|-------|-----------|
| **Loading** | Grid shows skeleton card placeholders (shimmer on icon and stats area). |
| **Collapsed** | Card shows only zone name + decorative logo + "Show stats" button. |
| **Expanded** | Card grows to show full device state, sensor readings, and valve state. |
| **Online / Offline** | Green vs red visual treatment on border, icon, and badge. |
| **Error fetching** | Cards show "-" for all values with a warning icon. A retry banner appears above the grid. |
| **Empty (no zones)** | Full-width empty state with text "No zones configured." |
| **WebSocket disconnected** | A subtle top banner warns "Live data unavailable - showing last known values." Values are greyed out. |

### API Endpoints Consumed

| Method | Endpoint | Purpose |
|--------|----------|---------|
| `GET` | `/api/v1/zones` | Initial load of all zone cards with sensor data |
| `GET` | `/api/v1/zones/{zone_id}` | Detailed refresh when a specific card is expanded |
| `WS` | `ws://.../api/v1/ws/realtime` | Live `SENSOR_UPDATE`, `DEVICE_STATE_CHANGE`, `VALVE_STATE_CHANGE` events to update card values in real time |

---

## 3. Analytics

### Screen Name
`AnalyticsScreen`

### Layout Description

Two-column layout in the upper half, single-row chart strip in the lower half.

**Upper-left:** AI Latest Decision card (tall, with decorative graphic overlay)
**Upper-right:** Decision Logs table card
**Below AI card:** Two-card sub-row — Observation (left) and Recommendation (right)
**Lower row (3 equal columns):** Water Usage bar chart | ENV Stats line chart | Resource Consumption by Zone stacked bar chart

### UI Components

| Component | Details |
|-----------|---------|
| **AI Latest Decision card** | Robot/circuit icon (top-left), label "AI Latest Decision", decorative gear motif (top-right). Body: quoted decision text with bold zone names highlighted. Faint dashed border style. |
| **Observation sub-card** | Clipboard icon, label "Observation", body text in amber/orange (e.g., "Detected high temperature variance in Zone D sensor array.") |
| **Recommendation sub-card** | Plant/sensor icon, label "Recommendation", body text in green (e.g., "Inspect irrigation valves in Zone D manually for blockage.") |
| **Decision Logs table card** | Title "Decision Logs". Filter tab bar: `All` | `Irrigation` | `Alerts` | `Advice` (pill buttons, active = filled green). Table columns: `ID`, `DATE`, `TYPE`, `DETAILS`. |
| **Decision type badges** | Colour-coded chips: `IRRIGATION` = teal, `ALERT` = amber, `ADVICE` = olive/muted, `CRITICAL` = red. |
| **Water Usage bar chart** | Title "WATER USAGE (LITERS)". Vertical bars per month (JAN-MAY visible). Current month highlighted in bright blue, others in muted teal. |
| **ENV Stats line chart** | Title "ENV STATS". Dual-line chart: `Temp` (red line) and `Hum` (blue dashed line). Large current temperature label overlaid (e.g., "24 degrees C AVG TEMP"). |
| **Resource Consumption by Zone chart** | Title "Resource Consumption by Zone". Toggle: `DAY` | `WEEK` | `MONTH`. Stacked vertical bars per zone. Three segments per bar: Water (blue), Moisture (green), Temp (red/coral). Legend at bottom. |

### Interactive States

| State | Behaviour |
|-------|-----------|
| **Loading** | AI Decision card shows shimmer text placeholder. Table shows skeleton rows. Charts show empty axes with a spinner. |
| **No decisions yet** | AI Decision card displays "No decisions recorded yet." Observation and Recommendation sub-cards show placeholder dashes. Table shows "No logs found." |
| **Filter active** | Decision Logs table filters rows to the selected type. Active filter pill turns solid green. |
| **Error (AI endpoint)** | AI Decision card shows an error icon and "Unable to load latest decision." |
| **Error (table endpoint)** | Table body replaced with an inline error message + retry button. |
| **Period toggle** | Switching DAY / WEEK / MONTH on Resource Consumption re-fetches and re-renders the stacked bar chart. |
| **Chart empty** | Axes render with "No data for selected period" label centred in the chart area. |

### API Endpoints Consumed

| Method | Endpoint | Purpose |
|--------|----------|---------|
| `GET` | `/api/v1/ai/latest-decision` | Populates AI Latest Decision card, Observation text (`notes`), Recommendation text (`farmer_advice`) |
| `GET` | `/api/v1/ai/decisions?type=&limit=20&offset=0` | Populates the Decision Logs table; `type` param driven by filter tab selection |
| `GET` | `/api/v1/analytics/water-usage?period=month` | Populates the Water Usage bar chart |
| `GET` | `/api/v1/analytics/environmental-stats?period=day` | Populates the ENV Stats dual-line chart |
| `GET` | `/api/v1/analytics/consumption-by-zone?period=day` | Populates the Resource Consumption stacked bar chart; period driven by DAY/WEEK/MONTH toggle |
| `WS` | `ws://.../api/v1/ws/realtime` | `AI_DECISION` events trigger a refresh of the Latest Decision card and prepend a new row to the logs table |

---

## 4. Emergency Control

### Screen Name
`EmergencyScreen`

### Layout Description

Full-width content area with a page header, a scrollable zone status grid, and a fixed-position Emergency Stop button pinned to the bottom.

**Header:** Alert bell icon + "Emergency Control" heading + subtitle
**Body:** Responsive 4-column grid of zone status cards
**Footer (pinned):** Full-width Emergency Stop button inside a container card

### UI Components

| Component | Details |
|-----------|---------|
| **Page header** | Red/coral alert icon, bold "Emergency Control" title, subtitle: "Monitor live independent device states. In case of system failure or hazard, initiate emergency stop immediately." |
| **Zone status card (Online)** | Zone name centred, green dot + "ONLINE" pill badge. Neutral card background. |
| **Zone status card (Offline)** | Zone name centred, red dot + "OFFLINE" pill badge (red background tint). Warmer card background tint. |
| **Emergency Stop button** | Full-width, bold red/coral background. White uppercase text "EMERGENCY STOP" with two circle icons flanking the label. Decorative stitched border pattern on button. |
| **Bottom container** | Rounded card wrapping the Emergency Stop button, providing visual separation from the zone grid. |

### Interactive States

| State | Behaviour |
|-------|-----------|
| **Loading** | Zone cards show shimmer skeleton. Emergency Stop button is disabled (greyed out). |
| **All zones online** | All cards show green ONLINE badges. No warnings in sidebar. |
| **Mixed online/offline** | Offline cards render with red badge. Sidebar Emergency nav item gains a red accent. |
| **All zones offline** | All cards show red OFFLINE badges. Page header subtitle may update to indicate system-wide failure. |
| **Emergency Stop pressed** | Frontend-managed confirmation dialog appears. On confirm, Flutter handles the stop logic. Button shows loading state during execution. |
| **Error (status fetch)** | Zone grid replaced with full-width error card "Unable to retrieve zone statuses." + Retry button. Emergency Stop button remains active. |
| **WebSocket live update** | Cards animate badge change (ONLINE to OFFLINE or reverse) when `DEVICE_STATE_CHANGE` events arrive. |

### API Endpoints Consumed

| Method | Endpoint | Purpose |
|--------|----------|---------|
| `GET` | `/api/v1/emergency/status` | Initial load of all zone online/offline states for the grid |
| `WS` | `ws://.../api/v1/ws/realtime` | `DEVICE_STATE_CHANGE` and `EMERGENCY_ALERT` events for live card state updates |
| *(Frontend-managed)* | `POST /api/v1/emergency/stop` | **NOT a backend endpoint.** Emergency stop logic is owned entirely by the Flutter frontend (Reffas Chouaib). Backend team must not implement this. |

---

## 5. Settings

### Screen Name
`SettingsScreen`

### Layout Description

Single centred column of stacked section cards, with a fixed action button row at the bottom-right of the screen.

**Header:** Title "Settings" + subtitle "Manage your preferences and system configurations."
**Body (3 section cards, vertically stacked):** Display Settings, System Settings, Notification Settings
**Footer:** `Reset Default` (outlined) + `Apply Settings` (filled green) buttons — bottom-right aligned.

### UI Components

| Component | Details |
|-----------|---------|
| **Display Settings card** | Monitor icon + section title. Five setting rows: Switch Language, Switch Theme, Switch Font Size, Date Format, Time Format. Each row: label + description on left, current value in a rounded selector on right. |
| **Switch Language row** | Dropdown-style selector. Options: English, French, Arabic. |
| **Switch Theme row** | Dropdown-style selector. Options: `Light`, `Dark`. Changes propagate immediately to the entire app. |
| **Switch Font Size row** | Dropdown-style selector. Options: Small, Medium, Large. |
| **Date Format row** | Dropdown-style selector. Options: DD/MM/YYYY, MM/DD/YYYY, YYYY-MM-DD. |
| **Time Format row** | Dropdown-style selector. Options: 24 Hours, 12 Hours (AM/PM). |
| **System Settings card** | Gear icon + section title. Three rows: Power Saving (toggle), Auto-Sleep Timer (dropdown), UI Animations (toggle). |
| **Power Saving toggle** | Toggle switch (off by default). Label + sub-description "Reduce performance to save energy." |
| **Auto-Sleep Timer row** | Dropdown selector. Options: 5 min, 10 min, 15 min, 30 min, Never. Default: 15 Minutes. |
| **UI Animations toggle** | Toggle switch (on by default, green). Label "Enable smooth transitions and effects." |
| **Notification Settings card** | Bell icon + section title. One row: Sound Alerts toggle (off by default). |
| **Reset Default button** | Outlined button. Reverts all fields to defaults locally without saving. |
| **Apply Settings button** | Filled green button. Persists all changes via PUT endpoint. |

### Interactive States

| State | Behaviour |
|-------|-----------|
| **Loading (initial GET)** | All selector and toggle fields show shimmer skeletons. Buttons are disabled. |
| **Unsaved changes** | Dirty fields are visually marked. Apply Settings button becomes more prominent. |
| **Applying (PUT in flight)** | Apply Settings button shows a loading spinner. Other controls are briefly disabled. |
| **Apply success** | Brief success snackbar: "Settings saved." Theme/font changes take effect immediately across the app. |
| **Apply error** | Error snackbar: "Failed to save settings. Please try again." Fields retain their pending values. |
| **Reset Default** | All fields snap back to default values locally. No API call is made until Apply is tapped. |

### API Endpoints Consumed

| Method | Endpoint | Purpose |
|--------|----------|---------|
| `GET` | `/api/v1/user/preferences` | Populates all setting fields on screen load |
| `PUT` | `/api/v1/user/preferences` | Persists all setting changes when "Apply Settings" is tapped |

---

## 6. Help Center

### Screen Name
`HelpScreen`

### Layout Description

Single-column centred content area with a page header, a 2x2 FAQ card grid, and a "Still need assistance?" banner at the bottom.

**Header:** Title "Help Center" + subtitle "Find answers and support for your dashboard."
**Body:** 2-column, 2-row grid of static issue cards
**Footer:** Dark-background support banner card with a CTA button

### UI Components

| Component | Details |
|-----------|---------|
| **Page header** | "Help Center" H1 + subtitle. No icon. |
| **Issue card — System Offline?** | Red/orange warning circle icon, bold title, body text with troubleshooting steps. Background uses diagonal Amazigh pattern. |
| **Issue card — Erratic Readings?** | Blue pulse/waveform icon, bold title, body text recommending Zones diagnostics tab. |
| **Issue card — Data Not Syncing?** | Amber bar-chart icon, bold title, body text about internet connection and local cache behaviour. |
| **Issue card — Access Denied?** | Purple lock icon, bold title, body text directing user to their administrator. |
| **"Still need assistance?" banner** | Dark card with decorative corner icons (Tazrout motifs). Centre text: bold heading + support availability message. Right side: lifesaver ring icon. |
| **Get Support button** | White outlined CTA button "Get Support ->" inside the banner. Triggers QR/Contact Card overlay. |

### Interactive States

| State | Behaviour |
|-------|-----------|
| **Default** | All four issue cards are static informational content. No loading states required. |
| **Get Support tapped** | Triggers display of the QR Code / Contact Card overlay (Section 8). |
| **Error (contact endpoint)** | If contact info fails to load, the "Get Support" button is disabled with a tooltip "Contact info unavailable." |

### API Endpoints Consumed

| Method | Endpoint | Purpose |
|--------|----------|---------|
| `GET` | `/api/v1/support/contact` | Populates phone number and website URL used by the QR/Contact card triggered from "Get Support" |

> **Note:** FAQ card content is **frontend-managed static content**. Do not implement `GET /api/v1/support/faq`.

---

## 7. User Manual

### Screen Name
`UserManualScreen`

### Layout Description

Single centred content area with a page header and a large document viewer card filling the remaining height.

**Header:** Title "User Manual" + subtitle "View documentation and operating procedures."
**Body:** Mac-style window frame card (with red/amber/green traffic-light dots and a filename tab `manual_v2.0.pdf`) containing the document viewer.
**Footer (inside card):** Last updated date + version string.

### UI Components

| Component | Details |
|-----------|---------|
| **Page header** | "User Manual" H1 + subtitle. |
| **Document viewer card** | Rounded card with mock macOS window chrome at top. Filename tab centred: `manual_v2.0.pdf`. |
| **Document placeholder / viewer** | When no PDF is loaded: centred book icon + "Document Helper" title + body text. When loaded: rendered PDF pages or rich text with scroll support. |
| **Traffic-light buttons** | Red (close), amber (minimise), green (maximise) decorative dots — visual only. |
| **Footer metadata** | Muted text: last-updated date and version number (e.g., "Last updated: Oct 24, 2024 - Version 2.0"). |

### Interactive States

| State | Behaviour |
|-------|-----------|
| **Loading** | Viewer area shows a shimmer or "Loading document..." spinner. |
| **Loaded** | PDF or rich-text content renders inside the card with scroll support. |
| **Empty / not configured** | Placeholder: book icon + "Document Helper" descriptive text. |
| **Error** | "Unable to load manual. Please check your connection." with a retry button. |

### API Endpoints Consumed

> **This screen is fully frontend-managed.** All user manual content (PDF files, markdown) is handled by the Flutter frontend developer in `docs/user-manuals/`. No backend API calls are required.

| Method | Endpoint | Purpose |
|--------|----------|---------|
| *(none)* | — | No backend API calls required for this screen |

---

## 8. QR Code / Contact Card

### Screen Name
`QrContactCard` (modal overlay or sub-screen, triggered from Help Center)

### Layout Description

A narrow portrait card displayed as a centred modal or full-screen overlay. Uses a decorative Amazigh triangular pattern as the card background. A secondary informational banner sits below the card.

**Card body (top to bottom):** Heading, subtitle, QR code display, website button row, phone button row
**Below card:** Dark informational banner with support availability text

### UI Components

| Component | Details |
|-----------|---------|
| **Card container** | Rounded card with dark background and full-height triangular chevron pattern borders (Amazigh motif). |
| **Heading** | Bold large text: "More Help?" |
| **Subtitle** | "Scan the code below or call the following number for More Help." |
| **QR code** | Green QR code image centred in a rounded display container. Encodes the support URL. |
| **Website button row** | Globe icon + `Tazrout/help.com` text. Full-width tappable row. Decorative corner accent icons. |
| **Phone button row** | Phone icon + `+213-55-55-55-55` text. Full-width tappable row with warm green background tint. Decorative corner accent icons. |
| **Support banner** | Question-mark icon, bold "Still need assistance?" prefix + "Our support team is available 24/7..." body text. |

### Interactive States

| State | Behaviour |
|-------|-----------|
| **Default** | Card displays static contact information. QR code is pre-rendered. |
| **Loading (contact data)** | Phone and URL rows show shimmer while waiting for `GET /api/v1/support/contact` response. |
| **Error (contact data)** | Rows show "-" with a warning icon. QR code may still render if URL is hardcoded as fallback. |
| **Website tapped** | Opens `Tazrout/help.com` in the system browser. |
| **Phone tapped** | On desktop: copies number to clipboard or opens system dialler if available. |

### API Endpoints Consumed

| Method | Endpoint | Purpose |
|--------|----------|---------|
| `GET` | `/api/v1/support/contact` | Populates phone number (`emergency_number`) and support website URL displayed in the contact rows |

---

## Appendix A: WebSocket Event Summary

| Event Type | Screens Listening | Effect |
|------------|-------------------|--------|
| `SENSOR_UPDATE` | Home, Zones | Updates live metric values in sub-cards and zone cards |
| `DEVICE_STATE_CHANGE` | Zones, Emergency | Updates ONLINE/OFFLINE badge on zone cards |
| `VALVE_STATE_CHANGE` | Zones | Updates valve state bar on zone card |
| `AI_DECISION` | Analytics | Prepends new row to Decision Logs table; refreshes Latest Decision card |
| `EMERGENCY_ALERT` | Emergency | Highlights affected zone cards; may trigger an app-level alert banner |

**WebSocket endpoint:** `ws://backend-url/api/v1/ws/realtime`
**Required auth header:** `Authorization: Bearer <JWT_TOKEN>`

---

## Appendix B: API Endpoint Quick Reference

| # | Method | Endpoint | Screen(s) |
|---|--------|----------|-----------|
| 1 | GET | `/api/v1/dashboard/summary` | Home |
| 2 | GET | `/api/v1/dashboard/performance-metrics` | Home |
| 3 | POST | `/api/v1/system/control` | Home |
| 4 | GET | `/api/v1/zones` | Zones |
| 5 | GET | `/api/v1/zones/{zone_id}` | Zones |
| 6 | GET | `/api/v1/ai/latest-decision` | Analytics |
| 7 | GET | `/api/v1/ai/decisions` | Analytics |
| 8 | GET | `/api/v1/analytics/water-usage` | Analytics |
| 9 | GET | `/api/v1/analytics/environmental-stats` | Analytics |
| 10 | GET | `/api/v1/analytics/consumption-by-zone` | Analytics |
| 11 | GET | `/api/v1/emergency/status` | Emergency |
| 12 | GET | `/api/v1/user/preferences` | Settings |
| 13 | PUT | `/api/v1/user/preferences` | Settings |
| 14 | GET | `/api/v1/support/contact` | Help, QR Card |
| 15 | POST | `/api/v1/auth/login` | App startup / auth flow |
| WS | — | `ws://.../api/v1/ws/realtime` | Home, Zones, Analytics, Emergency |

---

## Appendix C: Frontend-Managed Items (Backend: Do Not Implement)

| Item | Owner | Notes |
|------|-------|-------|
| `POST /api/v1/emergency/stop` | Frontend — Reffas Chouaib | Emergency stop logic managed entirely in Flutter application |
| `GET /api/v1/support/faq` | Frontend — Reffas Chouaib | FAQ content is static, stored in Flutter assets |
| User manual content | Frontend — Reffas Chouaib | All files in `docs/user-manuals/` (EN, FR, AR variants) |
| Localization / translations | Frontend — Reffas Chouaib | All `.arb` files in `frontend/lib/core/localization/l10n/` |
| Language switching logic | Frontend — Reffas Chouaib | Handled entirely in Flutter — no backend involvement needed |
| Theme switching logic | Frontend — Reffas Chouaib | Light/Dark toggle applied locally; user preference persisted via Settings API only |