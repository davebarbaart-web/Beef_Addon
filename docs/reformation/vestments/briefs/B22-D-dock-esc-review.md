Spec PASS

# B22-D — Event dock ESC via UISpecialFrames (review)

**Quality:** Approved-with-nits

**Lane:** B22-D Event dock ESC via UISpecialFrames
**Brief:** `docs/reformation/vestments/briefs/B22-D-dock-esc.md`
**Writer report:** `docs/reformation/vestments/briefs/B22-D-dock-esc-report.md`
**Diff:** `docs/reformation/vestments/briefs/B22-D-dock-esc.diff` (B22-D-only exclusive-pair packet; both exclusive files are still untracked vs HEAD and also carry earlier dock batches)
**Exclusive files:** `addon/ChurchOfBeef/UI/ConsoleDock.lua`, `tests/test_console_dock.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, the provided exclusive-pair diff, live `UI/ConsoleDock.lua` (`rememberSpecial` / `build` / `mayShow` / `paint` / CloseButton hide / `ui.consoleDock`), and `tests/test_console_dock.lua` (source helper pins, Init once / second Init / missing-table survive, StartEvent + Pope name once, Hide is not EndEvent, persist remount still once, Quiet / title / SANCTION + Expand / hidden CloseButton keep-pins, isolation wrap); then ran `lua tests/test_console_dock.lua` (**233 passed, 0 failed**, exit 0, Lua 5.1.5) and throwaway probes that do not live in the exclusive files. Law cited: wiki "Make frames closable with the Escape key" (named `ChurchOfBeefConsoleDock` on `UISpecialFrames` once); Toasts / Console `rememberSpecial`; Bible §18.1 (collapsible Director Console); Law 10 / §19.3 (functional / stock `BasicFrameTemplate`); Law 6 / §19.4 (Quiet is silent; no panel whoosh); CONTINUE 2026-08-18 license 4 (stock only). Title stays exactly `DIRECTOR CONSOLE`. CloseButton hidden. Persist `ui.consoleDock` stays. No `PlaySound`. Did not mutate `ConsoleDock.lua` or `test_console_dock.lua`. Did not commit. Did not edit Console.lua, Hud, glue, TOC, `ChurchOfBeef.lua`, or `tests/run.lua`.

This review does not sign the lane.

---

## Named risks

| Risk | Verdict |
|---|---|
| `ChurchOfBeefConsoleDock` missing from `UISpecialFrames`, or listed more than once | **Pass. Verified.** `build()` calls `rememberSpecial(FRAME_NAME)` once. `FRAME_NAME` is `"ChurchOfBeefConsoleDock"`. After Init, `GetName()` is that string and `countSpecial` is 1. StartEvent + Pope re-pins name + once. Persist remounts stay at 1. Reviewer probe: pre-seeded `ChurchOfBeefConsole` / `ChurchOfBeefToast` stay; dock appends once (`#list == 3`). |
| Second Init / `ResetForTests` rebuild duplicates the name | **Pass. Verified.** Init is idempotent (`frame` already set; no second `build`). Pins: second Init Quiet and second Init while shown stay at 1. Reviewer probe: `ResetForTests` leaves the list entry; rebuild hits `rememberSpecial` again; count stays 1; new widget, same name. |
| `PlaySound` / `IG_CHARACTER_INFO_*` on hide / ESC / show | **Pass.** Live file has no `PlaySound`, `PlaySoundFile`, `IG_CHARACTER_INFO`, or `SOUNDKIT`. Hide is `paint(false)` only. Suite `sounds == 0` through Quiet Init, Show, Hide, clicks, persist. Reviewer spy: widget `Hide()` (ESC stand-in) and `ConsoleDock:Hide()` both leave the counter at 0. |
| CloseButton shown, or a new close control added | **Pass.** Stock `BasicFrameTemplate` CloseButton is `Hide()`d in `build()`. No new close chrome. Pins: Quiet Init, shown, persist Quiet restore. Reviewer probe: `CloseButton:IsShown() == false` after Init and after persist drag. |
| Title no longer `DIRECTOR CONSOLE`, or persist `ui.consoleDock` broken | **Pass.** `TITLE` is still exactly `DIRECTOR CONSOLE`. `savePoint` / `restorePoint` / `db.consoleDock` unchanged. Persist pins and source `consoleDock` / `ANCHORS` / no `relativeTo` stay. Reviewer probe: TitleBar drop still writes exactly `{ point, relativePoint, x, y }` with `relativeTo` nil; title and hidden CloseButton stay. |
| Hide ends the event, or Quiet hide / `mayShow` broken | **Pass. Verified.** `ConsoleDock:Hide()` paints hidden; Runtime stays `ASSEMBLY`. Quiet Init / Quiet Show / Pope-false / EndEvent still hide. `mayShow` is still live event + registered Pope. Reviewer probe: EndEvent Refresh is hidden / `QUIET`. |
| Isolated suite not exit 0 | **Pass. Verified.** 233 passed, 0 failed. Writer-reported count matches. Writer-reported red (**222 / 11**) matches the eleven helper / once-list asserts that a dock without `rememberSpecial` would fail (B14-C was **207**; 207 + 26 new pins = 233). |
| Exclusive file breach | **Pass.** Lane implementation is the two named files. Packet is two `diff --git` hunks (header + `rememberSpecial` + `build()` call; source / once / Hide / persist pins). Both files are still untracked vs HEAD. Sibling dirt in this workspace is other lanes (Console, Hud, TOC, bootstrap, `run.lua`). |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; do not edit Console.lua, Hud, glue; no commit | **Pass.** Named-risk check. |
| `rememberSpecial("ChurchOfBeefConsoleDock")` on `build` (dedupe; Toasts / Console helper shape) | **Pass.** Call is `rememberSpecial(FRAME_NAME)` at the end of `build()`. Helper is byte-identical to Toasts / Console / Decree (type-guard, scan `UISpecialFrames[i] == name`, append at `# + 1`). Reviewer extracted the seven-line body from all four files. |
| Do not add a close button; CloseButton stays hidden | **Pass.** Named-risk check. |
| Do not `PlaySound` / `IG_CHARACTER_INFO_*` on hide | **Pass.** Named-risk check. |
| Hide is not EndEvent; Quiet hide stays; `mayShow` (live event + registered Pope) stays | **Pass.** Named-risk check. |
| After Init + StartEvent + Pope: `_G` name or `GetName()` is `ChurchOfBeefConsoleDock`; listed exactly once | **Pass.** Suite pins `GetName()` (brief allows that). Once-list pins after Init and after StartEvent + Pope. Harness `CreateFrame` does not mint `_G[name]`; production named `CreateFrame` will. See leftover. |
| Second Init does not duplicate | **Pass.** Named-risk check. |
| Hide / Quiet still hide | **Pass.** `ConsoleDock:Hide()` hides the widget and paints `shown` false. Quiet / EndEvent keep-pins stay. |
| No `PlaySound` in source; persist / title / SANCTION + Expand pins stay | **Pass.** Source `PlaySound` / `IG_CHARACTER_INFO` nil. Persist `consoleDock` keep-pins plus shown-state SANCTION / Expand / hidden CloseButton re-pins. |
| Isolation wrap stays; `lua tests/test_console_dock.lua` exit 0 | **Pass.** **233 / 0.** Wrap still **24** under `if standalone then`. |

Wiki ESC registration, Law 6 (no panel whoosh), Law 10 / license 4 (stock dock, hidden CloseButton, no custom media), and §18.1 (Director Console stays titled `DIRECTOR CONSOLE`; persist stays) hold on the exclusive pair.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| No client smoke; real ESC vs `CloseSpecialWindows` on Anniversary is unproven. Harness `UISpecialFrames` is a stub table | **Not a miss.** Brief asked isolated green + named once-list. **POLISH:CANDIDATE** only. |
| ESC `Hide()`s the widget, not `ConsoleDock:Hide()`. `lastView.shown` may stay true until the next `Refresh`. No `OnHide` hook | **On contract.** Brief asked `rememberSpecial` on build, not FighterCard-style `OnHide`. Reviewer probe: widget `Hide()` leaves `GetView().shown == true` and Runtime `ASSEMBLY`; next `Refresh` re-shows because `mayShow` is still true. `ConsoleDock:Hide()` still paints false. See leftover. |
| `Init` is idempotent. Second Init does not re-call `build()`. A missing table at first `build()` is not queued | **On contract.** Brief: Init survives a missing table; second Init does not duplicate. Suite pin nils the table *after* the name is already listed. Reviewer probe: `ResetForTests` then nil table then Init leaves a later empty table at 0 until another `build`. Client `UISpecialFrames` is a table. |
| Full `lua tests/run.lua` not run; Gate W / Gate V stay OPEN; lane unsigned | **Not a miss.** Brief asked the isolated suite. This review does not sign the lane. |
| Parked desk `after()` double cue | **On contract.** Overview parks that leftover for a later Console batch. |

---

## Isolation / rememberSpecial / Hide

**Isolation wrap — Pass.** Load list is still `wow_ui_stub` + Common + Runtime + ConsoleDock. Stub Sender / Console only. No `dofile` of Console / Hud / Toasts / Net / DB. Standalone wrap is still **24** nils (UI, DB, Net, Officer, Archive, Recognition, Roster, Popes, Hud, Sound, DecreeBanner, RecordsBook, Minimap, Toasts, Codec, Snapshot, Console, Sender, Store, Gora, Knighting, FighterCard, Decree, slash). Wrap text is unchanged. Reviewer probe: UI / Console / Hud / Store are nil at load. Wrap is load-time only.

**rememberSpecial — Pass.** Missing table no-ops. Existing name returns. New name appends. `build()` remembers `FRAME_NAME` only. No bare `table.insert(UISpecialFrames`. CloseButton hide and title set stay in `build()` before the register. `ResetForTests` does not drop the list entry.

**Hide / Quiet — Pass.** `ConsoleDock:Hide()` is `paint(false)`: widget hidden, `lastView.shown` false, Runtime untouched, no sound. Quiet `mayShow` is false. Event + Pope Show after Hide still paints. Persist Quiet Init with a saved point still hides.

---

## Strengths

- The delta is the brief: one Decree-shaped helper, one `build()` call, no close button, no hide sound, no EndEvent, persist / title / SANCTION + Expand left alone.
- Uniqueness is pinned after Init, after a second Init while shown, after Hide, and after persist `dofile` remounts — the path that would have appended on each remount if they had bare-inserted.
- Helper is a byte-for-byte Toasts / Console / Decree copy, not a third shape. Writer-reported red **222 / 11** matches the new once-list / helper asserts; green **233 / 0** matched the re-run.
- Isolation wrap and `mayShow` were not rewritten. Source still has no `PlaySound`. CloseButton stays hidden.

---

## Issues

### Critical

None.

### Important (leftover — not must-fix)

1. **Widget `Hide()` (ESC) does not sync `lastView`.** Reviewer probe: after `frame:Hide()`, `IsShown()` is false and `GetView().shown` stays true; Runtime stays `ASSEMBLY`; next `Refresh` re-shows because `mayShow` is still true. Glue `refreshEventFurniture` / inbound Refresh would undo a mid-event ESC. Brief did not ask `OnHide` or a dismissed flag. `ConsoleDock:Hide()` still paints. No INT glue required.

### Nit

1. **Harness `CreateFrame` does not mint `_G["ChurchOfBeefConsoleDock"]`.** Brief allows `GetName()`. A `CloseSpecialWindows`-style `_G[name]` walk on the stub finds nil unless the probe falls back to the widget. Anniversary named `CreateFrame` sets the global. Not a production miss.

2. **Missing-table pin is after the name is already listed.** It proves Init does not error. First-`build` with a nil table is not queued (writer leftover). Client table exists.

3. **Suite pins list membership, not a special-frame walk.** Harness `Hide()` is a direct call. Real ESC order vs other `UISpecialFrames` names is unproven.

4. **`countSpecial` is a new main-chunk local.** Brief did not require a nest. This suite is nowhere near Lua 5.1's 200-local cap.

5. **Isolation wrap is load-only.** Persist `dofile` does not re-assert the 24 nil-module pins. Wrap text is unchanged.

6. **Exclusive-pair diff is not a vs-HEAD dock delta.** Both files are still untracked. Packet is the B22-D-only helper + pins vs the pre-lane working tree. Report already says this.

7. **No `/reload` smoke and no full `lua tests/run.lua`.** Isolated **233 / 0** was re-run here.

---

## Must-fix

None.

---

## Assessment

**Spec PASS. Quality: Approved-with-nits.**

**Must-fix:** none.

**Isolated count:** **233 passed, 0 failed.** Isolation wrap: **24**.

`build()` registers `ChurchOfBeefConsoleDock` on `UISpecialFrames` once via a Toasts / Console-shaped `rememberSpecial`. Second Init and persist remounts do not duplicate. Hide is not EndEvent and plays no sound. CloseButton stays hidden. Title stays `DIRECTOR CONSOLE`. Persist `ui.consoleDock` stays. Quiet / `mayShow` stay. Isolated `lua tests/test_console_dock.lua` **233 passed, 0 failed**, exit 0.

Do not claim V1 / MVP complete. **POLISH:CANDIDATE** only. This review does not sign the lane.
