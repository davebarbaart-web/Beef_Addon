Spec PASS

# B28-A — Console Show / Refresh remount ESC (review)

**Quality:** Approved-with-nits

**Lane:** B28-A Console Show / Refresh remount ESC
**Brief:** `docs/reformation/vestments/briefs/B28-A-console-show.md`
**Writer report:** `docs/reformation/vestments/briefs/B28-A-console-show-report.md`
**Diff:** `docs/reformation/vestments/briefs/B28-A-console-show.diff` (B28-A-only exclusive-pair packet; live `Console.lua` also carries earlier console batches vs HEAD)
**Exclusive files:** `addon/ChurchOfBeef/UI/Console.lua`, `tests/test_console.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, the provided exclusive-pair diff, live `UI/Console.lua` (`Show` / `Refresh` / `rememberSpecial` / `Init` / `Hide` / `Toggle` / `ResetForTests` / `FRAME_NAME`), and `tests/test_console.lua` (isolation wrap, nested `runB28A()` inside `runB8E()` after `runB27A()`); then ran `lua tests/test_console.lua` (**2026 passed, 0 failed**, exit 0, Lua 5.1.5) and throwaway probes that do not live in the exclusive files. Law cited: wiki ESC (named frame on `UISpecialFrames`; do **not** PlaySound `IG_CHARACTER_INFO_*`); Law 6 / §19.4 (Quiet is silent; no panel whoosh); Law 10 / Bible §19.3 (functional / stock desk); Bible §18.1 Director Console; B27 leftover (`Refresh` / `Show` / `Toggle` skipped `rememberSpecial`; a wiped list then Show-only or Refresh-only never put `ChurchOfBeefConsoleFrame` back). When the frame exists, `Show` and `Refresh` call `rememberSpecial(FRAME_NAME)`. Do not rebuild. Init remount (B27-A) stays. `SaveNote` stays nil. Nest `runB8E()`. Did not mutate `Console.lua` or `test_console.lua`. Did not commit. Did not edit Dock, glue, TOC, `ChurchOfBeef.lua`, or `tests/run.lua`.

This review does not sign the lane.

---

## Named risks

| Risk | Verdict |
|---|---|
| `Show` / `Refresh` still skip `rememberSpecial` (B27 leftover; wiped list stays empty) | **Pass. Verified.** Live `Show` (after the frame-exists guard) and `Refresh` (after `if not self.frame then return end`) call `rememberSpecial(FRAME_NAME)`. Pin: wipe `UISpecialFrames` to `{}` then Show-only lists `ChurchOfBeefConsoleFrame` exactly once. Wipe again, Refresh-only lists it once. Reviewer probe matches, including a third Show / later Refresh still once. |
| Show / Refresh rebuild (`buildFrame` / `CreateFrame`) | **Pass. Verified.** Same frame pointer after Show-only and Refresh-only. Wrapped `CreateFrame` saw 0 calls on both remounts. Source pins: Show and Refresh bodies have no `buildFrame` / `CreateFrame`. Reviewer probe: pointer identity holds; forced `Console.frame = nil` is what mints a new widget. |
| Wipe remount duplicates the name | **Pass. Verified.** `rememberSpecial` is still scan-then-append. Show-only after wipe is 1 (Show remounts, then Refresh remounts again). Refresh-only after wipe is 1. Third Show still 1. B14-D uniqueness pin still runs first (count 1 before wipe). Reviewer probe: forced rebuild after remount still counts 1. |
| `SaveNote` defined; `PlaySound` / `IG_CHARACTER_INFO_*`; SUMMON / parchment / tabs | **Pass.** `Console.SaveNote` nil before and after the nested block. Live source has no `PlaySound`, no `IG_CHARACTER_INFO`, no `function Console:SaveNote`, no `SUMMON THE FAITHFUL`, no `Parchment`, no `PanelTabButtonTemplate`. Chrome pins: no SUMMON / COPY SUMMARY / WHISPER ALL / RSVP. |
| New main-chunk locals / not nested in `runB8E()` | **Pass.** `runB28A()` is a nested `local function` inside `runB8E()` after `runB27A()`. Packet adds no main-chunk `local`. Header comment only at file top. No new file locals in `Console.lua`. |
| Isolated suite not exit 0 | **Pass. Verified.** 2026 passed, 0 failed. Writer-reported count matches. |
| Exclusive file breach (Dock / glue this lane) | **Pass.** Lane packet is two exclusive hunks (header remount note + Show / Refresh `rememberSpecial`; header comment + nested `runB28A()`). Workspace Dock / MainFrame / TOC / bootstrap / `tests/run.lua` dirt vs HEAD is other lanes, not this packet. |
| B27-A Init remount / B14-D uniqueness / B26-A pair-clear dropped | **Pass.** `runB14D()`, `runB26A()`, and `runB27A()` still run inside `runB8E()` before `runB28A()`. Nested B28-A re-pins Init early-return remount, first-create uniqueness, and the two B26-A success-block strings. Isolated suite **2026 / 0**. |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; no Dock / glue; no commit | **Pass.** Named-risk check. |
| Isolation wrap stays | **Pass.** Nine `dofile`s unchanged. Load wrap still **17** nil-module pins under `if standalone then`. |
| When the frame exists, `Show` and `Refresh` call `rememberSpecial(FRAME_NAME)` | **Pass.** Named-risk check. |
| Do not rebuild | **Pass.** Named-risk check. |
| Wipe `UISpecialFrames` to `{}` then Show-only lists `ChurchOfBeefConsoleFrame` exactly once; wipe again, Refresh-only lists it once; same frame pointer | **Pass.** Nested pins + reviewer probe. Third Show / later Refresh still once. |
| Init remount (B27-A) / B14-D uniqueness / B26-A pins stay | **Pass.** Named-risk check. |
| `SaveNote` stays nil | **Pass.** Named-risk check. |
| No `PlaySound` / `IG_CHARACTER_INFO_*` | **Pass.** Named-risk check. |
| Nest `runB28A()` inside `runB8E()` after `runB27A()`; no new main-chunk locals | **Pass.** Named-risk check. |
| Isolation wrap stays; `lua tests/test_console.lua` exit 0 | **Pass.** **2026 / 0.** |

Wiki ESC holds on the exclusive pair: the named desk is remounted onto `UISpecialFrames` when `Show` or `Refresh` runs after the list is gone. Law 6 / §19.4 hold: no panel whoosh. Law 10 / §19.3 hold: stock desk, no parchment / tabs / SUMMON. License 4 holds: `SaveNote` stays nil. B14-D scan-then-append stays. B27-A Init remount stays. This lane only adds the Show / Refresh remounts.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| `Toggle` on an existing frame still skips `rememberSpecial` | **Leftover, not must-fix.** Brief scoped Show and Refresh. Toggle-show calls Show and remounts; Toggle-hide does not. Overview parks one Console leftover this batch. See Important leftover. |
| `ResetForTests` does not nil `Console.frame` | **On contract.** Wipe remount uses the existing pointer. Idempotent Init / Show / Refresh is the path the brief named. |
| No client / two-client smoke; harness membership counts, not `CloseSpecialWindows`; `Hide()` is a direct call | **Not a miss.** Brief asked the isolated suite plus wipe-then-Show-only / Refresh-only. |
| Full `lua tests/run.lua` not run | **Not a miss.** Exclusive lane; `run.lua` not edited. |
| Lane is unsigned; no Gate or POLISH claim | **On contract.** This review does not sign the lane. |

---

## Isolation / remount / keep

**Isolation wrap — Pass.** Load list is still Common + Ranks + Runtime + Store + Gora + Knighting + Sender + Decree + Console. No `dofile` of Confession, MainFrame, Dock, Toasts, Sound, Hud, Net, DB, or glue. Standalone wrap is still 17 nils (UI, DB, Net, Officer, Archive, Recognition, Roster, Popes, Hud, Sound, DecreeBanner, RecordsBook, Minimap, Toasts, Codec, Snapshot, Confession). Reviewer probe: those keys are nil at load. Wrap is load-time only (unchanged). Nested B28-A re-pins Archive / UI / Toasts / Confession / Popes after restore.

**Remount — Pass.** Show remounts then shows then Refresh (Refresh remounts again). Refresh remounts then paints. Neither rebuilds. They do not depend on `CreateFrame` still being a function. `rememberSpecial` still type-guards the table, scans, and appends once. Reviewer probe: wipe to `{}` then Show-only lists the name once and does not call `CreateFrame`. Wipe again, Refresh-only lists it once and does not call `CreateFrame`. Third Show still once. Forced rebuild after remount still unique. Refresh with `Console.frame` nil does not remount. No `ChurchOfBeefConsoleFrame*` scroll-child names on the list.

**Keep — Pass.** Create path is unchanged: `buildFrame` still calls `rememberSpecial(FRAME_NAME)` once. Init early-return still remounts (B27-A). B14-D uniqueness still green. B26-A successful Start / End still nil the selected pair before `after()`. B13-D `stockEdit` still ClearFocus-only. `SaveNote` stays nil. No `PlaySound`.

---

## Strengths

- The production delta is the brief: one `rememberSpecial(FRAME_NAME)` on the existing Show path and one on Refresh. `rememberSpecial` is reused. `buildFrame` is not re-entered. No new locals, chrome, or sound.
- B27's leftover (wiped list then Show-only or Refresh-only never put the name back) is closed on the same named desk, not a second register helper. Init remount stays.
- Same-pointer / wrapped-`CreateFrame` / third-Show-still-once pins mean a rebuild-and-re-register would fail, and a bare append without dedupe would fail the Show path (Show remounts, then Refresh remounts).
- Refresh remount sits after the nil-frame return, so a paint with no desk does not touch the list. Show remount sits after the frame-exists guard, so a missing widget still goes through Init / create rather than a bare remount.
- Isolation wrap was not rewritten. `runB28A()` is nested inside `runB8E()` after `runB27A()`.
- Writer-reported **2026 / 0** matched the re-run. Writer-reported first red (**2022 / 4**) matches a skip-`rememberSpecial` Show / Refresh (source pins plus wiped list stayed 0 after Show-only / Refresh-only).

---

## Issues

### Critical

None.

### Important (leftover — not must-fix)

1. **`Toggle` on an existing frame still skips `rememberSpecial`.** Toggle-show calls Show and remounts. Reviewer probe: wipe to `{}` then Toggle-hide leaves the list empty; only a later Show / Refresh / Init puts `ChurchOfBeefConsoleFrame` back. `Hide` also skips. Brief scoped Show and Refresh. Overview parks one Console leftover this batch. Not Dock. Not glue.

### Nit

1. **Wipe+Show-only also hits Refresh.** Live `Show` remounts, then `self:Refresh()` remounts again. A deleted Show-body `rememberSpecial` would still pass the wipe+Show count pin. The Show source pin closes that hole; Refresh-only is the isolated Refresh remount.

2. **`"buildFrame still rememberSpecial FRAME_NAME"` is a whole-file find.** Show / Refresh / Init early-return themselves satisfy `srcEscBody:find("rememberSpecial(FRAME_NAME)")`. A deleted `buildFrame` call would still pass that pin. Live `buildFrame` still has the call (line 790). Create-path uniqueness pins in `runB14D()` are what keep it.

3. **Wipe to `nil` (not `{}`) no-ops.** `rememberSpecial` returns when `UISpecialFrames` is not a table and does not mint one. Brief asked wipe to `{}`. Probe: same frame pointer; list stays absent until an empty table is restored.

4. **Isolation wrap is load-only.** Seventeen pins under `if standalone then` at file load. Nested B28-A re-pins four of them plus Popes after restore. Brief said the wrap stays; it did.

5. **Exclusive-pair diff is not a vs-HEAD Console delta.** Packet is the B28-A-only remount + nested pins. `git diff HEAD` on the two files still includes earlier console batches. Report already says this.

6. **No `/reload` smoke and no full `lua tests/run.lua`.** Isolated **2026 / 0** was re-run here. Real ESC vs focused EditBox vs `CloseSpecialWindows` on the named desk is unproven on Anniversary. A live remount that dropped the name is simulated by `UISpecialFrames = {}`.

7. **`ResetForTests` still does not nil `Console.frame`.** On contract. The wipe remount uses the existing pointer; a rebuild still requires the harness to nil the widget.

---

## Must-fix

None.

---

## Assessment

**Spec PASS. Quality: Approved-with-nits.**

**Must-fix:** none.

**Isolated count:** **2026 passed, 0 failed.** Isolation wrap: **17**.

`Show` and `Refresh` call `rememberSpecial(FRAME_NAME)` when the frame exists. Wipe `UISpecialFrames` to `{}` then Show-only lists `ChurchOfBeefConsoleFrame` exactly once. Wipe again, Refresh-only lists it once. Same pointer. No rebuild. `SaveNote` stays nil. No `PlaySound` / `IG_CHARACTER_INFO_*`. Init remount stays. `runB28A()` is nested inside `runB8E()`. Isolated `lua tests/test_console.lua` **2026 passed, 0 failed**, exit 0. `Toggle` remount remains parked.

Do not claim V1 / MVP complete. This review does not sign the lane.
