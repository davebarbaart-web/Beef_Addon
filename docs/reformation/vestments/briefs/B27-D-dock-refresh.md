# B27-D — Dock Refresh / Show remount ESC

**Exclusive:** `addon/ChurchOfBeef/UI/ConsoleDock.lua`, `tests/test_console_dock.lua`

**Do not edit** Console, glue. Do not commit. Per-event dismiss (B24-B) stays. B26-D Init remount stays. No sound. No parchment.

## Law

B26 leftover: `Refresh` / `Show` skip `rememberSpecial`. A wiped `UISpecialFrames` then Refresh-only or Show-only never puts `ChurchOfBeefConsoleDock` back.

When the frame already exists, `Refresh` and `Show` call `rememberSpecial(FRAME_NAME)` (create-via-Refresh still gets it from `build()` + this call is fine). Do not rebuild. Dismiss keyed to `eventId` stays.

## Tests

Init, wipe `UISpecialFrames` to `{}`, Refresh-only: dock name listed exactly once. Wipe again, Show-only: listed once. Same frame pointer. B24-B same-event Hide+Refresh stays hidden. Isolation wrap stays.

`lua tests/test_console_dock.lua` exit 0.

Report `docs/reformation/vestments/briefs/B27-D-dock-refresh-report.md` + diff.
