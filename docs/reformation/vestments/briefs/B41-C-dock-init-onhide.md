# B41-C — ConsoleDock Init remounts missing OnHide

**Exclusive:** `addon/ChurchOfBeef/UI/ConsoleDock.lua`, `tests/test_console_dock.lua`

**Do not edit** glue, Console, MainFrame. Do not commit. No `PlaySound`.

## Law

Wiki: ESC via `UISpecialFrames`. Hide / Show / Refresh remount missing OnHide. Existing-frame Init remounts `rememberSpecial` then Refresh, but the Init remount body still has no `wireDockOnHide`. B26-D / later pins currently forbid `wireDockOnHide` in Init — update those keep-strings in this exclusive test file.

Existing-frame Init: remount missing OnHide (`wireDockOnHide`), then `rememberSpecial(FRAME_NAME)`, then Refresh (Refresh remount stays). Never replace an existing script. Do **not** reset drag persist. Do **not** pop a dismissed dock (Refresh keep). No OnShow re-wire. No rebuild. No `PlaySound` / `IG_CHARACTER_INFO_*`.

## Tests

Nest `runB41C()` after `runB40C()`. Wipe list, nil OnHide, Init: OnHide restored, `ChurchOfBeefConsoleDock` re-listed once, no sound. Third Init does not replace OnHide. Isolation wrap stays.

`lua tests/test_console_dock.lua` exit 0.

Report `docs/reformation/vestments/briefs/B41-C-dock-init-onhide-report.md` + diff.
