Spec PASS

# B15-B — Records Book wheel on chrome (review)

**Quality:** Approved-with-nits

**Lane:** B15-B Records Book wheel on chrome
**Brief:** `docs/reformation/vestments/briefs/B15-B-records-wheel.md`
**Writer report:** `docs/reformation/vestments/briefs/B15-B-records-wheel-report.md`
**Diff:** `docs/reformation/vestments/briefs/B15-B-records-wheel.diff` (exclusive-pair packet: `UI/RecordsBook.lua` + `tests/test_records.lua`)
**Exclusive files:** `addon/ChurchOfBeef/UI/RecordsBook.lua`, `tests/test_records.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, the provided exclusive-pair diff, live `UI/RecordsBook.lua` (`PAGE_TITLES`, `bodyText`, `turn`, extracted `onMouseWheel`, `wireChildWheel`, outer-frame hook, seven named chrome), and `tests/test_records.lua` (outer-frame pins kept; chrome block after those pins); then ran `lua tests/test_records.lua` (**420 passed, 0 failed**, exit 0, Lua **5.1.5**) and throwaway probes that do not live in the exclusive files. Law cited: Bible §14.2 (player-opened Quiet identity/history); §10.9 (nine superlative titles); Law 10 / §19.3 (theatrical parchment tome); Law 6 / §19.4 (Quiet is silent); B13-C outer-frame wheel. Anniversary `EnableMouseWheel([enable])` confirmed on `classic_anniversary` 2.5.6 as SimpleScriptRegionAPI (the region under the cursor gets the event). Isolation stays stub + Common + Ranks + Store + RecordsBook. Did not mutate `RecordsBook.lua` or `test_records.lua`. Did not commit. Did not edit MainFrame, glue, TOC, `ChurchOfBeef.lua`, or `tests/run.lua`.

This review does not sign the lane.

---

## Named risks

| Risk | Verdict |
|---|---|
| One extracted handler; outer-frame hook kept | **Pass. Verified.** Live `onMouseWheel` type-guards number `delta`, then `> 0` → `turn(-1)` Previous and `< 0` → `turn(1)` Next. Outer named frame still type-guards `EnableMouseWheel(true)` and `SetScript("OnMouseWheel", onMouseWheel)`. Reviewer probe: `frame:GetScript("OnMouseWheel")` is the same function as TitleBar, CloseButton, all three ribbons, PrevButton, and NextButton. |
| TitleBar, Close, three ribbons, Prev, Next eat the wheel | **Pass. Verified.** `wireChildWheel` type-guards `EnableMouseWheel(true)` + `SetScript("OnMouseWheel", onMouseWheel)` on those seven named children after they exist. After Init/Show, each has `GetScript("OnMouseWheel")`. Pin: `stub.fire(TitleBar, "OnMouseWheel", -1)` paints `Longest Streak` (Next). Pin: `stub.fire(PrevButton, "OnMouseWheel", 1)` returns `Most Sanctioned Victories` (Previous). Reviewer probe: Close / Victories / Rivalries / Martyrs / Next fire the same handler and turn the same way. Only seven Frame/Button children exist; all seven are wired. |
| `PAGE_TITLES` stay 9; no generated prose | **Pass.** Live table is still the nine §10.9 names in Bible order. Provided hunks do not add, rename, reorder, or delete a title. Chrome block pins `#GetPages() == #BIBLE_TITLES` and `#GetPages() == 9`. `bodyText` still returns `""` when `entries` is missing or empty. Empty leaf `Body` stays `""` on open, after TitleBar Next, and after PrevButton Previous. Source still bans ordained / folk-hero / sermon copy. |
| No `PlaySound`; no permanent `OnUpdate`; stock only | **Pass.** Source has no `PlaySound`, no `OnUpdate`, no `Media\\`. Chrome block pins `sounds == 0` and `GetScript("OnUpdate") == nil`. Roman paint and stock QuestBG / MORPHEUS / `UI-Quickslot2` are unchanged. |
| Isolated suite not exit 0; isolation wrap dropped | **Pass. Verified.** **420 passed, 0 failed.** Writer-reported count matches. Isolation cluster is still `if standalone then` (Runtime, Gora, Officer, UI, Net, DB, Sender, Minimap, Toasts, Console, Hud — **11**). Wrap was not in the provided hunks. |
| Exclusive file breach | **Pass.** Provided diff is two `diff --git` hunks: `UI/RecordsBook.lua` and `tests/test_records.lua`. Live wheel sites match that slice. Sibling dirt in this workspace is other lanes. |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; do not edit MainFrame, glue; no commit | **Pass.** Named-risk check. |
| Extract one handler; wheel up Previous, down Next | **Pass.** Named-risk check. |
| Type-guard `EnableMouseWheel(true)` + `OnMouseWheel` on TitleBar, Close, Victories / Rivalries / Martyrs ribbons, Prev, Next | **Pass.** Named-risk check. |
| Keep the outer-frame hook | **Pass.** Outer `type(frame.EnableMouseWheel)` pin still matches source. Outer `GetScript("OnMouseWheel")` stays set. B13-C fire pins stay (`stub.fire(frame, -1)` Next, `1` Previous). |
| Empty body stays `""`; no generated prose | **Pass.** Named-risk check. |
| `PAGE_TITLES` stay 9 | **Pass.** Named-risk check. |
| No custom media; no `PlaySound` on wheel; roman paint unchanged | **Pass.** Named-risk check. |
| After Init, named children have `OnMouseWheel`; TitleBar `-1` turns Next; PrevButton `1` turns Previous; outer-frame pins stay; isolation wrap stays; `lua tests/test_records.lua` exit 0 | **Pass.** Isolated **420 / 0**. |

Bible §14.2 (player-opened Quiet identity/history), §10.9 (nine titles), Law 10 / §19.3 (theatrical tome, UI never jokes), and Law 6 / §19.4 (Quiet is silent) hold on the exclusive pair. Wheel still reuses `turn`. It does not invent a tenth page, a search box, or empty-leaf copy.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| No client `/reload`; chrome hover on Anniversary unproven | **Not a spec miss.** Brief asked isolated `tests/test_records.lua`. **POLISH:CANDIDATE** is the ceiling. See leftover. |
| Stub `EnableMouseWheel` is a noop and stores no flag | **Not a miss.** Reviewer instructions / brief allow source + `GetScript` + fire. Production still calls the guarded client method on the seven children. See leftover. |
| FontStrings / parchment textures were not named and are not wired | **On contract.** Brief named TitleBar, Close, three ribbons, Prev, Next. Those are the only Frame/Button children. FontStrings are not mouse-enabled here. See leftover. |
| `delta == 0` no-ops | **Not a miss.** Brief named `> 0` and `< 0` only. Reviewer probe: non-number and `0` leave the leaf. |

---

## Isolation / chrome / empty-leaf

**Isolation wrap — Pass.** Load list is still `wow_ui_stub` + Common + Ranks + Store + RecordsBook. No `dofile` of MainFrame / Console / Net. **11** nil-module pins under `if standalone then`. Wrap text is unchanged. Chrome pins sit after the B13-C outer-frame block.

**Chrome — Pass.** One handler. Outer hook kept. Seven named children get type-guarded `EnableMouseWheel(true)` + the same `OnMouseWheel`. TitleBar `-1` is Next. PrevButton `1` is Previous. Reviewer probe: the other five named chrome fire the same function and turn the same way. Close / ribbon `OnClick` scripts are not overwritten.

**Empty-leaf / titles — Pass.** First leaf still opens `Most Sanctioned Victories` with `Body == ""`. Chrome turns do not invent copy. `#PAGE_TITLES` stays 9.

---

## Strengths

- B13-C leftover (TitleBar / Close / ribbons / Previous / Next sitting on top and eating the wheel) is closed on the named list without a second handler or an `OnUpdate` poll.
- Direction matches Previous / Next (`turn(-1)` / `turn(1)`). The suite pins the same `Longest Streak` title the outer-frame Next pin already uses.
- Empty-leaf `Body` stays `""`. `PAGE_TITLES` stay the nine Bible names. No `PlaySound`. Isolation stayed gated.
- Writer-reported **420 / 0** and **11** isolation pins matched the re-run.

---

## Issues

### Critical

None.

### Important (leftover — not must-fix)

None that this exclusive pair opened. Client `/reload` chrome hover remains unproven; that is the writer's own ceiling, not a brief miss.

### Minor

1. **Close / ribbons / Next wheel fire are code-true, not suite-pinned.** The suite pins `GetScript` on all seven and fires only TitleBar `-1` and PrevButton `1`, which is what the brief named. Reviewer probe: Close / Victories / Rivalries / Martyrs / Next turn the same way.

2. **Same-handler identity is unpinned.** Live `GetScript("OnMouseWheel")` on the outer frame and all seven children is one function. A later per-child closure would still pass the current pins if it called `turn` the same way.

3. **Stub `EnableMouseWheel` is a noop.** The harness lists the method and caches `function() end`; it stores no enabled bit. Tests pin `GetScript` + fire, not `IsMouseWheelEnabled`. Production still calls `EnableMouseWheel(true)` on the seven children.

4. **FontStrings / parchment textures are unwired.** They were not in the brief. They are not Frame/Button children and are not `EnableMouse`. If Anniversary ever delivered wheel to a mouse-enabled region outside the named seven, that hover would still miss. **POLISH:CANDIDATE** only.

5. **Non-number / zero delta are unpinned.** The handler no-ops both. Brief did not require those pins. Reviewer probe: leaf stays.

6. **No `/reload` smoke and no full `lua tests/run.lua`.** Isolated **420 / 0** was re-run here. Sibling dirt in MainFrame / glue / TOC / `run.lua` is other lanes.

---

## Must-fix

None.

---

## Assessment

**Spec PASS. Quality: Approved-with-nits.**

**Must-fix:** none.

**Isolated count:** `lua tests/test_records.lua` **420 passed, 0 failed**, exit 0. Isolation wrap **11**.

One `onMouseWheel` is shared by the outer named frame and TitleBar, Close, Victories / Rivalries / Martyrs ribbons, Previous, and Next. Outer hook stays. TitleBar wheel down turns Next; PrevButton wheel up turns Previous. Empty-leaf body stays `""`. `PAGE_TITLES` stay 9. No generated prose, no `PlaySound`, no `OnUpdate`, no custom media.

Do not claim V1 / MVP complete. **POLISH:CANDIDATE** only. This review does not sign the lane.
