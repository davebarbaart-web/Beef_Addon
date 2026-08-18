# B33-C — Gate refuse keeps remembered mark units (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** B32-D leftover (`refuse` → `remember` replaces `last`, so a Ghost miss after Chuckroast dropped `last.unit`); Bible §8 (marks on the **current** candidate / fighters); Law 5 (Pope client); Law 6 (Quiet refuse); brief `docs/reformation/vestments/briefs/B33-C-markers-keep.md`. `refuse` copies `last.unit` / `last.unitA` / `last.unitB` (and their indices) onto `fields` when the caller omitted them, then `remember`. Successful Mark* still replace last. Successful `Clear` still records Clear. First-mark Quiet refuse stays empty units. Does **not** call `Markers:Clear`. `clearPrior` stays. No `UnitIsDead`. No SecureActionButton. No combat automation. Exclusive files only. No commit. Lane is not signed.

**Isolated count:** 491 passed, 0 failed (`lua tests/test_markers.lua`). **27** isolation pins under `if standalone then`.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_markers.lua` | TDD first. After the B32-D block. Nested `do`/`end` extracts `refuse` and requires `fields.unit = last.unit` / `unitA` / `unitB` / `index` / `indexA` / `indexB` with no `:Clear(`. First Quiet refuse still has no unit / unitA / unitB. MarkCandidate A then Ghost: `GetView().unit` stays A's token. MarkCandidate B then spies `{raid2, 0}` then `{raid3, 1}`. Ghost after MarkFighters keeps `unitA` / `unitB`. Successful Clear still records Clear. Isolation wrap stays. No new main-chunk locals (`ok` / `err` / `view` reused; extract locals are `do`/`end`). |
| `addon/ChurchOfBeef/UI/Markers.lua` | `refuse` copies omitted `unit` / `unitA` / `unitB` / `index` / `indexA` / `indexB` from `last` via `== nil` (index `0` stays). Then `remember`. `clearPrior` / Mark* / `Clear` / `Target` / `resolveUnit` / `"player"` return unchanged. |
| `docs/reformation/vestments/briefs/B33-C-markers-keep-report.md` | This file |
| `docs/reformation/vestments/briefs/B33-C-markers-keep.diff` | B33-C-only unified diff of the exclusive implementation files vs the pre-lane working tree |

Did not edit glue, Console, TOC, bootstrap, `ChurchOfBeef.lua`, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not add `UnitIsDead`. Did not add SecureActionButton. Did not add GuildPromote. Did not call `Markers:Clear` from `refuse`. Did not commit.

`git status` shows these two implementation files as untracked (Markers landed after HEAD). The brief diff is the B33-C-only delta, not a whole-file add.

## Contract

```lua
local function refuse(verb, err, fields)
  -- fields.unit / unitA / unitB / index / indexA / indexB
  -- copied from last when the caller omitted them (== nil)
  -- then remember(fields)
end
```

| Path | Memory |
|------|--------|
| First Quiet / not-pope / ungrouped refuse (no prior last) | empty units |
| MarkCandidate A, then Ghost (`unit not found`) | `GetView().unit` stays A's token |
| Then MarkCandidate B | `clearPrior` spies `{A, 0}` then `{B, 1}` |
| MarkFighters pair, then Ghost | `GetView()` keeps `unitA` / `unitB` / indices |
| Successful Mark* | `remember` replaces last |
| Successful Clear | records Clear (`verb`, unit, index `0`) |
| Caller passed unit / index (applyMark fail) | those fields win; last is not copied over them |

Keep:

- Event + Pope + grouped still required
- `clearPrior` stays; Mark* still do not call `Markers:Clear`
- `resolveUnit` player return (B16-D / B22-C) stays
- B16-D / B18-D / B22-C player-token pins stay
- B32-D clearPrior / first-mark / remake / A-then-B / player-prior pins stay
- `Clear` still `applyMark(unit, 0)` and still overwrites `last` on success
- Target verb unchanged
- Party scan pins stay
- `pcall(SetRaidTarget, …)` stays inside `applyMark`
- No GuildPromote / SetGuildMemberRank / StartAttack / AttackTarget / AssistUnit / UnitIsDead / SecureActionButton
- Isolation wrap stays (wow_ui_stub + Common + Runtime + Markers)
- No new main-chunk locals

### Unchanged

- Quiet / unlisted Pope / ungrouped / invalid-name / unit-not-found refuse (still fail-closed; no `SetRaidTarget` on those gates).
- First-mark spy counts in the existing Event + Pope + grouped block.
- B16-D player Mark / MarkFighters pins.
- B18-D player Clear pin.
- B22-C grouped player Mark without `GetNumGroupMembers`.
- B32-D `clearPrior` keep-set / same-unit remake / outsider pair / player prior.
- Both-nil group-API pin stays `"not in a group"`.
- Isolation wrap. No new main-chunk locals.

## TDD

1. Extended `tests/test_markers.lua` first (source `refuse` copies last units / indices and does not `:Clear(`; first Quiet refuse empty units; MarkCandidate A then Ghost keeps A's token; MarkCandidate B spies `{A, 0}` then `{B, 1}`; Ghost after fighters keeps `unitA` / `unitB`; successful Clear still records Clear). Isolation wrap and B16-D / B18-D / B22-C / B32-D pins untouched.
2. Red: `lua tests/test_markers.lua` — **474 passed, 17 failed** (`refuse copies last.unit` / `unitA` / `unitB` / indices; Ghost miss keeps A's unit / index; B after Ghost spy count and `{raid2, 0}` / `{raid3, 1}`; Ghost after fighters keeps pair tokens). First Quiet empty-unit pins, `refuse` does not `:Clear(`, successful B replace-last, successful Clear, existing clearPrior / player-token pins stayed green.
3. `refuse` copies omitted unit / unitA / unitB / index / indexA / indexB from `last` (`== nil`), then `remember`. Successful Mark* / Clear still go through `remember` and replace last.
4. Green: `lua tests/test_markers.lua` — **491 passed, 0 failed**.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_markers.lua   # 491 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_markers.lua` standalone | **491 passed, 0 failed.** Lua 5.1.5. Exit 0. |

**Isolated count:** 27 pins under `if standalone then` at file load (UI, DB, Net, Officer, Archive, Recognition, Roster, Popes, Hud, Sound, DecreeBanner, RecordsBook, Minimap, Toasts, Codec, Snapshot, Console, Sender, Store, Gora, Knighting, FighterCard, Confession, Inputs, ConsoleDock, Decree, slash). Wrap unchanged.

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run.

## Self-review

- Exclusive implementation files only. Glue / Console / TOC / bootstrap were not edited.
- `refuse` is the only changed helper. `clearPrior` stays. `SetRaidTarget` still lives only in `applyMark`. Mark* / `refuse` do not call `Markers:Clear`.
- MarkCandidate A then Ghost: `GetView().unit` stays `raid2`. MarkCandidate B spies `{raid2, 0}` then `{raid3, 1}`. Successful B replaces last.
- First Quiet refuse still has no unit. Successful Clear still records Clear.
- `"player"` resolve stays. Quiet / ungrouped / unlisted Pope still refuse.
- Source has no `UnitIsDead` / `GuildPromote` / `StartAttack` / `CreateFrame` / `SecureActionButton`. Isolation wrap stays. No new main-chunk locals.

## Leftovers

- **No client smoke / full harness.** Memory-only. Anniversary `SetRaidTarget(unit, 0)` on a remembered prior token after a Ghost miss is not walked in-game this lane.
- **`GetView` name vs unit.** Ghost refuse records `name = "Ghost"` while `unit` stays the prior token. `clearPrior` reads tokens, not names.
- **`clearPrior` ignores `applyMark(0)` failure** and still applies the new mark. If the new `applyMark` then fails, the caller-supplied unit/index win and the in-world prior is already index `0`.
- **Remembered tokens, not names.** If the raid roster shuffles, `last.unit` may `applyMark` index `0` on a different person.
- Full `lua tests/run.lua` was not run.
- Gate W stays OPEN. Gate V stays OPEN.

## Status

**DONE_WITH_CONCERNS.** Isolated **491 / 0**. Isolation wrap **27**. Not signed. Do not claim Gate W, Gate V, or POLISH:PASS.
