Spec PASS

# B13-C — Records Book mouse wheel (review)

**Quality:** Approved-with-nits

**Lane:** B13-C Records Book mouse wheel
**Brief:** `docs/reformation/vestments/briefs/B13-C-records-wheel.md`
**Writer report (unverified):** `docs/reformation/vestments/briefs/B13-C-records-wheel-report.md`
**Diff:** `docs/reformation/vestments/briefs/B13-C-records-wheel.diff`
**Exclusive files:** `addon/ChurchOfBeef/UI/RecordsBook.lua`, `tests/test_records.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, the exclusive-pair diff, live `UI/RecordsBook.lua` (`PAGE_TITLES`, `bodyText`, `turn`, `buildFrame` named-frame wheel), and `tests/test_records.lua` (source pins + Init/Show `OnMouseWheel` + `stub.fire(..., -1)` Next pin); then ran `lua tests/test_records.lua`. Law cited: Bible §14.2 (player-opened Quiet identity/history); Law 10 / §19.3 (theatrical parchment tome); Law 6 / §19.4 (Quiet is silent). Anniversary `EnableMouseWheel([enable])` confirmed on `classic_anniversary` 2.5.6 as SimpleScriptRegionAPI (default false). Did not mutate addon code. Did not edit `RecordsBook.lua` or `test_records.lua`. Did not commit. This review does not sign the lane.

---

## Named risks

| Risk | Verdict |
|---|---|
| Named frame has type-guarded `EnableMouseWheel(true)` + `OnMouseWheel` | **Pass.** After `EnableMouse` / movable / clamp on `ChurchOfBeefRecordsBook`: `type(frame.EnableMouseWheel) == "function"` then `EnableMouseWheel(true)`; `type(frame.SetScript) == "function"` then `SetScript("OnMouseWheel", …)`. Handler type-guards number `delta`. Missing methods no-op. After Init/Show, `GetScript("OnMouseWheel")` is set. Anniversary SimpleScriptRegionAPI lists `EnableMouseWheel([enable])` (default false). |
| Wheel direction: up Previous, down Next | **Pass.** `delta > 0` → `turn(-1)` (same as Previous). `delta < 0` → `turn(1)` (same as Next). `delta == 0` no-ops. `stub.fire(frame, "OnMouseWheel", -1)` pins `Longest Streak` (same title Next already pins). `stub.fire(..., 1)` returns to `Most Sanctioned Victories`. Not inverted. |
| Empty-leaf body stays `""`; no invented copy | **Pass.** `bodyText` still returns `""` when `entries` is missing or `#entries == 0`. Wheel block resets the store, then pins `Body == ""` on the first leaf, after wheel-down, and after wheel-up. Source has no empty-page sermon. |
| `PAGE_TITLES` stays 9 | **Pass.** Live table is still the nine §10.9 names in Bible order. Provided hunks do not add, rename, reorder, or delete a title. Wheel block pins `#GetPages() == #BIBLE_TITLES` and `#GetPages() == 9`. |
| No sound; no permanent `OnUpdate` | **Pass.** Source has no `PlaySound` / `OnUpdate`. Wheel block pins `sounds == 0` and `GetScript("OnUpdate") == nil` at install and after both fires. Quiet Mode stays silent. |
| Isolated green; isolation wrap stays | **Pass.** Reviewer ran `lua tests/test_records.lua` on Lua **5.1.5**: **391 passed, 0 failed**, exit 0. Isolation cluster is still `if standalone then` (Runtime, Gora, Officer, UI, Net, DB, Sender, Minimap, Toasts, Console, Hud — **11**). Wrap was not in the provided hunks. |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; do not edit Console, glue; no commit | **Pass.** Provided diff is two `diff --git` hunks: `UI/RecordsBook.lua` and `tests/test_records.lua`. Live wheel site matches that slice (after clamp, before `SetWidth`). Console / TOC / bootstrap / `run.lua` are not in the packet. |
| After the named frame exists, type-guard `EnableMouseWheel(true)` and `OnMouseWheel`; missing APIs no-op; no permanent `OnUpdate` | **Pass.** Named-risk check. |
| Positive delta (wheel up) → `turn(-1)` Previous; negative → `turn(1)` Next | **Pass.** Named-risk check. |
| No invented empty-page copy; empty-leaf body stays `""` | **Pass.** Named-risk check. |
| `PAGE_TITLES` stay 9 | **Pass.** Named-risk check. |
| No sound | **Pass.** Named-risk check. `PlaySound` / `PlaySoundFile` / `PlaySoundKitID` stay stubbed at 0 through the wheel block. |
| After Init/Show, frame has `OnMouseWheel`; source contains `EnableMouseWheel`; `stub.fire(..., -1)` turns the leaf the same way Next does; isolation wrap stays; `lua tests/test_records.lua` exit 0 | **Pass.** Source pins the call, the type-guard string, and `SetScript("OnMouseWheel"`. Runtime pin is `GetScript` plus the Next-equivalent title. Isolated **391 / 0**. |
| Stock textures/fonts only; **POLISH:CANDIDATE** at most | **Pass.** Wheel adds no `Media\\`. Writer claimed the ceiling and no more. |

Bible §14.2 (player-opened Quiet identity/history), Law 10 / §19.3 (theatrical tome, UI never jokes), and Law 6 / §19.4 (Quiet is silent) hold on the exclusive pair. Wheel reuses `turn`; it does not invent a tenth page or a search box.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| No client `/reload`; hover over title bar / ribbons / buttons vs parchment unproven | **Not a spec miss.** Brief asked isolated `tests/test_records.lua`. **POLISH:CANDIDATE** is the ceiling. See leftover. |
| Stub `EnableMouseWheel` is a noop and stores no flag | **Not a miss.** Reviewer instructions / brief allow source + `GetScript` + fire. Production still calls the guarded client method. See leftover. |
| Wheel is on the outer named frame, not every mouse-enabled child | **Not a miss.** Brief named the named frame after it exists. Child-hover delivery is unproven on Anniversary, not an invented fix this lane was asked to make. See leftover. |
| `delta == 0` no-ops | **Not a miss.** Brief named `> 0` and negative only. |

---

## Strengths

- Wheel is a type-guarded script on the existing named tome, not a new chrome surface and not an `OnUpdate` poll.
- Direction matches the brief and the existing Previous / Next buttons (`turn(-1)` / `turn(1)`). The suite pins the same `Longest Streak` title Next already uses.
- Empty-leaf `Body` stays `""`. `PAGE_TITLES` stays the nine Bible names. No `PlaySound`. Isolation stayed gated.
- Isolated **391 / 0** was re-run here and matches the writer report.

---

## Must-fix

None.

---

## Leftover (Minor)

1. **No `/reload` smoke.** TitleBar / Close / ribbons / Previous / Next are mouse-enabled children and do not call `EnableMouseWheel`. If Anniversary delivers wheel only to the topmost mouse-enabled region, hovering chrome may not turn leaves. **POLISH:CANDIDATE** only.

2. **Stub `EnableMouseWheel` is a noop.** The harness lists the method and caches `function() end`; it stores no enabled bit. Tests pin source type-guard + `GetScript("OnMouseWheel")` + fire, not a runtime enabled flag. A deleted `EnableMouseWheel(true)` with the type-guard string left in a comment would still satisfy the source pin; the `GetScript` + fire pins would still catch a missing handler.

3. **Non-number / zero delta are unpinned.** The handler no-ops both. Brief did not require those pins.

4. **No full `lua tests/run.lua`.** Isolated **391 / 0** was re-run here. That does not prove the client path.

---

## Assessment

**Spec PASS. Quality: Approved-with-nits.**

**Must-fix:** none.

This is the B13-C vestment contract: type-guarded mouse wheel on the named Records Book frame (up Previous, down Next), empty-leaf body stays `""`, `PAGE_TITLES` stay 9, no sound, no `OnUpdate`. Named risks are clean. Isolated suite is green.

Do not claim V1 / MVP complete. **POLISH:CANDIDATE** only. This review does not sign the lane.
