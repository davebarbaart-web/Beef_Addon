# Phase 1 Lane E — Standing tab, grant toasts, minimap pip

**Status:** DONE (exclusive files). Cross-lane harness/TOC still red.

**Law:** 6. Quiet Mode: at most minimap presence and the active Decree. No standing tab, grant toasts, or pips.

**Cited:** Bible §4.8, §13.4, §14.1, §14.2, §19.1, §19.4; Law 6; Audit V8, V9; `quiet-event-modes.mdc`.

**Do not git commit:** honored. Did not edit MainFrame, LadderTab, OfficerTab, TOC, bootstrap, or `tests/run.lua`.

## Files changed

| Action | Path |
|--------|------|
| Deleted | `addon/ChurchOfBeef/UI/StandingTab.lua` |
| Deleted | `tests/test_standing_ui.lua` |
| Edited | `addon/ChurchOfBeef/UI/Toasts.lua` |
| Edited | `addon/ChurchOfBeef/UI/Minimap.lua` |
| Edited | `tests/test_minimap.lua` |
| Written | `docs/reformation/phase-1/reports/P1-E-quiet-ui.md` (this file) |

## What was excised

- **Standing tab** — points-history / threshold / petition / Gora-self-report surface. File gone; it no longer registers `My Standing`.
- **Grant-driven toast kinds** — `suggest`, `credit`, `demote`, `excommunicate` removed from `KINDS` and from `Celebrate` copy builders. Credit coalesce is gone. Standing-delta / attendee-credit copy is gone.
- **Minimap pip** — `petitionPip`, gold border tint, `StandingGlanceLines`, Ladder suggestion lookup, and threshold glance copy are gone. Button, drag, show/hide, and `/beef minimap` remain. Hover is presence only (`Church of Beef` + `Left-click: /beef`). `Refresh` is a no-op for cues (shell may still call it).

## What was kept

- Toast **engine** (queue, priority, interrupt, dedupe, motion). Leftover kinds: `promote`, `rite`, `system`, `debug`. No Event Mode kinds invented (Phase 4).
- Isolated smoke: `Celebrate("suggest", { title = … })` → `false, "invalid"` (no text minted). `Push({ kind = "credit", text = … })` falls through to `system` (leftover engine path, not a standing-kind family). `promote` / `Show` still work.
- Minimap suite isolated: **74 passed, 0 failed**.

## Verification

`lua tests/run.lua` is red on this branch from parallel Phase 1 cuts (missing Ladder / attic'd instance+quest suites, plus this lane's deleted `test_standing_ui`). Out of lane to repair `run.lua`. Lane E's exclusive minimap suite is green in isolation.

No `OPEN_QUESTIONS.md` item appended.

## Concerns

1. **TOC still lists `UI\StandingTab.lua`.** Client load will fail until the TOC owner drops the line. This lane was forbidden to edit the TOC.
2. **`tests/run.lua` still lists `test_standing_ui`.** The runner treats a listed-but-missing suite as a fail.
3. **Other suites still `dofile` StandingTab:** `tests/test_ui.lua`, `tests/test_officer_ui.lua`, `tests/test_gora_ceremony.lua`. Lane F owns the first two; Lane G owns the Gora/ceremony test. They will abort on the missing file.
4. **`test_ui.lua` still asserts `kind = "credit"` and Standing tab chrome.** After kinds excision, credit `Push` shows as `system`. Lane F owns that suite.
5. **Quiet toasts can still fire from out-of-lane callers.** `Net/BeefNet.lua` still calls `Celebrate("suggest", …)` without `fields.text` — that now no-ops (invalid). `OfficerTab` still `Push`es dismiss (`system`) and standing-correction (`rite` + standing copy). Lane F is slated to delete/gut OfficerTab. Unknown kinds with explicit `text` still display as `system` (engine leftover).
6. **`MainFrame` still `MarkDirty("standing")` and calls `Minimap:Refresh`.** Refresh no longer paints a pip. Standing IA remains until Lane F strips the shell.
7. **Leftover `promote` / `rite` kinds** are not Event Mode theater and are not a standing-kind family. They stay so the engine is not an empty stub. Phase 4 owns real Event kinds. Do not treat them as Quiet grant toasts.
