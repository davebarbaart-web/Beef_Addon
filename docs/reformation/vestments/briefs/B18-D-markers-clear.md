# B18-D — Markers Clear uses the player token

**Exclusive:** `addon/ChurchOfBeef/UI/Markers.lua`, `tests/test_markers.lua`

**Do not edit** Knighting, glue. Do not commit. Event + Pope + grouped still required. Quiet refuse. No GuildPromote. No combat automation. `resolveUnit` player return (B16-D) stays.

## Law

B16-D leftover: `Clear` inherits `resolveUnit` but is unpinned. Grouped + Pope + Event `Clear` of the local stub name (`Beefina`) must spy `SetRaidTarget("player", 0)`. Quiet / ungrouped Clear still refuse. Target verb unchanged. Party scan pins stay.

Anniversary `SetRaidTarget(target, userIndex)` — index `0` clears.

## Tests

After the B16-D Mark pins: grouped Clear("Beefina") spies `"player", 0`. Isolation wrap stays. No new main-chunk locals.

`lua tests/test_markers.lua` exit 0.

Report `docs/reformation/vestments/briefs/B18-D-markers-clear-report.md` + diff.
