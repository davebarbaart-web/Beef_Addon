# B22-C — resolveUnit player token does not need GetNumGroupMembers (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Bible §8 (candidate / fighter marks); Law 5 (Pope client); Law 6 (Quiet refuse); brief `docs/reformation/vestments/briefs/B22-C-markers-grouped.md`. Anniversary `SetRaidTarget(target, userIndex)` accepts UnitToken `"player"`. Catalog may omit `GetNumGroupMembers`; no replacement API invented. No GuildPromote. No combat automation.

B16-D leftover: `resolveUnit` type-guarded `GetNumGroupMembers` before the player return. `isGrouped` can already be true via `IsInRaid` / `IsInGroup` when the count API is missing; a Pope marking themselves then failed with `unit not found`. Player arm now requires `UnitName`. If `pcall(UnitName, "player")` names-same the target, return `"player"`. Party / raid scan still requires and type-guards `GetNumGroupMembers`. Missing `UnitName` stays fail-closed. Ungrouped Mark still refuses (`isGrouped`). Target verb unchanged. Exclusive files only. No commit. Lane is not signed.

**Isolated count:** 349 passed, 0 failed (`lua tests/test_markers.lua`). **27** isolation pins under `if standalone then`.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_markers.lua` | TDD first. Grouped (`IsInRaid` true) + Pope + Event, `GetNumGroupMembers = nil`: `MarkCandidate("Beefina")` spies `SetRaidTarget("player", 1)`. Existing missing-group-APIs pin (nils both `GetNumGroupMembers` and `IsInRaid`) stays fail-closed `"not in a group"`. Quiet / ungrouped / party scan pins stay. Isolation wrap stays. Existing source pin `type(GetNumGroupMembers)` stays (scan path). No new main-chunk locals (`ok` / `err` reused; count API save is `do`/`end` local). |
| `addon/ChurchOfBeef/UI/Markers.lua` | `resolveUnit` type-guards `UnitName` only before the player return. `GetNumGroupMembers` type-guard moves to the party / raid scan arm. |
| `docs/reformation/vestments/briefs/B22-C-markers-grouped-report.md` | This file |
| `docs/reformation/vestments/briefs/B22-C-markers-grouped.diff` | B22-C-only unified diff of the exclusive implementation files vs the pre-lane working tree |

Did not edit Knighting, glue, TOC, bootstrap, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not add GuildPromote. Did not commit.

## Contract

```lua
local function resolveUnit(name)
  -- missing UnitName → nil (fail-closed)
  -- pcall UnitName("player"); if namesSame(me, name) return "player"
  -- missing GetNumGroupMembers → nil (scan only)
  -- else scan raidN / partyN via Names.Same
end
```

| Gate | MarkCandidate / MarkFighters |
|------|------------------------------|
| Quiet / missing Runtime | `false, "quiet"` |
| Unlisted Pope | `false, "not a registered pope"` |
| Ungrouped (including local name Beefina) | `false, "not in a group"` |
| Grouped + Pope + Event, name is local player, count API missing | `SetRaidTarget("player", index)` |
| Grouped + Pope + Event, other name | existing `raidN` / `partyN` scan (still needs `GetNumGroupMembers`) |
| Missing both `GetNumGroupMembers` and `IsInRaid` | `false, "not in a group"` |

Keep:

- Event + Pope + grouped still required
- Target verb unchanged (name-based; no group)
- Party scan pins stay
- Missing `UnitName` fail-closed
- No invented replacement for `GetNumGroupMembers`
- No GuildPromote / SetGuildMemberRank / StartAttack / AttackTarget / AssistUnit
- Isolation wrap stays (wow_ui_stub + Common + Runtime + Markers)

## TDD

1. Extended `tests/test_markers.lua` first (B22-C block after B18-D: grouped `IsInRaid` + Pope + Event, `GetNumGroupMembers = nil`, `MarkCandidate("Beefina")` spies `"player"`). Isolation wrap, Quiet / ungrouped / party scan pins, and the both-nil group-API pin untouched.
2. Red: `lua tests/test_markers.lua` — player mark without the count API returned `false, "unit not found"` (combined type-guard still required `GetNumGroupMembers` before `"player"`).
3. Player arm type-guards `UnitName` only. Scan arm still type-guards `GetNumGroupMembers`.
4. Green: `lua tests/test_markers.lua` — **349 passed, 0 failed**.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_markers.lua   # 349 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_markers.lua` standalone | **349 passed, 0 failed.** Lua 5.1.5. Exit 0. |

**Isolated count:** 27 pins under `if standalone then` at file load (UI, DB, Net, Officer, Archive, Recognition, Roster, Popes, Hud, Sound, DecreeBanner, RecordsBook, Minimap, Toasts, Codec, Snapshot, Console, Sender, Store, Gora, Knighting, FighterCard, Confession, Inputs, ConsoleDock, Decree, slash). Wrap unchanged.

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run.

## Self-review

- Exclusive implementation files only. Knighting / glue / TOC were not edited.
- Player token no longer requires `GetNumGroupMembers`. `pcall` on the `UnitName("player")` read stays. Missing `UnitName` still fail-closed at the type-guard.
- Grouped + Pope + Event + `GetNumGroupMembers = nil` `MarkCandidate("Beefina")` spies `SetRaidTarget("player", 1)`.
- Existing both-nil group-API pin stays `"not in a group"`. Quiet / ungrouped / party scan pins stay.
- Scan path still type-guards `GetNumGroupMembers`. No replacement API invented.
- Source has no `GuildPromote` / `StartAttack` / `CreateFrame`. Isolation wrap stays.

## Isolated count

**349 passed, 0 failed.** Isolation wrap: **27**.

## Concerns

- **No client smoke / full harness.** Memory-only. Anniversary `SetRaidTarget("player", …)` with a missing catalog `GetNumGroupMembers` is not walked in-game this lane.
- **Scan-without-count-API is unpinned.** A non-player name with `GetNumGroupMembers = nil` still fail-closes in source (`unit not found`); this lane only spies the player arm.
- **Missing `UnitName` has no new pin.** Fail-closed stays at the type-guard; not re-asserted as a dedicated B22-C case.
- Gate W stays OPEN. Gate V stays OPEN.

## Status

**DONE_WITH_CONCERNS.** Isolated **349 / 0**. Isolation wrap **27**. Not signed.

## Leftover not closed

B16-D leftover assigned to this lane (player return required `GetNumGroupMembers`) is closed. Not closed: client smoke; a dedicated scan-miss pin when the count API is nil; a dedicated missing-`UnitName` pin; Gate W / Gate V.
