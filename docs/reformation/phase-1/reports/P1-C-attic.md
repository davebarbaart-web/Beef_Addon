# Phase 1 Lane C — Attic Instance and Quest

**Status:** DONE

**Cited:** Ten Laws 1–2 (no points economy; record events, never behavior); Audit §4 shelve row for `Core/Instance.lua` / `Core/Quest.lua`; Bible §14.3 later-phase Church Expeditions; Handoff attic note (`CURSOR_REWORK_HANDOFF.md`).

**Tests:** moved, not deleted. Both suites test sensing (Qualifies, tracking lifecycle, rest grace, live sampler, event wiring) as well as scoring grants. Brief: prefer attic if they test sensing.

**TOC / bootstrap / `tests/run.lua`:** not edited (integrator-owned). Attic is not listed in the TOC.

**Commit:** none.

## Files moved (`git mv`)

| From | To |
|------|----|
| `addon/ChurchOfBeef/Core/Instance.lua` | `attic/Core/Instance.lua` |
| `addon/ChurchOfBeef/Core/Quest.lua` | `attic/Core/Quest.lua` |
| `tests/test_instance.lua` | `attic/tests/test_instance.lua` |
| `tests/test_quest.lua` | `attic/tests/test_quest.lua` |

## Written (not moved)

- `attic/README.md` — not shipped; Expedition witnessing later; do not load from TOC
- `docs/reformation/phase-1/reports/P1-C-attic.md` (this file)

## Leftover callers (not fixed)

Integrator-owned; Lane C must not edit these:

| File | What remains |
|------|----------------|
| `addon/ChurchOfBeef/ChurchOfBeef.toc` | still lists `Core\Instance.lua` and `Core\Quest.lua` (missing after this move) |
| `addon/ChurchOfBeef/ChurchOfBeef.lua` | `WireInstanceEvents` / `WireQuestEvents`; `OnLogin` still calls `COB.Instance:Init` / `COB.Quest:Init` (nil-guarded; frames no-op if modules are absent) |
| `tests/run.lua` | `suites` still lists `test_instance` and `test_quest` (files no longer under `tests/`) |

Attic tests still `dofile` the old addon paths (`addon/ChurchOfBeef/Core/Instance.lua`, `Core/Quest.lua`) and Scoring/Ladder. They are a shelf, not a live suite.

No other live Lua under `addon/` or `tests/` calls `COB.Instance` or `COB.Quest`. Scoring grant APIs (`GrantInstanceBucket`, `GrantQuestBucket`, `GrantBattlegroundEnd`) belong to P1-A, not this lane.

Historical mentions in `docs/archive/`, `docs/research/`, and `docs/design/Demo_Build_Audit.md` were left in place.
