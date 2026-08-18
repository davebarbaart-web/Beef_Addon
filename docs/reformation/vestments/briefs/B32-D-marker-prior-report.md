# B32-D — New raid mark clears the previous subject (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** B22-C leftover (Mark* never cleared the remembered prior unit); Bible §8 (marks on the **current** candidate / fighters); Law 5 (Pope client); Law 6 (Quiet refuse); brief `docs/reformation/vestments/briefs/B32-D-marker-prior.md`. Anniversary `SetRaidTarget(target, userIndex)` — index `0` already clears (existing `Clear`). `clearPrior(keepUnits)` `applyMark`s index `0` on remembered `last.unit` / `last.unitA` / `last.unitB` that are not in the new keep-set. Does **not** call `Markers:Clear` (that overwrites `last` first). Same-unit remake does not clear-then-mark. First Mark* with no prior memory still one spy. Fail-closed gates stay (quiet / not pope / ungrouped / unit not found). `"player"` resolve stays. No `UnitIsDead`. No SecureActionButton. No combat automation. Existing `pcall(SetRaidTarget, …)` stays. Exclusive files only. No commit. Lane is not signed.

**Isolated count:** 438 passed, 0 failed (`lua tests/test_markers.lua`). **27** isolation pins under `if standalone then`.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_markers.lua` | TDD first. Source pins: `local function clearPrior`; no `UnitIsDead`. Nested `do`/`end` extracts `MarkCandidate` / `MarkFighters` bodies and requires `clearPrior` with no `:Clear(`. First MarkCandidate still one spy. Same-name remake: no extra `0` on that unit. A then B: `{raid2, 0}` then `{raid3, 1}`. MarkFighters after an outsider candidate clears the candidate. MarkCandidate after fighters clears both. In-pair keep-set remake has no extra `0`. Player prior clears `"player"` at `0`. Quiet / ungrouped refuse after a live mark do not clear. Isolation wrap stays. No new main-chunk locals (`ok` / `err` reused; extract locals are `do`/`end`). |
| `addon/ChurchOfBeef/UI/Markers.lua` | `clearPrior(keepUnits)` sweeps `last.unit` / `last.unitA` / `last.unitB` through existing `applyMark(unit, 0)`. `MarkCandidate` / `MarkFighters` call it after resolve, before the new `applyMark`. `Clear` / `Target` / `resolveUnit` / `"player"` return unchanged. |
| `docs/reformation/vestments/briefs/B32-D-marker-prior-report.md` | This file |
| `docs/reformation/vestments/briefs/B32-D-marker-prior.diff` | B32-D-only unified diff of the exclusive implementation files vs the pre-lane working tree |

Did not edit glue, Console, TOC, bootstrap, `ChurchOfBeef.lua`, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not add `UnitIsDead`. Did not add SecureActionButton. Did not add GuildPromote. Did not commit.

`git status` shows these two implementation files as untracked (Markers landed after HEAD). The brief diff is the B32-D-only delta, not a whole-file add.

## Contract

```lua
local function clearPrior(keepUnits)
  -- applyMark(unit, 0) on last.unit / last.unitA / last.unitB
  -- skipped when the token is in keepUnits or already swept
end

function Markers:MarkCandidate(name)
  -- gates unchanged; then clearPrior({ [unit] = true }); applyMark(unit, 1)
end

function Markers:MarkFighters(nameA, nameB)
  -- gates unchanged; then clearPrior({ [unitA] = true, [unitB] = true })
  -- applyMark(unitA, 2); applyMark(unitB, 3)
end
```

| Gate | MarkCandidate / MarkFighters |
|------|------------------------------|
| Quiet / missing Runtime | `false, "quiet"` — no prior clear |
| Unlisted Pope | `false, "not a registered pope"` — no prior clear |
| Ungrouped | `false, "not in a group"` — no prior clear |
| Unit not found | `false, "unit not found"` — no prior clear |
| First Mark* (no remembered unit) | one `SetRaidTarget` spy |
| Same-unit remake | new index only; no extra `0` on that token |
| New unit not in keep-set | `applyMark(prior, 0)` then the new mark |

Keep:

- Event + Pope + grouped still required
- `resolveUnit` player return (B16-D / B22-C) stays
- B16-D / B18-D / B22-C player-token pins stay
- `Clear` still `applyMark(unit, 0)` and still overwrites `last`
- Target verb unchanged
- Party scan pins stay
- `pcall(SetRaidTarget, …)` stays inside `applyMark`
- No GuildPromote / SetGuildMemberRank / StartAttack / AttackTarget / AssistUnit / UnitIsDead / SecureActionButton
- Isolation wrap stays (wow_ui_stub + Common + Runtime + Markers)
- No new main-chunk locals

### Unchanged

- Quiet / unlisted Pope / ungrouped / invalid-name / unit-not-found refuse.
- First-mark spy counts in the existing Event + Pope + grouped block.
- B16-D player Mark / MarkFighters pins.
- B18-D player Clear pin.
- B22-C grouped player Mark without `GetNumGroupMembers`.
- Both-nil group-API pin stays `"not in a group"`.
- Isolation wrap. No new main-chunk locals.

## TDD

1. Extended `tests/test_markers.lua` first (source `clearPrior` / no `UnitIsDead`; Mark* bodies call `clearPrior` and do not `:Clear(`; first mark one spy; same-name remake no extra `0`; A then B `{A, 0}` then `{B, 1}`; MarkFighters after outsider candidate; MarkCandidate after fighters; keep-set in-pair; player prior; Quiet / ungrouped refuse do not clear). Isolation wrap and B16-D / B18-D / B22-C pins untouched.
2. Red: `lua tests/test_markers.lua` — **407 passed, 27 failed** (`clearPrior helper exists`; Mark* call `clearPrior`; A then B / MarkFighters after outsider / MarkCandidate after fighters / player prior had no index `0`). First-mark / remake / refuse / existing Quiet / ungrouped / player-token pins stayed green.
3. `clearPrior` sweeps remembered tokens through `applyMark(unit, 0)`. `MarkCandidate` / `MarkFighters` call it after resolve, before the new mark. Split A-then-B onto a fresh `reset()` after the Ghost refuse pin (`refuse` overwrites `last`).
4. Green: `lua tests/test_markers.lua` — **438 passed, 0 failed**.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_markers.lua   # 438 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_markers.lua` standalone | **438 passed, 0 failed.** Lua 5.1.5. Exit 0. |

**Isolated count:** 27 pins under `if standalone then` at file load (UI, DB, Net, Officer, Archive, Recognition, Roster, Popes, Hud, Sound, DecreeBanner, RecordsBook, Minimap, Toasts, Codec, Snapshot, Console, Sender, Store, Gora, Knighting, FighterCard, Confession, Inputs, ConsoleDock, Decree, slash). Wrap unchanged.

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run.

## Self-review

- Exclusive implementation files only. Glue / Console / TOC / bootstrap were not edited.
- `clearPrior` is the only new helper. `SetRaidTarget` still lives only in `applyMark`. Mark* do not call `Markers:Clear`.
- MarkCandidate A then B spies `{raid2, 0}` then `{raid3, 1}`. Same-name remake has no extra `0`. First mark is still one spy.
- MarkFighters after an outsider candidate clears the candidate. An in-pair candidate is kept.
- `"player"` resolve stays. Player prior clears at index `0`. Quiet / ungrouped / unlisted Pope still refuse.
- Source has no `UnitIsDead` / `GuildPromote` / `StartAttack` / `CreateFrame` / `SecureActionButton`. Isolation wrap stays. No new main-chunk locals.

## Leftovers

- **No client smoke / full harness.** Memory-only. Anniversary `SetRaidTarget(unit, 0)` on a remembered prior token is not walked in-game this lane.
- **`refuse` overwrites `last`.** `GetView` still records the refuse. A successful mark, then a fail-closed remake (`unit not found` / Quiet / ungrouped), then a new Mark* cannot clear the forgotten prior — A-then-B is therefore a fresh `reset()` after the Ghost pin. Out of this lane's `refuse` / `remember` rewrite.
- **`clearPrior` ignores `applyMark(0)` failure** and still applies the new mark. If the new `applyMark` then fails, the prior token is already index `0` and `refuse` overwrites `last`.
- **Remembered tokens, not names.** If the raid roster shuffles, `last.unit` may `applyMark` index `0` on a different person.
- Full `lua tests/run.lua` was not run.
- Gate W stays OPEN. Gate V stays OPEN.

## Status

**DONE_WITH_CONCERNS.** Isolated **438 / 0**. Isolation wrap **27**. Not signed. Do not claim Gate W, Gate V, or POLISH:PASS.
