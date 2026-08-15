# Phase 1 Lane M — Adversarial Review

**Lane:** Gora / Ceremony stub containment  
**Exclusive files:** `addon/ChurchOfBeef/Core/Gora.lua`, `addon/ChurchOfBeef/Core/Ceremony.lua` (delete), `tests/test_gora_ceremony.lua` (keep pair-key)  
**Lane report:** `docs/reformation/phase-1/reports/P1-M-stubs.md`  
**Cited law:** Ten Laws 4, 5, 8; Bible §10, §20; Audit V4, V5; Gate 1 §3b; brief `docs/reformation/phase-1/briefs/P1-M-stubs.md`

**Spec:** PASS  
**Quality:** Approved

`RecordResult` is gone, not renamed. `Ceremony.lua` is gone from live `addon/` and is not listed in the TOC (integrator). Pair-key `Challenge` / `Cancel` / `IsChallenged` / `GetPending` remain. Isolated pair-key suite is green. No UI, slash, or Net caller reaches a typed result or a ceremony session. Sanctioned Gora and the §20 runtime were not rebuilt. Writer did not edit the TOC. Ceremony and `RecordResult` were not restored this review.

## Verdict

Refutation of Gate 1 §3b / Ten Laws 4, 5, and 8 **fails** for this lane’s exclusive files. §3b allows an inert `RecordResult` only with zero callers and prefers sever when that is trivial. The same rule applies to Ceremony session stubs. Both had zero UI / slash / Net callers. Both were severed. What remains is the Audit-salvage pair-key note (brief-required), in-memory, with no winner, loser, outcome, Grant, or theater. That is containment, not a Gora and not a ceremony runtime.

This review did not restore Ceremony or `RecordResult`, did not edit leftover callers, and did not commit.

## Confirmations

| Check | Result |
|---|---|
| `RecordResult` gone from `Gora.lua` | **Yes.** No `function Gora:RecordResult`. `type(Gora.RecordResult) == "nil"`. Live `addon/` has one token: the excision comment in `Gora.lua` (waived below). |
| `Ceremony.lua` gone from live `addon/` | **Yes.** `ls addon/ChurchOfBeef/Core/`: Common, DB, Gora, Officer, Roster. Repo-wide glob: 0 `Ceremony.lua`. Git: `D`. Not in attic. `COB.Ceremony` is nil. |
| `Ceremony.lua` not listed in TOC | **Yes.** Integrator. `ChurchOfBeef.toc` has `Core\Gora.lua` only. No `Ceremony` file line. Interface remains `20506`. |
| Pair-key APIs remain | **Yes.** `Challenge` / `Cancel` / `IsChallenged` / `GetPending` / `_Prune` / `ResetForTests`. Stores `{ challenger, target, at }` only. |
| `test_gora_ceremony.lua` pair-key only | **Yes.** Loads `Gora.lua` only. No `RecordResult`, Ceremony, Scoring, Ladder, Grant, winner/loser, or theater assertions. Writer transcript: file not edited this lane (Lane G already cut it). |
| Isolated pair-key suite green | **Yes.** Common + `tests/test_gora_ceremony.lua`: **17 passed, 0 failed.** |
| No UI / slash / Net caller of `RecordResult` or Ceremony | **Yes.** Live `addon/` UI, `Net/BeefNet.lua`, and `ChurchOfBeef.lua` have zero `Gora:` / `Ceremony:` / `RecordResult` callees. `/beef` is minimap-toggle or `UI:Toggle`. |
| Writer did not rebuild sanctioned Gora or §20 runtime | **Yes.** No petition pool, `SANCTION BEEF GORA`, mute cards, favor, HUD, duel propose, or Pope verbs. No `QUIET` / `ASSEMBLY` / `RITE` / `CONSEQUENCE`. |
| Writer did not edit TOC | **Yes.** Writer transcript writes: `Gora.lua` (sever `RecordResult`), delete `Ceremony.lua`, this lane’s report. TOC dirty from integrator / other lanes. |
| No commit; `OPEN_QUESTIONS.md` not edited this lane | **Yes.** |

Writer brief forbade TOC edits and forbade rebuilding sanctioned Gora / §20. Integrator owns the TOC drop (`docs/REFORMATION_LOG.md`). Writer report’s “TOC still lists `Core\Ceremony.lua`” line is stale against the current tree; the live tree matches the review contract.

## Attack results

| Attack | Result |
|---|---|
| `RecordResult` renamed / inlined, not severed? | **No.** No winner/loser/outcome path. `Challenge` writes `{ challenger, target, at }`. No `OUTCOMES`, `GrantGora`, `winnerPoints`, or `goraLordWin`. |
| `Ceremony.lua` moved / renamed (attic) instead of deleted? | **No.** Zero `Ceremony.lua` anywhere. Git is `D`, not `R`. Attic holds Instance/Quest only. |
| Pair-key `Challenge` is an invented petition / unofficial Gora (brief + Law 8)? | **No.** Brief requires the Audit salvage. Pre-existing notes, not a new petition pool, not `SANCTION BEEF GORA`, not a typed result. Phase 4 must not grow them into results. |
| Challenge without Pope ratification (Law 4 / Law 5)? | **No live caller.** Inert API cannot auto-declare or broadcast. Notes are not official callouts and are not peer authority. `/run` is forging, not a shipped path. |
| `_Prune` / TTL deletes Church history (Law 7)? | **No.** Pending is in-memory social noise, not a Gora record and not SV. Gate 0: Law 7 governs Church history. |
| `CHALLENGE_TTL` (1800) / `PENDING_MAX` (20) are invented Law 1 thresholds or a petition window? | **Not this lane.** Pre-existing demo numbers. Writer did not invent them. Not engagement scoring. Not a Bible petition freshness default. |
| Writer rebuilt §20 or the §10 loop under another name? | **No.** Those named states and verbs are absent from exclusive files. |
| Writer edited TOC / bootstrap / `tests/run.lua`? | **No** for this lane. Integrator dropped the Ceremony TOC line. |
| UI / slash / Net still reach the stubs? | **No.** Bootstrap never names Gora or Ceremony. Toasts `Celebrate` is UI-owned copy, not a Core call. Net has no Gora/Ceremony symbols. |

Refutation of §3b (inert leftover only with zero callers; prefer sever) **fails**. The banned surfaces are the typed-result stub and the unused session flags. They are gone. A pair-key note with no product caller is the salvage the brief named, not a second Gora.

### Smoke (adversarial)

Isolated Common + `tests/test_gora_ceremony.lua`:

| Probe | Result |
|---|---|
| Assertion count | **17 passed, 0 failed** |
| `Gora.RecordResult` | `nil` |
| `Gora.Challenge` / `Cancel` / `IsChallenged` / `GetPending` | `function` |
| `ChurchOfBeef.Ceremony` | `nil` |

## Leftover callers

Live `addon/` has **no** UI, slash, or Net caller of `RecordResult`, Ceremony, or the remaining pair-key APIs. Gate 1 checklist item 3 (§3b callers) is clean on the live load graph.

### Benign comment (waived)

- `Core/Gora.lua` header names excised `RecordResult` / `GrantGora` / `goraLordWin`. Comment only. Waived.

### Brief-required salvage (not a leftover to cut)

- `Gora:Challenge` / `Cancel` / `IsChallenged` / `GetPending` — zero product callers. Kept because the brief names them as Audit salvage and requires the isolated suite. Not a petition, not sanction, not a typed result. Phase 4 must not grow them into results.

### Writer report leftover (stale)

- Writer flagged `ChurchOfBeef.toc` still listing `Core\Ceremony.lua`. **Integrator already dropped that line.** Client load no longer fails on a missing Ceremony file from this lane.

### Other-lane / docs leftovers (not fixed)

- `tests/test_net_validate.lua` — `GrantCeremony` / `GrantGora` against deleted `COB.Scoring`. Scoring leftover, not a Gora/Ceremony module caller.
- Parallel-lane reports still speak as if `Ceremony.lua` is live: `P1-I-officer.md`, `P1-A-scoring.md`, `P1-A-scoring-review.md`, `P1-G-core-cut.md`, `P1-G-core-cut-review.md`, `P1-C-attic-review.md` (Core listing), `P1-B-ladder.md`. Historical. Not a load-graph caller.
- `.cursor/rules/addon-module-layers.mdc` still lists `Gora` / `Ceremony` as matching `Core/*.lua`. Rule map, not a TOC load.
- TOC `## Notes` still says “Ceremony, sanctioned Gora, and memory…”. Product description, not a file listing. Integrator-owned file.

`ChurchOfBeef.lua` has no Gora / Ceremony / `RecordResult` references.

## Findings

### Critical

None.

### Important

None for this lane’s exclusive files.

### Nit

1. **Writer report TOC leftover is stale** (`P1-M-stubs.md`). It still says the TOC lists deleted `Core\Ceremony.lua` and that client load will fail. Integrator already dropped the line. Does not reopen Spec.

2. **Pre-existing error copy** `"a Gora needs two different combatants"` still names informal notes as Goras. Not invented this lane. Not a sanctioned Gora. Do not treat the string as product.

3. **Pre-existing `CHALLENGE_TTL` (1800) and `PENDING_MAX` (20).** Writer already flagged. Not Bible defaults. Not a petition freshness window.

## Brief contract

| Requirement | Result |
|---|---|
| `RecordResult` remain only if zero callers; prefer sever | Met (severed) |
| Same for Ceremony session stubs; prefer gut or delete | Met (file deleted) |
| Keep pair-key challenge notes + tests | Met |
| Isolated pair-key suite must pass | Met (17 / 0) |
| Do not invent petitions, sanction, HUD, or ceremony theater | Met |
| Do not rebuild sanctioned Gora or §20 runtime | Met |
| Do not edit TOC (report delete for integrator) | Met (writer). Integrator dropped the line. |
| No commit | Met |
| Ceremony / `RecordResult` not restored this review | Met |

## Sections checked

- Brief `docs/reformation/phase-1/briefs/P1-M-stubs.md`
- Writer report `docs/reformation/phase-1/reports/P1-M-stubs.md`
- `docs/reformation/phase-0/TEN_LAWS.md` Laws 4, 5, 8
- Gate 1 §3b and closing checklist item 3 (`GATE1_DESIGN_LEAD_DIRECTIVE.md`)
- Bible §10 (sanctioned loop) and §20 (QUIET → ASSEMBLY → RITE → CONSEQUENCE) — confirmed absent
- Audit V4, V5 and §4 `Core/Gora.lua` / `Core/Ceremony.lua` Discard rows (`docs/design/Demo_Build_Audit.md`)
- `addon/ChurchOfBeef/Core/Gora.lua` (live + HEAD diff + writer transcript)
- `addon/ChurchOfBeef/Core/Ceremony.lua` (absent; git `D`)
- `tests/test_gora_ceremony.lua` (pair-key only; isolated Common + suite)
- Writer transcript [Stub containment](632f80f1-30c7-46c5-9ddc-49d0aed77b73) (exclusive writes only; no TOC; no commit)
- `ChurchOfBeef.toc` (integrator dropped Ceremony; `Gora.lua` remains)
- `ChurchOfBeef.lua`, `Net/BeefNet.lua`, `UI/*` (no callers)
- `docs/design/OPEN_QUESTIONS.md` (not edited this lane)
