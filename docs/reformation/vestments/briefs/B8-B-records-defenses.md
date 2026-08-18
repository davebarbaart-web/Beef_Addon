# B8-B — Records Most Successful Defenses

**Exclusive:** `addon/ChurchOfBeef/UI/RecordsBook.lua`, `tests/test_records.lua`

**Do not edit** PAGE_TITLES, Store, Console. Do not commit. No generated prose.

## Law

Bible §10.9 page **Most Successful Defenses** is already titled. Fill it from `Store:CountDefenses` (or the same derive if you must inline — prefer the Store method when present). Use the existing `maxHolders` pattern: empty when best < 1; list only the top count. PAGE_TITLES stays the nine Bible names.

Replace the old pin that expected this page always empty / "do not derive from elevationAt". That pin was "later display." Later is now.

Do not write `gora.defenses`. Do not invent a tenth page.

## Tests

Lord + two post-elevation wins → page lists that name with count 2. Pre-elevation-only wins stay off the page. PAGE_TITLES count 9. Isolation wrap stays.

`lua tests/test_records.lua` exit 0. POLISH:CANDIDATE.

Report `docs/reformation/vestments/briefs/B8-B-records-defenses-report.md` + diff.
