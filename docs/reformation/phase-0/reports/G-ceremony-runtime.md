# Phase 0 Lane G — Ceremony runtime report

**Status:** DONE

**Files written:**
- `.cursor/rules/ceremony-runtime.mdc`
- `docs/reformation/phase-0/reports/G-ceremony-runtime.md` (this file)

**Cited:** Bible §20.1–20.4, §13.1, §13.4, §4.11, §7 (SUMMON kind), §18.2, §21.3, §22.1–22.2; Law 4, Law 5; Audit V5, V7, §4 BeefNet keepers; Adjudication §5 (generic ceremony builder rejected).

**Peer-authority sync is banned.** The rule forbids rebuilding `SYNC_STATE` / `SYNC_REQUEST` (or any peer reply) as a source of truth. Broadcasts are one-way from the Pope; snapshots are Pope-answered whispers; congregation clients are display + input only (Audit V7, §13.1).

**Auto-advance is banned.** The Pope's client owns every transition. Nothing auto-advances queues, auto-declares outcomes, or auto-announces in the Pope's voice (Law 4, §18.2, §20.2). Attendance-timesheet ceremonies are banned (Audit V5).

**Omitted (not invented):** opcode strings; hold-timeout seconds; snapshot schema; congregation-input channel. §20.4's five/thirty seconds is cited as the chaos-test quality bar, not a hold timer. Broadcast field *kinds* named in §20.2 (event id, state, rite type, subjects, sequence) are included; that is not a snapshot schema.

**OPEN_QUESTIONS:** none appended (exclusive-file rule). Those omissions stay unspecified.

**No commit made.**
