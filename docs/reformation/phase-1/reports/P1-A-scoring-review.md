# Phase 1 Lane A — Adversarial Review

**Lane:** Delete Scoring  
**Exclusive files:** `addon/ChurchOfBeef/Core/Scoring.lua`, `tests/test_scoring.lua` (delete)  
**Lane report:** `docs/reformation/phase-1/reports/P1-A-scoring.md`  
**Cited law:** Ten Laws 1–2; Bible §4.6, §4.9; Audit V1

**Spec:** PASS  
**Quality:** Approved

No replacement scorer. Scoring.lua and test_scoring.lua are gone. TOC and `tests/run.lua` no longer list them (integrator). Leftover callers are other lanes. Scoring was not restored.

## Verdict

Lane A removed the points-economy engine. Nothing in `addon/` implements `Grant*`, `DailyCaps`, a `Points` table, or `COB.Scoring =`. Gora `RecordResult` hard-fails `"scoring unavailable"`; Ceremony Close and OfficerTab reads are nil-guarded and mint nothing. That is deletion, not a rebalance. Law 1 / Bible §4.6 / Audit V1 hold for this lane’s exclusive files. Residual Grant call sites, `db.scoring` schema, and attic `_Grant` wiring are expected other-lane leftovers — they are not a second scorer.

## Confirmations

| Check | Result |
|---|---|
| `addon/ChurchOfBeef/Core/Scoring.lua` gone | **Yes.** `ls`: no such file. Repo-wide glob: 0 `Scoring.lua`. Git: `D`. |
| `tests/test_scoring.lua` gone | **Yes.** Not on disk. Not among `tests/test_*.lua`. Git: `D`. |
| No replacement scorer | **Yes.** No `COB.Scoring =`, no `:Grant(`, no `Points = {`, no `DailyCaps` in `addon/`. `Data/Ranks.lua` has titles only (no thresholds). |
| TOC no longer lists `Scoring.lua` | **Yes.** `ChurchOfBeef.toc` has no `Scoring` string. |
| `tests/run.lua` no longer lists `test_scoring` | **Yes.** Suite list has no `test_scoring`. |

Writer brief forbade TOC / bootstrap / `run.lua` edits. Integrator owns those files (`docs/REFORMATION_LOG.md`). Writer report’s “still listed” lines are stale against the current tree; the live tree matches the review contract.

## Attack results

| Attack | Result |
|---|---|
| Scoring moved (attic / rename) instead of deleted? | **No.** Zero `Scoring.lua` anywhere. Attic holds Instance/Quest only. |
| New Grant engine under another name? | **No.** Live Core is Common, Roster, Officer, Gora, Ceremony, DB. None define Grant / caps / point amounts. |
| Gora inlined the 15/8/5 faucet? | **No.** `OUTCOMES` maps win/draw to grant *kinds*. `RecordResult` requires `scoring.GrantGora` or returns `nil, "scoring unavailable"`. No amounts. |
| Ceremony still pays attendance? | **No mint.** `GrantCeremony` is nil-guarded; `paid` stays 0. Attendance sampling remains (Lane G / Audit V5). |
| `DB.defaultScoring()` is a hidden wallet? | **Schema only.** `{ dayKey = "", granted = {} }` plus nil-guarded Import/Export. No Grant. Lane G. |
| Demo grant table (5/12/20/3/40/15/8/5) rebuilt? | **No** in `addon/`. Only dead test assertions that `dofile` the deleted file. |
| Writer replaced the engine and called it records? | **No.** Exclusive work is delete + report. `OPEN_QUESTIONS.md` untouched. |

Refutation of Law 1 / §4.6 / Audit V1 **fails** for this lane. The banned mechanism is the Grant engine. It is gone. Call sites without an implementation cannot award Beef XP.

## Leftover callers (other lanes — expected; not fixed)

Writer leftover list is partly stale (Ladder, StandingTab, live Instance/Quest paths already moved or deleted by parallel lanes). Current Scoring-shaped leftovers:

### Lane G (`Core/Gora.lua`, `Core/Ceremony.lua`, `Core/DB.lua`)

- `Core/Gora.lua` — header still describes pair-pay / daily gora cap; `RecordResult` calls `COB.Scoring:GrantGora` and hard-fails if missing; returns `winnerPoints` / `loserPoints`.
- `Core/Ceremony.lua` — header still describes attendance credit; `Close` calls `GrantCeremony` when present.
- `Core/DB.lua` — `defaultScoring()`, `db.scoring`, `ImportState` / `ExportState` hooks (nil-guarded).

### Lane C (attic)

- `attic/Core/Instance.lua` — `_Grant` → `GrantBattlegroundEnd` / `GrantInstanceBucket` (nil-guarded).
- `attic/Core/Quest.lua` — `_Grant` → `GrantQuestBucket` (nil-guarded).
- `attic/tests/test_instance.lua`, `attic/tests/test_quest.lua` — `dofile` deleted `Scoring.lua`.

### Lane F (UI)

- `UI/OfficerTab.lua` — `GetGranted` / `GetHistory` (nil-guarded). Standing-correction UI is Ladder-shaped (Lane B/F), not a scorer.

### Tests that `dofile` the deleted file (abort when those suites run)

- `tests/test_db.lua`
- `tests/test_gora_ceremony.lua`
- `tests/test_minimap.lua`
- `tests/test_ui.lua`
- `tests/test_officer_ui.lua`
- `tests/test_net_validate.lua`

`ChurchOfBeef.lua` has no Scoring references. `UI/StandingTab.lua` is gone (Lane E); do not treat it as a current caller.

## Findings

### Critical

None.

### Important

None for this lane’s exclusive files.

### Minor

1. **Writer report leftover map is stale** (`P1-A-scoring.md`). It still lists TOC / `test_scoring` in `run.lua`, `Core/Ladder.lua` comment, live `Core/Instance.lua` / `Core/Quest.lua`, and `UI/StandingTab.lua`. Integrator and parallel lanes already moved those. Does not reopen Spec. This review’s leftover list is the current map.

2. **Empty `db.scoring` seed remains** (`Core/DB.lua`). Not a Grant engine. Lane G.

## Brief contract

| Requirement | Result |
|---|---|
| Delete `Core/Scoring.lua` | Met |
| Delete `tests/test_scoring.lua` | Met |
| No replacement scorer | Met |
| Do not edit TOC / bootstrap / `run.lua` / other Core/UI (writer) | Met (integrator dropped TOC + suite list) |
| Report leftover callers; do not fix them | Met |
| No commit | Met |
| Scoring not restored this review | Met |

## Sections checked

- Brief `docs/reformation/phase-1/briefs/P1-A-scoring.md`
- Writer report `docs/reformation/phase-1/reports/P1-A-scoring.md`
- `docs/reformation/phase-0/TEN_LAWS.md` Laws 1–2
- Bible §4.6, §4.9
- Audit V1 and §4 `Core/Scoring.lua` Discard row
- `ChurchOfBeef.toc`, `tests/run.lua`, `ChurchOfBeef.lua`
- Live Core/UI/Net Lua for `COB.Scoring`, `Grant*`, `Points`, `DailyCaps`
- `Data/Ranks.lua` (no thresholds)
- Attic Instance/Quest + their tests
- `docs/REFORMATION_LOG.md` P1-A integrator note
