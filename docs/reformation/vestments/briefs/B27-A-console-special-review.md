Spec PASS

# B27-A — Console Init early-return remounts ESC (review)

**Quality:** Approved-with-nits

**Lane:** B27-A Console Init early-return remounts ESC
**Brief:** `docs/reformation/vestments/briefs/B27-A-console-special.md`
**Writer report:** `docs/reformation/vestments/briefs/B27-A-console-special-report.md`
**Diff:** `docs/reformation/vestments/briefs/B27-A-console-special.diff` (B27-A-only exclusive-pair packet; live `Console.lua` also carries earlier console batches vs HEAD)
**Exclusive files:** `addon/ChurchOfBeef/UI/Console.lua`, `tests/test_console.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, the provided exclusive-pair diff, live `UI/Console.lua` (`Init` / `rememberSpecial` / `buildFrame` / `Show` / `Hide` / `Toggle` / `Refresh` / `ResetForTests` / `FRAME_NAME`), and `tests/test_console.lua` (isolation wrap, nested `runB27A()` inside `runB8E()` after `runB26A()`); then ran `lua tests/test_console.lua` (**1970 passed, 0 failed**, exit 0, Lua 5.1.5) and throwaway probes that do not live in the exclusive files. Law cited: wiki ESC (named frame on `UISpecialFrames`; do **not** PlaySound `IG_CHARACTER_INFO_*`); Law 6 / §19.4 (Quiet is silent; no panel whoosh); Law 10 / Bible §19.3 (functional / stock desk); Bible §18.1 Director Console; B14-D leftover (`rememberSpecial` lived only in `buildFrame`; a wiped list then second Init never put `ChurchOfBeefConsoleFrame` back). On the early-return path: `rememberSpecial(FRAME_NAME)` then return the existing frame. Do not rebuild. `SaveNote` stays nil. Nest `runB8E()`. Did not mutate `Console.lua` or `test_console.lua`. Did not commit. Did not edit Dock, glue, TOC, `ChurchOfBeef.lua`, or `tests/run.lua`.

This review does not sign the lane.

---

## Named risks

| Risk | Verdict |
|---|---|
| `Init` early-return still skips `rememberSpecial` (B14-D leftover; wiped list stays empty) | **Pass. Verified.** Live `if self.frame then` calls `rememberSpecial(FRAME_NAME)` then `return self.frame`. Pin: wipe `UISpecialFrames` to `{}` then second Init lists `ChurchOfBeefConsoleFrame` exactly once. Reviewer probe matches, including a third Init still once. |
| Second Init rebuilds (`buildFrame` / `CreateFrame`) | **Pass. Verified.** Early-return is before the `CreateFrame` guard and before `buildFrame`. Same frame pointer. Wrapped `CreateFrame` saw 0 calls. Source pin: early-return body has no `buildFrame` / `CreateFrame`. Reviewer probe: pointer identity holds; forced `Console.frame = nil` is what mints a new widget. |
| Wipe remount duplicates the name | **Pass. Verified.** `rememberSpecial` is still scan-then-append. Second Init after wipe is 1. Third Init after wipe is 1. B14-D uniqueness pin still runs first (count 1 before wipe). Reviewer probe: forced rebuild after remount still counts 1. |
| `SaveNote` defined; `PlaySound` / `IG_CHARACTER_INFO_*`; SUMMON / parchment / tabs | **Pass.** `Console.SaveNote` nil before and after the nested block. Live source has no `PlaySound`, no `IG_CHARACTER_INFO`, no `function Console:SaveNote`, no `SUMMON THE FAITHFUL`, no `Parchment`, no `PanelTabButtonTemplate`. Chrome pins: no SUMMON / COPY SUMMARY / WHISPER ALL / RSVP. |
| New main-chunk locals / not nested in `runB8E()` | **Pass.** `runB27A()` is a nested `local function` inside `runB8E()` after `runB26A()`. Packet adds no main-chunk `local`. Header comment only at file top. No new file locals in `Console.lua`. |
| Isolated suite not exit 0 | **Pass. Verified.** 1970 passed, 0 failed. Writer-reported count matches. |
| Exclusive file breach (Dock / glue this lane) | **Pass.** Lane packet is two exclusive hunks (header remount note + early-return `rememberSpecial`; header comment + nested `runB27A()`). Workspace Dock / MainFrame / TOC / bootstrap / `tests/run.lua` dirt vs HEAD is other lanes, not this packet. |
| B14-D uniqueness / B26-A pair-clear dropped | **Pass.** `runB14D()` and `runB26A()` still run inside `runB8E()` before `runB27A()`. Nested B27-A re-pins first-create uniqueness and the two B26-A success-block strings. Isolated suite **1970 / 0**. |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; no Dock / glue; no commit | **Pass.** Named-risk check. |
| Isolation wrap stays | **Pass.** Nine `dofile`s unchanged. Load wrap still **17** nil-module pins under `if standalone then`. |
| `Init` early-return calls `rememberSpecial(FRAME_NAME)` then returns the existing frame | **Pass.** Named-risk check. |
| Do not rebuild | **Pass.** Named-risk check. |
| Wipe `UISpecialFrames` to `{}` then second Init lists `ChurchOfBeefConsoleFrame` exactly once; same frame pointer | **Pass.** Nested pins + reviewer probe. Third Init still once. |
| First-create uniqueness / B14-D / B26-A pins stay | **Pass.** Named-risk check. |
| `SaveNote` stays nil | **Pass.** Named-risk check. |
| No `PlaySound` / `IG_CHARACTER_INFO_*` | **Pass.** Named-risk check. |
| Nest `runB27A()` inside `runB8E()` after `runB26A()`; no new main-chunk locals | **Pass.** Named-risk check. |
| Isolation wrap stays; `lua tests/test_console.lua` exit 0 | **Pass.** **1970 / 0.** |

Wiki ESC holds on the exclusive pair: the named desk is remounted onto `UISpecialFrames` when `Init` is called again after the list is gone. Law 6 / §19.4 hold: no panel whoosh. Law 10 / §19.3 hold: stock desk, no parchment / tabs / SUMMON. License 4 holds: `SaveNote` stays nil. B14-D scan-then-append stays; this lane only adds the early-return remount.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| `Refresh` / `Show` / `Toggle` on an existing frame still skip `rememberSpecial` | **Leftover, not must-fix.** Brief scoped `Init` early-return. See Important leftover. |
| `ResetForTests` does not nil `Console.frame` | **On contract.** Wipe remount uses the existing pointer. Idempotent Init is the path the brief named. |
| No client / two-client smoke; harness membership counts, not `CloseSpecialWindows`; `Hide()` is a direct call | **Not a miss.** Brief asked the isolated suite plus wipe-then-second-Init. |
| Full `lua tests/run.lua` not run | **Not a miss.** Exclusive lane; `run.lua` not edited. |
| Lane is unsigned; no Gate or POLISH claim | **On contract.** This review does not sign the lane. |

---

## Isolation / remount / keep

**Isolation wrap — Pass.** Load list is still Common + Ranks + Runtime + Store + Gora + Knighting + Sender + Decree + Console. No `dofile` of Confession, MainFrame, Dock, Toasts, Sound, Hud, Net, DB, or glue. Standalone wrap is still 17 nils (UI, DB, Net, Officer, Archive, Recognition, Roster, Popes, Hud, Sound, DecreeBanner, RecordsBook, Minimap, Toasts, Codec, Snapshot, Confession). Reviewer probe: those keys are nil at load. Wrap is load-time only (unchanged). Nested B27-A re-pins Archive / UI / Toasts / Confession / Popes after restore.

**Remount — Pass.** Early-return remounts then returns the same widget. It does not depend on `CreateFrame` still being a function. `rememberSpecial` still type-guards the table, scans, and appends once. Reviewer probe: wipe to `{}` then second Init lists the name once and does not call `CreateFrame`. Third Init still once. Forced rebuild after remount still unique. No `ChurchOfBeefConsoleFrame*` scroll-child names on the list.

**Keep — Pass.** Create path is unchanged: `buildFrame` still calls `rememberSpecial(FRAME_NAME)` once. B14-D uniqueness still green. B26-A successful Start / End still nil the selected pair before `after()`. B13-D `stockEdit` still ClearFocus-only. `SaveNote` stays nil. No `PlaySound`.

---

## Strengths

- The production delta is the brief: three lines on the existing early-return. `rememberSpecial` is reused. `buildFrame` is not re-entered. No new locals, chrome, or sound.
- B14-D's leftover (wiped list then second Init never put the name back) is closed on the same named desk, not a second register helper.
- Same-pointer / wrapped-`CreateFrame` / third-Init-still-once pins mean a rebuild-and-re-register would fail, and a bare append without dedupe would fail the third Init.
- Early-return sits **before** the `CreateFrame` guard, so a remount does not drop the widget if `CreateFrame` is missing.
- Isolation wrap was not rewritten. `runB27A()` is nested inside `runB8E()` after `runB26A()`.
- Writer-reported **1970 / 0** matched the re-run. Writer-reported first red (**1967 / 3**) matches a skip-`rememberSpecial` early-return (wiped list stayed 0 after second / third Init).

---

## Issues

### Critical

None.

### Important (leftover — not must-fix)

1. **`Refresh` / `Show` / `Toggle` on an existing frame still skip `rememberSpecial`.** Reviewer probe: wipe to `{}` then `Refresh`, `Show`, or hidden-`Toggle` leaves the list empty; only a later `Init` puts `ChurchOfBeefConsoleFrame` back. `Show` / `Toggle` call `Init` only when `self.frame` is nil. Brief scoped Init. Overview parks one Console leftover this batch. Not Dock. Not glue.

### Nit

1. **`"buildFrame still rememberSpecial FRAME_NAME"` is a whole-file find.** The early-return itself satisfies `srcEscBody:find("rememberSpecial(FRAME_NAME)")`. A deleted `buildFrame` call would still pass that pin. Live `buildFrame` still has the call (line 790). Create-path uniqueness pins in `runB14D()` are what keep it.

2. **Wipe to `nil` (not `{}`) no-ops.** `rememberSpecial` returns when `UISpecialFrames` is not a table and does not mint one. Brief asked wipe to `{}`. Probe: same frame pointer; list stays absent until an empty table is restored.

3. **Isolation wrap is load-only.** Seventeen pins under `if standalone then` at file load. Nested B27-A re-pins four of them plus Popes after restore. Brief said the wrap stays; it did.

4. **Exclusive-pair diff is not a vs-HEAD Console delta.** Packet is the B27-A-only remount + nested pins. `git diff HEAD` on the two files still includes earlier console batches. Report already says this.

5. **No `/reload` smoke and no full `lua tests/run.lua`.** Isolated **1970 / 0** was re-run here. Real ESC vs focused EditBox vs `CloseSpecialWindows` on the named desk is unproven on Anniversary. A live remount that dropped the name is simulated by `UISpecialFrames = {}`.

6. **`ResetForTests` still does not nil `Console.frame`.** On contract. The wipe remount uses the existing pointer; a rebuild still requires the harness to nil the widget.

---

## Must-fix

None.

---

## Assessment

**Spec PASS. Quality: Approved-with-nits.**

**Must-fix:** none.

**Isolated count:** **1970 passed, 0 failed.** Isolation wrap: **17**.

`Init` early-return calls `rememberSpecial(FRAME_NAME)` then returns the existing frame. Wipe `UISpecialFrames` to `{}` then second Init lists `ChurchOfBeefConsoleFrame` exactly once. Same pointer. No rebuild. `SaveNote` stays nil. No `PlaySound` / `IG_CHARACTER_INFO_*`. `runB27A()` is nested inside `runB8E()`. Isolated `lua tests/test_console.lua` **1970 passed, 0 failed**, exit 0. `Refresh` / `Show` / `Toggle` remount remains parked.

Do not claim V1 / MVP complete. This review does not sign the lane.
