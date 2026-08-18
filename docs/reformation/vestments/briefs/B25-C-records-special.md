# B25-C — Records Book Init early-return re-registers ESC

**Exclusive:** `addon/ChurchOfBeef/UI/RecordsBook.lua`, `tests/test_records.lua`

**Do not edit** Decree, Toasts, glue. Do not commit. PAGE_TITLES stay 9. `PAGE_TITLE_FONT` stays `Fonts\\MORPHEUS.ttf`. No category remap (#3). No custom media.

## Law

Wiki ESC: named frame on `UISpecialFrames`. `RecordsBook:Init` returns the existing frame and skips `rememberSpecial` (only `buildFrame` registers).

On the early-return path, call `rememberSpecial(FRAME_NAME)` then return the frame. Do not rebuild. Wheel / roman tallies stay.

## Tests

Init, wipe `UISpecialFrames` to `{}`, second Init: Records frame name listed exactly once. Existing page / wheel / Morpheus pins stay. Isolation wrap stays.

`lua tests/test_records.lua` exit 0.

Report `docs/reformation/vestments/briefs/B25-C-records-special-report.md` + diff.
