# B15-D — KnightThisBeef refuses Lord+

**Exclusive:** `addon/ChurchOfBeef/Core/Knighting.lua`, `tests/test_knighting.lua`

**Do not edit** Store, Console, glue. Do not commit. No GuildPromote (A04). No `CreateFrame`. Re-knight of a **Beef Knight** (rank 3) stays allowed. Enqueue still uses `needsKnighting` (1 / 2 / nil only).

## Law

Bible §8 / §5: Knighting writes Beef Knight. Elevation is a different verb (`ElevateToLord`). Today `KnightThisBeef` can `SetRank(..., 3)` on a Lord / Butcher / Council if passed a raw id — a silent demotion. Refuse when `human.rankId` is a number **≥ 4** (Lord, Butcher, Council). Return `nil, "already elevated"`. Do not write Store. Do not append ceremony. Do not dequeue (the human should not be on the line; if they are, leave the line unchanged).

Rank 3 re-knight still writes 3 and appends. Rank 1 / 2 / nil still knight. Isolation stays Common + Ranks + Store + Knighting.

## Tests

After existing re-knight-of-Knight pins: ElevateToLord then `KnightThisBeef` is nil / `"already elevated"`; rank stays 4; ceremony log does not grow; elevationAt unchanged. Seed a Butcher (rank 5) and Council (rank 6) the same way Enqueue tests do — refuse both. Isolation wrap stays. No GuildPromote.

`lua tests/test_knighting.lua` exit 0.

Report `docs/reformation/vestments/briefs/B15-D-knight-lord-report.md` + diff.
