# Phase 1 Lane K — Adversarial Review

**Lane:** DB test cut  
**Exclusive files:** `tests/test_db.lua`  
**Lane report:** `docs/reformation/phase-1/reports/P1-K-db-tests.md`  
**Cited law:** Ten Laws 1, 7; Bible §12, §13.1; GATE1 §2 (DB test cut must not become the Pope store); brief `docs/reformation/phase-1/briefs/P1-K-db-tests.md`

**Spec:** PASS  
**Quality:** Approved

`test_db.lua` no longer `dofile`s deleted `Ladder.lua` / `Scoring.lua`. Fresh Init is `{ version, ui }` only. Standing / suggestion / scoring are not required product. Leftover SV keys on an old table survive and are not created when absent. No Pope store, archive, or account-level SV switch. Isolated suite: **36 passed, 0 failed**. Writer stayed inside exclusive files.

## Verdict

Refutation of GATE1 §2 / Law 1 / Law 7 **fails** for this lane’s exclusive file. The dead suite (`dofile` Ladder + Scoring; `SetStanding` / `MaybeSuggest` / `GrantInstanceBucket`; standing and daily-cap round-trip; v1→v3 standing-row migration) is gone, not rebalanced. What remains asserts the shipping `{ version = 4, ui }` defaults, Init/Save, leftover-key survival, and unknown-key merge. That is the cut GATE1 §2 asked for. It is not a second scorer and not the Phase 2 Pope store.

This review did not invent a Pope store, did not edit `Core/DB.lua`, and did not commit.

## Confirmations

| Check | Result |
|---|---|
| `test_db.lua` does not `dofile` `Ladder.lua` or `Scoring.lua` | **Yes.** Sole load is `dofile("addon/ChurchOfBeef/Core/DB.lua")`. No `Ranks` / `Roster` / `Ladder` / `Scoring`. Repo glob: 0 `Ladder.lua` / `Scoring.lua`. |
| Asserts `{ version, ui }` defaults; does not require standing / suggestion / scoring as product | **Yes.** Fresh keys are exactly `ui,version`. `ladder` / `scoring` are `nil` on first Init and after re-Init. No `SetStanding`, `GetStanding`, `Grant`, `MaybeSuggest`, `ImportState`, or `ExportState`. Nested `records` / `suggestions` / `granted` are never asserted as required schema. |
| Leftover SV keys may survive (Law 7) | **Yes.** Old table with leftover `ladder` / `scoring` keeps those keys after Init. A v1 table without them does not grow them. They are not required product. |
| No Pope store invented | **Yes.** Suite and `defaultDb()` have no `pope`, `archive`, `chronicle`, `humans`, `records`, `identity`, `ranks`, `ceremony`, `gora`, or `notebook`. `futureRoot` / `ui.streamerMode` are unknown-key merge probes, not schema. `SCHEMA_VERSION` 4 is the Lane G stamp, not a store. |
| No account-level SV switch | **Yes.** TOC still `## SavedVariablesPerCharacter: ChurchOfBeefDB`. No `## SavedVariables:` line. Writer did not edit TOC. Suite does not assert account scope. |
| Isolated suite green | **Yes.** Isolated (`test_db.lua` + `Core/DB.lua` only): **36 passed, 0 failed.** Writer count matches. |
| Writer did not edit `Core/DB.lua` / TOC / bootstrap / `tests/run.lua` | **Yes.** Transcript ([DB tests](96a69503-9177-4d76-91f0-f1ca0051e79b)): `Write` `tests/test_db.lua` + this lane’s report only. `DB.lua` unread (already `{ version, ui }` after Lane G). |
| No commit; `OPEN_QUESTIONS.md` unchanged | **Yes.** No commit. Writer did not touch `OPEN_QUESTIONS.md`. |

## Attack results

| Attack | Result |
|---|---|
| Law 1 — leftover fixture re-requires scoring / standing as product? | **No.** Fixture uses empty leftover tables. Asserts are `type(...) == "table"` on the root keys only. Missing leftovers are asserted `nil`. The old Grant / standing / suggestion round-trip is deleted. |
| Law 1 — Grant / threshold / daily-cap still encoded in the suite? | **No.** `GrantInstanceBucket`, `GetGranted`, `GetDayKey`, `SetStanding`, `MaybeSuggest`, and standing-row migration are gone. No points amounts. |
| Law 7 — Init / Save wipes leftover keys or nested leftover payload? | **No wipe.** Suite proves leftover *keys* survive Init. Reviewer probe (not added to the suite): nested leftover `records` / `suggestions` / `granted` / `dayKey` also survive Init **and** Save. `applyDefaults` only fills `version` and `ui`. |
| Law 7 misapplied to keep a points economy in SV? | **No.** Dead leftover bytes that nothing reads are not an economy. Requiring a wipe here would invent a Phase 2 migration and look like a history sweep. Brief + GATE1 §3d already ruled: do not require them, do not wipe them as product. Phase 2 owns that SV. |
| GATE1 §2 — suite or defaults became the Pope store / archive? | **No.** Fresh Init invents only `{ version, ui }`. Unknown-key merge is additive protection for a later store, not a store. No archive, no identity tables, no ceremony state. |
| Writer switched account-level SV (Phase 2)? | **No.** Per-character TOC line unchanged. Suite does not test or recommend the switch. |
| Writer edited `DB.lua` to grow schema (forbidden except one-line comment)? | **No.** Exclusive write is the suite + report. Live `DB.lua` shape is Lane G’s. |

Refutation of Law 1 (no points economy) and Law 7 (never-delete; leftover keys may survive; do not invent the store) **fails** for the exclusive file. The banned round-trip is gone. Leftover keys are tolerated, not required. The Pope store was not invented.

## Leftovers (other lanes — expected; not fixed)

Writer concerns are current (TOC per-character; player SV may still hold leftover `ladder` / `scoring`; full harness is integrator-owned). Additional live leftovers this lane correctly did not touch:

### Tests that still `dofile` deleted modules (abort when those suites run)

- `tests/test_net_validate.lua` — `dofile`s `Ladder.lua` and `Scoring.lua`.
- `tests/test_net_adversarial.lua` — `dofile`s `Ladder.lua`.

### TOC / SV (Phase 2 — GATE1 §3d)

- `ChurchOfBeef.toc` — `## SavedVariablesPerCharacter: ChurchOfBeefDB`. Account-level switch is Phase 2. Not this writer.
- Existing player `ChurchOfBeefDB` may still contain leftover `ladder` / `scoring` tables. Tests assert they are not wiped. Phase 2 migration owns that SV.

### Not this lane

- `Core/DB.lua` comments still name `ladder.records` / `ladder.suggestions` / `scoring` as things Init must **not** require (Lane G).
- `Net/BeefNet.lua` suggestion / standing / threshold protocol (other lane).
- `ui.announce` remains a shipped default. This lane correctly asserts it; it is not a scorer.

## Findings

### Critical

None.

### Important

None for this lane’s exclusive file.

### Nit

1. **Leftover survival asserts root `type == table` only.** The leftover fixture’s nested `records` / `suggestions` / `granted` are empty and unasserted. A nested wipe would still pass. Implementation does not wipe (reviewer probe). Phase 2 may care about leftover payload; this lane correctly refused to treat that payload as product.

2. **Leftover survival is not re-asserted after `Save()`.** `Save` shares `applyDefaults` with `Init`. Probe confirms Save preserves nested leftovers. Coverage gap only.

3. **Assert message says “officer-written ui fields.”** Leftover officer vocabulary. The fields are UI writes (`shown` / `point` / `announce`), not an officer store.

4. **Writer leftover map does not name the Net suites** that still `dofile` deleted `Ladder.lua` / `Scoring.lua`. Expected other-lane leftovers; does not reopen Spec.

## Brief contract

| Requirement | Result |
|---|---|
| Stop `dofile` of deleted `Ladder.lua` / `Scoring.lua` | Met |
| Assert `{ version, ui }` defaults; Init/Save without standing / suggestion / scoring schema | Met |
| Leftover SV keys may survive; do not require them; do not wipe them as product | Met |
| Do not invent Phase 2 Pope store / archive | Met |
| Do not switch account-level SV / TOC | Met |
| Prefer tests only; do not edit `Core/DB.lua` unless a one-line comment is required | Met (unread) |
| Isolated suite must pass | Met (36 / 0) |
| Do not edit TOC | Met |
| No commit | Met |
| `OPEN_QUESTIONS.md` unchanged | Met |

## Sections checked

- `docs/reformation/phase-0/TEN_LAWS.md` Laws 1, 7
- Brief `docs/reformation/phase-1/briefs/P1-K-db-tests.md`
- Writer report `docs/reformation/phase-1/reports/P1-K-db-tests.md`
- GATE1 §2 and §3d (`docs/reformation/phase-1/GATE1_DESIGN_LEAD_DIRECTIVE.md`)
- `tests/test_db.lua` (HEAD diff + live + isolated run)
- `addon/ChurchOfBeef/Core/DB.lua` (read-only; Init/Save leftover-payload probe; no Pope-store keys on fresh Init)
- `ChurchOfBeef.toc` (`SavedVariablesPerCharacter`; no account-level `SavedVariables` line)
- Writer transcript ([DB tests](96a69503-9177-4d76-91f0-f1ca0051e79b)) — exclusive writes only
- Live leftovers: `test_net_validate.lua`, `test_net_adversarial.lua`
- `docs/design/OPEN_QUESTIONS.md` (unchanged by this writer; no product invention)
