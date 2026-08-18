Spec PASS

# B14-D — Console UISpecialFrames dedupe (review)

**Quality:** Approved-with-nits

**Lane:** B14-D Console UISpecialFrames rememberSpecial dedupe
**Brief:** `docs/reformation/vestments/briefs/B14-D-console-special.md`
**Writer report:** `docs/reformation/vestments/briefs/B14-D-console-special-report.md`
**Diff:** `docs/reformation/vestments/briefs/B14-D-console-special.diff` (B14-D-only exclusive-pair packet)
**Exclusive files:** `addon/ChurchOfBeef/UI/Console.lua`, `tests/test_console.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, the provided exclusive-pair diff, live `UI/Console.lua` (`rememberSpecial` / `buildFrame` / `stockEdit` / `Init` / `ResetForTests` / `SaveNote` / SUMMON / parchment / tabs), and nested `runB14D()` in `tests/test_console.lua` (inside `runB8E()` after `runB13D()`); then ran `lua tests/test_console.lua` (**1332 passed, 0 failed**, exit 0, Lua 5.1.5) and throwaway probes that do not live in the exclusive files. Law cited: wiki “Make frames closable with the Escape key” (named frame on `UISpecialFrames`); Decree `rememberSpecial`; Bible §18.1 (Director Console stock desk); Law 10 / §19.3 (functional / stock templates); Law 6 / §19.4 (Quiet is silent; no panel whoosh / `IG_CHARACTER_INFO`); CONTINUE 2026-08-18 license 4 (stock only; `SaveNote` stays nil; no SUMMON); B13-D ClearFocus stays. Did not mutate `Console.lua` or `test_console.lua`. Did not edit Store, Gora, glue, TOC, bootstrap, or `tests/run.lua`. Did not commit.

This review does not sign the lane.

---

## Named risks

| Risk | Verdict |
|---|---|
| `Init` twice duplicates `ChurchOfBeefConsoleFrame` on `UISpecialFrames` | **Pass. Verified.** After `Console:Init()`, count is 1. Second `Init` without nilling the widget returns the same frame (`Init` is idempotent) and the count stays 1. Reviewer probe: same widget, count 1, `SaveNote` still nil. |
| `ResetForTests` + `Init` duplicates the name | **Pass. Verified.** Suite pin: `reset()` (which calls `Console:ResetForTests()`) then `Init` still counts 1. Probe: `ResetForTests` returns true, **does not nil** `Console.frame`, hides the desk, then `Init` returns the same widget and count stays 1. |
| Second `buildFrame` / remember path duplicates the name | **Pass.** `ResetForTests` does not rebuild, so the suite nils `Console.frame` and `Init`s again. Count stays 1. Pre-seeded name then rebuild stays 1. Probe: forced rebuild mints a new widget and still counts 1; Show/Hide does not append. |
| Source has `IG_CHARACTER_INFO` / `PlaySound` on show / hide / ESC | **Pass.** Live `Console.lua` has no `IG_CHARACTER_INFO`, no `PlaySound`, no `OnShow` / `OnHide` sound scripts. `Show` / `Hide` only Show/Hide the widget. Suite source-pins both strings. |
| `SaveNote` defined | **Pass.** `Console.SaveNote` is nil before and after B14-D. Source has no `function Console:SaveNote`. `GetNotes` / `CopyCeremonySummary` / `CeremonySummary` stay nil. |
| `runB14D` not nested / new main-chunk locals / Lua 5.1 200-local | **Pass.** `runB14D()` is a nested local inside `runB8E()`, after `runB13D()`. `countSpecial` is nested inside `runB14D`. Diff adds no main-chunk locals. Isolated suite ran on Lua **5.1.5** with no `too many local variables`. |
| B13-D ClearFocus regresses / desk Hide from EditBox ESC | **Pass.** `stockEdit` still type-guards `OnEscapePressed` → `ClearFocus` only. After the forced rebuild, suite pins `ArchiveBox` exists and still has `OnEscapePressed`. Probe: fire on `ArchiveBox` leaves `Console:IsShown() == true`. |
| Isolated suite not exit 0 | **Pass. Verified.** 1332 passed, 0 failed. Writer-reported count matches. |
| Exclusive file breach | **Pass.** Lane implementation is the two named files. Provided diff is two `diff --git` hunks. Sibling dirt in this workspace is other lanes. |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; do not edit Store, Gora, glue; no commit; Console stays stock | **Pass.** Named-risk check. Live hunk is Decree-style `rememberSpecial` plus one `buildFrame` call. |
| Copy Decree `rememberSpecial` (scan then append); replace bare `table.insert` | **Pass.** Helper is the Decree body: type-guard the table, numeric scan, skip if `name` is listed, else `# + 1`. `buildFrame` ends with `rememberSpecial(FRAME_NAME)` once. Bare `table.insert(UISpecialFrames, FRAME_NAME)` is gone. |
| Named desk `ChurchOfBeefConsoleFrame` once; do not register scroll children or toast names | **Pass.** Only `rememberSpecial(FRAME_NAME)`. Scroll frames still take `FRAME_NAME .. "DeskScroll"` (and Presence / Knighting / Confession / Petition / CeremonyLog) as widget names; they are not passed to `rememberSpecial`. Probe: no extra `ChurchOfBeefConsoleFrame*` entries. No toast frame names. |
| No `PlaySound` / `IG_CHARACTER_INFO` on show / hide / ESC | **Pass.** Named-risk check. |
| `SaveNote` stays nil; no SUMMON; no parchment / tabs | **Pass.** Runtime `Console.SaveNote == nil`. Source has no `SUMMON THE FAITHFUL`, `Parchment`, or `PanelTabButtonTemplate`. Chrome pins: no SUMMON / COPY SUMMARY / WHISPER ALL / RSVP. |
| Do not Hide the desk from EditBox ESC (B13-D ClearFocus stays) | **Pass.** Named-risk check. |
| Lua 5.1 200-local: nest `runB14D()` inside `runB8E()`; no new main-chunk locals | **Pass.** Named-risk check. |
| Tests: after Init exactly once; remember path again still once; source has dedupe / `rememberSpecial` / `ChurchOfBeefConsoleFrame`; isolation wrap stays | **Pass.** Count pins + forced second `buildFrame` + pre-existing name. Source pins helper, loop, `rememberSpecial(FRAME_NAME)`, no bare insert, no `rememberSpecial(FRAME_NAME ..`. Isolation re-pin stays under `if standalone then` (Archive / Quiet shell / Toasts). Load list unchanged. |
| `lua tests/test_console.lua` exit 0; **POLISH:CANDIDATE** at most | **Pass. Verified.** 1332 / 0. Writer claimed that ceiling and no more. |

Wiki ESC (named frame on `UISpecialFrames`, deduped), §18.1 / Law 10 (stock desk), Law 6 (no panel whoosh), license 4 (`SaveNote` nil; no SUMMON; Console stays plain), and B13-D ClearFocus hold on the exclusive pair.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| No client smoke; real ESC vs focused EditBox vs `UISpecialFrames` close order unproven on Anniversary | **Not a spec miss.** Brief asked isolated green + rememberSpecial dedupe, not a `CloseSpecialWindows` walk. **POLISH:CANDIDATE** is the ceiling. See leftover. |
| `ResetForTests` does not nil `Console.frame`; harness nils the widget to force a second `buildFrame` | **On contract.** Brief allowed second Init **or** a second insert simulation. Idempotent `Init` does not re-enter `rememberSpecial`; the forced rebuild is the actual remember-path pin. |
| Harness `UISpecialFrames` is a stub table; tests pin membership counts, not the client walk | **Not a miss.** Brief asked the name exactly once on the table. See leftover. |
| Gate W stays OPEN. Gate V stays OPEN. | **Not a miss.** Overview already holds those gates open. |

---

## Isolation / rememberSpecial / ClearFocus

**Isolation wrap — Pass.** Load list is still wow_ui_stub + Common + Ranks + Runtime + Store + Gora + Knighting + Sender + Core Decree + Console. No `dofile` of Confession / MainFrame / Toasts / Sound / Hud / bootstrap. File-load `if standalone then` cluster still nils Quiet shell / DB / Net / Officer / Archive / Recognition / Roster / Popes / Hud / Sound / DecreeBanner / RecordsBook. B14-D re-pins Archive + Quiet shell + Toasts. End wrap still prints under `standalone`. Twelve `if standalone then` sites (helpers, load cluster, nested re-pins, result print).

**rememberSpecial — Pass.** Decree-identical helper. Called once from `buildFrame` with `FRAME_NAME`. After Init the name is listed once. Second `Init` and `ResetForTests`+`Init` stay at one (idempotent widget). Forced second `buildFrame` and pre-seeded name stay at one (the dedupe). Missing table no-ops; probe `Init` still returns a frame. Scroll-child names are not registered. Show/Hide does not append.

**ClearFocus — Pass.** B13-D `stockEdit` path is unchanged. Rebuild restores `ArchiveBox` with `OnEscapePressed`. Probe fire still ClearFocuses and leaves the desk shown.

---

## Strengths

- The production delta is the brief: replace the bare insert with Decree’s scan-then-append, one call for the named desk. No new chrome, no sound, no SUMMON, no `SaveNote`.
- The suite’s forced `Console.frame = nil` actually hits `rememberSpecial` twice. Naive second `Init` would not, because `Init` returns early when the widget exists.
- B13-D ClearFocus is re-pinned after that rebuild. Isolation stayed gated. New locals sit in `runB14D()` inside `runB8E()`.
- Writer-reported **1332 / 0** matched the re-run.

---

## Issues

### Critical

None.

### Important (leftover — not must-fix)

1. **No `/reload` smoke.** Client ESC while an EditBox is focused still swallows the key (wiki / B13-D). First ESC should unfocus; a later ESC should close via `UISpecialFrames` on `ChurchOfBeefConsoleFrame`. Same-keypress close is not claimed. Harness never walks `CloseSpecialWindows`. **POLISH:CANDIDATE** only.

2. **`Init` twice and `ResetForTests`+`Init` do not re-enter `rememberSpecial`.** `Init` returns `self.frame` when it exists; `ResetForTests` only hides. Those two brief-named checks stay at count 1 even if `buildFrame` still bare-inserted. The forced rebuild and pre-seed pins are what prove the dedupe. They exist and are green.

### Minor

1. **Suite does not pin Init-twice-without-`reset`.** Reviewer probe: second `Init` returns the same widget and count stays 1. First B14-D count pin also observes the suite-long single `buildFrame` from the main-chunk `Console:Init()` (nothing else nils `Console.frame` until B14-D).

2. **Missing-`UISpecialFrames` no-op is un-pinned.** Helper type-guards `type(...) ~= "table"`. FighterCard’s suite pins a nilled table; this suite does not. Probe: `Init` still returns a frame.

3. **Source pins are literal.** `Parchment` is case-sensitive (`true`); live comments already say lowercase “parchment.” `function Console:SaveNote` would miss `Console.SaveNote =`. Runtime `Console.SaveNote == nil` is the real SaveNote gate. `rememberSpecial(FRAME_NAME ..` would miss a concat without spaces; live call is `rememberSpecial(FRAME_NAME)` only.

4. **B13-D fire is not re-run after rebuild.** Post-rebuild pin is `GetScript` only. Probe: ArchiveBox fire still does not Hide the desk.

5. **Exclusive-pair git vs HEAD is not a B14-D-only delta.** `Console.lua` / `test_console.lua` already carry earlier vestment batches. The provided brief diff is the B14-D slice. Report already says this.

6. **No full `lua tests/run.lua`.** Isolated **1332 / 0** was re-run here. Runner listing was not (exclusive lane; `run.lua` not edited).

---

## Must-fix

None.

---

## Assessment

**Spec PASS. Quality: Approved-with-nits.**

**Must-fix:** none.

`rememberSpecial` is Decree’s scan-then-append. `buildFrame` registers `ChurchOfBeefConsoleFrame` once and does not register scroll children. `Init` twice and `ResetForTests`+`Init` still list the name once. A forced second `buildFrame` still lists it once. Source has no `IG_CHARACTER_INFO` / `PlaySound`. `SaveNote` stays nil. No SUMMON. B13-D ClearFocus stays. `runB14D()` is nested inside `runB8E()` with no new main-chunk locals. Isolated `lua tests/test_console.lua` **1332 passed, 0 failed**, exit 0.

Do not claim V1 / MVP complete. This review does not sign the lane.
