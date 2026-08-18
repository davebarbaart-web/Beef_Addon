# B16-A — ElevateToLord refuses Butcher / Council

**Exclusive:** `addon/ChurchOfBeef/Core/Knighting.lua`, `tests/test_knighting.lua`

**Do not edit** Store, Console, glue. Do not commit. No GuildPromote. No `CreateFrame`. Re-elevate of a **Beef Lord** (rank 4) stays allowed (existing `stillLord` pin). Fresh / Cooked / Knight still elevate. `KnightThisBeef` rank ≥ 4 refuse stays.

## Law

Bible §8 / §5: elevation writes Beef Lord. Butcher is a display-only raiding designation; Council is a different rank. Today `ElevateToLord` can `SetRank(..., 4)` on a Butcher or Council — a silent demotion. Refuse when `human.rankId` is a number **> LORD_ID** (5 / 6). Return `nil, "already elevated"`. Do not write Store. Do not append ceremony. Do not dequeue.

Isolation stays Common + Ranks + Store + Knighting.

## Tests

Seed Butcher (rank 5) and Council (rank 6) like the B15-D Enqueue / KnightThisBeef block. `ElevateToLord` is nil / `"already elevated"`; ranks stay 5 / 6; ceremony log unchanged; elevationAt unchanged. Existing re-elevate Lord pin stays. Isolation wrap stays. `promoteCalls` stay 0.

`lua tests/test_knighting.lua` exit 0.

Report `docs/reformation/vestments/briefs/B16-A-elevate-refuse-report.md` + diff.
