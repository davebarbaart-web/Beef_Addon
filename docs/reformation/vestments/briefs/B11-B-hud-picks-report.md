# B11-B — HUD leftover plate clicks (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Bible §10.7 (HUD persists through the verdict; favor picks close); §10.6 (favor is pick-a-side only); §13.1 (congregation input devices; they never Sanction). Brief `docs/reformation/vestments/briefs/B11-B-hud-picks.md`. Display persist (lastPair / B9-E / B10-B) stays. W-F favor paint stays. A01 still NOT RUN.

Event Mode Fight HUD. After a ruling the card stays painted; leftover plate clicks must not `SendFavor`. `clickPlate` pick pair never uses lastPair. Pope (`Sender:IsRegisteredPope` local) → `Gora:GetSanctioned()` only. Congregation → Runtime `subjects.fighters` (two ids) only while Runtime state is `RITE`. Isolated suite with a live `GetSanctioned` still sends even if Sender is nil. `PickFavor` stays a send helper (missing-target / missing-character errors unchanged). `health` stays nil. No `UnitHealth`. No custom media. Exclusive files only. No commit. Lane is not signed. **POLISH:CANDIDATE** at most.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_hud.lua` | TDD first. B11-B leftover-click pins: live Sanction still sends with Sender nil; `DeclareVictor` persist shown → plate does not send; Pope leftover Runtime subjects after a ruling do not send; OpenRite Gora subjects, no Sanction, Sender nil → plate sends; same after `CloseRite` (CONSEQUENCE) → no send, HUD may still show; after `Continue` (empty Runtime, lastPair persist) → no send, HUD still shown; QUIET plate no-op; `PickFavor` missing-target / missing-character pins stay; `health` nil; isolation wrap stays. |
| `addon/ChurchOfBeef/UI/Hud.lua` | `pickPair` for plate `OnClick` only. `displayPair` / lastPair / Refresh paint unchanged. `PickFavor` unchanged. `health` nil. No `UnitHealth`. |
| `docs/reformation/vestments/briefs/B11-B-hud-picks-report.md` | This file |
| `docs/reformation/vestments/briefs/B11-B-hud-picks.diff` | B11-B-only unified diff of the exclusive files vs the pre-lane baseline |

Did not edit Gora, FighterCard, Snapshot, glue, Console, TOC, bootstrap, `run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not add Media files. Did not commit.

## Contract

### Display persist (unchanged)

- `livePair` is still `GetSanctioned()`, else Runtime `subjects.fighters` with two ids.
- `displayPair` still remembers lastPair. Persist lastPair when both Gora and Runtime fighters are empty and the event is still live (B9-E / B10-B).
- Hide on QUIET / EndEvent / no last pair. No verdict qualifier. Health stays nil.

### Plate pick pair (B11-B)

| Client | Pick pair |
|--------|-----------|
| Live `GetSanctioned()` (both ids) | That pair. Isolated suite still sends with Sender nil. |
| Local Pope, no live Gora pair | No send. Leftover Runtime subjects after a ruling do not pick. |
| Congregation, Runtime `RITE` + two fighter ids | Those ids. |
| CONSEQUENCE / ASSEMBLY without a live pick pair / QUIET | No send. lastPair persist may still paint. |

`PickFavor` itself is unchanged: missing target → `nil, "no target"`; missing character → `nil, "no character"`.

### W-F favor (intact)

| Client | Fill |
|--------|------|
| Hidden / QUIET / no last pair | `favor == nil`, `health == nil` |
| Local Pope, live Gora pair | `Gora:GetFavorSplit()`, including zeros |
| Local Pope, Gora pair cleared, event live | last painted split (frozen), even if Runtime still names fighters |
| Congregation | last `SetBroadcastFavor({ a, b })` only |

STATE-off still omits the FAVOR label and both halves. No `UnitHealth`.

## TDD

1. Extended `test_hud.lua` first (leftover-click pins; persist still shown; congregation RITE send; CONSEQUENCE / Continue / QUIET no send; PickFavor errors stay; isolation wrap).
2. Ran isolated suite: **4 failed** (Pope leftover Runtime subjects still sent; CONSEQUENCE leftover still sent).
3. Implemented `pickPair` on plate `OnClick` only. `displayPair` / lastPair / `PickFavor` untouched.
4. Green: `lua tests/test_hud.lua` — **624 passed, 0 failed**.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_hud.lua   # 624 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_hud.lua` standalone | **624 passed, 0 failed.** Lua 5.1. Exit 0. |

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run.

## Isolated count

**624 passed, 0 failed.**

Isolation wrap (unchanged, still under `if standalone then`): **13** nil-module pins — Net, Quiet shell, Toasts, DB, Officer, Archive, Recognition, Sender, Codec, Snapshot, Knighting, Minimap, Console.

## Self-review

- Exclusive implementation files only. Quiet still hides. Health pins and nameplate-scrape greps stay.
- Source has no `UnitHealth`, `COMBAT_LOG`, `NamePlate`, `PlaySound`, `Toasts`, `Media\\`, `.tga`, `.blp`, or `.ttf`.
- `displayPair` / lastPair / Refresh paint unchanged. Favor W-F paint unchanged.
- `PickFavor` missing-target / missing-character strings unchanged.
- Existing Sanctioned plate-click sends stay (isolated suite has `GetSanctioned`).
- `countStatusBars` stays 2. `health` stays nil. `healthReads` stay 0.
- Isolation asserts stay under `if standalone then`.

## Concerns

- **No client smoke.** Leftover plate clicks are Event Mode input. Harness proves `OnClick` after `DeclareVictor` / `OpenRite` / `CloseRite` / `Continue`. Two-client `/reload` after a Pope ruling was not run. **POLISH:CANDIDATE** only.
- **OpenRite stands in for STATE.** Congregation RITE send is pinned via `StartEvent` + `OpenRite`. A real congregation client lands the same snapshot via Restore / STATE. Restore is not a separate pin.
- **Congregation leftover RITE after a local ruling.** Isolated Pope leftover is gated (`GetSanctioned` only). A Sender-nil client still in `RITE` with two Runtime fighters still sends (pin 2). In production the congregation client never `DeclareVictor`s; leftover picks close when STATE leaves `RITE`.
- **A01 still NOT RUN.** `health` is nil. Mute rails stay textures. No `UnitHealth`.
- **FighterCard / Snapshot / glue were not edited.** Card persist and SNAPSHOT last-pair overlay are other lanes.
- Integrator still lists the files in the TOC and `run.lua` (already listed).

## Status

**DONE_WITH_CONCERNS.** Isolated **624 / 0**. Isolation wrap **13**. Not signed. **POLISH:CANDIDATE.**
