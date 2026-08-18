# B16-D — Markers resolve local player (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Bible §8 (candidate / fighter marks); Law 5 (Pope client); Law 6 (Quiet refuse); brief `docs/reformation/vestments/briefs/B16-D-markers-player.md`. Anniversary `SetRaidTarget(target, userIndex)` accepts UnitToken `"player"`. No GuildPromote. No combat automation.

`resolveUnit` now pcalls `UnitName("player")` before the party/raid scan. If `namesSame(me, name)` it returns `"player"`. Missing `UnitName` stays fail-closed. Event + Pope + grouped still required. Ungrouped Mark still refuses (`isGrouped` before resolve). Target verb unchanged. Exclusive files only. No commit. Lane is not signed.

**Isolated count:** 319 passed, 0 failed (`lua tests/test_markers.lua`). **27** isolation pins under `if standalone then`.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_markers.lua` | TDD first. Source pins: `return "player"`, `namesSame(me, name)`, pcalled `UnitName("player")`. Grouped + Pope + Event: `MarkCandidate("Beefina")` / `MarkFighters` spy `SetRaidTarget("player", …)` (raid and party). Case / realm fold. Party scan pin stays (`party1` for Chuckroast). Quiet / ungrouped / unlisted Pope still refuse the player name. Isolation wrap stays. No new main-chunk locals. |
| `addon/ChurchOfBeef/UI/Markers.lua` | In `resolveUnit`, after the API type-guard and before `GetNumGroupMembers`: `pcall(UnitName, "player")`; if `namesSame(me, name)` return `"player"`. |
| `docs/reformation/vestments/briefs/B16-D-markers-player-report.md` | This file |
| `docs/reformation/vestments/briefs/B16-D-markers-player.diff` | B16-D-only unified diff of the exclusive implementation files vs the pre-lane working tree |

Did not edit Knighting, glue, TOC, bootstrap, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not add GuildPromote. Did not commit.

`git status` shows these two implementation files as untracked (Markers landed after HEAD). The brief diff is the B16-D-only delta, not a whole-file add.

## Contract

```lua
local function resolveUnit(name)
  -- missing GetNumGroupMembers / UnitName → nil (fail-closed)
  -- pcall UnitName("player"); if namesSame(me, name) return "player"
  -- else scan raidN / partyN via Names.Same
end
```

| Gate | MarkCandidate / MarkFighters |
|------|------------------------------|
| Quiet / missing Runtime | `false, "quiet"` |
| Unlisted Pope | `false, "not a registered pope"` |
| Ungrouped (including local name Beefina) | `false, "not in a group"` |
| Grouped + Pope + Event, name is local player | `SetRaidTarget("player", index)` |
| Grouped + Pope + Event, other name | existing `raidN` / `partyN` scan |

Keep:

- Event + Pope + grouped still required
- Target verb unchanged (name-based; no group)
- Party scan pins stay
- No GuildPromote / SetGuildMemberRank / StartAttack / AttackTarget / AssistUnit
- Isolation wrap stays (wow_ui_stub + Common + Runtime + Markers)

## TDD

1. Extended `tests/test_markers.lua` first (source pins + grouped player MarkCandidate / MarkFighters + party scan stay + Quiet / ungrouped / unlisted refuse). Isolation wrap untouched.
2. Red: `lua tests/test_markers.lua` — **305 passed, 14 failed** (source lacked `return "player"` / `namesSame(me, name)`; raid self-mark used `raid1`; party self-mark was `unit not found`).
3. Player read in `resolveUnit` only, before the party/raid scan.
4. Green: `lua tests/test_markers.lua` — **319 passed, 0 failed**.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_markers.lua   # 319 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_markers.lua` standalone | **319 passed, 0 failed.** Lua 5.1.5. Exit 0. |

**Isolated count:** 27 pins under `if standalone then` at file load (UI, DB, Net, Officer, Archive, Recognition, Roster, Popes, Hud, Sound, DecreeBanner, RecordsBook, Minimap, Toasts, Codec, Snapshot, Console, Sender, Store, Gora, Knighting, FighterCard, Confession, Inputs, ConsoleDock, Decree, slash). Wrap unchanged.

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run.

## Self-review

- Exclusive implementation files only. Knighting / glue / TOC were not edited.
- Player token is tried before `partyN` / `raidN`. `pcall` on the read. Missing `UnitName` still fail-closed at the type-guard.
- Grouped + Pope + Event `MarkCandidate("Beefina")` spies `SetRaidTarget("player", 1)`. `MarkFighters` spies `"player"` on the matching side; the other side stays the scan token.
- Party scan pin stays (`Chuckroast` → `party1`). Ungrouped / Quiet / unlisted Pope still refuse.
- Source has no `GuildPromote` / `StartAttack` / `CreateFrame`. Isolation wrap stays.

## Isolated count

**319 passed, 0 failed.** Isolation wrap: **27**.

## Concerns

- **No client smoke / full harness.** Memory-only. Anniversary `SetRaidTarget("player", …)` is not walked in-game this lane.
- **`Clear` inherits the same `resolveUnit` path** and would also mark `"player"`, but B16-D tests only pin `MarkCandidate` / `MarkFighters`.
- Gate W stays OPEN. Gate V stays OPEN.

## Status

**DONE_WITH_CONCERNS.** Isolated **319 / 0**. Isolation wrap **27**. Not signed.
