# B25-B — Empty Decree Show still registers ESC then hides

**Exclusive:** `addon/ChurchOfBeef/UI/Decree.lua`, `tests/test_decree_ui.lua`

**Do not edit** Toasts, Records, glue. Do not commit. No deputy (#5). No custom media. No sound. Quiet Mode stays silent. `LINE_FONT` stays `Fonts\\MORPHEUS.ttf`.

## Law

B24-D leftover: `Show()` with no active Decree returns before `ensureFrame`. A wiped `UISpecialFrames` then Show-only (empty Get) never puts `ChurchOfBeefDecree` back.

`Show()`: if `getDecree()` is nil, still call `ensureFrame()`, then Hide, return false. Do not paint. Do not Show the banner. Quiet stays hidden-until-Set. `ensureFrame` already `rememberSpecial`s.

Wiki ESC: named frame on `UISpecialFrames`. No `PlaySound` / `IG_CHARACTER_INFO_*`.

## Tests

No decree set: `Show()` is false, `IsShown` false. Frame name is listed on `UISpecialFrames` once. Existing Set / Show / Quiet hide / persist / Morpheus pins stay. Isolation wrap stays.

`lua tests/test_decree_ui.lua` exit 0.

Report `docs/reformation/vestments/briefs/B25-B-decree-show-report.md` + diff.
