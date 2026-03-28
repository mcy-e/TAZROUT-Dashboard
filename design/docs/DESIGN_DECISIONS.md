# TAZROUT Dashboard — Design Decision Log
> Smart Agricultural IoT Irrigation System · UI/UX Architecture
> Prepared by: Reffas Chouaib (UI/UX Designer) · Last updated: March 2026

---

## How to Read This Log

Each entry follows the format:

| Field | Content |
|---|---|
| **ID** | Unique reference (e.g. DD-01) |
| **Category** | Theme · Navigation · Color · Components · Accessibility |
| **Decision** | What was decided |
| **Rationale** | Why this choice was made |
| **Alternatives Considered** | What was evaluated but rejected, and why |
| **Status** | Approved / Under Review / Superseded |

---

## Theme

### DD-01 · Dual Theme System (Light Default + Dark Optional)

| | |
|---|---|
| **Decision** | Ship with Light Mode as the default theme, with a fully-parity Dark Mode available via the Settings page "Switch Theme" control. |
| **Rationale** | The primary users — agronomists, farm managers, and office-based operators — interact with the dashboard in well-lit indoor environments during standard working hours. Light mode offers superior readability for data-dense screens (tables, analytics charts, zone grids) under ambient light, and aligns with user expectations for a professional desktop application. Dark mode is offered as an opt-in for night-shift operators or control room deployments with low ambient lighting. Both themes share the same green-based brand palette; surface colors and text colors invert while accent and status colors remain semantically consistent. |
| **Alternatives Considered** | **Dark-only:** Rejected — inappropriate as a default for daytime office use; increases eye strain under bright ambient light. **Auto (OS-matched):** Considered but deferred — adds Flutter platform-channel complexity without clear benefit at v1 given the explicit Settings toggle. **High-contrast mode:** Flagged for accessibility roadmap but out of scope for v1. |
| **Status** | ✅ Approved |

---

## Navigation

### DD-02 · Persistent Vertical Sidebar Navigation

| | |
|---|---|
| **Decision** | Use a fixed-width (~210px) left sidebar with icon + label nav items, always visible on desktop. Collapsed hamburger menu reserved for a future mobile breakpoint. |
| **Rationale** | The dashboard has 7 distinct top-level sections (Home, Zones, Analytics, Emergency, Settings, Help, User Manual) — too many for a top navbar without wrapping or overflow on typical 1280px screens. A sidebar provides constant spatial orientation and avoids the cognitive cost of "where am I?" when navigating between real-time data views. The persistent sidebar also allows quick Emergency access at all times, which is safety-critical for an irrigation system. |
| **Alternatives Considered** | **Top horizontal navbar:** Rejected — at 7+ items, wraps poorly and buries critical Emergency link. **Icon-only collapsed sidebar (default):** Rejected — labels are necessary for operators who may not be deeply familiar with every icon. **Tab-based bottom nav:** Rejected — appropriate for mobile-first apps, not a desktop monitoring dashboard. |
| **Status** | ✅ Approved |

### DD-03 · Active State Highlighting with Colored Background + Icon Tint

| | |
|---|---|
| **Decision** | Active nav items receive a filled pill background (green in dark mode, muted green in light mode) with the icon tinted to match. Emergency uses a red tint when active to reinforce urgency. |
| **Rationale** | Clear active-state contrast is essential in a multi-section dashboard where operators jump between zones and analytics rapidly. Color-coding the Emergency item red even in its active/hover state creates a persistent visual "alert tone" consistent with its function. |
| **Alternatives Considered** | **Underline/border-left indicator only:** Considered but deemed too subtle for glanceability at distance. **Bold text only:** Insufficient contrast. |
| **Status** | ✅ Approved |

---

## Color Palette

### DD-04 · Agricultural Green as Primary Brand and Status Color

| | |
|---|---|
| **Decision** | Medium-to-deep green (`#3A7D44` – `#4CAF50`) as the interactive/accent color on white/light-gray surfaces. Bright green reserved for ONLINE/healthy device states. Dark green used for the sidebar background in both themes and for the "Still need assistance?" footer banner. |
| **Rationale** | Green is semantically aligned with agriculture, growth, and system health. Using it as both brand color and "OK/Online" status color creates an intuitive mapping: green UI elements signal that everything is working. The palette was derived from natural vegetation tones rather than pure `#00FF00` digital green, keeping it grounded and professional. On the light theme, the white/off-white content area provides high contrast for data readability, while green accents on buttons, active nav, and status badges maintain brand identity without overwhelming the data. |
| **Alternatives Considered** | **Blue-based SaaS palette:** Rejected — too generic and disconnected from the agricultural context. **Earthy brown/terracotta primary:** Used as a secondary accent (Observation cards, decorative corner elements) but not as primary — insufficient contrast for interactive chrome. **Full green background surfaces everywhere:** Rejected — reduces legibility of data tables and charts on the default light theme. |
| **Status** | ✅ Approved |

### DD-05 · Red/Coral Accent Strictly Reserved for Critical States

| | |
|---|---|
| **Decision** | Red-coral (`#E57373` / `#C0392B`) is used exclusively for: OFFLINE device badges, CRITICAL log entries, Emergency button, Offline zone card borders, and "Hide stats" labels on offline zones. It appears nowhere in decorative or neutral UI. |
| **Rationale** | Semantic color hygiene — if red appears somewhere, it means danger or failure. Operators in high-stress situations (valve failure, zone offline) rely on pre-attentive color processing. Diluting red with decorative use would degrade its signal value. |
| **Alternatives Considered** | **Orange for warnings, red for critical:** Partially adopted — amber/orange is used for Alert badges and Observation cards (medium severity), maintaining a three-tier traffic-light system (green → amber → red). **Purple for alerts:** Rejected — no semantic mapping. |
| **Status** | ✅ Approved |

### DD-06 · Berber/Amazigh Geometric Motifs as Decorative Pattern Layer

| | |
|---|---|
| **Decision** | Subtle Amazigh-inspired diamond cross patterns are used as background texture on the QR card, calendar widget, and decorative fills. These do not interfere with readability. |
| **Rationale** | TAZROUT is an Algerian project ("Tazrout" is a Tamazight word). Embedding cultural design DNA distinguishes the product from generic international SaaS dashboards and creates a sense of authentic local ownership. The patterns are used at low opacity so they read as texture, not noise. |
| **Alternatives Considered** | **No decorative pattern (pure utilitarian):** Considered for the data-heavy screens but felt sterile. **Photographic agricultural backgrounds:** Rejected — too heavy, poor contrast for overlaid text. |
| **Status** | ✅ Approved |

---

## Components for Real-Time Data Display

### DD-07 · Sparkline Charts for Performance Monitor (No Axes on Home)

| | |
|---|---|
| **Decision** | Home screen performance metrics (Water Output, Soil Moisture, Temperature, Humidity) use minimal area/line sparklines inside bordered metric cards, without axes or gridline labels. The current value is displayed as a large typographic readout above the chart. |
| **Rationale** | On the Home screen the goal is trend awareness, not precise reading. Operators need to know "is soil moisture going up or down?" not "what was it at 14:23?" The large numeric label satisfies the "what is it right now?" need while the sparkline satisfies "is it stable?". Removing axes reduces visual clutter on a screen already dense with 4 metric panels + sidebar + top widgets. Real-time values are pushed via MQTT, so the sparkline always reflects live data without a manual refresh. |
| **Alternatives Considered** | **Full axes with tick labels:** Available on Analytics page (appropriate there). Rejected for Home — too much visual weight for a glance-first screen. **Gauge/radial charts:** Considered for Temperature/Humidity but rejected — harder to show trends over time. **Color-coded number only (no chart):** Rejected — loses temporal context entirely. |
| **Status** | ✅ Approved |

### DD-08 · Decision Log Table with Categorical Badge Filtering

| | |
|---|---|
| **Decision** | The Analytics page Decision Log uses a Flutter data table with pill badges color-coded by type (IRRIGATION=teal, ALERT=amber, ADVICE=green, CRITICAL=red), plus filter buttons (All / Irrigation / Alerts / Advice) at the top right. Data is fetched and filtered client-side after initial load. |
| **Rationale** | Operators need to quickly audit what the AI has been doing. A table is the correct component because the data is inherently tabular (ID, date, type, details), and filtering by type mirrors the mental model of "show me only the alerts from this week." Badge colors replicate the semantic color system used elsewhere. |
| **Alternatives Considered** | **Card list instead of table:** Rejected — uses more vertical space and makes comparison harder. **Timeline/feed view:** Considered but rejected — doesn't support the filtering/scanning use case as efficiently. |
| **Status** | ✅ Approved |

### DD-09 · Zone Cards with Togglable Stats + Status Border Color

| | |
|---|---|
| **Decision** | Each zone in the Zones view is a card with a top border that is green (Online), red (Offline), or neutral (no data/hidden). Cards can be toggled between a compact icon-only state and an expanded stats view. |
| **Rationale** | A farm may have 10–20+ zones. Showing all stats simultaneously would produce an unreadable wall of numbers. The toggle lets operators focus on zones of interest while using the top border as a quick at-a-glance health indicator across the whole grid. The Amazigh icon in collapsed state is both decorative and a visual "identity" for each zone node device (one of them is the symbol of life). |
| **Alternatives Considered** | **Always-expanded cards:** Rejected — doesn't scale beyond ~6 zones. **List/table view for zones:** Considered as an alternative view mode but not implemented in v1. **Map-based zone view:** Flagged as a future enhancement. |
| **Status** | ✅ Approved |

### DD-10 · Analog Clock Widget + Stylized Calendar on Home

| | |
|---|---|
| **Decision** | Home sidebar includes a live analog clock and a date/calendar card with Amazigh geometric surround. |
| **Rationale** | Irrigation systems are time-sensitive — scheduled watering, frost timing, solar peak. Having the current time and date persistently visible on the home screen prevents operators from needing to check a phone/watch. The analog format was chosen over digital for aesthetic coherence and because it reads faster for relative time ("how long until the next cycle?"). |
| **Alternatives Considered** | **Digital clock only:** Considered — simpler to implement, rejected on aesthetic grounds. **Remove clock entirely (rely on OS clock):** Rejected — operators using full-screen kiosk deployments lose OS taskbar access. |
| **Status** | ✅ Approved |

---

## Accessibility

### DD-11 · Color Never Used as the Sole Differentiator

| | |
|---|---|
| **Decision** | Every status communicated by color is also communicated by text label or icon. ONLINE/OFFLINE badges include text. CRITICAL log entries include the word "CRITICAL" not just red color. The Emergency Stop button includes text + icon. |
| **Rationale** | Approximately 8% of males have color vision deficiency. In a safety-critical agricultural system, a red-only "danger" signal that a color-blind operator misses could result in crop loss or equipment damage. Text + color redundancy satisfies WCAG 1.4.1 (Use of Color). |
| **Alternatives Considered** | **Icon-only status (no text):** Rejected on accessibility and localization grounds. **Pattern fill + color:** Considered for chart series differentiation; partially implemented (dashed vs solid lines in ENV Stats). |
| **Status** | ✅ Approved |

### DD-12 · Minimum 4.5:1 Contrast Ratio for Body Text

| | |
|---|---|
| **Decision** | All body text on light backgrounds uses dark charcoal (`#1A1A1A` / `#2C2C2C`). Secondary/muted text uses a mid-dark gray that stays above the 4.5:1 WCAG AA threshold against the white/off-white card surfaces. In dark mode, off-white text (`#E8F5E9`) is used over the deep green surfaces. |
| **Rationale** | WCAG 2.1 AA requires 4.5:1 for normal text. The light theme's white-surface + dark-text combination naturally exceeds this. Care was taken on secondary text (labels, captions, zone stat subtitles) where designers are tempted to use very light gray — these were validated to remain above the AA threshold. In dark mode the same principle applies in reverse. |
| **Alternatives Considered** | **Pure black (`#000000`) text everywhere on light:** Passes contrast but creates harsh visual tension; dark charcoal is softer and equally legible. **Green-tinted text for secondary content on light:** Tested but rejected — colored text on white surfaces was confused with interactive links. |
| **Status** | ✅ Approved |

### DD-13 · Emergency Stop — Redundant Interaction Requirement

| | |
|---|---|
| **Decision** | The Emergency Stop button uses a visually distinct oversized "ticket" treatment with border stitching pattern and dual circle icons on each side, implying a physical press-and-hold or confirm-before-fire interaction model. |
| **Rationale** | Accidental triggering of an emergency stop on an irrigation system (e.g., from a misclick) could damage crops or disrupt automated schedules. The unusual visual treatment slows the operator down and signals that this is not a casual action. A confirmation dialog or press-and-hold should be implemented in the final build. |
| **Alternatives Considered** | **Standard red button (no special treatment):** Rejected — too easy to accidentally activate. **Hidden behind a modal only:** Rejected — Emergency access must be fast in a real emergency; the balance is visible-but-intentional. |
| **Status** | ✅ Approved — confirmation UX to be finalized in next sprint |

### DD-14 · Settings Provides Language, Font Size, and Theme Controls

| | |
|---|---|
| **Decision** | Settings page exposes: Language switch, Light/Dark theme toggle, Font size adjustment (Small/Medium/Large), Date format (DD/MM/YYYY), Time format (12h/24h), and Sound alerts toggle. All preferences are persisted via `GET/PUT /api/v1/user/preferences`. |
| **Rationale** | Agricultural operators in Algeria may prefer Arabic or French interfaces. Font size adjustment supports operators using the Flutter desktop app on lower-resolution embedded screens or with visual impairment. These are standard accessibility affordances (WCAG 1.4.4 Resize Text, 3.1.2 Language of Parts). Persisting preferences on the backend means settings roam across devices and reinstalls. |
| **Alternatives Considered** | **Font size via Flutter `textScaleFactor` only:** Considered but the in-app slider gives non-technical users a more discoverable control. **Single language hardcoded:** Rejected given the multilingual Algerian deployment context (Arabic, French, English). **Local-only preference storage:** Rejected — backend persistence chosen so settings survive app reinstalls and sync across operator sessions. |
| **Status** | ✅ Approved — Arabic/French localization files pending |

---

## Open Questions / Deferred Decisions

| ID | Topic | Notes |
|---|---|---|
| DD-OQ-01 | Mobile / tablet responsive layout | Sidebar collapses to hamburger; breakpoints TBD |
| DD-OQ-02 | Map-based zone visualization | Flagged for v2; requires GPS coordinates per zone |
| DD-OQ-03 | Internationalization (Arabic RTL layout) | RTL sidebar and chart mirroring needed for Arabic mode |
| DD-OQ-04 | Keyboard navigation & focus rings | To be audited before production release |
| DD-OQ-05 | Emergency Stop confirmation UX | Press-and-hold vs. modal confirm — decision pending |

---

*End of Design Decision Log · TAZROUT v1.0 · March 2026*