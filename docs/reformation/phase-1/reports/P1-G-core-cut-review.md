# Phase 1 Lane G — Adversarial Review

**Lane:** Cut Scoring/Ladder calls so Core still loads  
**Exclusive files:** `addon/ChurchOfBeef/Core/Gora.lua`, `addon/ChurchOfBeef/Core/Ceremony.lua`, `addon/ChurchOfBeef/Core/DB.lua`, `tests/test_gora_ceremony.lua`  
**Lane report:** `docs/reformation/phase-1/reports/P1-G-core-cut.md`  
**Cited law:** Ten Laws 1, 4, 8; Bible §10, §20; Audit V4, V5; brief `docs/reformation/phase-1/briefs/P1-G-core-cut.md`

**Spec:** PASS  
**Quality:** Approved

Scoring/Ladder/Grant are gone from this lane’s exclusive files. No points faucet was inlined. Sanctioned Gora and the §20 runtime were not rebuilt. Init no longer requires standing/suggestion/scoring. Account-level SV was not switched. Writer stayed inside exclusive files.

## Verdict

Refutation of the Lane G brief / Law 1 / Audit V4–V5 **fails** for this lane’s exclusive files. The demo faucets (`GrantGora`, attendance `GrantCeremony`, `goraLordWin`, knighting-on-close, `loadIntoModules` into deleted Scoring/Ladder) are deleted, not rebalanced. What remains is a pair-key challenge note, a no-points `RecordResult` stub, an officer-gated session flag, and a `{ version, ui }` SV default. Those leftovers are Phase 3 / Phase 4 / Phase 2 work. They are not a second scorer and not a rebuilt product.

This review did not rebuild Gora or Ceremony and did not edit leftover callers.

## Confirmations

| Check | Result |
|---|---|
| `Gora.lua` has no Scoring / Ladder / Grant / points awards | **Yes.** Code (comments stripped) has no `Scoring`, `Ladder`, `GrantGora`, `Grant(`, `winnerPoints`, `loserPoints`, `goraLordWin`, `SetRiteFlag`, `standing`, `paid`, or `ResultCooldown`. `OUTCOMES` / daily-cap path is gone. |
| No-points stub OK; sanctioned-duel Gora not rebuilt (Phase 4) | **Yes.** `RecordResult` clears a pending pair and returns `{ winner, loser, challenged, at }`. No petition, sanction, mute cards, favor, HUD, duel propose, or Pope verbs. No §10 loop. |
| `Ceremony.lua` has no attendance-credit / Grant | **Yes.** `sampleRoster`, `liveRoster`, `Mark`, `seen`, `attendees`, `GrantCeremony`, `SetHonoree`, and knighting-on-close are gone. `Close` returns label + timestamps only. `_roster` is unused. |
| Ceremony runtime not rebuilt (Phase 3); stub OK | **Yes.** No `QUIET` / `ASSEMBLY` / `RITE` / `CONSEQUENCE`, no Director, no snapshot, no sequence. `Start` / `Close` / `Cancel` / `IsActive` only. Unused `_kind` is not a typed-rite machine. |
| `DB.lua` Init does not require standing/suggestion/scoring | **Yes.** `defaultDb()` is `{ version, ui }`. `applyDefaults` only ensures `ui`. No `ensureTable` for `ladder` / `scoring`. No `ImportState` / `ExportState`. Probed with Scoring and Ladder absent: Init and Save succeed. |
| Phase 2 Pope store not invented | **Yes.** Fresh SV has no `records`, `chronicle`, `pope`, ranks-in-SV, or identity tables. Leftover `ladder` / `scoring` keys on an existing SV are left in place (Law 7). `SCHEMA_VERSION` 3→4 is a stamp, not a store. |
| Account-level SV not switched this lane | **Yes.** TOC still `## SavedVariablesPerCharacter: ChurchOfBeefDB`. Writer did not edit TOC. |
| `test_gora_ceremony.lua` pair-key only; no points-grant tests | **Yes.** Loads `Gora.lua` only. No `RecordResult`, Ceremony, Scoring, Ladder, standing, or grant assertions. Isolated with Common: **17 passed, 0 failed.** |
| Writer did not edit Roster / Officer (prefer none) | **Yes.** Writer transcript writes only exclusive files + this lane’s report. Officer has no Scoring / Grant / Gora / Ceremony calls, so no crash-prevention cut was needed. Roster / Officer diffs on the branch are other lanes. |
| Writer did not edit TOC / bootstrap / `tests/run.lua` | **Yes.** Exclusive writes only. Those files are dirty from other lanes / integrator. `Gora.lua` / `Ceremony.lua` / `DB.lua` still ship. |

## Attack results

| Attack | Result |
|---|---|
| Points faucet inlined into Gora / Ceremony? | **No.** No grant amounts, no `Points` table, no daily caps, no `paid` ledger. `RecordResult` does not write standing. `Close` does not mint. |
| Typed self-report Gora treated as product authority (Audit V4)? | **Leftover stub, not a scored rebuild.** `RecordResult(winner, loser, _outcome)` still exists and still names a winner. It does not persist, Grant, or set rite flags. No UI/Net caller in `addon/` invokes it. Phase 4 must replace this path; this lane did not grow it. |
| Attendance sampling still pays? | **No.** Group sampling and `Mark` are deleted. `Close(_roster, now)` ignores the roster. `Cancel` still credits nobody. |
| Standing / suggestion schema still required on Init? | **No.** Fresh SV: `ladder == nil`, `scoring == nil`. Existing leftover keys survive Init + Save. No error with Scoring / Ladder absent. |
| Writer rebuilt Director / §20 state machine or sanctioned Gora? | **No.** Bible §10 loop and §20 states are absent. Officer-gated Start/Close is the thinned demo session, not the Pope runtime. Challenge notes are the Audit salvage (pair-key), not `SANCTION BEEF GORA`. |
| Writer switched SavedVariables to account-level (Phase 2)? | **No.** Per-character TOC line unchanged. DB comment no longer says “per-character”; that is prose, not a TOC switch. |

Refutation of Law 1 (no points economy) and Audit V4/V5 (typed-result faucet / attendance timesheet) **fails** for the exclusive files. The banned mechanisms are gone. The remaining APIs cannot award Beef XP.

## Leftover callers (other lanes — expected; not fixed)

Writer leftover list is partly stale (TOC no longer lists `Scoring.lua` / `Ladder.lua`; integrator already dropped them). Current Scoring/Ladder-shaped leftovers:

### Tests (abort or assert the old schema when those suites run)

- `tests/test_db.lua` — `dofile`s deleted `Ladder.lua` / `Scoring.lua`; still asserts `ladder.records`, `ladder.suggestions`, `scoring.granted`, and standing round-trip.
- `tests/test_roster.lua` — `dofile`s `Ladder.lua`; `GetLadderView` standing / suggestion tests.
- `tests/test_net_validate.lua` — `dofile`s `Ladder.lua` and `Scoring.lua`; `GrantCeremony` / `GrantGora`.
- `tests/test_net_adversarial.lua` — `dofile`s `Ladder.lua`; suggestion standing claims.

### Roster / Officer / Net / UI (other lanes)

- `Core/Roster.lua` — still reads `COB.Ladder` and builds `GetLadderView` standing rows.
- `Core/Officer.lua` — no Scoring / Grant / Gora / Ceremony calls (no Lane G crash cut required).
- `Net/BeefNet.lua` — suggestion fanout still carries `standing` / `threshold`; `RefreshLadder`.
- `UI/MainFrame.lua` — leftover `GetLadderView` / `RefreshLadder` name.

### TOC / bootstrap

- `ChurchOfBeef.toc` — Scoring / Ladder already unlisted. Still `SavedVariablesPerCharacter` (Phase 2). Not this writer.
- `ChurchOfBeef.lua` — `DB:Init` / `DB:Save` only; no Gora / Ceremony / Grant.

`UI/StandingTab.lua` is gone (Lane E). Do not treat it as a current caller.

## Findings

### Critical

None.

### Important

None for this lane’s exclusive files.

### Nit

1. **Writer report assertion count is off** (`P1-G-core-cut.md`). Pair-key suite is **17** assertions, not 16. Isolated run is green either way.

2. **Writer leftover map is stale.** It still says TOC lists deleted `Core/Scoring.lua` and `Core/Ladder.lua`. Current TOC does not. Integrator / parallel lanes already dropped those lines.

3. **`SCHEMA_VERSION` 3→4** is a stamp with no new tables. Harmless, but Phase 2 owns the next real schema. Do not treat 4 as a Pope store.

4. **`Ceremony:Start(..., _kind)`** adds an unused rite-kind slot. It is discarded. It is not §20. Do not grow it here.

5. **`Gora:RecordResult` leftover** (writer already flagged). Audit V4 bans the typed-result *product*. The brief allows a no-points stub. Phase 4 replaces it.

## Brief contract

| Requirement | Result |
|---|---|
| Remove Scoring / Ladder / Grant / points from `Gora.lua` | Met |
| Do not rebuild sanctioned-duel Gora; stub OK | Met |
| Remove attendance-credit / Grant from `Ceremony.lua` | Met |
| Do not rebuild ceremony runtime; stub OK | Met |
| Remove standing / suggestion schema requirements from `DB.lua` Init | Met |
| Do not invent Phase 2 Pope store | Met |
| Do not switch account-level SV / TOC this lane | Met |
| Keep pair-key tests only; no points-grant tests | Met (17 / 0 isolated) |
| Do not edit Roster / Officer except one-line crash cut (prefer none) | Met (none) |
| Do not edit TOC / bootstrap / `tests/run.lua` | Met |
| Report leftovers; do not fix them | Met (map now stale; see Nit) |
| No commit | Met |
| `OPEN_QUESTIONS.md` unchanged | Met |

## Sections checked

- `docs/reformation/phase-0/TEN_LAWS.md` Laws 1, 4, 8
- Brief `docs/reformation/phase-1/briefs/P1-G-core-cut.md`
- Writer report `docs/reformation/phase-1/reports/P1-G-core-cut.md`
- `addon/ChurchOfBeef/Core/Gora.lua` (HEAD diff + live)
- `addon/ChurchOfBeef/Core/Ceremony.lua` (HEAD diff + live)
- `addon/ChurchOfBeef/Core/DB.lua` (HEAD diff + live + Init/Save probe without Scoring/Ladder)
- `tests/test_gora_ceremony.lua` (HEAD diff + isolated Common + suite)
- Audit V4, V5 and §4 `Core/Gora.lua` / `Core/Ceremony.lua` Discard rows (`docs/design/Demo_Build_Audit.md`)
- Bible §10 (sanctioned loop) and §20 (QUIET → ASSEMBLY → RITE → CONSEQUENCE) — confirmed absent
- Writer transcript (exclusive writes only)
- `ChurchOfBeef.toc` (`SavedVariablesPerCharacter`; Gora / Ceremony / DB still listed)
- `ChurchOfBeef.lua`, `tests/run.lua` (not this writer)
- Live leftovers: `test_db.lua`, Roster, Officer, BeefNet, MainFrame
- `docs/design/OPEN_QUESTIONS.md` (unchanged; no product invention)
