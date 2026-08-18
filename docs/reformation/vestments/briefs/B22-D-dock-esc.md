# B22-D — Event dock ESC via UISpecialFrames

**Exclusive:** `addon/ChurchOfBeef/UI/ConsoleDock.lua`, `tests/test_console_dock.lua`

**Do not edit** Console.lua, Hud, glue. Do not commit. Dock stays stock `BasicFrameTemplate`. Title stays exactly `DIRECTOR CONSOLE`. CloseButton stays hidden. Persist `ui.consoleDock` stays. No custom media. No `PlaySound`. Quiet hide stays.

## Law

Wiki: ESC hides a **named** frame on `UISpecialFrames`. The dock already creates `ChurchOfBeefConsoleDock` and hides CloseButton. ESC does not dismiss it.

`rememberSpecial("ChurchOfBeefConsoleDock")` on build (dedupe; same helper shape as Toasts / Console). Do not add a close button. Do not `PlaySound` / `IG_CHARACTER_INFO_*` on hide. Hide is not EndEvent. `mayShow` (live event + registered Pope) stays.

## Tests

After Init + StartEvent + Pope: `_G` name or `GetName()` is `ChurchOfBeefConsoleDock`; `UISpecialFrames` contains that name exactly once. Second Init does not duplicate. Hide / Quiet still hide. No `PlaySound` in source. Persist / title / SANCTION + Expand pins stay. Isolation wrap stays.

`lua tests/test_console_dock.lua` exit 0.

Report `docs/reformation/vestments/briefs/B22-D-dock-esc-report.md` + diff.
