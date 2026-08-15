# Phase 1 Sweep M — Gora / Ceremony stub containment

Read: `docs/reformation/phase-0/TEN_LAWS.md`, `GATE1_DESIGN_LEAD_DIRECTIVE.md` §3b.

## Exclusive files

- `addon/ChurchOfBeef/Core/Gora.lua`
- `addon/ChurchOfBeef/Core/Ceremony.lua`
- `tests/test_gora_ceremony.lua`
- Report: `docs/reformation/phase-1/reports/P1-M-stubs.md`

**Do not** edit TOC (if you delete Ceremony.lua, report it for the integrator). Do not rebuild sanctioned Gora or §20 runtime.

## Mission

`RecordResult` may remain **only if zero callers** (no UI, slash, Net). Prefer **sever** — it is unused. Same for Ceremony Start/Close/Cancel session flags: zero live callers; prefer gut or delete the file.

Keep pair-key challenge notes + their tests (Audit salvage). Isolated pair-key suite must pass.

Do not invent petitions, sanction, HUD, or ceremony theater.

## Do not git commit.
