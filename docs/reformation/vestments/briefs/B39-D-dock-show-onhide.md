# B39-D — ConsoleDock Show remounts missing OnHide

**Exclusive:** `addon/ChurchOfBeef/UI/ConsoleDock.lua`, `tests/test_console_dock.lua`

**Do not edit** glue, Console, MainFrame. Do not commit. No `PlaySound`.

## Law

Wiki: ESC via `UISpecialFrames`. Hide remounts missing OnHide (B36-C). Show remounts `rememberSpecial` but skips `wireDockOnHide`, so a niled OnHide stays idle until Hide. B36-C source pin currently forbids `wireDockOnHide` in Show — update that keep-string in this exclusive test file.

Existing-frame Show: remount missing OnHide (`wireDockOnHide`), then `rememberSpecial(FRAME_NAME)`. Never replace an existing script. Do **not** reset drag persist. No OnShow re-wire. No rebuild. No `PlaySound` / `IG_CHARACTER_INFO_*`.

## Tests

Nest `runB39D()` after `runB36C()`. Wipe list, nil OnHide, Show: OnHide restored, `ChurchOfBeefConsoleDock` re-listed once, no sound. Third Show does not replace OnHide. Isolation wrap stays.

`lua tests/test_console_dock.lua` exit 0.

Report `docs/reformation/vestments/briefs/B39-D-dock-show-onhide-report.md` + diff.
