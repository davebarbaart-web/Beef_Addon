# B28-C — Records Book Hide remounts ESC

**Exclusive:** `addon/ChurchOfBeef/UI/RecordsBook.lua`, `tests/test_records.lua`

**Do not edit** Decree, Toasts, glue. Do not commit. PAGE_TITLES stay 9. `PAGE_TITLE_FONT` stays `Fonts\\MORPHEUS.ttf`. No category remap (#3). No custom media.

## Law

B25 leftover: `Hide` / Toggle-while-shown skip `rememberSpecial`. Wiki ESC: named frame on `UISpecialFrames`.

`Hide()`: if a frame exists, `rememberSpecial(FRAME_NAME)` then Hide. Do not rebuild. Init remount (B25-C) stays. `FRAME_NAME` is `"ChurchOfBeefRecordsBook"`.

## Tests

Init, wipe `UISpecialFrames` to `{}`, Hide: name listed exactly once. Same frame pointer. PAGE_TITLES==9 / Morpheus / B25-C Init remount stay. Isolation wrap stays.

`lua tests/test_records.lua` exit 0.

Report `docs/reformation/vestments/briefs/B28-C-records-hide-report.md` + diff.
