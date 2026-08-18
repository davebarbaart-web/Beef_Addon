Spec PASS

# B12-C — Fighter card ESC dismiss (review)

**Quality:** Approved-with-nits

**Lane:** B12-C Fighter card ESC dismiss
**Brief:** `docs/reformation/vestments/briefs/B12-C-card-esc.md`
**Writer report (unverified):** `docs/reformation/vestments/briefs/B12-C-card-esc-report.md`
**Diff:** `docs/reformation/vestments/briefs/B12-C-card-esc.diff`
**Exclusive files:** `addon/ChurchOfBeef/UI/FighterCard.lua`, `tests/test_fighter_card.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, the exclusive-pair diff, live `UI/FighterCard.lua` (`rememberSpecial` / `Init` register / `Hide` / `lastPair` / `paintHidden`), and `tests/test_fighter_card.lua` (source pins, once-after-Init, second Init, missing-table, rebuild, Hide / persist / `1-0` / health-nil, isolation wrap); then ran `lua tests/test_fighter_card.lua`. Law cited: Classic FrameXML `UISpecialFrames` (wiki: “Make frames closable with the Escape key”); Decree `rememberSpecial` (type-guard + dedupe); Bible §10.6 (mute tape), §10.7 (persist through the verdict beat); Law 6 / §19.1 (Quiet hides Event chrome); Law 10 / §19.3 (theatrical card, stock ESC). Anniversary `CloseSpecialWindows` (`UIParentPanelManager.lua`) looks up `_G[name]` and `Hide()`s shown specials. Did not mutate `FighterCard.lua` or `test_fighter_card.lua`. Did not edit Hud, glue, or Toasts. Did not commit. This review does not sign the lane.

---

## Named risks

| Risk | Verdict |
|---|---|
| `UISpecialFrames` registration | **Pass.** Named widget is still `ChurchOfBeefFighterCard`. `Init` builds first, then `rememberSpecial(FRAME_NAME)`. After Init the harness list contains that name once. Source contains `UISpecialFrames` (comment + helper). |
| Duplicates on second Init | **Pass.** `rememberSpecial` type-guards `type(UISpecialFrames) ~= "table"`, scans `#UISpecialFrames`, returns if the name is already listed, else appends. Second `Init` (same module) stays count 1. Rebuild `dofile` + `Init` stays count 1. Copy matches Decree / Records Book / Toasts. |
| Close ✕ added | **Pass.** No `CreateFrame("Button"`. `countType(frame, "Button") == 0`. Source has no `✕`. `EnableMouse(false)` unchanged. No `OnClick` / `OnHide` / close chrome. |
| `ShowUIPanel` | **Pass.** Source has no `ShowUIPanel` / `HideUIPanel`. Show / Hide stay insecure widget methods. Existing source pin stays. |
| `UnitHealth` | **Pass.** Source has no `UnitHealth`, `UnitHealthMax`, combat-log, or nameplate scrape. `hiddenView` / `paintShown` still set `health = nil`. Suite stubs those APIs; Show / Hide / suite end pin `healthReads == 0`. No `StatusBar`. |
| `PlaySound` on show / hide | **Pass.** Source has no `PlaySound` / `PlaySoundFile`. No `OnShow` / `OnHide` sound hooks (wiki example was not copied). Suite `sounds == 0` after Show, after Hide, and at suite end. |
| `Hide` forgets `lastPair` before QUIET | **Pass.** `FighterCard:Hide()` is still `paintHidden()` only. `forgetPersist` runs in `Refresh` / `Show` when not `eventLive`, and in `ResetForTests`. Subjects path: Hide then Refresh while ASSEMBLY still paints the remembered pair. Live-pair Hide then Refresh still shows. QUIET `Refresh` forgets; later ASSEMBLY does not revive. |
| Isolated suite exit 0 | **Pass.** Reviewer ran `lua tests/test_fighter_card.lua` on Lua **5.1.5**: **448 passed, 0 failed**, exit 0. Isolation cluster is still `if standalone then` (**17** nil-module pins). |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; do not edit Hud, glue, Toasts; no commit | **Pass.** Provided diff is two `diff --git` hunks: `UI/FighterCard.lua` and `tests/test_fighter_card.lua`. Live B12-C sites match that slice (`rememberSpecial` + `Init` register; `countSpecial` + six new pins). |
| Stock only; no close-button chrome; no `UnitHealth` | **Pass.** Named-risk checks. Dress, LEFT dock, Morpheus names, honorifics, mute defense integers, and A01 were not reopened. |
| Named frame on `UISpecialFrames`; Decree-shaped `rememberSpecial`; type-guard a missing table | **Pass.** Named-risk check. `UISpecialFrames = nil` then `Init` does not error. |
| After Init the name is listed once; second Init does not duplicate; source contains `UISpecialFrames` | **Pass.** Runtime count 1 after first Init, after second Init, after restore, and after rebuild Init. |
| Hide-vs-forget stays: `Hide()` dismisses; `lastPair` remains until QUIET; Refresh after Hide still paints while the event is live | **Pass.** Named-risk check. Existing subjects Hide+Refresh pin and live-pair Hide+Refresh pin stay. |
| Existing Hide / persist / `1-0` / health-nil pins stay; isolation wrap stays | **Pass.** Persist after `DeclareVictor`, `1-0` / H2H arabic, honorific, defenses, GetView copy, and Quiet no-revive blocks are untouched. Isolation stayed gated. |
| `lua tests/test_fighter_card.lua` exit 0; **POLISH:CANDIDATE** at most | **Pass. Verified.** 448 / 0. Writer claimed that polish ceiling and no more. |

Bible §10.6 / §10.7 (mute tape; persist through the verdict), Law 6 (Quiet hides Event chrome), Law 10 (stock FrameXML ESC, no close-button joke chrome), and the B3-B / B4-E / B6-D / B8-C / B10-C mute-tape pins hold on the exclusive pair.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| No client `/reload`; harness pins registration and dedupe, not a live Escape key | **Not a spec miss.** Brief asked isolated green. **POLISH:CANDIDATE** is the ceiling. See leftover. |
| ESC `Hide()`s the widget, not `FighterCard:Hide()`; `lastView.shown` may stay true until the next Refresh | **Accepted leftover.** Reviewer instructions name this nit unless Hide persist is broken. Persist is not broken: `lastPair` is untouched by widget `Hide()`; `forgetPersist` is still QUIET-only. |
| Type-guard is a no-op if the table is missing; no later backfill until another Init | **Not a miss.** Brief asked a type-guard, not a queue. Anniversary FrameXML mints `UISpecialFrames` before addons load. |
| A01 still NOT RUN; `health` is nil; no `UnitHealth` | **Not a miss.** Brief forbade opening it. |
| Hud / Toasts / glue were not edited | **Not a miss.** Exclusive card-only ESC. |
| Integrator still lists the files in the TOC and `run.lua` | **Not a miss.** Brief forbade those edits. Already listed. |

---

## Strengths

- Registration is the Decree helper, not a second `table.insert` without a scan. Second Init and a module rebuild do not grow the list.
- `Init` registers after the named widget exists. The string on the list matches `CreateFrame(..., FRAME_NAME, ...)` and `frame:GetName()`.
- Hide-vs-forget was not “fixed.” No `OnHide` → `forgetPersist`. ESC / widget `Hide` cannot wipe the remembered pair. QUIET `Refresh` / `Show` still forget so a later ASSEMBLY does not revive.
- Mute tape stayed mute: no close ✕, no `ShowUIPanel`, no `UnitHealth`, no sound on show/hide, no `StatusBar`, painted W–L / H2H stay `1-0`.
- Isolation stayed gated (17). Writer-reported 448 / 0 matches the reviewer run (441 prior persist suite + 7 new pins).

---

## Must-fix

None.

---

## Leftover (Minor)

1. **ESC calls widget `Hide()`, not `FighterCard:Hide()`.** Anniversary `CloseSpecialWindows` does `_G[name]:Hide()` on shown specials. `lastView.shown` stays true until the next `Refresh` / `FighterCard:Hide()`. `lastPair` remains until QUIET. Accepted leftover; persist is intact. This lane correctly did not add an `OnHide` hook (B12-D owns that on Proclaim). An `OnHide` that called `forgetPersist` would have been a must-fix.

2. **No `/reload` smoke and no `CloseSpecialWindows` fire.** The suite pins list membership and dedupe. It never hides via the FrameXML loop. **POLISH:CANDIDATE** only.

3. **Harness `CreateFrame` does not mint `_G[FRAME_NAME]`.** Production CreateFrame-with-a-name does; the wiki requires the global for ESC. A CloseSpecialWindows-shaped pin would no-op in this stub even if added. Not a client miss.

4. **Missing-table pin is crash-only.** `UISpecialFrames = nil` then `Init` then restore the *old* table still counts 1 because the first Init already appended. A deleted `rememberSpecial` that left the comment and the first-Init entry would still go green on restore / rebuild. First-Init `countSpecial == 1` is the real registration pin.

5. **Glue can undo ESC.** `showFighterCard` is `Show` then `Refresh`. Inbound STATE with two fighter ids does the same. That is the specified persist contract (Refresh after Hide still paints). On a live event, ESC is a temporary dismiss until the next Show/Refresh.

6. **Anniversary `CloseSpecialWindows` hides every shown special**, not the first only (`pairs` + `Hide` + `found = 1`, no early return). ESC with Console / Decree / Proclaim / Records Book also shown will dismiss those too. FrameXML fact; not this exclusive pair.

7. **B10-C Refresh-lazy forget is unchanged.** `Hide()` never forgets. Glue `afterEndEvent` still `Hide()`s without `Refresh`. A QUIET Hide that never Refreshs can revive on a later ASSEMBLY Refresh. Pre-existing; not opened by this lane.

8. **No full `lua tests/run.lua`.** Isolated 448 / 0 was re-run here. That does not prove the client path.

---

## Assessment

**Spec PASS. Quality: Approved-with-nits.**

**Must-fix:** none.

This is the B12-C vestment contract: named `ChurchOfBeefFighterCard` on `UISpecialFrames` via Decree-shaped `rememberSpecial` (type-guard + dedupe), no close ✕, no `ShowUIPanel`, no `UnitHealth`, no sound on show/hide, `Hide()` dismisses without forgetting `lastPair` until QUIET, Refresh after Hide still paints while the event is live. Named risks are clean. Isolated suite is green.

Do not claim V1 / MVP complete. **POLISH:CANDIDATE** only. This review does not sign the lane.
