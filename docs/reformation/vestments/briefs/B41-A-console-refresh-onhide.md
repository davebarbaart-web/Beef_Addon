# B41-A — Console Refresh remounts missing OnHide

**Exclusive:** `addon/ChurchOfBeef/UI/Console.lua`, `tests/test_console.lua`

**Do not edit** glue, Dock, MainFrame. Do not commit. `SaveNote` stays nil. No SUMMON. No parchment. No tabs. Do not refuse empty OpenRite Gora.

## Law

Wiki: ESC closes a **named** frame on `UISpecialFrames`. `FRAME_NAME` is `ChurchOfBeefConsoleFrame`. Hide remounts missing OnHide (B40-A). Refresh remounts `rememberSpecial` but skips `wireConsoleOnHide`. Glue `Runtime:EndEvent` Refreshs the desk, so a niled OnHide stays idle until Hide. B40-A source pin currently forbids `wireConsoleOnHide` in Refresh — update that keep-string in this exclusive test file. Show may stay without a direct call (Show already Refreshs).

Existing-frame Refresh: remount missing OnHide (`wireConsoleOnHide`), then `rememberSpecial(FRAME_NAME)`. Never replace an existing script. Do **not** reset selection / pair / Recommend (QUIET Refresh still nils Recommend — B31-A keep). No OnShow re-wire. No rebuild. No `PlaySound` / `IG_CHARACTER_INFO_*`.

## Tests

Nest `runB41A()` after `runB40A()` inside `runB8E()`. Wipe list, nil OnHide, Refresh: OnHide restored, `ChurchOfBeefConsoleFrame` re-listed once, no sound. Third Refresh does not replace OnHide. Isolation wrap stays. No new main-chunk locals.

`lua tests/test_console.lua` exit 0.

Report `docs/reformation/vestments/briefs/B41-A-console-refresh-onhide-report.md` + diff.
