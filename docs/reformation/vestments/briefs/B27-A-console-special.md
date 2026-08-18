# B27-A — Console Init early-return remounts ESC

**Exclusive:** `addon/ChurchOfBeef/UI/Console.lua`, `tests/test_console.lua`

**Do not edit** Dock, glue. Do not commit. `SaveNote` stays nil. Nest `runB27A()` inside `runB8E()` after `runB26A()`. Do not add main-chunk locals.

## Law

Wiki ESC: named frame on `UISpecialFrames`. `Console:Init` returns the existing frame and skips `rememberSpecial` (only `buildFrame` registers).

On the early-return path, call `rememberSpecial(FRAME_NAME)` then return the frame. Do not rebuild. `FRAME_NAME` is `"ChurchOfBeefConsoleFrame"`. `rememberSpecial` already exists. No `PlaySound` / `IG_CHARACTER_INFO_*`. `SaveNote` stays nil.

## Tests

Init, wipe `UISpecialFrames` to `{}`, second Init: `ChurchOfBeefConsoleFrame` listed exactly once. Same frame pointer. Existing first-create uniqueness / B14-D / B26-A pins stay. Isolation wrap stays.

`lua tests/test_console.lua` exit 0.

Report `docs/reformation/vestments/briefs/B27-A-console-special-report.md` + diff.
