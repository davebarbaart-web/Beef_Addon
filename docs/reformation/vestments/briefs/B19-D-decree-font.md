# B19-D — Decree line uses FrameXML Morpheus casing

**Exclusive:** `addon/ChurchOfBeef/UI/Decree.lua`, `tests/test_decree_ui.lua`

**Do not edit** Toasts, Records, FighterCard, glue. Do not commit. No deputy (#5). No custom media. No sound. Quiet Mode stays silent.

## Law

Bible §19.3 / license 4 stock only. V-A leftover: FrameXML / game font is `Fonts\MORPHEUS.ttf`. Decree `LINE_FONT` is `Fonts\\MORPHEUS.TTF`. Toasts already uses `Fonts\\MORPHEUS.ttf`. `applyFont` already falls back to GameFont if `SetFont` fails — keep that.

Change `LINE_FONT` to `Fonts\\MORPHEUS.ttf`. Body `FRIZQT__.TTF` stays. Header copy, church name, QuestBG, no cross glyphs stay.

Do not use `MORPHEUS_CYR.TTF` (GlueFonts localization face).

## Tests

Source pin for `Fonts\\MORPHEUS.ttf`. Existing decree paint / Quiet hide / persist / `UISpecialFrames` pins stay. Isolation wrap stays.

`lua tests/test_decree_ui.lua` exit 0.

Report `docs/reformation/vestments/briefs/B19-D-decree-font-report.md` + diff.
