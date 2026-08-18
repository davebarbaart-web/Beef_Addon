# B20-C — Fighter card name uses FrameXML Morpheus casing

**Exclusive:** `addon/ChurchOfBeef/UI/FighterCard.lua`, `tests/test_fighter_card.lua`

**Do not edit** Decree, Records, Toasts, glue. Do not commit. Keep arabic `1-0`. No drag persist (left-third docked). No `UnitHealth`. lastPair until QUIET. ESC `UISpecialFrames` stays.

## Law

Bible §19.3 / license 4. `NAME_FONT` is `Fonts\\MORPHEUS.TTF`. Change to `Fonts\\MORPHEUS.ttf` (match Decree / Toasts). `SetFont` pcall fallback stays. Do not use `MORPHEUS_CYR.TTF`.

## Tests

Source pin for `Fonts\\MORPHEUS.ttf`. Existing dock / persist / ESC / `1-0` / health-nil pins stay. Isolation wrap stays.

`lua tests/test_fighter_card.lua` exit 0.

Report `docs/reformation/vestments/briefs/B20-C-card-font-report.md` + diff.
