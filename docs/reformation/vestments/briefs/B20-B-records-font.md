# B20-B — Records title uses FrameXML Morpheus casing

**Exclusive:** `addon/ChurchOfBeef/UI/RecordsBook.lua`, `tests/test_records.lua`

**Do not edit** Decree, Toasts, FighterCard, glue. Do not commit. No category remap (#3). No generated prose. PAGE_TITLES stay 9. Roman tallies stay. Wheel pins stay.

## Law

Bible §19.3 / license 4. Decree and Toasts use `Fonts\\MORPHEUS.ttf`. Records `PAGE_TITLE_FONT` is `Fonts\\MORPHEUS.TTF`. Change to `Fonts\\MORPHEUS.ttf`. `applyFont` fallback stays. Do not use `MORPHEUS_CYR.TTF`.

## Tests

Source pin for `Fonts\\MORPHEUS.ttf`. Existing page / identity / wheel pins stay. Isolation wrap stays.

`lua tests/test_records.lua` exit 0.

Report `docs/reformation/vestments/briefs/B20-B-records-font-report.md` + diff.
