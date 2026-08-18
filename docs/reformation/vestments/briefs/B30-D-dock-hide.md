# B30-D — Event dock Hide remounts ESC

**Exclusive:** `addon/ChurchOfBeef/UI/ConsoleDock.lua`, `tests/test_console_dock.lua`

**Do not edit** Console.lua, glue. Do not commit. No parchment on the dock. No `PlaySound` / `IG_CHARACTER_INFO_*`. Same-event Refresh still does not pop a dismissed dock.

## Law

B27 leftover: Hide skips `rememberSpecial`. Wiki ESC: named frame on `UISpecialFrames`.

`Hide()`: if a frame exists, `rememberSpecial(FRAME_NAME)` then `paint(false)` (current Hide body). Do not rebuild. Do not Show. Init / Show / Refresh remount stay. `FRAME_NAME` is `"ChurchOfBeefConsoleDock"`.

## Tests

Nest after `runB27D()`. Init, wipe `UISpecialFrames` to `{}`, Hide: `ChurchOfBeefConsoleDock` listed once. Same frame pointer. B27-D Show/Refresh / B26-D Init stay. Isolation wrap stays.

`lua tests/test_console_dock.lua` exit 0.

Report `docs/reformation/vestments/briefs/B30-D-dock-hide-report.md` + diff.
