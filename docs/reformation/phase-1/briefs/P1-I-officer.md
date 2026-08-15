# Phase 1 Sweep I — Officer fail-closed stub

Read: `docs/reformation/phase-0/TEN_LAWS.md`, `GATE1_DESIGN_LEAD_DIRECTIVE.md` §2 (Officer: fail-closed is correct for the Phase 1 shell).

## Exclusive files

- `addon/ChurchOfBeef/Core/Officer.lua`
- `tests/test_officer.lua`
- Report: `docs/reformation/phase-1/reports/P1-I-officer.md`

**Do not** edit TOC, Roster, Ranks, BeefNet, UI.

## Mission

Stub authority to **refuse everything**. `IsOfficerIndex`, `IsOfficerName`, `LocalIsOfficer` always false. Comment: Phase 4 owns registered-Pope / Council. Do **not** invent that module or a config UX (OPEN_QUESTIONS #8 is direction only).

`IsGuildRosterName` may stay as membership sensing (not authority). Roster cache may stay if BeefNet still asks — do not add SUGGESTION logic.

Rewrite `test_officer.lua`: assert the stub shape (always false). No `OfficerRankIndexMax`, no Prophet, no GM=officer. Isolated suite must pass.

## Do not git commit.
