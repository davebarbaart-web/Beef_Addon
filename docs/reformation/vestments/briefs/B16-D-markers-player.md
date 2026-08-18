# B16-D — Markers resolve local player

**Exclusive:** `addon/ChurchOfBeef/UI/Markers.lua`, `tests/test_markers.lua`

**Do not edit** Knighting, glue. Do not commit. Event + Pope + grouped still required. Quiet refuse. No GuildPromote. No combat automation.

## Law

`resolveUnit` scans `partyN` / `raidN` and never checks `"player"`. A Pope marking themselves (or a fighter who is the local character) fails even when grouped. Anniversary `SetRaidTarget(target, userIndex)` takes a UnitToken — `"player"` is valid.

At the start of `resolveUnit`, if `UnitName("player")` names-same the target, return `"player"`. `pcall` the read. Missing `UnitName` stays fail-closed. Ungrouped Mark still refuses (`isGrouped`). Target verb unchanged.

## Tests

Grouped + Pope + Event: `MarkCandidate` / `MarkFighters` when the name is the stub player (`Beefina`) spies `SetRaidTarget("player", …)`. Party scan pins stay. Quiet / ungrouped / unlisted Pope still refuse. Isolation wrap stays.

`lua tests/test_markers.lua` exit 0.

Report `docs/reformation/vestments/briefs/B16-D-markers-player-report.md` + diff.
