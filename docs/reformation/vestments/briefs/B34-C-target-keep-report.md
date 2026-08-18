# B34-C — successful Target keeps last mark units (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** B33-C leftover (successful `Target` `remember({ verb, ok, name })` replaced `last` wholesale and wiped the prior mark token); Bible §8 (marks on the **current** candidate / fighters); Law 5 (Pope client); Law 6 (Quiet refuse); brief `docs/reformation/vestments/briefs/B34-C-target-keep.md`. Anniversary `TargetUnit([name], [exactMatch])`. `keepLastUnits` copies omitted `last.unit` / `last.unitA` / `last.unitB` (and their indices) via `== nil`. `refuse` and successful `Target` both call it, then `remember`. MarkCandidate / MarkFighters / Clear success still replace last. First Quiet refuse stays empty units. Failed Target still keeps (already refuse). Does **not** call `Markers:Clear` from Target. No `UnitIsDead`. No SecureActionButton. No combat automation. Exclusive files only. No commit. Lane is not signed.

**Isolated count:** 543 passed, 0 failed (`lua tests/test_markers.lua`). **27** isolation pins under `if standalone then`.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_markers.lua` | TDD first. After the B33-C block. Nested `do`/`end` extracts `Markers:Target` and requires `keepLastUnits` / `remember(keepLastUnits` with no `:Clear(` / `clearPrior`. B33-C source extract widens to `keepLastUnits` so the six `fields.* = last.*` pins still see the helper. Runtime StartEvent + Pope + `armRaid`: MarkCandidate A, successful Target of Tendermage, `GetView` still has A's `unit` / `index`; then MarkCandidate B spies `{raid2, 0}` then `{raid3, 1}`. MarkFighters pair + Target keeps `unitA` / `unitB`. Failed Target after A still keeps (refuse). Successful Mark* / Clear still replace (B33-C pins stay). Isolation wrap stays. No new main-chunk locals (`ok` / `err` / `view` reused; extract / fail-Target locals are `do`/`end`). |
| `addon/ChurchOfBeef/UI/Markers.lua` | Extracted `keepLastUnits` (same `== nil` copy as B33-C `refuse`). `refuse` is `remember(keepLastUnits(fields))`. Successful `Target` is `remember(keepLastUnits({ verb = "Target", ok = true, name = trimmed }))`. Mark* / `Clear` / `clearPrior` / `resolveUnit` / `"player"` return unchanged. |
| `docs/reformation/vestments/briefs/B34-C-target-keep-report.md` | This file |
| `docs/reformation/vestments/briefs/B34-C-target-keep.diff` | B34-C-only unified diff of the exclusive implementation files vs the pre-lane (B33-C) working tree |

Did not edit glue, Hud, Console, TOC, bootstrap, `ChurchOfBeef.lua`, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not add `UnitIsDead`. Did not add SecureActionButton. Did not add GuildPromote. Did not call `Markers:Clear` from Target. Did not commit.

`git status` shows these two implementation files as already dirty vs HEAD (Markers landed after HEAD). The brief diff is the B34-C-only delta, not a whole-file add.

## Contract

```lua
local function keepLastUnits(fields)
  -- fields.unit / unitA / unitB / index / indexA / indexB
  -- copied from last when the caller omitted them (== nil)
end

function Markers:Target(name)
  -- gates unchanged; success is remember(keepLastUnits({ verb, ok, name }))
end
```

| Path | Memory |
|------|--------|
| First Quiet / not-pope refuse (no prior last) | empty units |
| MarkCandidate A, then successful Target of another name | `GetView().unit` / `index` stay A's token |
| Then MarkCandidate B | `clearPrior` spies `{A, 0}` then `{B, 1}` |
| MarkFighters pair, then Target | `GetView()` keeps `unitA` / `unitB` / indices |
| Failed Target after A | keeps A's token (refuse) |
| Successful Mark* | `remember` replaces last (no keep helper) |
| Successful Clear | records Clear (`verb`, unit, index `0`) |

Keep:

- Event + Pope still required for Target; group is not required
- `clearPrior` stays; Mark* / Target still do not call `Markers:Clear`
- `resolveUnit` player return (B16-D / B22-C) stays
- B16-D / B18-D / B22-C player-token pins stay
- B32-D clearPrior / first-mark / remake / A-then-B / player-prior pins stay
- B33-C refuse keep / Ghost miss / fighters keep / successful Clear pins stay
- Target still `pcall(TargetUnit, trimmed, true)`
- No GuildPromote / SetGuildMemberRank / StartAttack / AttackTarget / AssistUnit / UnitIsDead / SecureActionButton
- Isolation wrap stays (wow_ui_stub + Common + Runtime + Markers)
- No new main-chunk locals

### Unchanged

- Quiet / unlisted Pope / invalid-name refuse (still fail-closed; no `TargetUnit` on those gates).
- First-mark spy counts in the existing Event + Pope + grouped block.
- B16-D player Mark / MarkFighters pins.
- B18-D player Clear pin.
- B22-C grouped player Mark without `GetNumGroupMembers`.
- B32-D `clearPrior` keep-set / same-unit remake / outsider pair / player prior.
- B33-C Ghost miss keep / B after Ghost `{A, 0}` `{B, 1}` / fighters Ghost keep / successful Clear.
- Both-nil group-API pin stays `"not in a group"`.
- Isolation wrap. No new main-chunk locals.

## TDD

1. Extended `tests/test_markers.lua` first (source Target success copies last units when omitted via `keepLastUnits`; no `:Clear(` / `clearPrior`; MarkCandidate A then successful Target of another name keeps A's token; MarkCandidate B spies `{A, 0}` then `{B, 1}`; Target after fighters keeps `unitA` / `unitB`; failed Target after A still keeps). Isolation wrap and B16-D / B18-D / B22-C / B32-D / B33-C runtime pins untouched. B33-C source extract widened to include the helper.
2. Red: `lua tests/test_markers.lua` — **530 passed, 13 failed** (`Target success path copies last units when omitted`; `Target success remembers kept units`; successful Target keeps A's unit / index; B after Target spy count and `{raid2, 0}` / `{raid3, 1}`; Target after fighters keeps pair tokens). Failed Target keep, Target does not `:Clear(` / `clearPrior`, first Quiet empty-unit pins, B33-C Ghost / Clear / replace-last, existing clearPrior / player-token pins stayed green.
3. Extracted `keepLastUnits` (`== nil` copy). `refuse` and successful `Target` call it, then `remember`. Mark* / Clear success still go through `remember` without that copy.
4. Green: `lua tests/test_markers.lua` — **543 passed, 0 failed**.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_markers.lua   # 543 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_markers.lua` standalone | **543 passed, 0 failed.** Lua 5.1.5. Exit 0. |

**Isolated count:** 27 pins under `if standalone then` at file load (UI, DB, Net, Officer, Archive, Recognition, Roster, Popes, Hud, Sound, DecreeBanner, RecordsBook, Minimap, Toasts, Codec, Snapshot, Console, Sender, Store, Gora, Knighting, FighterCard, Confession, Inputs, ConsoleDock, Decree, slash). Wrap unchanged.

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run.

## Self-review

- Exclusive implementation files only. Glue / Hud / Console / TOC / bootstrap were not edited.
- `keepLastUnits` is the only new helper. `refuse` now calls it. Successful `Target` now calls it. `clearPrior` stays. `SetRaidTarget` still lives only in `applyMark`. Target / Mark* / `refuse` do not call `Markers:Clear`.
- MarkCandidate A then Target Tendermage: `GetView().unit` stays `raid2`. MarkCandidate B spies `{raid2, 0}` then `{raid3, 1}`. Successful B replaces last.
- MarkFighters then Target keeps `unitA` / `unitB`. Failed Target after A still keeps. First Quiet refuse still has no unit. Successful Clear still records Clear.
- `"player"` resolve stays. Quiet / ungrouped / unlisted Pope still refuse.
- Source has no `UnitIsDead` / `GuildPromote` / `StartAttack` / `CreateFrame` / `SecureActionButton`. Isolation wrap stays. No new main-chunk locals.

## Leftovers

- **No client smoke / full harness.** Memory-only. Anniversary `TargetUnit(name, true)` after a live mark, and the later `SetRaidTarget(unit, 0)` on the remembered prior token, are not walked in-game this lane.
- **`GetView` name vs unit.** Successful Target records `name = "Tendermage"` while `unit` stays the prior token. `clearPrior` reads tokens, not names.
- **`nameA` / `nameB` drop on a cross-verb Target.** Brief asked unit / index keep only. After fighters, Target keeps `unitA` / `unitB` and drops the fighter names.
- **`clearPrior` ignores `applyMark(0)` failure** and still applies the new mark. If the new `applyMark` then fails, the caller-supplied unit/index win and the in-world prior is already index `0`.
- **Remembered tokens, not names.** If the raid roster shuffles, `last.unit` may `applyMark` index `0` on a different person.
- **Source pins are substrings.** `keepLastUnits` / `remember(keepLastUnits` and no `:Clear(` would pass on a comment inside the extract. Live call is real (`== nil` then `remember`).
- Full `lua tests/run.lua` was not run.
- Gate W stays OPEN. Gate V stays OPEN.

## Status

**DONE_WITH_CONCERNS.** Isolated **543 / 0**. Isolation wrap **27**. Not signed. Do not claim Gate W, Gate V, or POLISH:PASS.
