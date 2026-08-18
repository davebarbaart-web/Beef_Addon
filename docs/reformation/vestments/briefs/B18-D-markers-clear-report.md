# B18-D — Markers Clear uses the player token (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Bible §8 (candidate / fighter marks); Law 5 (Pope client); Law 6 (Quiet refuse); brief `docs/reformation/vestments/briefs/B18-D-markers-clear.md`. Anniversary `SetRaidTarget(target, userIndex)` — index `0` clears. `resolveUnit` player return (B16-D) stays. No GuildPromote. No combat automation.

B16-D leftover: `Clear` already inherits `resolveUnit` and `applyMark(unit, 0)` but was unpinned for the local stub name. Grouped + Pope + Event `Clear("Beefina")` now spies `SetRaidTarget("player", 0)`. Quiet / ungrouped `Clear("Beefina")` still refuse. Target verb unchanged. Party scan pins stay. B16-D Mark player pins stay. Exclusive files only. No commit. Lane is not signed.

**Isolated count:** 342 passed, 0 failed (`lua tests/test_markers.lua`). **27** isolation pins under `if standalone then`.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_markers.lua` | TDD first. After the B16-D Mark pins: grouped + Pope + Event `Clear("Beefina")` spies `"player", 0` (not `raid1`). View records `unit` / `index`. Quiet / ungrouped `Clear("Beefina")` still refuse (`"quiet"` / `"not in a group"`, no spy). Isolation wrap stays. No new main-chunk locals (`ok` / `err` / `view` reused). |
| `addon/ChurchOfBeef/UI/Markers.lua` | Unchanged. `Clear` already calls `resolveUnit` then `applyMark(unit, 0)`. Player token is the B16-D `resolveUnit` return. |
| `docs/reformation/vestments/briefs/B18-D-markers-clear-report.md` | This file |
| `docs/reformation/vestments/briefs/B18-D-markers-clear.diff` | B18-D-only unified diff of the exclusive implementation files vs the pre-lane working tree |

Did not edit Knighting, glue, TOC, bootstrap, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not add GuildPromote. Did not commit.

`git status` shows these two implementation files as untracked (Markers landed after HEAD). The brief diff is the B18-D-only test hunk. `Markers.lua` has no B18-D production delta.

## Contract

```lua
function Markers:Clear(name)
  -- Quiet / missing Runtime → false, "quiet"
  -- Unlisted Pope → false, "not a registered pope"
  -- Ungrouped → false, "not in a group"
  -- Grouped + Pope + Event, name is local player → SetRaidTarget("player", 0)
end
```

| Gate | Clear |
|------|-------|
| Quiet / missing Runtime | `false, "quiet"` |
| Unlisted Pope | `false, "not a registered pope"` |
| Ungrouped (including local name Beefina) | `false, "not in a group"` |
| Grouped + Pope + Event, name is local player | `SetRaidTarget("player", 0)` |
| Grouped + Pope + Event, other name | existing `raidN` / `partyN` scan, index `0` |

Keep:

- Event + Pope + grouped still required
- `resolveUnit` player return (B16-D) stays
- B16-D Mark player pins stay (`MarkCandidate` / `MarkFighters` → `"player"`)
- Target verb unchanged (name-based; no group)
- Party scan pins stay
- No GuildPromote / SetGuildMemberRank / StartAttack / AttackTarget / AssistUnit
- Isolation wrap stays (wow_ui_stub + Common + Runtime + Markers)
- No new main-chunk locals

## TDD

1. Extended `tests/test_markers.lua` first (B18-D block after the B16-D Mark pins: grouped `Clear("Beefina")` spies `"player", 0`; Quiet / ungrouped refuse; view unit / index). Isolation wrap and B16-D Mark pins untouched.
2. Red was not required: `Clear` already inherits `resolveUnit`. Pre-lane `lua tests/test_markers.lua` was **319 passed, 0 failed**.
3. No `Markers.lua` edit.
4. Green: `lua tests/test_markers.lua` — **342 passed, 0 failed**.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_markers.lua   # 342 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_markers.lua` standalone | **342 passed, 0 failed.** Lua 5.1.5. Exit 0. |

**Isolated count:** 27 pins under `if standalone then` at file load (UI, DB, Net, Officer, Archive, Recognition, Roster, Popes, Hud, Sound, DecreeBanner, RecordsBook, Minimap, Toasts, Codec, Snapshot, Console, Sender, Store, Gora, Knighting, FighterCard, Confession, Inputs, ConsoleDock, Decree, slash). Wrap unchanged.

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run.

## Self-review

- Exclusive implementation files only. Knighting / glue / TOC were not edited.
- `Clear` still uses `resolveUnit` then `applyMark(unit, 0)`. Player token stays the B16-D return.
- Grouped + Pope + Event `Clear("Beefina")` spies `SetRaidTarget("player", 0)`. Not `raid1`.
- Quiet / ungrouped `Clear("Beefina")` still refuse. No spy.
- B16-D Mark player pins stay. Target verb unchanged. Party scan pins stay.
- Source has no `GuildPromote` / `StartAttack` / `CreateFrame`. Isolation wrap stays. No new main-chunk locals.

## Isolated count

**342 passed, 0 failed.** Isolation wrap: **27**.

## Concerns

- **No client smoke / full harness.** Memory-only. Anniversary `SetRaidTarget("player", 0)` is not walked in-game this lane.
- **Party `Clear("Beefina")` is not a separate pin.** Raid `armRaid` covers grouped. Party scan pins for Mark stay; party Clear of the local name is inherited, not re-asserted.
- **Unlisted Pope `Clear("Beefina")` is not a separate pin.** Brief named Quiet / ungrouped refuse. Unlisted Pope Clear of other names stays in the earlier block.
- **Type-guard still requires `GetNumGroupMembers` before the player return** (B16-D leftover). Missing count API still fail-closes a self-clear.
- Gate W stays OPEN. Gate V stays OPEN.

## Status

**DONE_WITH_CONCERNS.** Isolated **342 / 0**. Isolation wrap **27**. Not signed.
