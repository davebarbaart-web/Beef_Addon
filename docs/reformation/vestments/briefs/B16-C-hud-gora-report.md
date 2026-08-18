# B16-C — Congregation picks only during Gora RITE (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Bible §10.6 (favor is pick-a-side only); §10.7 (HUD persists through the verdict; favor picks close); §13.1 (congregation input devices; they never Sanction). Brief `docs/reformation/vestments/briefs/B16-C-hud-gora.md`. B11-B leftover-ruling Pope pins stay. Congregation Gora RITE still sends. W-F favor paint stays. Display persist (lastPair) stays. Dress stays stock. A01 still NOT RUN.

Congregation `pickPair` now required only `state == "RITE"` plus Runtime fighters. A Knighting RITE that carries leftover fighters would `SendFavor`. Congregation leftovers now send only when `snap.state == "RITE"` **and** `snap.riteType == "Gora"`. Pope path unchanged: live `GetSanctioned()` only. Isolated suite with a live `GetSanctioned` still sends even if Sender is nil. `health` stays nil. No `UnitHealth`. No lastPair clicks. Exclusive files only. No commit. Lane is not signed.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_hud.lua` | TDD first. Source pin `riteType == "Gora"`. Existing congregation `OpenRite("Gora")` pick still sends and now asserts `riteType == "Gora"`. New Knighting RITE + two Runtime fighters + `SetFavorTarget` + local id: plate `OnClick` sends 0. B11-B leftover-ruling Pope pins kept. Isolation wrap stays. `health` nil. |
| `addon/ChurchOfBeef/UI/Hud.lua` | Congregation `pickPair` returns `runtimePair()` only when `snap.state == "RITE"` and `snap.riteType == "Gora"`. Pope / live `GetSanctioned` unchanged. `displayPair` / lastPair / Refresh paint / `PickFavor` / dress unchanged. `health` nil. No `UnitHealth`. |
| `docs/reformation/vestments/briefs/B16-C-hud-gora-report.md` | This file |
| `docs/reformation/vestments/briefs/B16-C-hud-gora.diff` | B16-C-only unified diff of the exclusive files vs the pre-lane working tree |

Did not edit Gora, glue, TOC, bootstrap, `run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not add Media files. Did not commit.

`git diff` vs HEAD on these two files also includes earlier HUD batches (working tree already dirty). The brief diff is the B16-C-only delta.

## Contract

### Plate pick pair (B16-C)

| Client | Pick pair |
|--------|-----------|
| Live `GetSanctioned()` (both ids) | That pair. Isolated suite still sends with Sender nil. Pope path is this only. |
| Local Pope, no live Gora pair | No send. Leftover Runtime subjects after a ruling do not pick (B11-B). |
| Congregation, Runtime `RITE` + `riteType == "Gora"` + two fighter ids | Those ids. Existing `OpenRite("Gora")` pins stay green. |
| Congregation, Runtime `RITE` + `riteType == "Knighting"` + two leftover fighter ids | No send. |
| CONSEQUENCE / ASSEMBLY without a live pick pair / QUIET | No send. lastPair persist may still paint. |

`pickPair` never uses lastPair. `PickFavor` itself is unchanged: missing target → `nil, "no target"`; missing character → `nil, "no character"`.

### W-F favor (intact)

| Client | Fill |
|--------|------|
| Hidden / QUIET / no last pair | `favor == nil`, `health == nil` |
| Local Pope, live Gora pair | `Gora:GetFavorSplit()`, including zeros |
| Local Pope, Gora pair cleared, event live | last painted split (frozen) |
| Congregation | last `SetBroadcastFavor({ a, b })` only |

STATE-off still omits the FAVOR label and both halves. No `UnitHealth`. Dress stays stock iron/parchment.

## TDD

1. Extended `test_hud.lua` first (source `riteType == "Gora"`; existing Gora RITE send stays; Knighting leftover + target + local id → send 0; B11-B leftover-ruling Pope pins kept; isolation wrap; `health` nil).
2. Red: `lua tests/test_hud.lua` — **643 passed, 3 failed** (source gate missing; Knighting leftover plates still sent).
3. Congregation `pickPair` now requires `snap.state == "RITE"` and `snap.riteType == "Gora"` before `runtimePair()`. Pope / `GetSanctioned` first-return unchanged.
4. Green: `lua tests/test_hud.lua` — **646 passed, 0 failed**.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_hud.lua   # 646 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_hud.lua` standalone | **646 passed, 0 failed.** Lua 5.1. Exit 0. |

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run.

## Isolated count

**646 passed, 0 failed.**

Isolation wrap (unchanged, still under `if standalone then`): **13** nil-module pins — Net, Quiet shell, Toasts, DB, Officer, Archive, Recognition, Sender, Codec, Snapshot, Knighting, Minimap, Console.

## Self-review

- Exclusive implementation files only. Gora, glue, TOC not edited.
- Pope path still `GetSanctioned()` only. Congregation leftovers send only during a Gora RITE.
- Existing `OpenRite("Gora")` congregation pick pins stay green.
- Knighting RITE + two Runtime fighters: plate `OnClick` does not `SendFavor`.
- Source has no `UnitHealth`, `COMBAT_LOG`, `NamePlate`, `PlaySound`, `Toasts`, `Media\\`, `.tga`, `.blp`, or `.ttf`.
- `displayPair` / lastPair / Refresh paint unchanged. Favor W-F paint unchanged. Dress stays stock.
- `countStatusBars` stays 2. `health` stays nil. `healthReads` stay 0.
- Isolation asserts stay under `if standalone then`.

## Concerns

- **No client smoke.** Knighting leftover picks are Event Mode input. Harness proves `OnClick` after `OpenRite("Knighting", { fighters })`. Two-client `/reload` during a Knighting that still names leftover fighters was not run.
- **OpenRite stands in for STATE.** Congregation Gora send and Knighting refuse are pinned via `StartEvent` + `OpenRite`. A real congregation client lands the same snapshot via Restore / STATE. Restore is not a separate pin.
- **Display may still paint leftover fighters during Knighting.** `livePair` / `displayPair` are unchanged. This lane gates plate send only. A leftover pair can remain visible while clicks do not `SendFavor`.
- **Confession / Proclamation leftovers are not separately pinned.** The gate is `riteType == "Gora"`; only Knighting is the named leftover pin.
- **A01 still NOT RUN.** `health` is nil. Mute rails stay textures. No `UnitHealth`.

## Status

**DONE_WITH_CONCERNS.** Isolated **646 / 0**. Isolation wrap **13**. Not signed. Do not claim Gate W, Gate V, or POLISH:PASS.
