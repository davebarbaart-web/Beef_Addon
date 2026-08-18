# B26-D — Console dock Init remounts ESC

**Exclusive:** `addon/ChurchOfBeef/UI/ConsoleDock.lua`, `tests/test_console_dock.lua`

**Do not edit** Console, glue. Do not commit. Per-event dismiss (B24-B) stays. No sound. No parchment on the dock.

## Law

Wiki ESC: named frame on `UISpecialFrames`. `ConsoleDock:Init` builds once; `rememberSpecial` lives only in `build()`. A wiped list then second Init never puts `ChurchOfBeefConsoleDock` back.

When the frame already exists, `Init` still calls `rememberSpecial(FRAME_NAME)` then Refresh. Do not rebuild. Dismiss keyed to `eventId` stays.

## Tests

Init, wipe `UISpecialFrames` to `{}`, second Init: dock name listed exactly once. Same frame pointer. Existing persist / per-event dismiss / ESC pins stay. Isolation wrap stays.

`lua tests/test_console_dock.lua` exit 0.

Report `docs/reformation/vestments/briefs/B26-D-dock-special-report.md` + diff.
