# B6-B — Records Book identity leaf

**Exclusive:** `addon/ChurchOfBeef/UI/RecordsBook.lua`, `tests/test_records.lua`

**Do not edit** PAGE_TITLES list, Console, Store. Do not commit. Theatrical stock only. No generated prose. No new superlative category (#3).

## Law

Bible §12.1 / §14.2 / §15. The right parchment leaf is currently dress-only. Paint **identity**, not a tenth ladder page.

Right-leaf FontStrings (or one body):

1. **Honorifics** — if Store can resolve the local player (`UnitName("player")` via Names.Key → character → human), list that human's `honorifics` as given. Missing bind → leave blank (no invented "unrecognized").
2. **Marked moments** — `Store:GetMarkedMoments()` locations only (already Pope/zone text). No "on this day" narration.

Do not change `PAGE_TITLES`. Left leaf superlatives stay. No jokes. No roman on honorific text (text is titles, not counts).

## Tests

PAGE_TITLES pin unchanged (still 9 titles). Right leaf exists. Seed honorific + FlagMoment → paint includes those strings and not `ordained` / `folk hero`. Isolation wrap stays.

`lua tests/test_records.lua` exit 0. POLISH:CANDIDATE.

Report `docs/reformation/vestments/briefs/B6-B-records-identity-report.md` + diff.
