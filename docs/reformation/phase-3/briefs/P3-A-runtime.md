# Phase 3 Lane A — Ceremony runtime (Core state machine)

Read: Ten Laws 4, 5, 6; Bible §20.1–20.3, §4.11; `.cursor/rules/ceremony-runtime.mdc`.

## Exclusive files

- `addon/ChurchOfBeef/Core/Runtime.lua` (create)
- `tests/test_runtime.lua` (create)
- Report: `docs/reformation/phase-3/reports/P3-A-runtime.md`

**Do not** edit TOC, bootstrap, `tests/run.lua`, Store, Archive, Recognition, BeefNet, UI.

## Mission

Test-first. Isolated suite: Common + Runtime (Ranks/Store only if you call them — prefer not to).

Pope-owned state machine. States, named only: **QUIET → ASSEMBLY → RITE (typed) → CONSEQUENCE → ASSEMBLY or QUIET**.

Harness-driven Pope verbs (no UI, no auto-advance):

- **StartEvent** — QUIET → ASSEMBLY. Zero configuration (§4.11). One action.
- **OpenRite(type)** — ASSEMBLY → RITE. Closed types only: `Knighting`, `Gora`, `Confession`, `Proclamation`. No free-text kind. No generic builder.
- **CloseRite** — RITE → CONSEQUENCE.
- **Continue** — CONSEQUENCE → ASSEMBLY (next rite).
- **EndEvent** — ASSEMBLY or CONSEQUENCE → QUIET.

Illegal transitions return `nil, err` and leave state unchanged. Nothing auto-declares outcomes or generates narration.

Broadcast-shaped event object (Bible §20.2 fields only): event id, state, rite type (or nil), active subjects (candidate / fighters — ids or nil), sequence number (increment on each successful transition).

`Snapshot` / `Restore` of that object so the Pope can resume after disconnect (§20.3). Do not invent extra snapshot fields. Do not persist into `ChurchOfBeefDB` this lane (integrator / later).

Do not invent hold-timeout seconds, “awaiting the Pope” UI, Net sends, Director Console, Decree, Grant, attendance sampling.

## Do not git commit.
