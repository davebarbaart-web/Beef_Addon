# B6-C — ElevateToLord leaves the knighting line

**Exclusive:** `addon/ChurchOfBeef/Core/Knighting.lua`, `tests/test_knighting.lua`

**Do not edit** Console, Store. Do not commit. No GuildPromote. Keep `queue` / `AdvanceQueue` / `NextCandidate` / `next` nil.

## Law

B5-A nit: a human Enqueued then elevated to Lord stays on the line; a later KnightThisBeef would write rank 3. After successful `ElevateToLord`, remove that `humanId` from the local line (same as KnightThisBeef). Still do not call Runtime. Still do not auto-knight.

## Tests

Enqueue → ElevateToLord → GetLine does not contain that id. Existing pins stay. Isolation wrap stays.

`lua tests/test_knighting.lua` exit 0.

Report `docs/reformation/vestments/briefs/B6-C-lord-line-report.md` + diff.
