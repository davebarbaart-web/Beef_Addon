# B24-D — Decree ensureFrame re-registers ESC

**Exclusive:** `addon/ChurchOfBeef/UI/Decree.lua`, `tests/test_decree_ui.lua`

**Do not edit** Toasts, Records, glue. Do not commit. No deputy (#5). No custom media. No sound. Quiet Mode stays silent. `LINE_FONT` stays `Fonts\\MORPHEUS.ttf`.

## Law

Wiki ESC: named frame on `UISpecialFrames`. `ensureFrame` returns the existing banner and skips `rememberSpecial` (only `buildFrame` registers). A wiped list never gets the Decree name back.

On the early-return path, call `rememberSpecial(FRAME_NAME)` then return the frame. Do not rebuild. Do not PlaySound. Header copy / QuestBG stay.

## Tests

Init / Show so the frame exists, wipe `UISpecialFrames` to `{}`, `ensureFrame` path (second Init or Show): name listed exactly once. Existing Quiet hide / persist / Morpheus pins stay. Isolation wrap stays.

`lua tests/test_decree_ui.lua` exit 0.

Report `docs/reformation/vestments/briefs/B24-D-decree-special-report.md` + diff.
