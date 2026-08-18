# B19-C — lastPair does not paint through a non-Gora RITE (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Bible §10.7 (HUD persists through a Gora verdict). Brief `docs/reformation/vestments/briefs/B19-C-hud-rite.md`. B9-E lastPair until QUIET still applies to ASSEMBLY / CONSEQUENCE. B16-C pickPair and B17-D livePair Gora-RITE gates stay. Live `GetSanctioned` still shows during Knighting. Favor W-F intact. Dress stays stock. A01 still NOT RUN.

B17-D leftover: after a Gora, `lastPair` still painted during a later Knighting RITE. `displayPair` now returns nil when `lastPair` would be used and the Runtime snapshot is `RITE` with a `riteType` that is not `"Gora"`. Live `GetSanctioned` still shows during Knighting. lastPair after Continue (ASSEMBLY, no riteType) still paints. lastPair during Gora CONSEQUENCE still paints. QUIET still hides. `health` stays nil. No `UnitHealth`. Exclusive files only. No commit. Lane is not signed.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_hud.lua` | TDD first. Source pin: `riteType ~= "Gora"`. Nested `runB19C()`: OpenRite Gora → Refresh (remember lastPair) → CloseRite (Gora CONSEQUENCE persist) → Continue (ASSEMBLY persist) → OpenRite Knighting with a candidate, no Sanction → `shown == false`, leftover Gora names empty, `health` nil. Existing Sanction-during-Knighting pin stays shown. Continue persist pin stays. Isolation wrap stays. |
| `addon/ChurchOfBeef/UI/Hud.lua` | `displayPair` lastPair arm: if Runtime snapshot is `RITE` and `riteType ~= "Gora"`, return nil (do not paint). live `GetSanctioned` / livePair / pickPair unchanged. lastPair itself is not forgotten. `health` nil. No `UnitHealth`. |
| `docs/reformation/vestments/briefs/B19-C-hud-rite-report.md` | This file |
| `docs/reformation/vestments/briefs/B19-C-hud-rite.diff` | B19-C-only unified diff of the exclusive files vs the pre-lane working tree |

Did not edit Gora, glue, TOC, bootstrap, `ChurchOfBeef.lua`, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not add Media files. Did not commit.

`git diff` vs HEAD on these two files also includes earlier HUD batches (working tree already dirty). The brief diff is the B19-C-only delta.

## Contract

### Display pair (B19-C)

| Source | Paint |
|--------|-------|
| Live `GetSanctioned()` (both ids) | That pair. Still shown after `OpenRite("Knighting")`. |
| Runtime `RITE` + `riteType == "Gora"` + two fighter ids | Those ids. Remembered as lastPair. |
| lastPair, Runtime `RITE` + `riteType` not `"Gora"` (no live pair) | Hidden. Do not paint leftover Gora names. |
| lastPair, Gora CONSEQUENCE | lastPair persist. |
| lastPair, ASSEMBLY after Continue (no riteType) | lastPair persist. |
| QUIET / EndEvent / no last pair | Hidden. |

`livePair` (B17-D) and `pickPair` (B16-C) are unchanged. Never lastPair clicks.

### W-F favor (intact)

| Client | Fill |
|--------|------|
| Hidden / QUIET / no last pair | `favor == nil`, `health == nil` |
| Local Pope, live Gora pair | `Gora:GetFavorSplit()`, including zeros |
| Local Pope, Gora pair cleared, event live | last painted split (frozen) |
| Congregation | last `SetBroadcastFavor({ a, b })` only |

STATE-off still omits the FAVOR label and both halves. No `UnitHealth`. Dress stays stock iron/parchment.

## TDD

1. Extended `test_hud.lua` first (source pin `riteType ~= "Gora"`; nested `runB19C()` Gora remember → Gora CONSEQUENCE persist → Continue persist → Knighting hide; existing Sanction-during-Knighting and Continue persist pins kept; isolation wrap; `health` nil).
2. Red: `lua tests/test_hud.lua` — **707 passed, 7 failed** (source pin missing; leftover lastPair still painted through Knighting).
3. `displayPair` lastPair arm: `snap.state == "RITE"` and `snap.riteType ~= "Gora"` returns nil. livePair / pickPair / remember unchanged.
4. Green: `lua tests/test_hud.lua` — **714 passed, 0 failed**.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_hud.lua   # 714 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_hud.lua` standalone | **714 passed, 0 failed.** Lua 5.1. Exit 0. |

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run.

## Isolated count

**714 passed, 0 failed.**

Isolation wrap (unchanged, still under `if standalone then`): **13** nil-module pins — Net, Quiet shell, Toasts, DB, Officer, Archive, Recognition, Sender, Codec, Snapshot, Knighting, Minimap, Console.

## Self-review

- Exclusive implementation files only. Gora, glue, TOC not edited.
- `goraPair()` still first. Sanctioned pair still shows during Knighting.
- lastPair after Continue (ASSEMBLY) still paints. lastPair during Gora CONSEQUENCE still paints.
- B16-C `pickPair` and B17-D `livePair` Gora-RITE gates unchanged. No lastPair clicks.
- After Gora remember + later Knighting with no Sanction: `Refresh` `shown == false`. Leftover Gora names are not painted.
- lastPair is not forgotten during the hide; only the paint is refused.
- Source has no `UnitHealth`, `COMBAT_LOG`, `NamePlate`, `PlaySound`, `Toasts`, `Media\\`, `.tga`, `.blp`, or `.ttf`.
- Favor W-F paint unchanged. Dress stays stock.
- `countStatusBars` stays 2. `health` stays nil. `healthReads` stay 0.
- Isolation asserts stay under `if standalone then`. New pins are nested in `runB19C()`.

## Leftovers

- **No client smoke.** Knighting leftover lastPair hide is Event Mode paint. Harness proves `Refresh` after Gora remember + `OpenRite("Knighting")`. Two-client `/reload` during a later Knighting after a Gora was not run.
- **OpenRite stands in for STATE.** Congregation Gora remember and Knighting refuse are pinned via `StartEvent` + `OpenRite`. Runtime only opens a rite from ASSEMBLY, so the brief sequence uses CloseRite + Continue between the two OpenRites. Restore / STATE is not a separate pin.
- **Confession / Proclamation leftovers are not separately pinned.** The gate is `riteType ~= "Gora"`; only Knighting is the named leftover hide pin.
- **Knighting CONSEQUENCE still paints lastPair.** B9-E persist still applies to CONSEQUENCE. Only a non-Gora RITE refuses lastPair paint.
- **A01 still NOT RUN.** `health` is nil. Mute rails stay textures. No `UnitHealth`.
- Full `lua tests/run.lua` was not run.

## Status

**DONE_WITH_CONCERNS.** Isolated **714 / 0**. Isolation wrap **13**. Not signed. Do not claim Gate W, Gate V, or POLISH:PASS.
