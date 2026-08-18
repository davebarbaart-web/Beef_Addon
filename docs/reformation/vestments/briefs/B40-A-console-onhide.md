# B40-A — Console Hide remounts missing OnHide

**Exclusive:** `addon/ChurchOfBeef/UI/Console.lua`, `tests/test_console.lua`

**Do not edit** glue, Dock, MainFrame. Do not commit. `SaveNote` stays nil. No SUMMON. No parchment. No tabs. Do not refuse empty OpenRite Gora.

## Law

Wiki: ESC closes a **named** frame on `UISpecialFrames`. `FRAME_NAME` is `ChurchOfBeefConsoleFrame`. Hide remounts `rememberSpecial` then `frame:Hide()`. ESC / `CloseSpecialWindows` bypass `Console:Hide` and there is no OnHide, so a wiped list stays idle until Show / Init / Refresh / Hide.

Extract `wireConsoleOnHide` (never replace an existing script). Existing-frame Hide: remount missing OnHide, then `rememberSpecial(FRAME_NAME)`, then `frame:Hide()`. OnHide remounts `rememberSpecial` so ESC still re-lists. Do **not** reset selection / pair / Recommend. No OnShow re-wire. No rebuild. No `PlaySound` / `IG_CHARACTER_INFO_*`.

## Tests

Nest `runB40A()` after `runB39A()` inside `runB8E()`. Source pin: Hide remounts OnHide before `frame:Hide()`. Wipe list, nil OnHide, Show, Hide: OnHide restored, `ChurchOfBeefConsoleFrame` re-listed once, no sound. Third Hide does not replace OnHide. Isolation wrap stays. No new main-chunk locals.

`lua tests/test_console.lua` exit 0.

Report `docs/reformation/vestments/briefs/B40-A-console-onhide-report.md` + diff.
