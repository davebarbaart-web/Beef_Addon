# Phase 1 Lane L — UI leftovers

**Status:** DONE (exclusive files).

**Cited:** Ten Laws 6, 10; Bible §4.8, §19.1, §19.3; GATE1 §3a; brief `docs/reformation/phase-1/briefs/P1-L-ui-leftovers.md`.

**Not edited (per brief):** Status.lua (footer already empty), TOC, Roster, Minimap, `tests/run.lua`.

**Not invented:** Director Console, Decree, Event theater, Event Mode toast kinds.

**No commit made.**

## Files changed

| Action | Path |
|--------|------|
| Edited | `addon/ChurchOfBeef/UI/MainFrame.lua` |
| Edited | `addon/ChurchOfBeef/UI/Toasts.lua` |
| Rewritten | `tests/test_ui.lua` |
| Written | `docs/reformation/phase-1/reports/P1-L-ui-leftovers.md` (this file) |

## What was excised

- **Tab registry** — `RegisterTab`, `ShowTab`, `GetTabNames`, `UpdateOfficerVisibility`, `officerOnly` chrome, `PanelTabButtonTemplate` build/layout, gold/idle tab paint, `MarkDirty` / `_RefreshActive`. `/beef` is a tabless Quiet shell.
- **`ClassColorCode`** — roster-generation cache that walked `Roster:GetLadderView()`. Gone. No live UI caller remained.
- **Promote / rite toast kinds** — removed from `KINDS`. `Celebrate("promote"|"rite", { name, title, … })` mints no copy (`false, "invalid"`). Unknown kind with explicit `text` still falls through to `system` (engine leftover, not a kind family).

**Eternal Grazing.** was already gone (footer `""`). Left it gone. Status.lua not touched.

## What was kept

- Insecure `BasicFrameTemplate` under `UIParent`: drag, resize, clamp, size/point SV, `ResetSize`, empty content host, paint / roster coalesce ≤10 Hz.
- `RefreshLadder` name (BeefNet still calls it). Body is optional `Minimap:Refresh` only.
- Toast engine: queue, priority, interrupt, dedupe, motion. Kinds: `system`, `debug`. `Push` / `Show` / `Celebrate` (system/debug / plain string only).
- Status chip path unchanged (guild / roster / version-mismatch). Not a standing feed.

`/beef` opens this empty frame. It is not a Director Console.

## Verification

Isolated `tests/test_ui.lua` (Common + assert helpers + suite): **135 passed, 0 failed**.

No `OPEN_QUESTIONS.md` item appended.

## Leftover callers (not fixed)

| File | What remains |
|------|----------------|
| `Net/BeefNet.lua` | `COB.UI:RefreshLadder()` — still valid; paints no tabs. `Celebrate("suggest", …)` without `text` still no-ops (Lane E). Out of this lane. |
| `Core/Roster.lua` | `GetLadderView()` still exists. This lane cut the last UI walker. Roster lane owns the function. |
| `UI/MainFrame.lua` | `UI.Palette.Gold` / `IdleTab` unused after tab chrome died. Not presented. |

## Concerns

1. **In-game `/reload` smoke was not run.** Owner: David (GATE1 §3e). Harness cannot prove Law 6 in the client.
2. **`/beef` still opens a frame** (empty content, title + optional status chip). Allowed. Not Quiet-only presence. Not a Director Console or Decree.
3. **Toast engine can still fire** if an out-of-lane caller `Push`es `system`/`debug` or a string. Quiet Mode contract: this file does not drive itself. No Event Mode kinds were added.
4. **Palette leftover keys** (`Gold`, `IdleTab`) are unused. Not tab IA. Not cut so this lane would not restyle chrome.
