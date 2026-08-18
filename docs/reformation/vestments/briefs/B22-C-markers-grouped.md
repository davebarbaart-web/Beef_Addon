# B22-C — resolveUnit player token does not need GetNumGroupMembers

**Exclusive:** `addon/ChurchOfBeef/UI/Markers.lua`, `tests/test_markers.lua`

**Do not edit** Knighting, glue. Do not commit. Event + Pope + grouped still required. Quiet refuse. No GuildPromote. No combat automation.

## Law

B16-D leftover: `resolveUnit` type-guards `GetNumGroupMembers` **before** the player return. `isGrouped` can already be true via `IsInRaid` / `IsInGroup` when `GetNumGroupMembers` is missing. A Pope marking themselves then fails with `unit not found`.

`resolveUnit`: require `UnitName` only for the player arm. If `pcall(UnitName, "player")` names-same the target, return `"player"`. Party / raid scan still requires `GetNumGroupMembers` and still type-guards it. Missing `UnitName` stays fail-closed. Ungrouped Mark still refuses (`isGrouped`). Target verb unchanged.

Anniversary `SetRaidTarget(target, userIndex)` takes a UnitToken — `"player"` is valid. The catalog may omit `GetNumGroupMembers`; do not invent a replacement API. Keep existing pcall guards.

## Tests

Grouped (`IsInRaid` true) + Pope + Event, `GetNumGroupMembers = nil`: `MarkCandidate("Beefina")` spies `SetRaidTarget("player", …)`. Existing missing-group-APIs pin (nils both `GetNumGroupMembers` and `IsInRaid`) stays fail-closed `"not in a group"`. Quiet / ungrouped / party scan pins stay. Isolation wrap stays.

`lua tests/test_markers.lua` exit 0.

Report `docs/reformation/vestments/briefs/B22-C-markers-grouped-report.md` + diff.
