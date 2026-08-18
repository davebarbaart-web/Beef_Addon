# B10-B — HUD reads Runtime subjects (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Bible §10.7 (HUD during a sanctioned fight; persist through the verdict); §13.1 (congregation display terminals; star pair on STATE); license 2 favor on STATE. Brief `docs/reformation/vestments/briefs/B10-B-hud-subjects.md`. W-F favor, V-D dress, B4-F name fields, B8-D mute defense integers, and B9-E lastPair persist kept. A01 still NOT RUN.

Event Mode Fight HUD. Congregation clients never call `Gora:Sanction`. The star pair arrives as Runtime `subjects.fighters`. `livePair` is `GetSanctioned()`, else two ids from that list. Remember it as lastPair. Hide when QUIET. Persist lastPair when both Gora and Runtime fighters are empty and the event is still live (B9-E). Do not invent a pair. `health` stays nil. No `UnitHealth`. Favor W-F intact. Exclusive files only. No commit. Lane is not signed. **POLISH:CANDIDATE** at most.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_hud.lua` | TDD first. Source reads `subjects` / `fighters`; bans `Gora:Sanction`. No Sanction: `StartEvent` + `OpenRite("Gora", { fighters })` shows those ids. Broadcast W-F still paints. Continue empties Runtime fighters → lastPair persist. QUIET hides. One id does not invent a pair. Pope freeze survives leftover Runtime subjects after `DeclareVictor`. Isolation wrap stays. Existing persist-after-DeclareVictor pins stay. |
| `addon/ChurchOfBeef/UI/Hud.lua` | `goraPair` / `runtimePair` / `livePair`. Runtime pair requires two numeric ids. `displayPair` still remembers lastPair. `resolveFavor` Pope branch keys off `goraPair` so leftover subjects do not thaw the freeze. `health` nil. No `UnitHealth`. |
| `docs/reformation/vestments/briefs/B10-B-hud-subjects-report.md` | This file |
| `docs/reformation/vestments/briefs/B10-B-hud-subjects.diff` | B10-B-only unified diff of the exclusive files vs the pre-lane baseline |

Did not edit Gora, glue, FighterCard, Console, TOC, bootstrap, `run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not add Media files. Did not commit.

## Contract

### Congregation pair (Bible §13.1 / §10.7)

- `GetSanctioned()` wins when it names both ids.
- Else Runtime snapshot `subjects.fighters` with two numeric ids → `{ fighterA, fighterB }`. Remember as lastPair.
- One id, a missing second id, or a non-number does not invent a pair.
- Hide on QUIET / EndEvent / no last pair.
- Persist lastPair when both Gora and Runtime fighters are empty and the event is still live (B9-E).
- No verdict qualifier. Health stays nil.

### W-F favor (intact)

| Client | Fill |
|--------|------|
| Hidden / QUIET / no last pair | `favor == nil`, `health == nil` |
| Local Pope, live Gora pair | `Gora:GetFavorSplit()`, including zeros |
| Local Pope, Gora pair cleared, event live | last painted split (frozen), even if Runtime still names fighters |
| Congregation | last `SetBroadcastFavor({ a, b })` only |

`PickFavor` / plate click / GetView copy stay as W-F left them. Plate click still requires a live pair (`goraPair` or Runtime subjects). STATE-off still omits the FAVOR label and both halves. No `UnitHealth`.

## TDD

1. Extended `test_hud.lua` first (subjects greps; no-Sanction OpenRite show; W-F broadcast; lastPair persist after Continue; QUIET hide; one-id refuse; Pope freeze with leftover subjects; isolation wrap).
2. Implemented `runtimePair` + `goraPair` split in `Hud.lua`.
3. Green: `lua tests/test_hud.lua` — **539 passed, 0 failed**.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_hud.lua   # 539 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_hud.lua` standalone | **539 passed, 0 failed.** Lua 5.1. Exit 0. |

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run.

## Isolated count

**539 passed, 0 failed.**

Isolation wrap (unchanged, still under `if standalone then`): **13** nil-module pins — Net, Quiet shell, Toasts, DB, Officer, Archive, Recognition, Sender, Codec, Snapshot, Knighting, Minimap, Console.

## Self-review

- Exclusive implementation files only. Quiet still hides. Health pins and nameplate-scrape greps stay.
- Source has no `UnitHealth`, `COMBAT_LOG`, `NamePlate`, `PlaySound`, `Toasts`, `Media\\`, `.tga`, `.blp`, `.ttf`, or `Gora:Sanction`.
- Source does not invent a pair from one fighter. `view.verdict` stays nil.
- Pope split still comes from Gora while a Gora pair is live, then freezes. Congregation still comes from `SetBroadcastFavor`.
- `countStatusBars` stays 2. `health` stays nil. `healthReads` stay 0.
- Isolation asserts stay under `if standalone then`.
- Existing persist-after-DeclareVictor pins stay.

## Concerns

- **No client smoke.** Congregation HUD from STATE subjects is Event Mode theater. Harness proves `Refresh` after `OpenRite` / `Continue` / `EndEvent`. Two-client `/reload` after a Pope broadcast was not run. **POLISH:CANDIDATE** only.
- **OpenRite stands in for STATE.** The brief pins `StartEvent` + `OpenRite`. A real congregation client lands the same snapshot via Restore / STATE, not by calling OpenRite. Restore is not a separate pin.
- **B10-A last pair is unused.** This lane reads Runtime subjects, not `GetLastSanctioned`. Integrator still owns putting last pair + last favor onto outbound STATE after a ruling.
- **Plate click follows livePair.** Congregation can pick during RITE from Runtime subjects (they never Sanction). After Continue, lastPair persist still no-ops the plate. After a ruling, a Pope client whose Runtime leftover still names two fighters can still click — W-F freeze is gora-keyed; the plate is not.
- **A01 still NOT RUN.** `health` is nil. Mute rails stay textures. No `UnitHealth`.
- **FighterCard / glue were not edited.** Card persist is B10-C. STATE last-pair fill is the integrator.
- Integrator still lists the files in the TOC and `run.lua` (already listed).

## Status

**DONE_WITH_CONCERNS.** Isolated **539 / 0**. Isolation wrap **13**. Not signed. **POLISH:CANDIDATE.**
