# B12-A — ASSEMBLY may carry subjects (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Bible §20 broadcast active subjects; brief `docs/reformation/vestments/briefs/B12-A-runtime-assembly.md`.

`parseEvent` now treats ASSEMBLY as a live event: candidate and/or fighters may Restore. QUIET still refuses any subjects. `riteType` stays forbidden on ASSEMBLY and QUIET. `StartEvent` / `Continue` / `EndEvent` still write `emptySubjects()`. No auto-advance. No SV. No frames. Exclusive files only. No commit. Lane is not signed.

**Isolated count:** 688 passed, 0 failed (`lua tests/test_runtime.lua`).

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_runtime.lua` | TDD first. New Restore pins: ASSEMBLY + `{ fighters = { 8, 9 } }` succeeds and Snapshot keeps both ids; ASSEMBLY + `{ candidate = 7 }` succeeds; QUIET + fighters is `invalid subjects`; ASSEMBLY + `riteType` still refused (existing empty-subjects pin kept; fighters-plus-riteType pin added). StartEvent / Continue empty-subject pins unchanged. |
| `addon/ChurchOfBeef/Core/Runtime.lua` | `parseEvent` refuses nonempty subjects only on QUIET. ASSEMBLY no longer shares that refuse. |
| `docs/reformation/vestments/briefs/B12-A-runtime-assembly-report.md` | This file |
| `docs/reformation/vestments/briefs/B12-A-runtime-assembly.diff` | B12-A-only unified diff of the exclusive implementation files |

Did not edit Snapshot, Codec, Gora, glue, TOC, `ChurchOfBeef.lua`, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not commit.

## Contract

```lua
-- QUIET: subjects must stay empty (candidate nil, fighters nil)
-- ASSEMBLY: riteType still nil; candidate and/or fighters MAY Restore
-- RITE / CONSEQUENCE: unchanged (riteType required)
-- StartEvent / Continue / EndEvent still write emptySubjects()
```

- Restore ASSEMBLY + two fighters, no riteType → success; Snapshot keeps both ids.
- Restore ASSEMBLY + candidate, no riteType → success.
- Restore QUIET + fighters → `nil, "invalid subjects"`.
- Restore ASSEMBLY + riteType → refused (empty subjects or fighters present).
- StartEvent / Continue / EndEvent still clear subjects. OpenRite is still a Pope verb.

## TDD

1. Extended `tests/test_runtime.lua` first (four brief pins; existing StartEvent / Continue empty-subject pins left in place).
2. Red: `lua tests/test_runtime.lua` — Restore ASSEMBLY + `{ 8, 9 }` returned `nil, "invalid subjects"`.
3. `parseEvent` subject refuse is QUIET-only.
4. Green: `lua tests/test_runtime.lua` — **688 passed, 0 failed**.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_runtime.lua   # 688 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_runtime.lua` standalone | **688 passed, 0 failed.** Lua 5.1. Exit 0. |

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). Two-client catch-up smoke was not run.

## Self-review

- Exclusive files only. No sixth state. No holdSeconds. No OpenRite auto-fire. Runtime still does not write SV or CreateFrame.
- RITE / CONSEQUENCE parse unchanged. `riteType` still required there and still forbidden on ASSEMBLY / QUIET.
- Pope verbs that leave ASSEMBLY (`StartEvent`, `Continue`) still write empty subjects. This lane only opens Restore.

## Isolated count

**688 passed, 0 failed.**

## Concerns

- **Pope verbs still wipe subjects.** Sanction-before-`OpenRite` still does not live in Runtime after `StartEvent` / `Continue` / `EndEvent`. Congregation Restore of an ASSEMBLY snapshot that already names fighters/candidate now lands. The Pope writer still needs some other path (or `OpenRite`) to put those ids into live Runtime.
- **Snapshot / Codec / Gora not edited.** A STATE / SNAPSHOT that already carries ASSEMBLY subjects can Restore. Encoding those subjects onto the wire is other lanes.
- **No client / two-client smoke.** Isolated suite only. Sanction-before-OpenRite catch-up still needs a human pair.

## Status

**DONE_WITH_CONCERNS.** Isolated **688 / 0**. Not signed.
