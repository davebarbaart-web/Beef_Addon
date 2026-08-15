# Phase 1 Lane F — Strip ladder/standing IA from the shell

**Status:** DONE (exclusive files). Cross-lane harness/TOC still red.

**Cited:** Ten Laws 6; Bible §4.8, §19.1; Audit: salvage MainFrame plumbing, discard IA; brief `docs/reformation/phase-1/briefs/P1-F-shell.md`.

**Not edited (per brief):** Toasts, Minimap, StandingTab, TOC, bootstrap, `tests/run.lua`.

**Not invented:** Director Console, Decree banner, Event theater.

**No commit made.**

## Files changed

| Action | Path |
|--------|------|
| Deleted | `addon/ChurchOfBeef/UI/LadderTab.lua` |
| Deleted | `addon/ChurchOfBeef/UI/OfficerTab.lua` |
| Deleted | `addon/ChurchOfBeef/UI/Announce.lua` |
| Deleted | `tests/test_officer_ui.lua` |
| Edited | `addon/ChurchOfBeef/UI/MainFrame.lua` |
| Edited | `addon/ChurchOfBeef/UI/Status.lua` |
| Rewritten | `tests/test_ui.lua` |
| Written | `docs/reformation/phase-1/reports/P1-F-shell.md` (this file) |

## What was excised

- **Ladder tab** — institutional band list, Find, heavy viewport. File gone; nothing registers `ladder`.
- **Officer tab** — promote-prompt queue, Dismiss, standing correction. File gone; nothing registers `officer`.
- **Announce** — promote / demote / council / prophet guild-chat spectacle. Unused in production (`Deferred`); deleted rather than stubbed.
- **Status ladder banners** — `ShowsLearningBanner` / `ShowsHardGateBanner` and `MarkDirty("ladder")` on present. Chip is guild / roster / version-mismatch only. No standing, points, or grant copy.
- **`test_officer_ui.lua`** — standing/officer-queue only; deleted.

## What was kept (MainFrame plumbing)

- Insecure `BasicFrameTemplate` under `UIParent` so `/beef` opens in combat.
- Drag (title bar), resize (grip + Classic min/max bounds), size/point SV, clamp, `ResetSize`.
- Paint / roster coalesce ≤10 Hz.
- Empty content host. No product tabs. Tab *registry* remains as plumbing (`RegisterTab` / `ShowTab` / `MarkDirty`) so a later surface can register without this lane inventing one.
- `RefreshLadder` name kept (BeefNet still calls it). Body is `MarkDirty()` + optional `Minimap:Refresh`.
- Status chip: unguilded / roster-wait / ready / version-mismatch. Not a standing feed.

`/beef` opens this minimal frame. It is not a Director Console.

## Verification

Isolated `tests/test_ui.lua`: **119 passed, 0 failed**.

`lua tests/run.lua` is red on this branch from parallel Phase 1 cuts (missing Ladder / attic suites, plus this lane’s deleted `test_officer_ui` and Lane E’s deleted `test_standing_ui`). Out of lane to repair `run.lua` or TOC.

No `OPEN_QUESTIONS.md` item appended. The brief already allows a minimal `/beef` frame.

## Leftover callers (not fixed)

Integrator-owned:

| File | What remains |
|------|----------------|
| `addon/ChurchOfBeef/ChurchOfBeef.toc` | still lists `UI\Announce.lua`, `UI\LadderTab.lua`, `UI\OfficerTab.lua` (and Lane E’s `UI\StandingTab.lua`) |
| `tests/run.lua` | still lists `"test_officer_ui"` (and Lane E’s `"test_standing_ui"`) |

Other modules (nil-safe or comments only):

| File | What remains |
|------|----------------|
| `Net/BeefNet.lua` | `COB.UI:RefreshLadder()` — still valid; paints no tabs |
| `Core/DB.lua` | `ui.announce` default / migrate — unused with Announce gone |

No live Lua under `addon/` other than the TOC still references the deleted tab/announce files.

## Concerns

1. **TOC still lists the deleted files.** Client load will fail until the TOC owner drops `Announce`, `LadderTab`, `OfficerTab` (and StandingTab). This lane was forbidden to edit the TOC.
2. **`tests/run.lua` still lists `test_officer_ui`.** The runner treats a listed-but-missing suite as a fail.
3. **`/beef` still opens a frame** (empty content, title + footer + optional status chip). Allowed by the brief. Not a no-op-to-minimap. Not Quiet-only presence. Not a Director Console or Decree.
4. **Tab registry plumbing remains.** With Ladder/Officer/Standing files gone, nothing registers product tabs. A later lane could register one without this file growing IA again.
5. **In-game `/reload` smoke was not run.** TOC is already unloadable from parallel deletions; installing now would not prove the shell.
6. **Footer copy `"Eternal Grazing."` is pre-existing**, not new theater. Status version-mismatch copy stays on the player-opened frame chip (not a Quiet toast).
