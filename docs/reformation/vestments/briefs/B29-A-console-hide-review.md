Spec PASS

# B29-A — Console Hide remounts ESC (review)

**Quality:** nits

**Lane:** B29-A Console Hide remounts ESC
**Brief:** `docs/reformation/vestments/briefs/B29-A-console-hide.md`
**Writer report:** `docs/reformation/vestments/briefs/B29-A-console-hide-report.md`
**Diff:** `docs/reformation/vestments/briefs/B29-A-console-hide.diff` (B29-A-only exclusive-pair packet; live `Console.lua` also carries earlier console batches vs HEAD)
**Exclusive files:** `addon/ChurchOfBeef/UI/Console.lua`, `tests/test_console.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, the provided exclusive-pair diff, live `UI/Console.lua` (`Hide` / `Toggle` / `rememberSpecial` / `Show` / `Refresh` / `Init` / `ResetForTests` / `FRAME_NAME`), and `tests/test_console.lua` (isolation wrap, nested `runB29A()` inside `runB8E()` after `runB28A()`); then ran `lua tests/test_console.lua` (**2085 passed, 0 failed**, exit 0, Lua 5.1.5) and throwaway probes that do not live in the exclusive files. Law cited: wiki ESC (named frame on `UISpecialFrames`; do **not** PlaySound `IG_CHARACTER_INFO_*`); Law 6 / §19.4 (Quiet is silent; no panel whoosh); Law 10 / Bible §19.3 (functional / stock desk); Bible §18.1 Director Console; B28 leftover (`Toggle` / `Hide` skipped `rememberSpecial`; a wiped list then Hide-only or Toggle-hide never put `ChurchOfBeefConsoleFrame` back). When the frame exists, `Hide` calls `rememberSpecial(FRAME_NAME)` then hides. Do not rebuild. Show / Refresh / Init remount stay. `SaveNote` stays nil. Nest `runB8E()`. One Console leftover this batch (this is it). Did not mutate `Console.lua` or `test_console.lua`. Did not commit. Did not edit Dock, glue, TOC, `ChurchOfBeef.lua`, or `tests/run.lua`.

This review does not sign the lane.

---

## Named risks

| Risk | Verdict |
|---|---|
| `Hide` still skips `rememberSpecial` (B28 leftover; wiped list stays empty) | **Pass. Verified.** Live `Hide` (after the frame-exists guard) calls `rememberSpecial(FRAME_NAME)` then `self.frame:Hide()`. Pin: wipe `UISpecialFrames` to `{}` then Hide-only lists `ChurchOfBeefConsoleFrame` exactly once. Reviewer probe matches, including a third Hide still once. |
| Toggle-hide still skips remount | **Pass. Verified.** Live `Toggle` calls `Hide` when shown. Nested pin: widget `Show` (not `Console:Show`), wipe again, Toggle while shown lists the name once and hides. Reviewer probe matches. |
| Hide / Toggle rebuild (`buildFrame` / `CreateFrame`) | **Pass. Verified.** Same frame pointer after Hide-only and Toggle-hide. Wrapped `CreateFrame` saw 0 calls on both remounts. Source pins: Hide body has no `buildFrame` / `CreateFrame` / `PlaySound`. Reviewer probe: pointer identity holds; forced `Console.frame = nil` is what mints a new widget. |
| Wipe remount duplicates the name | **Pass. Verified.** `rememberSpecial` is still scan-then-append. Hide-only after wipe is 1. Toggle-hide after wipe is 1. Third Hide still 1. B14-D uniqueness pin still runs first (count 1 before wipe). Reviewer probe: forced rebuild after remount still counts 1. |
| `SaveNote` defined; `PlaySound` / `IG_CHARACTER_INFO_*`; SUMMON / parchment / tabs | **Pass.** `Console.SaveNote` nil before and after the nested block. Live source has no `PlaySound`, no `IG_CHARACTER_INFO`, no `function Console:SaveNote`, no `SUMMON THE FAITHFUL`, no `Parchment`, no `PanelTabButtonTemplate`. Chrome pins: no SUMMON / COPY SUMMARY / WHISPER ALL / RSVP. |
| New main-chunk locals / not nested in `runB8E()` | **Pass.** `runB29A()` is a nested `local function` inside `runB8E()` after `runB28A()`. Packet adds no main-chunk `local`. Header comment only at file top. No new file locals in `Console.lua`. |
| Isolated suite not exit 0 | **Pass. Verified.** 2085 passed, 0 failed. Writer-reported count matches. |
| Exclusive file breach (Dock / glue this lane) | **Pass.** Lane packet is two exclusive hunks (header remount note + Hide `rememberSpecial`; header comment + nested `runB29A()`). Workspace Dock / MainFrame / TOC / bootstrap / `tests/run.lua` dirt vs HEAD is other lanes, not this packet. |
| B28-A Show/Refresh / B27-A Init remount / B14-D uniqueness / B26-A pair-clear dropped | **Pass.** `runB14D()`, `runB26A()`, `runB27A()`, and `runB28A()` still run inside `runB8E()` before `runB29A()`. Nested B29-A re-pins Init / Show / Refresh remount, first-create uniqueness, and the two B26-A success-block strings. Isolated suite **2085 / 0**. |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; no Dock / glue; no commit | **Pass.** Named-risk check. |
| Isolation wrap stays | **Pass.** Nine `dofile`s unchanged. Load wrap still **17** nil-module pins under `if standalone then`. |
| When the frame exists, `Hide` calls `rememberSpecial(FRAME_NAME)` then hides | **Pass.** Named-risk check. |
| Toggle-hide remounts via Hide | **Pass.** Named-risk check. |
| Do not rebuild | **Pass.** Named-risk check. |
| Wipe `UISpecialFrames` to `{}` then Hide-only lists `ChurchOfBeefConsoleFrame` exactly once; wipe again, Toggle while shown lists it once; same frame pointer | **Pass.** Nested pins + reviewer probe. Third Hide still once. |
| Show / Refresh remount (B28-A) / Init remount (B27-A) / B14-D uniqueness / B26-A pins stay | **Pass.** Named-risk check. |
| `SaveNote` stays nil | **Pass.** Named-risk check. |
| No `PlaySound` / `IG_CHARACTER_INFO_*` | **Pass.** Named-risk check. |
| Nest `runB29A()` inside `runB8E()` after `runB28A()`; no new main-chunk locals | **Pass.** Named-risk check. |
| Isolation wrap stays; `lua tests/test_console.lua` exit 0 | **Pass.** **2085 / 0.** |

Wiki ESC holds on the exclusive pair: the named desk is remounted onto `UISpecialFrames` when `Hide` runs after the list is gone. Toggle-hide remounts because Toggle calls Hide. Law 6 / §19.4 hold: no panel whoosh. Law 10 / §19.3 hold: stock desk, no parchment / tabs / SUMMON. License 4 holds: `SaveNote` stays nil. B14-D scan-then-append stays. B28-A Show / Refresh remount stays. B27-A Init remount stays. This lane only adds the Hide remount. The one Console leftover this batch is closed.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| No client / two-client smoke; harness membership counts, not `CloseSpecialWindows`; `Hide()` / `Toggle()` are direct calls | **Not a miss.** Brief asked the isolated suite plus wipe-then-Hide-only / Toggle-hide. |
| ESC still walks names and calls `Frame:Hide`, not `Console:Hide` | **Nit, not leftover.** After a wipe, ESC cannot see the desk until something remounts. Hide remount recovers Toggle / close. Claiming Toggle-hide still skips is stale. |
| Full `lua tests/run.lua` not run | **Not a miss.** Exclusive lane; `run.lua` not edited. |
| `ResetForTests` does not nil `Console.frame` | **On contract.** Wipe remount uses the existing pointer. Idempotent Hide is the path the brief named. `ResetForTests` already called `Hide`; it now remounts as a side effect. |
| Lane is unsigned; no Gate or POLISH claim | **On contract.** This review does not sign the lane. |

---

## Isolation / remount / keep

**Isolation wrap — Pass.** Load list is still Common + Ranks + Runtime + Store + Gora + Knighting + Sender + Decree + Console. No `dofile` of Confession, MainFrame, Dock, Toasts, Sound, Hud, Net, DB, or glue. Standalone wrap is still 17 nils (UI, DB, Net, Officer, Archive, Recognition, Roster, Popes, Hud, Sound, DecreeBanner, RecordsBook, Minimap, Toasts, Codec, Snapshot, Confession). Reviewer probe: those keys are nil at load. Wrap is load-time only (unchanged). Nested B29-A re-pins Archive / UI / Toasts / Confession / Popes after restore.

**Remount — Pass.** Hide remounts then hides. It does not depend on `CreateFrame` still being a function. `rememberSpecial` still type-guards the table, scans, and appends once. Toggle-hide remounts only because Toggle calls Hide. Reviewer probe: wipe to `{}` then Hide-only lists the name once and does not call `CreateFrame`. Third Hide still once. Wipe again, Toggle-hide lists it once, hides, and does not call `CreateFrame`. Hide with `Console.frame` nil does not remount. Show / Refresh / Init remount still once after a later wipe. Forced rebuild after remount still unique. No `ChurchOfBeefConsoleFrame*` scroll-child names on the list.

**Keep — Pass.** Create path is unchanged: `buildFrame` still calls `rememberSpecial(FRAME_NAME)` once. Show / Refresh remount (B28-A) stay. Init early-return remount (B27-A) stays. B14-D uniqueness still green. B26-A successful Start / End still nil the selected pair before `after()`. B13-D `stockEdit` still ClearFocus-only. `SaveNote` stays nil. No `PlaySound`.

---

## Strengths

- The production delta is the brief: one `rememberSpecial(FRAME_NAME)` on the existing Hide path. `rememberSpecial` is reused. `buildFrame` is not re-entered. No new locals, chrome, or sound.
- B28's leftover (wiped list then Hide-only or Toggle-hide never put the name back) is closed on the same named desk, not a second register helper. Show / Refresh / Init remount stay.
- Toggle-hide is isolated from Show remount: the nested pin uses widget `Show`, wipes again, then Toggle. A Hide remount that forgot Toggle would fail that pin.
- Same-pointer / wrapped-`CreateFrame` / third-Hide-still-once pins mean a rebuild-and-re-register would fail, and a bare append without dedupe would fail the third Hide.
- Hide remount sits after the nil-frame return, so a hide with no desk does not touch the list.
- Isolation wrap was not rewritten. `runB29A()` is nested inside `runB8E()` after `runB28A()`.
- Writer-reported **2085 / 0** matched the re-run. Writer-reported first red (**2082 / 3**) matches a skip-`rememberSpecial` Hide (source pin plus wiped list stayed 0 after Hide-only / Toggle-hide).

---

## Issues

### Critical

None.

### Important (leftover — not must-fix)

None. The one Console leftover this batch (Hide / Toggle-hide remount) is closed. A claim that Toggle-hide still skips `rememberSpecial` is stale.

### Nit

1. **`"buildFrame still rememberSpecial FRAME_NAME"` is a whole-file find.** Hide / Show / Refresh / Init early-return themselves satisfy `srcEscBody:find("rememberSpecial(FRAME_NAME)")`. A deleted `buildFrame` call would still pass that pin. Live `buildFrame` still has the call (line 790). Create-path uniqueness pins in `runB14D()` are what keep it.

2. **Wipe to `nil` (not `{}`) no-ops.** `rememberSpecial` returns when `UISpecialFrames` is not a table and does not mint one. Brief asked wipe to `{}`. Probe: same frame pointer; list stays absent until an empty table is restored.

3. **Isolation wrap is load-only.** Seventeen pins under `if standalone then` at file load. Nested B29-A re-pins four of them plus Popes after restore. Brief said the wrap stays; it did.

4. **Exclusive-pair diff is not a vs-HEAD Console delta.** Packet is the B29-A-only remount + nested pins. `git diff HEAD` on the two files still includes earlier console batches. Report already says this.

5. **No `/reload` smoke and no full `lua tests/run.lua`.** Isolated **2085 / 0** was re-run here. Real ESC vs focused EditBox vs `CloseSpecialWindows` on the named desk is unproven on Anniversary. A live remount that dropped the name is simulated by `UISpecialFrames = {}`. ESC still walks names and calls `Frame:Hide`, not `Console:Hide`.

6. **`ResetForTests` still does not nil `Console.frame`.** On contract. The wipe remount uses the existing pointer; a rebuild still requires the harness to nil the widget. `ResetForTests` already called `Hide`; it now remounts as a side effect.

---

## Must-fix

None.

---

## Leftover list

- **No client smoke.** Real ESC vs focused EditBox vs `CloseSpecialWindows` is unproven on Anniversary. Nit / not a miss.
- **Harness membership, not the client walk.** `Hide()` / `Toggle()` in this suite are direct calls. ESC still walks names and calls `Frame:Hide`, not `Console:Hide`. Nit. Not a remaining Console remount leftover.
- **Full `lua tests/run.lua` not run.** Exclusive lane. Not a miss.
- **`ResetForTests` does not nil `Console.frame`.** On contract.
- **Toggle-hide skip is closed.** A leftover claim that Toggle-hide still skips `rememberSpecial` is stale (nit, not FAIL).

---

## Assessment

**Spec PASS. Quality: nits.**

**Must-fix:** none.

**Isolated count:** **2085 passed, 0 failed.** Isolation wrap: **17**.

`Hide` calls `rememberSpecial(FRAME_NAME)` when the frame exists, then hides. Wipe `UISpecialFrames` to `{}` then Hide-only lists `ChurchOfBeefConsoleFrame` exactly once. Wipe again, Toggle while shown lists it once. Same pointer. No rebuild. `SaveNote` stays nil. No `PlaySound` / `IG_CHARACTER_INFO_*`. Show / Refresh / Init remount stay. `runB29A()` is nested inside `runB8E()`. Isolated `lua tests/test_console.lua` **2085 passed, 0 failed**, exit 0. The one Console leftover this batch is closed.

Do not claim V1 / MVP complete. This review does not sign the lane.
