# Tazrout Frontend — Design System Implementation Guide

This document explains **how to use the design system in Flutter code**. It covers patterns, conventions, and code structure.

For the raw design tokens (exact hex values, font sizes, spacing scale, stroke weights), refer to the source of truth:

> `design/docs/DESIGN_SYSTEM.md` — Generated from Figma variables. Contains all color hex codes, typography scale, spacing tokens, border radius values, and component state colors.

This file only covers the Flutter implementation layer on top of those tokens.

---

## 1. Token Files in Code

The design tokens from `design/docs/DESIGN_SYSTEM.md` are implemented in three Dart files:

| Dart File | What it contains |
|---|---|
| `lib/core/theme/app_colors.dart` | All color tokens as `Color` constants |
| `lib/core/theme/app_typography.dart` | All text style presets as `TextStyle` constants |
| `lib/core/theme/app_theme.dart` | `ThemeData` for dark and light modes assembled from the above |

**Rule:** Never write a raw `Color(0xFF...)` or `TextStyle(fontSize: ...)` inline in a widget. Always use the token from `AppColors` or `AppTypography`.



All icons are custom SVGs stored in two sets: one for dark theme, one for light theme.

All paths are centralized in `lib/core/constants/app_assets.dart`. Never hardcode an asset path.

### Naming Convention
- `darkIconHomeI` — Dark theme, Home icon, Idle state
- `darkIconHomeH` — Dark theme, Home icon, Hover state
- `darkIconHomeActive` — Dark theme, Home icon, Active/selected state
- `lightIconHomeI` — Light theme equivalent

All icons are loaded with `SvgPicture.asset()`. To tint an SVG a specific color, use the `colorFilter` parameter:
```dart
SvgPicture.asset(
  AppAssets.darkIconEmergencyActive,
  colorFilter: const ColorFilter.mode(Color(0xFFF97316), BlendMode.srcIn),
)
```

### Berber Decorative Assets

Cultural assets include:
- `AppAssets.symbolWisdom`, `symbolBalance`, `symbolLife`, `symbolUnity`, `symbolEye` — Berber symbols used as card overlays
- `AppAssets.patternDotsLine`, `patternDiamondsChain`, etc. — Geometric border patterns
- `AppAssets.glyphT`, `glyphA`, `glyphZ`, etc. — Tifinagh letter forms for T-A-Z-R-O-U-T

---

## 4. Card Structure

All cards follow the same structural pattern:

```dart
Card(
  margin: EdgeInsets.zero,
  color: isDark ? AppColors.darkPanelCard : AppColors.lightSurfaceCard,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12),
    side: BorderSide(
      color: isDark ? AppColors.darkStrokeDivider : AppColors.lightStrokeDivider,
    ),
  ),
  child: Padding(
    padding: const EdgeInsets.all(16),
    child: ...
  ),
)
```

Border radius is always `12`. Padding inside is always `16`.

---

## 5. Hover Interaction Pattern

Interactive cards and buttons use a consistent hover pattern with `MouseRegion` and `AnimatedContainer`:

```dart
MouseRegion(
  onEnter: (_) => setState(() => _isHovered = true),
  onExit: (_) => setState(() => _isHovered = false),
  child: AnimatedContainer(
    duration: const Duration(milliseconds: 150),
    decoration: BoxDecoration(
      border: Border.all(
        color: _isHovered ? AppColors.primary : AppColors.darkStrokeDivider,
      ),
    ),
    ...
  ),
)
```

Hover state affects: border color, text color, icon variant (Idle → Hover), and sometimes background glow.

---

## 6. Empty State Pattern

Every data-driven card shows `EmptyStateWidget` when no data is available. This is how you implement it:

```dart
final data = ref.watch(someProvider);

if (data == null || data.isEmpty) {
  return EmptyStateWidget(message: l10n.emptyStateNoData);
}
// Show real content below
```

The `EmptyStateWidget` displays the Tazrout logo icon and a message string.

---

## 7. Localization Pattern

Every widget that shows text must support all three languages. The pattern is:

```dart
final l10n = AppLocalizations.of(context)!;
final isDark = Theme.of(context).brightness == Brightness.dark;

// For any Text widget
Text(
  l10n.someKey,
  textAlign: isArabic(context) ? TextAlign.right : TextAlign.left,
  textDirection: textDirectionForUiLocale(context),
  style: AppTypography.bodySRegular.copyWith(color: ...),
)
```

For `Row` layout that must flip in Arabic:
```dart
children: isArabic(context)
    ? [iconWidget, const SizedBox(width: 8), textWidget].reversed.toList()
    : [iconWidget, const SizedBox(width: 8), textWidget],
```

---

## 8. Animation Guidelines

Animations respect the user's Power Saving setting. The `animDuration` extension on `UserPreferencesModel` returns `Duration.zero` when power saving is on.

- Screen transitions: `FadeTransition` + `ScaleTransition` (0.96 → 1.0), 250ms
- Hover state changes: `AnimatedContainer`, 150ms
- Sidebar collapse: `AnimatedContainer`, 200ms
- Symbol/glow opacity: `AnimatedOpacity`, 300ms
- Notification toast: Slide-in from top, 300ms
