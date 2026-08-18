Spec PASS

# B15-C — Quiet shell UISpecialFrames dedupe (review)

**Quality:** Approved-with-nits

**Lane:** B15-C Quiet shell UISpecialFrames dedupe
**Brief:** `docs/reformation/vestments/briefs/B15-C-shell-special.md`
**Writer report:** `docs/reformation/vestments/briefs/B15-C-shell-special-report.md`
**Diff:** `docs/reformation/vestments/briefs/B15-C-shell-special.diff` (exclusive-pair packet: `UI/MainFrame.lua` + `tests/test_ui.lua`)
**Exclusive files:** `addon/ChurchOfBeef/UI/MainFrame.lua`, `tests/test_ui.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, the provided exclusive-pair diff, live `UI/MainFrame.lua` (`rememberSpecial` / `UI:Init` / `UI:Toggle` / `BasicFrameTemplate`), live `UI/Decree.lua` (`rememberSpecial` for parity), and `tests/test_ui.lua` (existing Init pin; B12-D Proclaim pins; B15-C nested pins inside `runB12D()`); then ran `lua tests/test_ui.lua` (**368 passed, 0 failed**, exit 0, Lua **5.1.5**) and throwaway probes that do not live in the exclusive files. Law cited: wiki "Make frames closable with the Escape key"; Decree `rememberSpecial`; Bible §14.2 (player-opened Quiet is Records Book); Law 6 / §19.4 (Quiet is silent); Law 10 / §19.3 (functional Quiet shell stays stock `BasicFrameTemplate`); CONTINUE 2026-08-18 license 4 (stock only). Did not mutate `MainFrame.lua` or `test_ui.lua`. Did not commit. Did not edit `Toasts.lua`, glue, TOC, `ChurchOfBeef.lua`, or `tests/run.lua`.

This review does not sign the lane.

---

## Named risks

| Risk | Verdict |
|---|---|
| `rememberSpecial` is not Decree-style (scan then append) | **Pass. Verified.** Live helper type-guards a missing table, scans `UISpecialFrames[i] == name`, then appends at `# + 1`. Body matches Decree byte-for-byte (and the B12-D Toasts helper). `UI:Init` calls `rememberSpecial(FRAME_NAME)` once after `buildFrame`. |
| Bare `table.insert(UISpecialFrames` remains | **Pass.** Live `MainFrame.lua` has no `table.insert(UISpecialFrames`. Pin inside `runB12D()` requires the same. Append is `#UISpecialFrames + 1`. |
| Wiki `PlaySound(IG_CHARACTER_INFO_*)` on ESC / show / hide | **Pass.** Live `MainFrame.lua` has no `PlaySound`, `PlaySoundFile`, or `IG_CHARACTER_INFO`. Source pins cover both strings. `OnShow` / `OnHide` persist `shown` and stop sizing only. |
| New main-chunk locals in `test_ui.lua` | **Pass.** B15-C added none. New names (`shellSrcFile`, `shellSrc`, `rebuilt`) live inside `runB12D()`. File header comment is the only main-chunk edit. About 75 main-chunk locals remain; well under the Lua 5.1 200-local cap. |
| `Toasts.lua` edited | **Pass.** Provided exclusive-pair diff has no Toasts hunk. Live Toasts has no `ChurchOfBeefFrame` string. Sibling dirt vs HEAD on `Toasts.lua` is other lanes (B12-D Proclaim `rememberSpecial`). This lane did not add production Toasts logic. |
| After `UI:Init`, `ChurchOfBeefFrame` is not listed exactly once | **Pass. Verified.** Existing Init pin `UISpecialFrames[1] == "ChurchOfBeefFrame"` stays. Nested pin: `countSpecial("ChurchOfBeefFrame") == 1` after the suite's two `loadUi()` remounts plus Proclaim register. Reviewer probe: a second and third `rememberSpecial("ChurchOfBeefFrame")` leave the count at 1. |
| Forced second build duplicates the name | **Pass. Verified.** Pin nils `COB.UI.frame` (Init is otherwise idempotent; no `ResetForTests`) and calls `Init` again. Rebuilt frame keeps the name and `BasicFrameTemplate`. Count stays 1. `ChurchOfBeefProclaim` stays 1. Index `[1]` stays `ChurchOfBeefFrame`. |
| Isolated suite not exit 0 | **Pass. Verified.** 368 passed, 0 failed. Writer-reported count matches. |
| Exclusive file breach | **Pass.** Lane implementation is the two named files. Provided diff is those two paths only. Sibling dirt in this workspace (Toasts, glue, TOC) is other lanes. |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; do not edit Toasts.lua; no commit | **Pass.** Named-risk check. |
| Copy Decree `rememberSpecial` (scan then append) for `ChurchOfBeefFrame` | **Pass.** Named-risk check. `Init` remembers `FRAME_NAME` only. |
| Do **not** copy wiki `PlaySound(IG_CHARACTER_INFO_*)`; no `PlaySound` on ESC / show / hide | **Pass.** Named-risk check. |
| After `UI:Init()`, `UISpecialFrames` contains `"ChurchOfBeefFrame"` exactly once | **Pass.** Named-risk check. |
| Forced second build (or Reset path that rebuilds) still once | **Pass.** Nil-`frame` rebuild. Brief allows that path. |
| Source has `rememberSpecial` and does **not** `table.insert(UISpecialFrames` | **Pass.** Also pins the dedupe loop and `rememberSpecial(FRAME_NAME)`. |
| No `IG_CHARACTER_INFO` | **Pass.** Named-risk check. |
| Nest new pins inside `runB12D()` or a `do` block; no new main-chunk locals | **Pass.** Nested after the Proclaim ESC pins. |
| Existing Init / Proclaim B12-D pins stay | **Pass.** Line-89 Init pin stays. `runB12D()` Proclaim once / no-toast-name / `OnHide` / no close button / no ESC sound stay; B15-C re-asserts Proclaim count after the shell counts. |
| Isolation wrap stays | **Pass.** Start-of-file `if standalone then` cluster is unchanged. Extra subset asserts sit at the end of `runB12D()`. Standalone summary stays. |
| Quiet shell stays stock `BasicFrameTemplate`; `/beef` still opens Records Book via `UI:Toggle`; no Ladder / Standing / Officer tabs | **Pass.** Source pins plus rebuilt `_template`. Live `UI:Toggle` still `RecordsBook:Toggle()` when that module is loaded. No `PanelTabButtonTemplate`. |
| `lua tests/test_ui.lua` exit 0 | **Pass.** **368 / 0.** |

Wiki ESC registration, Decree scan-then-append, Law 6 (no panel whoosh), Law 10 (stock Quiet shell), and §14.2 (Toggle → Records Book) hold on the exclusive pair.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| No client smoke; real ESC vs `UISpecialFrames` close order unproven on Anniversary | **Not a miss.** Brief asked the isolated suite. |
| `UI:Init` is idempotent; no `ResetForTests`; harness nils `UI.frame` | **On contract.** Brief: forced second build or a Reset path that rebuilds. |
| Harness `UISpecialFrames` is a stub table; tests pin membership, not `CloseSpecialWindows` | **Not a miss.** Same stub the Init pin already used. |
| Earlier `loadUi()` remounts used to append a second and third `ChurchOfBeefFrame`; `rememberSpecial` now keeps those at one | **On contract.** `dofile` replaces `COB.UI`; the next `Init` re-calls `rememberSpecial`. That is why the uniqueness pin sits after those remounts. |

---

## Isolation / rememberSpecial / rebuild

**Isolation wrap — Pass.** Load list is still Common + Ranks + Officer + Roster + DB + MainFrame + Status + Minimap + Toasts (Runtime / Sound later for Quiet / cue pins). No Console / Hud / Records Book / Gora at the start wrap. B15-C did not add a `dofile`. End-of-`runB12D()` subset re-asserts Console / Hud / Records Book / Gora nil. Standalone print stays.

**rememberSpecial — Pass.** Missing table no-ops. Existing name returns. New name appends. `FRAME_NAME` is `"ChurchOfBeefFrame"`. `CreateFrame(..., FRAME_NAME, UIParent, "BasicFrameTemplate")` still supplies that name. Reviewer probe: missing `UISpecialFrames` stays nil; a second remember of the shell name does not grow the list.

**Rebuild — Pass.** Second `Init` after nilling `UI.frame` rebuilds the shell and hits `rememberSpecial` again. Count stays one. Proclaim registration is untouched. Index `[1]` stays the Quiet shell.

---

## Strengths

- Faithful Decree copy. No wiki whoosh. No new toast-name registration.
- Uniqueness is pinned after the suite's real `loadUi()` remounts, not only on a cold first Init. That is the path that used to append duplicates.
- B15-C pins are nested inside `runB12D()`. No new main-chunk locals. Existing Init and B12-D Proclaim pins stay.
- `Toasts.lua` is unread for production edits. B12-D still owns Proclaim ESC.
- Writer-reported **368 / 0** matched the re-run.

---

## Issues

### Critical

None.

### Important (leftover — not must-fix)

1. **Client ESC still unproven.** `CloseSpecialWindows` walking `UISpecialFrames` and hiding `_G["ChurchOfBeefFrame"]` is not in this stub (`CreateFrame` does not bind the global). Isolated membership is green. Anniversary `/reload` + ESC remains a leftover.

### Minor

1. **Forced rebuild is a blunt instrument.** Nilling `UI.frame` re-runs the rest of `Init` (Minimap / Toasts / Decree / Sound / FighterCard `Init` when those tables exist). Brief allowed a rebuild path. A `ResetForTests` that only re-called `rememberSpecial` would have been smaller.

2. **Missing-table no-op is unpinned.** Production type-guards it. Reviewer probe holds. The nested pins never set `UISpecialFrames` to a non-table.

3. **Quiet-shell show / hide has no runtime `#played` pin.** `MainFrame.lua` source has no `PlaySound` at all. Proclaim ESC still pins `#played` unchanged. Shell `OnShow` / `OnHide` are source-clean only.

4. **`git diff` vs HEAD on the exclusive files is not a B15-C-only delta.** Working tree already carried earlier Quiet-shell / Proclaim batches (`MainFrame.lua` 38 lines vs HEAD; `test_ui.lua` 529). The provided packet is the lane-only hunk. Report already says this.

5. **Extra isolation asserts inside `runB12D()` are a subset** of the file-start wrap (no Knighting / Codec / Sender). Harmless. The wrap that "stays" is the start cluster.

---

## Must-fix

None.

---

## Assessment

**Spec PASS. Quality: Approved-with-nits.**

**Must-fix:** none.

**Isolated count:** 368 passed, 0 failed.

`ChurchOfBeefFrame` is remembered with Decree-style `rememberSpecial`. After Init and after a forced second build it appears on `UISpecialFrames` exactly once. Source has the helper and does not bare-insert. No `PlaySound` / `IG_CHARACTER_INFO`. No new main-chunk locals. `Toasts.lua` was not edited. Existing Init and B12-D Proclaim pins stay. Isolated `lua tests/test_ui.lua` **368 passed, 0 failed**, exit 0.

Do not claim V1 / MVP complete. This review does not sign the lane.
