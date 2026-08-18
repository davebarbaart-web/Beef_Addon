# B40-C — ConsoleDock Refresh remounts missing OnHide

**Exclusive:** `addon/ChurchOfBeef/UI/ConsoleDock.lua`, `tests/test_console_dock.lua`

**Do not edit** glue, Console, MainFrame. Do not commit. No `PlaySound`.

## Law

Wiki: ESC via `UISpecialFrames`. Hide remounts missing OnHide (B36-C). Show remounts it (B39-D). Refresh remounts `rememberSpecial` but skips `wireDockOnHide`, so a niled OnHide stays idle until Show / Hide.

Existing-frame Refresh: remount missing OnHide (`wireDockOnHide`), then `rememberSpecial(FRAME_NAME)`. Never replace an existing script. Do **not** reset drag persist. Do **not** pop a dismissed dock. No OnShow re-wire. No rebuild. No `PlaySound` / `IG_CHARACTER_INFO_*`.

## Tests

Nest `runB40C()` after `runB39D()`. Wipe list, nil OnHide, Refresh: OnHide restored, `ChurchOfBeefConsoleDock` re-listed once, no sound. Third Refresh does not replace OnHide. Isolation wrap stays.

`lua tests/test_console_dock.lua` exit 0.

Report `docs/reformation/vestments/briefs/B40-C-dock-refresh-onhide-report.md` + diff.
