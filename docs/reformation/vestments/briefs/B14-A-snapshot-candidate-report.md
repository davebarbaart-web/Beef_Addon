# B14-A — SNAPSHOT Knighting candidate overlay (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Bible §20.3 catch-up (subjects may carry candidate); §13.1 star; B11-A fighter overlay; B12-A ASSEMBLY Restore; B13-A live ASSEMBLY Apply; brief `docs/reformation/vestments/briefs/B14-A-snapshot-candidate.md`.

`BuildResponse` overlays `Knighting:GetLine()[1].humanId` onto the **encoded** SNAPSHOT when Runtime subjects lack a numeric candidate. Overlay runs on ASSEMBLY, and on RITE only when `riteType == "Knighting"`. It does not run on RITE Gora / Proclamation / other, CONSEQUENCE, or QUIET (`nil, "no event"`). Runtime is not mutated. `ApplyResponse` still Restores Bible fields; a candidate that landed on the wire Restores. Favor stays off Restore. B11-A fighter overlay is unchanged and may coexist. Isolation stays Common + Runtime + Codec + Snapshot. Exclusive files only. No commit. Lane is not signed.

**Isolated count:** 800 passed, 0 failed (`lua tests/test_net_snapshot.lua`).

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_net_snapshot.lua` | TDD first. Appended after the B11-A / B13-A overlay block. In-file `COB.Knighting` stub (`GetLine`); `clearPairStubs` also nils Knighting. Pins: no Knighting = `encode_expected`; ASSEMBLY + empty candidate + line head 77; RITE Knighting Restore empty subjects + overlay; RITE Gora / Proclamation no overlay; CONSEQUENCE no overlay; Runtime candidate 7 kept; live fighters `{31,32}` + candidate `77` coexist; `ApplyResponse` Restores 77 and stays ASSEMBLY, favor nil; empty line / missing `humanId` / `GetLine` throw → no overlay, no throw. Isolation wrap stays. |
| `addon/ChurchOfBeef/Net/Snapshot.lua` | `overlayCandidate` (preserves fighters). `pcall` `GetLine`. Encode-only overlay after the fighter overlay. `ApplyResponse` unchanged (`bibleFields`). |
| `docs/reformation/vestments/briefs/B14-A-snapshot-candidate-report.md` | This file |
| `docs/reformation/vestments/briefs/B14-A-snapshot-candidate.diff` | B14-A-only unified diff of the exclusive implementation files |

Did not edit Runtime, Codec, Gora, Knighting.lua, BeefNet, UI, TOC, `ChurchOfBeef.lua`, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not `dofile` Knighting / Gora / Store / UI. Did not commit.

## Contract

```lua
-- when Runtime subjects lack a numeric candidate:
--   Knighting:GetLine()[1].humanId
--     overlay when state == "ASSEMBLY"
--     overlay when state == "RITE" and riteType == "Knighting"
--   do NOT overlay on RITE Gora / Proclamation / other rites
--   do NOT overlay on CONSEQUENCE
--   do NOT overlay on QUIET (BuildResponse still nil, "no event")
-- missing Knighting / GetLine / empty line / missing humanId
--   → today's encode (no candidate overlay)
-- Runtime already has a number candidate → do not replace it
-- fighter overlay (B11-A) is unchanged and may coexist:
--   ASSEMBLY + live pair + line head → wire has both fighters and candidate
```

- Overlay writes a new `subjects` table on the encode fields. `Runtime:Snapshot()` is a copy; live Runtime is not assigned.
- `overlayCandidate` preserves fighters (mirror of `overlaySubjects` keeping candidate).
- `GetLine` is `pcall`'d. Throw / missing module / missing method / empty line / missing `humanId` → no overlay, `BuildResponse` does not throw.
- QUIET → `nil, "no event"` even when a Knighting stub exists.
- `ApplyResponse` still `Restore(bibleFields(msg))`. Favor on the wire is dropped before Restore.

## TDD

1. Extended `tests/test_net_snapshot.lua` first (nine brief pins + QUIET-with-stub + Knighting-without-GetLine + RITE Proclamation no-overlay + combined Apply + isolation wrap after stub clear).
2. Red: `lua tests/test_net_snapshot.lua` — **790 passed, 9 failed.** Overlay wires still Runtime-only (`1:SNAPSHOT:response:1:ASSEMBLY::::1` / Knighting `:::1`).
3. Implemented encode-only `overlayCandidate` + `pcall` `GetLine` on `BuildResponse`. `ApplyResponse` untouched.
4. Green: `lua tests/test_net_snapshot.lua` — **800 passed, 0 failed.**

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_net_snapshot.lua   # 800 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_net_snapshot.lua` standalone | **800 passed, 0 failed.** Lua 5.1.5. Exit 0. |

B11-A / B13-A pins still pass. Isolation wrap: Net / Store / UI / DB nil at load; Gora / Console / Knighting stubs nilled and re-asserted at end. `COB.Net` / Store / UI still nil.

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). Two-client catch-up smoke was not run.

## Self-review

- Exclusive implementation files only. No new codec kind. No SUMMON. Favor is not persisted and is not Restored.
- `bibleFields` still omits favor. Overlay assigns a new subjects table; it does not write `Runtime` fields.
- Knighting is an optional read. Missing module or method is the pre-lane encode path.
- Isolation stays Common + Runtime + Codec + Snapshot. Stubs are in-file tables, then nilled.
- Empty-candidate RITE Knighting uses `Runtime:Restore` of `{eventId=1,state="RITE",riteType="Knighting",subjects={},sequence=1}` — candidate nil is legal.

## Isolated count

**800 passed, 0 failed.** Isolation wrap stays (Net / Store / UI / DB). Gora / Console / Knighting stubs cleared.

## Concerns

- **CONSEQUENCE still has no candidate overlay.** Brief forbids it. CloseRite of a Knighting that never received `OpenRite` subjects (or whose Runtime snapshot lost the candidate) still catch-up-encodes empty candidate. Late join during the verdict beat of that Knighting lands without a candidate.
- **Pope writer Runtime stays empty.** `StartEvent` / `Continue` still write empty subjects. Overlay is encode-only. Congregation Restore of the overlaid ASSEMBLY wire now lands `77`. The Pope writer's live Runtime stays empty until `OpenRite`.
- **No client / two-client smoke.** Isolated suite only. ASSEMBLY line-standing catch-up still needs a human pair. B14-INT STATE overlay is a separate lane.
- **Gate W / Gate V stay OPEN.** Not signed. Not `POLISH:PASS`.

## Status

**DONE_WITH_CONCERNS.** Isolated **800 / 0**. Not signed.
