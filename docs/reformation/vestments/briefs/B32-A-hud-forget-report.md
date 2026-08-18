# B32-A — Non-Gora hide forgets lastPair (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Bible §10.7 (HUD exits with that Gora consequence). Brief `docs/reformation/vestments/briefs/B32-A-hud-forget.md`. B19-C / B21-B leftover: lastPair hid through Knighting RITE and CONSEQUENCE but did not `forgetPersist`, so `Runtime:Continue` (ASSEMBLY, `riteType` nil) returned lastPair and the Gora HUD came back. B16-C pickPair and B17-D livePair Gora-RITE gates stay. Live `GetSanctioned` still shows during Knighting. Gora CONSEQUENCE / ASSEMBLY Continue persist stay. QUIET still forgets in `Refresh`. Favor W-F intact. Dress stays stock. `NAME_FONT` stays `Fonts\\MORPHEUS.ttf`. A01 still NOT RUN.

`displayPair` now calls `forgetPersist()` then returns nil when `lastPair` would be used and the Runtime snapshot is `RITE` **or** `CONSEQUENCE` with a `riteType` that is not `"Gora"`. After Knighting Continue, ASSEMBLY + `riteType` nil stays hidden (`shown == false`, names `""`). lastPair during Gora CONSEQUENCE still paints. lastPair after a Gora Continue (ASSEMBLY, no prior forget) still paints. B19-C Knighting RITE hide and B21-B Knighting CONSEQUENCE hide stay. QUIET still forgets in `Refresh`. `health` stays nil. No `UnitHealth`. No roman numerals. Exclusive files only. No commit. Lane is not signed.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_hud.lua` | TDD first. Source pin: `displayPair` body names `forgetPersist`. Nested `runB32A()` after `runB21B()` inside `runB19C()` (no new main-chunk locals): after the B21-B Knighting CONSEQUENCE hide, `Continue` + `Refresh` → `shown == false`, leftover Gora names `""`, `health` nil. Existing Gora CONSEQUENCE / ASSEMBLY persist pins stay. Isolation wrap stays. |
| `addon/ChurchOfBeef/UI/Hud.lua` | `forgetPersist` hoisted above `displayPair` so the Lua 5.1 local is in scope. lastPair refuse arm (`RITE` or `CONSEQUENCE` and `riteType ~= "Gora"`) calls `forgetPersist()` then returns nil. live `GetSanctioned` / livePair / pickPair unchanged. QUIET `Refresh` still forgets. `health` nil. No `UnitHealth`. `NAME_FONT` stays `Fonts\\MORPHEUS.ttf`. |
| `docs/reformation/vestments/briefs/B32-A-hud-forget-report.md` | This file |
| `docs/reformation/vestments/briefs/B32-A-hud-forget.diff` | B32-A-only unified diff of the exclusive files vs the pre-lane working tree |

Did not edit FighterCard, glue, TOC, bootstrap, `ChurchOfBeef.lua`, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not add Media files. Did not commit.

`git diff` vs HEAD on these two files also includes earlier HUD batches (working tree already dirty). The brief diff is the B32-A-only delta.

## Contract

### Display pair (B32-A)

| Source | Paint |
|--------|-------|
| Live `GetSanctioned()` (both ids) | That pair. Still shown after `OpenRite("Knighting")`. |
| Runtime `RITE` + `riteType == "Gora"` + two fighter ids | Those ids. Remembered as lastPair. |
| lastPair, Runtime `RITE` + `riteType` not `"Gora"` (no live pair) | Hidden. `forgetPersist()`. B19-C hide stays. |
| lastPair, Runtime `CONSEQUENCE` + `riteType` not `"Gora"` (no live pair) | Hidden. `forgetPersist()`. B21-B hide stays. |
| lastPair, Gora CONSEQUENCE | lastPair persist. |
| lastPair, ASSEMBLY after a Gora Continue (no prior forget) | lastPair persist. |
| lastPair, ASSEMBLY after Knighting Continue | Hidden. lastPair already forgotten on the non-Gora refuse. |
| QUIET / EndEvent / no last pair | Hidden. `Refresh` still `forgetPersist()`. |

`livePair` (B17-D) and `pickPair` (B16-C) are unchanged. Never lastPair clicks.

### W-F favor (intact)

| Client | Fill |
|--------|-------|
| Hidden / QUIET / no last pair | `favor == nil`, `health == nil` |
| Local Pope, live Gora pair | `Gora:GetFavorSplit()`, including zeros |
| Local Pope, Gora pair cleared, event live | last painted split (frozen) |
| Congregation | last `SetBroadcastFavor({ a, b })` only |

STATE-off still omits the FAVOR label and both halves. No `UnitHealth`. Dress stays stock iron/parchment. Defense integers stay arabic mute.

## TDD

1. Extended `test_hud.lua` first (source pin `forgetPersist` inside `displayPair`; nested `runB32A()` after `runB21B()` inside `runB19C()`: Knighting Continue + Refresh → `shown == false`, names `""`; Gora CONSEQUENCE / ASSEMBLY persist pins kept; isolation wrap; `health` nil; `NAME_FONT` / no `UnitHealth` pins kept).
2. Red: `lua tests/test_hud.lua` — **757 passed, 7 failed** (source pin missing; leftover lastPair still painted after Knighting Continue).
3. Hoisted `forgetPersist` above `displayPair`. Refuse arm calls `forgetPersist()` then returns nil. livePair / pickPair / remember unchanged. QUIET `Refresh` still forgets.
4. Green: `lua tests/test_hud.lua` — **764 passed, 0 failed**.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_hud.lua   # 764 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_hud.lua` standalone | **764 passed, 0 failed.** Lua 5.1.5. Exit 0. |

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run.

## Isolated count

**764 passed, 0 failed.**

Isolation wrap (unchanged, still under `if standalone then`): **13** nil-module pins — Net, Quiet shell, Toasts, DB, Officer, Archive, Recognition, Sender, Codec, Snapshot, Knighting, Minimap, Console.

## Self-review

- Exclusive implementation files only. FighterCard, glue, TOC not edited.
- `goraPair()` still first. Sanctioned pair still shows during Knighting.
- lastPair after a Gora Continue (ASSEMBLY) still paints. lastPair during Gora CONSEQUENCE still paints.
- B16-C `pickPair` and B17-D `livePair` Gora-RITE gates unchanged. No lastPair clicks.
- After Gora remember + later Knighting RITE hide + CloseRite + Continue: `Refresh` `shown == false`. Leftover Gora names are not painted.
- lastPair is forgotten on the non-Gora refuse (`forgetPersist` also nils `lastPopeFavor`, existing helper).
- `forgetPersist` was hoisted above `displayPair` so the Lua 5.1 local is visible inside the refuse arm. No new file locals.
- QUIET `Refresh` still `forgetPersist()`.
- Source has no `UnitHealth`, `COMBAT_LOG`, `NamePlate`, `PlaySound`, `Toasts`, `Media\\`, `.tga`, `.blp`, or extra `.ttf`. `NAME_FONT` stays `Fonts\\MORPHEUS.ttf`.
- Favor W-F paint unchanged. Dress stays stock. Defense integers stay arabic mute. No roman numerals.
- `countStatusBars` stays 2. `health` stays nil. `healthReads` stay 0.
- Isolation asserts stay under `if standalone then`. New pins are nested in `runB32A()` after `runB21B()` inside `runB19C()`.

## Leftovers

- **No client smoke.** Knighting Continue leftover hide is Event Mode paint. Harness proves `Refresh` after Gora remember + `OpenRite("Knighting")` + `CloseRite` + `Continue`. Two-client `/reload` during a later Knighting after a Gora was not run.
- **OpenRite stands in for STATE.** Congregation Gora remember and Knighting refuse are pinned via `StartEvent` + `OpenRite`. Runtime only opens a rite from ASSEMBLY, so the brief sequence uses CloseRite + Continue between the two OpenRites. Restore / STATE is not a separate pin.
- **Confession / Proclamation leftovers are not separately pinned.** The gate is `riteType ~= "Gora"` on RITE and CONSEQUENCE; only Knighting is the named leftover-forget pin.
- **A01 still NOT RUN.** `health` is nil. Mute rails stay textures. No `UnitHealth`.
- Full `lua tests/run.lua` was not run.

## Status

**DONE_WITH_CONCERNS.** Isolated **764 / 0**. Isolation wrap **13**. Not signed. Do not claim Gate W, Gate V, or POLISH:PASS.
