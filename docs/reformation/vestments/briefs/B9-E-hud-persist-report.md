# B9-E — HUD persists through the verdict (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Bible §10.7 (appears at sanction, persists through the verdict beat, exits with the consequence); Law 6 / §19.1 (Quiet Mode hides Event chrome); brief `docs/reformation/vestments/briefs/B9-E-hud-persist.md`. W-F favor, V-D dress, B4-F name fields, and B8-D mute defense integers kept. A01 still NOT RUN.

Event Mode Fight HUD remembers the last sanctioned pair. After `Gora:GetSanctioned()` is nil, if Runtime is still not QUIET, the HUD keeps painting that pair. Pope favor freezes on the last split (`GetFavorSplit` is empty once the pair clears). Congregation favor still follows W-F (`SetBroadcastFavor` only). Hide on QUIET / EndEvent / no last pair. A new Sanction replaces the remembered pair. No verdict qualifier. `health` stays nil. No `UnitHealth`. Exclusive files only. No commit. Lane is not signed. **POLISH:CANDIDATE** at most.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_hud.lua` | TDD first. Flipped `HUD hides when the pair clears, even mid-event` → stays shown after DeclareVictor while the event is live; `shown == true`; names still painted; `health` nil; congregation favor still W-F (nil without broadcast); no `view.verdict`. Added Pope freeze (2/1 stays after Gora split goes 0/0), congregation broadcast persist, QUIET hide, ASSEMBLY after QUIET does not revive the last pair. Isolation wrap stays. |
| `addon/ChurchOfBeef/UI/Hud.lua` | `lastPair` / `lastPopeFavor`. `Refresh` paints `displayPair()` while not QUIET. `forgetPersist` on QUIET and `ResetForTests`. Pope `resolveFavor` caches the live split and returns the freeze after the pair clears. `PickFavor` / plate click still require a live pair. No verdict copy. `health` nil. Defense integers unchanged. |
| `docs/reformation/vestments/briefs/B9-E-hud-persist-report.md` | This file |
| `docs/reformation/vestments/briefs/B9-E-hud-persist.diff` | B9-E-only unified diff of the exclusive files vs the pre-lane baseline |

Did not edit Gora, FighterCard, Console, TOC, bootstrap, `run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not add Media files. Did not commit.

## Contract

### Persist (Bible §10.7)

- Remember the last sanctioned `fighterA` / `fighterB` when `GetSanctioned()` is a live pair.
- After the pair clears, if Runtime is not QUIET, keep painting that pair.
- Hide on QUIET / EndEvent / no last pair. Forget the remembered pair on QUIET so a later ASSEMBLY does not revive it.
- A new Sanction replaces the remembered pair.
- No verdict qualifier on the HUD (`view.verdict` stays nil). Health stays nil. Defense integers unchanged.

### W-F favor (intact)

| Client | Fill |
|--------|------|
| Hidden / QUIET / no last pair | `favor == nil`, `health == nil` |
| Local Pope, live pair | `Gora:GetFavorSplit()`, including zeros |
| Local Pope, pair cleared, event live | last painted split (frozen) |
| Congregation | last `SetBroadcastFavor({ a, b })` only |

`PickFavor` / plate click / GetView copy stay as W-F left them. Plate click still no-ops without a live pair. STATE-off still omits the FAVOR label and both halves. No `UnitHealth`.

## TDD

1. Extended `test_hud.lua` first (flip the mid-event hide pin; persist names / shown / health nil / W-F favor / no verdict; Pope freeze; QUIET hide; isolation wrap).
2. Implemented `lastPair` persist + frozen Pope split in `Hud.lua`.
3. Green: `lua tests/test_hud.lua` — **466 passed, 0 failed**.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_hud.lua   # 466 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_hud.lua` standalone | **466 passed, 0 failed.** Lua 5.1.5. Exit 0. |

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run.

## Isolated count

**466 passed, 0 failed.**

Isolation wrap (unchanged, still under `if standalone then`): **13** nil-module pins — Net, Quiet shell, Toasts, DB, Officer, Archive, Recognition, Sender, Codec, Snapshot, Knighting, Minimap, Console.

## Self-review

- Exclusive implementation files only. Quiet still hides. Health pins and nameplate-scrape greps stay.
- Source has no `UnitHealth`, `COMBAT_LOG`, `NamePlate`, `PlaySound`, `Toasts`, `Media\\`, `.tga`, `.blp`, or `.ttf`.
- Source does not invent verdict copy. `view.verdict` is nil after DeclareVictor.
- Pope split still comes from Gora while the pair is live, then freezes. Congregation still comes from `SetBroadcastFavor`. `PickFavor` and plate clicks are unchanged.
- `countStatusBars` stays 2. `health` stays nil. `healthReads` stay 0.
- Isolation asserts stay under `if standalone then`.

## Concerns

- **No client smoke.** Persist through the verdict beat is Event Mode theater. Harness proves `Refresh` after `DeclareVictor` / `EndEvent`. `/reload` after a live ruling was not run. **POLISH:CANDIDATE** only.
- **Favor freeze is HUD-local.** Pope freeze lives in `lastPopeFavor` because `Gora:GetFavorSplit()` returns `{0,0}` once the pair is cleared (Gora exclusive; this lane does not edit it). Congregation freeze is the existing broadcast table. A congregation client with no broadcast still paints names without favor — W-F.
- **Plate click still requires a live pair.** After the ruling, congregation cannot send a new pick from the persisted card. Intended: W-F `PickFavor` does not invent a post-verdict Gora.
- **Store W/L updates on persist paint.** The remembered pair is re-read from Store, so the tape can show 1-0 immediately after `DeclareVictor`. That is not a verdict qualifier.
- **A01 still NOT RUN.** `health` is nil. Mute rails stay textures. No `UnitHealth`.
- **Cowardice / Void share the same persist path** (`GetSanctioned()` nil + not QUIET). Only `DeclareVictor` is pinned.
- **FighterCard / Console were not edited.** Those surfaces may still hide when the pair clears. HUD-only persist is the exclusive scope.
- Integrator still lists the files in the TOC and `run.lua` (already listed).

## Status

**DONE_WITH_CONCERNS.** Isolated **466 / 0**. Isolation wrap **13**. Not signed. **POLISH:CANDIDATE.**
