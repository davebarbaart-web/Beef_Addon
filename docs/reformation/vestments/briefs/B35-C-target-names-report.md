# B35-C — keepLastUnits also keeps fighter names (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** B34-C leftover (`nameA` / `nameB` drop on a cross-verb Target); Bible §8 (marks on the **current** candidate / fighters); Law 5 (Pope client); Law 6 (Quiet refuse); brief `docs/reformation/vestments/briefs/B35-C-target-names.md`. Anniversary `TargetUnit([name], [exactMatch])`. B34-C `keepLastUnits` copies omitted units / indices via `== nil`. Successful Target still `remember(keepLastUnits({ verb, ok, name = trimmed }))`, so `remember` niled omitted `nameA` / `nameB`. After MarkFighters, Target kept units and dropped fighter names.

`keepLastUnits` also copies omitted `nameA` / `nameB` (`== nil`). Target success still sets `name = trimmed` (who was targeted). Does **not** merge name vs unit. Mark* / Clear success still replace last. First Quiet refuse stays empty names. Does **not** call `Markers:Clear` from Target. No `UnitIsDead`. Exclusive files only. No commit. Lane is not signed.

**Isolated count:** 563 passed, 0 failed (`lua tests/test_markers.lua`). **27** isolation pins under `if standalone then`.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_markers.lua` | TDD first. After the B34-C block. Nested `do`/`end` extracts `keepLastUnits` and requires `fields.nameA = last.nameA` / `fields.nameB = last.nameB`. Runtime StartEvent + Pope + `armRaid`: MarkFighters pair + Target Beefina, `GetView` keeps `nameA` / `nameB` and `unitA` / `unitB`; `name` is the targeted name. MarkCandidate A + Target, `name` is the Target; prior `unit` stays. Isolation wrap stays. No new main-chunk locals (`ok` / `err` / `view` reused; extract locals are `do`/`end`). |
| `addon/ChurchOfBeef/UI/Markers.lua` | `keepLastUnits` also copies omitted `nameA` / `nameB` (`== nil`). Target success still `remember(keepLastUnits({ verb = "Target", ok = true, name = trimmed }))`. Mark* / `Clear` / `clearPrior` / `resolveUnit` / `"player"` return unchanged. |
| `docs/reformation/vestments/briefs/B35-C-target-names-report.md` | This file |
| `docs/reformation/vestments/briefs/B35-C-target-names.diff` | B35-C-only unified diff of the exclusive implementation files vs the pre-lane (B34-C) working tree |

Did not edit glue, Hud, Console, TOC, bootstrap, `ChurchOfBeef.lua`, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not add `UnitIsDead`. Did not add SecureActionButton. Did not call `Markers:Clear` from Target. Did not commit.

`git status` shows these two implementation files as already dirty vs HEAD (Markers landed after HEAD). The brief diff is the B35-C-only delta, not a whole-file add.

## Contract

```lua
local function keepLastUnits(fields)
  -- fields.unit / unitA / unitB / index / indexA / indexB
  -- fields.nameA / nameB
  -- copied from last when the caller omitted them (== nil)
end

function Markers:Target(name)
  -- gates unchanged; success is remember(keepLastUnits({ verb, ok, name }))
end
```

| Path | Memory |
|------|--------|
| First Quiet / not-pope refuse (no prior last) | empty names |
| MarkFighters pair, then Target | `GetView()` keeps `nameA` / `nameB` and `unitA` / `unitB`; `name` is the targeted name |
| MarkCandidate A, then Target | `name` is the Target; prior `unit` stays |
| Successful Mark* | `remember` replaces last (no keep helper) |
| Successful Clear | records Clear (`verb`, unit, index `0`) |

Keep:

- Event + Pope still required for Target; group is not required
- `clearPrior` stays; Mark* / Target still do not call `Markers:Clear`
- `resolveUnit` player return (B16-D / B22-C) stays
- B16-D / B18-D / B22-C player-token pins stay
- B32-D clearPrior / first-mark / remake / A-then-B / player-prior pins stay
- B33-C refuse keep / Ghost miss / fighters keep / successful Clear pins stay
- B34-C Target unit keep / B after Target `{A, 0}` `{B, 1}` / fighters unit keep / failed Target keep stay
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
- B34-C Target keeps A's unit / index; fighters Target keeps `unitA` / `unitB`; failed Target keeps.
- Both-nil group-API pin stays `"not in a group"`.
- Isolation wrap. No new main-chunk locals.

## TDD

1. Extended `tests/test_markers.lua` first (source `keepLastUnits` copies `last.nameA` / `last.nameB` when omitted; MarkFighters pair + Target keeps `nameA` / `nameB` and `unitA` / `unitB` with `name` the targeted name; MarkCandidate A + Target: `name` is the Target, prior `unit` stays). Isolation wrap and B16-D / B18-D / B22-C / B32-D / B33-C / B34-C runtime pins untouched.
2. Red: `lua tests/test_markers.lua` — **559 passed, 4 failed** (`keepLastUnits copies last.nameA when omitted`; `keepLastUnits copies last.nameB when omitted`; Target after fighters keeps `nameA` / `nameB`). MarkCandidate A + Target name / prior-unit pins, B34-C unit keep, first Quiet empty-unit pins, and existing clearPrior / player-token pins stayed green.
3. `keepLastUnits` also copies omitted `nameA` / `nameB` (`== nil`). Target success still sets `name = trimmed`. Mark* / Clear success still go through `remember` without that copy.
4. Green: `lua tests/test_markers.lua` — **563 passed, 0 failed**.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_markers.lua   # 563 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_markers.lua` standalone | **563 passed, 0 failed.** Lua 5.1.5. Exit 0. |

**Isolated count:** 27 pins under `if standalone then` at file load (UI, DB, Net, Officer, Archive, Recognition, Roster, Popes, Hud, Sound, DecreeBanner, RecordsBook, Minimap, Toasts, Codec, Snapshot, Console, Sender, Store, Gora, Knighting, FighterCard, Confession, Inputs, ConsoleDock, Decree, slash). Wrap unchanged.

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run.

## Self-review

- Exclusive implementation files only. Glue / Hud / Console / TOC / bootstrap were not edited.
- `keepLastUnits` is the only helper touched. `refuse` and successful `Target` still call it. `clearPrior` stays. `SetRaidTarget` still lives only in `applyMark`. Target / Mark* / `refuse` do not call `Markers:Clear`.
- MarkFighters then Target Beefina: `GetView()` keeps `nameA` / `nameB` and `unitA` / `unitB`; `name` is `"Beefina"`.
- MarkCandidate A then Target Tendermage: `name` is `"Tendermage"`; `unit` stays `raid2`.
- First Quiet refuse still has no unit (and no prior names). Successful Mark* / Clear still replace last.
- `"player"` resolve stays. Quiet / ungrouped / unlisted Pope still refuse.
- Source has no `UnitIsDead` / `GuildPromote` / `StartAttack` / `CreateFrame` / `SecureActionButton`. Isolation wrap stays. No new main-chunk locals.

## Leftovers

- **No client smoke / full harness.** Memory-only. Anniversary `TargetUnit(name, true)` after a live fighter pair, with `GetView` still showing those names, is not walked in-game this lane.
- **`GetView` name vs unit stays split.** Successful Target records `name` as who was targeted while `unit` / `unitA` / `unitB` stay prior tokens. Intentional — this lane does not merge name vs unit. `clearPrior` still reads tokens, not names.
- **`last.name` (singular) is still replaced.** Only omitted `nameA` / `nameB` are copied. After MarkCandidate A → Target, the candidate's `name` is the Target string; A's name is not kept on `name`.
- **Failed Target after fighters is not newly pinned for names.** Refuse already goes through `keepLastUnits`, so `nameA` / `nameB` would keep; this lane pins successful Target only.
- **First Quiet empty names are not a new assert.** Existing first Quiet pins cover empty units; names stay empty because `last` is empty.
- **`clearPrior` ignores `applyMark(0)` failure** and still applies the new mark. If the new `applyMark` then fails, the caller-supplied unit/index win and the in-world prior is already index `0`.
- **Remembered tokens, not names.** If the raid roster shuffles, `last.unit` may `applyMark` index `0` on a different person.
- **Source pins are substrings.** `fields.nameA = last.nameA` would pass on a comment inside the extract. Live call is real (`== nil` then `remember`).
- Full `lua tests/run.lua` was not run.
- Gate W stays OPEN. Gate V stays OPEN.

## Status

**DONE_WITH_CONCERNS.** Isolated **563 / 0**. Isolation wrap **27**. Not signed. Do not claim Gate W, Gate V, or POLISH:PASS.
