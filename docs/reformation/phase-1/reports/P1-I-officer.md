# Phase 1 Lane I — Officer fail-closed stub

**Status:** DONE

**Cited:** Ten Laws 3, 5; Bible §6, §13.1; GATE1_DESIGN_LEAD_DIRECTIVE.md §2 (fail-closed is correct for the Phase 1 shell); brief `docs/reformation/phase-1/briefs/P1-I-officer.md`.

Authority APIs refuse everything. Phase 4 owns registered-Pope / Council. OPEN_QUESTIONS #8 is direction only — not coded. No TOC / Roster / Ranks / BeefNet / UI edits. No commit.

## Files written

- `addon/ChurchOfBeef/Core/Officer.lua` — rewrite
- `tests/test_officer.lua` — rewrite
- `docs/reformation/phase-1/reports/P1-I-officer.md` — this report

## Stub shape

| API | Phase 1 |
|-----|---------|
| `IsOfficerIndex` | always `false` |
| `IsOfficerName` | always `false` |
| `LocalIsOfficer` | always `false` |
| `IsGuildRosterName` | kept — membership sensing, not authority |
| Roster cache (`RefreshRosterCache` / `HasRosterCache` / `GetRosterLookup`) | kept — BeefNet still asks; no SUGGESTION logic added |

Comment on the module points at Phase 4. No `OfficerRankIndexMax`. No Prophet. No GM=officer.

## Verification

Isolated `tests/test_officer.lua`: **27 passed, 0 failed**.

`lua tests/run.lua`: **not green** (315 passed, 3 failed). Aborted suites `test_db`, `test_net_validate`, `test_net_adversarial` still `dofile` deleted `Core/Ladder.lua`. Out of this lane.

## Leftover callers (not fixed)

| File | What remains |
|------|----------------|
| `Core/Ceremony.lua` | Start / Close still call `LocalIsOfficer` — now always refuse. Session stub, not this lane. |
| `Net/BeefNet.lua` | `GetRosterLookup` / `HasRosterCache` / `RefreshRosterCache` still used (kept). `HandleSuggestion` still calls `LocalIsOfficer` — now always `"not an officer"`. Lane J owns the SUGGESTION cut. |
| `UI/MainFrame.lua` | `UpdateOfficerVisibility` still reads `LocalIsOfficer` — now always non-officer. Do not edit UI. |
| `tests/test_net_validate.lua` | still asserts `IsOfficerName("Pope", lookup) == true` (suite currently aborts on missing Ladder). Lane J. |

## Concerns

- Fail-closed is correct for the Quiet-Mode Phase 1 shell (directive §2). It becomes wrong when there is something true to say — that day is Phase 4.
- Ceremony Start/Close will not run until a later phase replaces the officer gate. Not invented here.
- Roster cache still stores guild `rankIndex`. That is display-rank sensing for BeefNet readiness, not Church authority.
