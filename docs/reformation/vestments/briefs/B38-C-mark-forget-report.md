# B38-C — Quiet Forget sweeps leftover raid marks (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Bible §8 current-subject marks; Law 5 (Pope client); Law 6 (Quiet Clear refuse stays — Forget is the Quiet leftover sweep, not a Clear exception); brief `docs/reformation/vestments/briefs/B38-C-mark-forget.md`. Anniversary `SetRaidTarget(target, userIndex)` — index `0` clears. `Clear` still refuses Quiet. `clearPrior` still only runs on new Mark\*. After End, leftover `last.unit` / `unitA` / `unitB` stay marked until `Forget`.

`Markers:Forget()` works in Quiet. Pope-gated (same writer as Mark\*). `applyMark(unit, 0)` on leftover `last.unit` / `unitA` / `unitB`, then remember empty (`verb = "Forget"`, no units). Does **not** call `Markers:Clear`. Clear Quiet refuse stays. Missing `SetRaidTarget` fail-closed when leftovers exist. Mark\* / Clear success still replace. No `UnitIsDead`. Exclusive files only. No commit. Lane is not signed.

**Isolated count:** 634 passed, 0 failed (`lua tests/test_markers.lua`). **27** isolation pins under `if standalone then`.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_markers.lua` | TDD first. After the B35-C block. Surface pin `type(Markers.Forget)`. Source pin `function Markers:Forget`. Nested `do`/`end` extracts Forget and requires `applyMark` with no `:Clear(`. MarkCandidate A, EndEvent, Forget: spies `SetRaidTarget(A, 0)`, GetView units nil; Quiet Clear still refuses. MarkFighters pair, Forget: spies clear A and B. Quiet Forget without prior last is true and does not SetRaidTarget. Unlisted Pope refuses (empty last, and after leftover — no sweep). Missing SetRaidTarget after leftover EndEvent is fail-closed and keeps the unit. Isolation wrap stays. No new main-chunk locals (`ok` / `err` / `view` reused; extract / missing-API locals are `do`/`end`). |
| `addon/ChurchOfBeef/UI/Markers.lua` | `Markers:Forget()` — no Quiet / group gate. Pope-gated. Sweeps leftover `last.unit` / `unitA` / `unitB` through `applyMark(unit, 0)` (deduped). Leftover + failed apply refuses (`nil` err) via `keepLastUnits`. Success `remember({ verb = "Forget", ok = true })` (empty units). Does not call `Markers:Clear`. `Clear` Quiet refuse unchanged. |
| `docs/reformation/vestments/briefs/B38-C-mark-forget-report.md` | This file |
| `docs/reformation/vestments/briefs/B38-C-mark-forget.diff` | B38-C-only unified diff of the exclusive implementation files vs the pre-lane (B35-C) working tree |

Did not edit glue (`ChurchOfBeef.lua` — integrator owns `afterEndEvent`), Hud, Console, TOC, bootstrap, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not add `UnitIsDead`. Did not add SecureActionButton. Did not call `Markers:Clear` from Forget. Did not change Clear Quiet refuse. Did not commit.

`git status` shows these two implementation files as already dirty vs HEAD (Markers landed after HEAD). The brief diff is the B38-C-only delta, not a whole-file add.

## Contract

```lua
function Markers:Forget()
  -- Pope-gated (same isLocalPope as Mark*)
  -- no eventLive / no isGrouped
  -- applyMark(unit, 0) on leftover last.unit / unitA / unitB
  -- leftover + applyMark fail → refuse("Forget", nil) (keeps last)
  -- success → remember({ verb = "Forget", ok = true })  -- no units
end
```

| Path | Memory / world |
|------|----------------|
| Quiet Forget, no prior last | `true`. No `SetRaidTarget`. View `verb = "Forget"`, units nil |
| MarkCandidate A, EndEvent, Forget | spies `{A, 0}`. View units nil |
| MarkFighters pair, Forget | spies `{A, 0}` then `{B, 0}`. View units nil |
| Unlisted Pope | `false, "not a registered pope"`. No `SetRaidTarget`. Leftover units kept |
| Leftover + missing `SetRaidTarget` | `false` (no throw). Leftover unit kept |
| Quiet Clear (unchanged) | still `false, "quiet"` |

Keep:

- `Clear` still refuses Quiet (`"quiet"`). Forget is a new verb, not a Clear exception
- Event + Pope + grouped still required for Mark\* / Clear / Target (Target still ungrouped-ok)
- `clearPrior` stays; Mark\* / Target / Forget still do not call `Markers:Clear`
- `resolveUnit` player return (B16-D / B22-C) stays
- B16-D / B18-D / B22-C player-token pins stay
- B32-D clearPrior / first-mark / remake / A-then-B / player-prior pins stay
- B33-C refuse keep / Ghost miss / fighters keep / successful Clear pins stay
- B34-C Target unit keep / B35-C nameA / nameB keep stay
- `pcall(SetRaidTarget, …)` stays inside `applyMark`
- No GuildPromote / SetGuildMemberRank / StartAttack / AttackTarget / AssistUnit / UnitIsDead / SecureActionButton
- Isolation wrap stays (wow_ui_stub + Common + Runtime + Markers)
- No new main-chunk locals

### Unchanged

- Quiet / unlisted Pope / ungrouped / invalid-name / unit-not-found refuse on Mark\* / Clear / Target.
- First-mark spy counts in the existing Event + Pope + grouped block.
- B16-D player Mark / MarkFighters pins.
- B18-D player Clear pin.
- B22-C grouped player Mark without `GetNumGroupMembers`.
- B32-D `clearPrior` keep-set / same-unit remake / outsider pair / player prior.
- B33-C Ghost miss keep / B after Ghost `{A, 0}` `{B, 1}` / fighters Ghost keep / successful Clear.
- B34-C Target keeps A's unit / index; B35-C Target keeps `nameA` / `nameB`.
- Both-nil group-API pin stays `"not in a group"`.
- Isolation wrap. No new main-chunk locals.

## TDD

1. Extended `tests/test_markers.lua` first (surface `Forget`; source `function Markers:Forget`; Forget body `applyMark` and no `:Clear(`; MarkCandidate A + EndEvent + Forget spies `{A, 0}` and nil units; Quiet Clear still refuses; MarkFighters pair + Forget spies `{A, 0}` `{B, 0}`; empty Quiet Forget is true with no `SetRaidTarget`; unlisted Pope refuses; leftover + missing `SetRaidTarget` fail-closed). Isolation wrap and B16-D / B18-D / B22-C / B32-D / B33-C / B34-C / B35-C runtime pins untouched.
2. Red: `lua tests/test_markers.lua` — **3 failed** then threw (`Forget sweeps leftover marks expected function got nil`; `Forget verb exists`; `Forget and GetView are findable`; `attempt to call method 'Forget' (a nil value)` at the first live call). Runtime Forget pins after that did not run. Existing pins before the B38-C block printed no FAILs.
3. `Markers:Forget()` Pope-gates, sweeps leftover tokens through `applyMark(unit, 0)`, remember empty on success. Does not call `Markers:Clear`. Missing API with leftover refuses and keeps last. `Clear` Quiet refuse untouched.
4. Green: `lua tests/test_markers.lua` — **634 passed, 0 failed**.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_markers.lua   # 634 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_markers.lua` standalone | **634 passed, 0 failed.** Lua 5.1.5. Exit 0. |

**Isolated count:** 27 pins under `if standalone then` at file load (UI, DB, Net, Officer, Archive, Recognition, Roster, Popes, Hud, Sound, DecreeBanner, RecordsBook, Minimap, Toasts, Codec, Snapshot, Console, Sender, Store, Gora, Knighting, FighterCard, Confession, Inputs, ConsoleDock, Decree, slash). Wrap unchanged.

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run. Glue `afterEndEvent` → `Markers:Forget` is B38-INT.

## Self-review

- Exclusive implementation files only. Glue / Hud / Console / TOC / bootstrap were not edited.
- Forget is the only new public verb. `Clear` still refuses Quiet. `applyMark` still owns `SetRaidTarget`. Forget / Mark\* / Target / `refuse` do not call `Markers:Clear`.
- MarkCandidate A, EndEvent, Forget: spies `{raid2, 0}`; GetView units nil.
- MarkFighters pair, Forget: spies `{raid2, 0}` then `{raid3, 0}`.
- Quiet Forget without prior last is true and does not SetRaidTarget.
- Unlisted Pope refuses. Leftover + missing `SetRaidTarget` is false and keeps the unit.
- `"player"` resolve stays. Quiet / ungrouped / unlisted Pope still refuse on Mark\* / Clear.
- Source has no `UnitIsDead` / `GuildPromote` / `StartAttack` / `CreateFrame` / `SecureActionButton`. Isolation wrap stays. No new main-chunk locals.

## Leftovers

- **No client smoke / full harness.** Memory-only. Anniversary leftover marks after End, then `Forget` on the Pope client, is not walked in-game this lane. Integrator still owns `afterEndEvent` → `Markers:Forget` (B38-INT).
- **Remembered tokens, not names.** Forget does not `resolveUnit`. If the raid roster shuffles, `last.unit` may `applyMark` index `0` on a different person (same as `clearPrior`).
- **Partial world sweep on apply fail.** If one leftover `applyMark(0)` succeeds and a later one fails, some marks are already `0` in the world; refuse keeps last so a retry can sweep again.
- **Empty Quiet Forget does not need `SetRaidTarget`.** No leftover → no call. Missing API fail-closed is only when leftovers exist.
- **Player-token leftover Forget is not newly pinned.** A `"player"` `last.unit` would `applyMark("player", 0)` the same way; this lane pins raid2 / raid3 leftovers.
- **Forget view still `mode = "Event"`.** `remember` always writes Event. Markers.MODE stays Event. Quiet capability does not redeclare the module Quiet.
- **MarkFighters Forget is pinned in Event.** Brief did not require EndEvent on that case. Quiet leftover sweep is the MarkCandidate A + EndEvent pin.
- **Extract guard is TDD leftover.** `if forgetStart and viewStart then` stops `src:sub(nil, …)` from throwing when the verb is missing. Live call is real.
- **Source pins are substrings.** `applyMark` inside the Forget extract would pass on a comment. Live sweep is real.
- Full `lua tests/run.lua` was not run.
- Gate W stays OPEN. Gate V stays OPEN.

## Status

**DONE_WITH_CONCERNS.** Isolated **634 / 0**. Isolation wrap **27**. Not signed. Do not claim Gate W, Gate V, or POLISH:PASS.
