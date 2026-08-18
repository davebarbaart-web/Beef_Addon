# B7-C — Records Book canonized scripture

**Exclusive:** `addon/ChurchOfBeef/UI/RecordsBook.lua`, `tests/test_records.lua`

**Do not edit** PAGE_TITLES, Console, Store. Do not commit. No generated prose.

## Law

Right leaf already paints marked-moment **locations**. If a moment has `scripture` (Pope text from CanonizeMoment), paint that string after the location. Do not invent “on this day” copy. PAGE_TITLES stays the nine Bible names. Famous Upsets page already reads `famousUpset` — no change required unless a pin breaks.

## Tests

Seed FlagMoment + scripture field (or CanonizeMoment if Store is loaded) → right leaf contains that text and not `ordained`. PAGE_TITLES count 9. Isolation wrap stays.

`lua tests/test_records.lua` exit 0. POLISH:CANDIDATE.

Report `docs/reformation/vestments/briefs/B7-C-records-scripture-report.md` + diff.
