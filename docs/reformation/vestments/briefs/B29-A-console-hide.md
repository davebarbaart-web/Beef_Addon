# B29-A — Console Hide remounts ESC

**Exclusive:** `addon/ChurchOfBeef/UI/Console.lua`, `tests/test_console.lua`

**Do not edit** Dock, glue. Do not commit. `SaveNote` stays nil. Nest `runB29A()` inside `runB8E()` after `runB28A()`. Do not add main-chunk locals.

## Law

B28 leftover: Toggle-hide skips `rememberSpecial`. Wiki ESC: named frame on `UISpecialFrames`. Do **not** PlaySound `IG_CHARACTER_INFO_*`.

`Hide()`: if a frame exists, `rememberSpecial(FRAME_NAME)` then Hide. Do not rebuild. Show / Refresh / Init remount stay. `FRAME_NAME` is `"ChurchOfBeefConsoleFrame"`. `SaveNote` stays nil.

## Tests

Init, wipe `UISpecialFrames` to `{}`, Hide: `ChurchOfBeefConsoleFrame` listed once. Wipe again, Toggle while shown: listed once. Same frame pointer. B28-A Show/Refresh / B27-A Init stay. Isolation wrap stays.

`lua tests/test_console.lua` exit 0.

Report `docs/reformation/vestments/briefs/B29-A-console-hide-report.md` + diff.
