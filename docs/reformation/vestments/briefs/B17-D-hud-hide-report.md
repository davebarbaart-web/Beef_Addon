# B17-D — HUD does not paint leftover fighters during a non-Gora RITE (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Bible §10.7 (HUD persists through a Gora verdict via lastPair; appears at sanction). Brief `docs/reformation/vestments/briefs/B17-D-hud-hide.md`. B16-C congregation pickPair Gora-RITE send gate stays. Sanctioned pair still shows during Knighting. lastPair persist after Continue stays. W-F favor paint stays. Dress stays stock. A01 still NOT RUN.

`livePair()` still returned ungated `runtimePair()`, so a Knighting RITE that carries leftover `subjects.fighters` painted the fight HUD. The `runtimePair()` arm now requires `snap.state == "RITE"` **and** `snap.riteType == "Gora"`. `goraPair()` (live `GetSanctioned`) stays first. `displayPair` still falls through to lastPair when live is nil (Continue persist until QUIET). After `reset()` with no Sanction, Knighting leftover fighter ids do not paint. `health` stays nil. No `UnitHealth`. No lastPair clicks. Exclusive files only. No commit. Lane is not signed.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_hud.lua` | TDD first. Nested source pin: `livePair` and `pickPair` both gate `runtimePair` to Gora RITE. Existing Sanction + `OpenRite("Knighting")` still shown. lastPair persist after Continue stays. B16-C send-0 stays; that leftover Refresh now also asserts `shown == false` and unpainted ids. New post-`reset()` Knighting leftover + no Sanction: `Refresh` `shown == false`, names empty, `health` nil. Isolation wrap stays. |
| `addon/ChurchOfBeef/UI/Hud.lua` | `livePair` `runtimePair()` arm nested: `state == "RITE"` and `riteType == "Gora"` only. `goraPair()` first-return unchanged. `pickPair` / lastPair / Continue persist / dress / `PickFavor` unchanged. `health` nil. No `UnitHealth`. |
| `docs/reformation/vestments/briefs/B17-D-hud-hide-report.md` | This file |
| `docs/reformation/vestments/briefs/B17-D-hud-hide.diff` | B17-D-only unified diff of the exclusive files vs the pre-lane working tree |

Did not edit Gora, glue, TOC, bootstrap, `run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not add Media files. Did not commit.

`git diff` vs HEAD on these two files also includes earlier HUD batches (working tree already dirty). The brief diff is the B17-D-only delta.

## Contract

### Display pair (B17-D)

| Source | Paint |
|--------|-------|
| Live `GetSanctioned()` (both ids) | That pair. Still shown after `OpenRite("Knighting")`. |
| Runtime `RITE` + `riteType == "Gora"` + two fighter ids | Those ids. Existing congregation `OpenRite("Gora")` pins stay green. |
| Runtime `RITE` + `riteType == "Knighting"` + two leftover fighter ids, no Sanction, lastPair empty | Hidden. Do not paint those leftover ids. |
| Live pair gone, lastPair set, event not QUIET | lastPair persist (Continue until QUIET). |
| QUIET / EndEvent / no last pair | Hidden. |

`pickPair` is unchanged (B16-C): congregation leftovers send only during a Gora RITE. Pope / live `GetSanctioned` only. Never lastPair.

### W-F favor (intact)

| Client | Fill |
|--------|------|
| Hidden / QUIET / no last pair | `favor == nil`, `health == nil` |
| Local Pope, live Gora pair | `Gora:GetFavorSplit()`, including zeros |
| Local Pope, Gora pair cleared, event live | last painted split (frozen) |
| Congregation | last `SetBroadcastFavor({ a, b })` only |

STATE-off still omits the FAVOR label and both halves. No `UnitHealth`. Dress stays stock iron/parchment.

## TDD

1. Extended `test_hud.lua` first (nested `>= 2` Gora-RITE source pin; B16-C leftover Refresh now `shown == false` and unpainted ids; post-`reset()` Knighting leftover hide; existing Sanction-during-Knighting and Continue persist pins kept; isolation wrap; `health` nil).
2. Red: `lua tests/test_hud.lua` — **662 passed, 10 failed** (second Gora-RITE gate missing; Knighting leftover fighters still painted).
3. `livePair` `runtimePair()` arm nested: `snap.state == "RITE"` and `snap.riteType == "Gora"`. `goraPair()` first-return unchanged.
4. Green: `lua tests/test_hud.lua` — **672 passed, 0 failed**.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_hud.lua   # 672 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_hud.lua` standalone | **672 passed, 0 failed.** Lua 5.1. Exit 0. |

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run.

## Isolated count

**672 passed, 0 failed.**

Isolation wrap (unchanged, still under `if standalone then`): **13** nil-module pins — Net, Quiet shell, Toasts, DB, Officer, Archive, Recognition, Sender, Codec, Snapshot, Knighting, Minimap, Console.

## Self-review

- Exclusive implementation files only. Gora, glue, TOC not edited.
- `goraPair()` still first. Sanctioned pair still shows during Knighting.
- `displayPair` still falls through to lastPair. Continue persist until QUIET stays.
- B16-C `pickPair` Gora-RITE send gate unchanged. No lastPair clicks.
- After `reset()` + Knighting leftover fighters + no Sanction: `Refresh` `shown == false`. Leftover ids are not painted.
- Source has no `UnitHealth`, `COMBAT_LOG`, `NamePlate`, `PlaySound`, `Toasts`, `Media\\`, `.tga`, `.blp`, or `.ttf`.
- Favor W-F paint unchanged. Dress stays stock.
- `countStatusBars` stays 2. `health` stays nil. `healthReads` stay 0.
- Isolation asserts stay under `if standalone then`. New source pin is nested (`do` / `end`). `livePair` gate locals are nested.

## Concerns

- **No client smoke.** Knighting leftover hide is Event Mode paint. Harness proves `Refresh` after `OpenRite("Knighting", { fighters })` with empty lastPair. Two-client `/reload` during a Knighting that still names leftover fighters was not run.
- **OpenRite stands in for STATE.** Congregation Gora paint and Knighting refuse are pinned via `StartEvent` + `OpenRite`. A real congregation client lands the same snapshot via Restore / STATE. Restore is not a separate pin.
- **lastPair can still paint during Knighting.** If a prior Gora pair was remembered, `displayPair` falls through to lastPair until QUIET. This lane hides only a live leftover `runtimePair` after `reset()`. A leftover lastPair from an earlier Gora is persist, not leftover Knighting ids.
- **Confession / Proclamation leftovers are not separately pinned.** The gate is `riteType == "Gora"`; only Knighting is the named leftover hide pin.
- **A01 still NOT RUN.** `health` is nil. Mute rails stay textures. No `UnitHealth`.

## Status

**DONE_WITH_CONCERNS.** Isolated **672 / 0**. Isolation wrap **13**. Not signed. Do not claim Gate W, Gate V, or POLISH:PASS.
