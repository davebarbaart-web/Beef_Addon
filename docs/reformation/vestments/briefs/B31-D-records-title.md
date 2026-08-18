# B31-D — Records paint re-applies Morpheus on the book title

**Exclusive:** `addon/ChurchOfBeef/UI/RecordsBook.lua`, `tests/test_records.lua`

**Do not edit** Decree, Toasts, glue. Do not commit. No category remap (#3). No generated prose. `PAGE_TITLE_FONT` stays `Fonts\\MORPHEUS.ttf`. Title copy stays `"The Records Book"`.

## Law

B30 leftover: `TitleText` Morpheus applies only in `buildFrame`.

When `paint()` runs and `frame.TitleText` exists, call `applyFont(frame.TitleText, "GameFontNormalHuge", PAGE_TITLE_FONT, 20)`. Do not change the chrome title string. PageTitle apply (B30-C) stays. FRIZQT / GameFont fallback stays.

## Tests

Nest after `runB30C()`. Source pin: `paint()` contains `applyFont` on `TitleText` with `PAGE_TITLE_FONT`. Existing PageTitle paint pin / wheel / Hide remount stay. Isolation wrap stays.

`lua tests/test_records.lua` exit 0.

Report `docs/reformation/vestments/briefs/B31-D-records-title-report.md` + diff.
