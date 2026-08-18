# B30-C — Records paint re-applies Morpheus on the page title

**Exclusive:** `addon/ChurchOfBeef/UI/RecordsBook.lua`, `tests/test_records.lua`

**Do not edit** Decree, Toasts, glue. Do not commit. No category remap (#3). No generated prose. No custom media. `PAGE_TITLE_FONT` stays `Fonts\\MORPHEUS.ttf`.

## Law

B28 leftover: `applyFont(..., PAGE_TITLE_FONT, 18)` runs only in `buildFrame`. A later font reset would not re-apply when the leaf turns.

When `paint()` writes `frame.PageTitle`, call `applyFont(frame.PageTitle, "GameFontNormalLarge", PAGE_TITLE_FONT, 18)` first. Do not change page titles, roman tallies, or honorific copy. Book chrome title may stay create-only. FRIZQT / GameFont fallback in `applyFont` stays.

## Tests

Nest after `runB28C()`. Source pin: `paint()` contains `applyFont` with `PAGE_TITLE_FONT`. Existing wheel / Hide remount / Morpheus create-path / isolation pins stay.

`lua tests/test_records.lua` exit 0.

Report `docs/reformation/vestments/briefs/B30-C-records-font-report.md` + diff.
