# B28-A — Console Show / Refresh remount ESC

**Exclusive:** `addon/ChurchOfBeef/UI/Console.lua`, `tests/test_console.lua`

**Do not edit** Dock, glue. Do not commit. `SaveNote` stays nil. Nest `runB28A()` inside `runB8E()` after `runB27A()`. Do not add main-chunk locals.

## Law

B27 leftover: `Refresh` / `Show` / `Toggle` skip `rememberSpecial`. Wiki ESC: named frame on `UISpecialFrames`. Do **not** PlaySound `IG_CHARACTER_INFO_*`.

When the frame exists, `Show` and `Refresh` call `rememberSpecial(FRAME_NAME)`. Do not rebuild. `FRAME_NAME` is `"ChurchOfBeefConsoleFrame"`. Init remount (B27-A) stays. `SaveNote` stays nil.

## Tests

Init, wipe `UISpecialFrames` to `{}`, Show-only: `ChurchOfBeefConsoleFrame` listed once. Wipe again, Refresh-only: listed once. Same frame pointer. B27-A Init remount / B14-D uniqueness / B26-A pins stay. Isolation wrap stays.

`lua tests/test_console.lua` exit 0.

Report `docs/reformation/vestments/briefs/B28-A-console-show-report.md` + diff.
