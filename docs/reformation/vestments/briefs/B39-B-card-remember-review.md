Spec PASS

# B39-B — FighterCard Show / Refresh remount rememberSpecial (review)

**Quality:** Approved-with-nits

**Lane:** B39-B existing-frame Show / Refresh remount `rememberSpecial(FRAME_NAME)` and keep `wireCardOnHide`
**Brief:** `docs/reformation/vestments/briefs/B39-B-card-remember.md`
**Writer report:** `docs/reformation/vestments/briefs/B39-B-card-remember-report.md`
**Diff:** `docs/reformation/vestments/briefs/B39-B-card-remember.diff` (B39-B-only exclusive-pair packet; live `FighterCard.lua` / `test_fighter_card.lua` are untracked vs HEAD and also carry earlier card batches)
**Exclusive files:** `addon/ChurchOfBeef/UI/FighterCard.lua`, `tests/test_fighter_card.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, the provided exclusive-pair diff, live `UI/FighterCard.lua` (`rememberSpecial` ~51–57 / `wireCardOnHide` ~455–465 / `build` / `FighterCard:Init` ~554–562 / `Refresh` ~569–588 / `Show` ~590–608 / `Hide` ~610–616 / `forgetPersist` / `FRAME_NAME` / `NAME_FONT`), and `tests/test_fighter_card.lua` (isolation wrap, persist / health-nil / Morpheus / B28-D Init / B29-C Show/Refresh OnHide / B30-B Hide OnHide / B37-C Hide special remount pins, nested `runB39B()` inside `runB28D()` after `runB37C()`); then ran `lua tests/test_fighter_card.lua` (**731 passed, 0 failed**, exit 0, Lua **5.1.5**) and throwaway probes that do not live in the exclusive files. Law cited: wiki ESC via `UISpecialFrames` (named frame; do **not** PlaySound `IG_CHARACTER_INFO_*`); Bible §10.6 (mute tape), §10.7 (persist through the verdict beat); Law 6 / §19.1 (Quiet hides Event chrome); Law 10 / §19.3 (theatrical card, no close ✕); B37 leftover: Hide remounts `rememberSpecial`; Show / Refresh remounted `wireCardOnHide` only, so a wiped list stayed idle until Init or Hide. Existing-frame `Show` and `Refresh`: `rememberSpecial(FRAME_NAME)` then existing `wireCardOnHide(frame)`. `FRAME_NAME` is `ChurchOfBeefFighterCard`. Do not reset `lastPair`. Never replace an existing OnHide. No OnShow re-wire. No rebuild. No `PlaySound`. Hide remount (B37-C) and Init remount stay. Did not mutate `FighterCard.lua` or `test_fighter_card.lua`. Did not commit. Did not edit Hud, glue, MainFrame, TOC, bootstrap, `ChurchOfBeef.lua`, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG.

This review does not sign the lane. Do not claim Gate W / Gate V / **POLISH:PASS**.

---

## Named risks

| Risk | Verdict |
|---|---|
| Show / Refresh still skip `rememberSpecial` | **Pass. Verified.** Live exists-paths are `rememberSpecial(FRAME_NAME)` then `wireCardOnHide(frame)` before the live / Quiet paint. Nested: Show / Refresh exists-path `find("rememberSpecial(FRAME_NAME)")` before `wireCardOnHide`; wipe `UISpecialFrames` to `{}`, Show lists `ChurchOfBeefFighterCard` once; wipe again, Refresh lists once. Reviewer probe: wipe with neighbor `OtherFrame` then Show / Refresh lists the card once and keeps the neighbor. Quiet Show still remounts (then `forgetPersist` + `paintHidden`). `rememberSpecial(FRAME_NAME)` sites are **4** (Init + Refresh + Show + Hide). |
| lastPair reset on remount | **Pass. Verified.** Remount lines do not call `forgetPersist`. Nested: Refresh after wipe still paints Chuckroast / Tendermage; `health` nil; live Gora stays. Reviewer probe: subjects Show remount, then CloseRite / Continue (no live Gora, fighters cleared) then wipe + Refresh still paints Chuckroast / Tendermage; Sanction remount then `DeclareVictor` (live pair nil, event still live) then wipe + Refresh still paints. EndEvent then Refresh hides; later StartEvent stays hidden. Hide still has no `forgetPersist`. |
| PlaySound added | **Pass. Verified.** Source has no `PlaySound` / `IG_CHARACTER_INFO`. Show / Refresh exists-paths pin both absent. Nested: `sounds` unchanged across Show remount; suite-end `sounds == 0`. Reviewer probe: remount Show / Refresh / Quiet Show stay at **0**. |
| OnShow re-wire | **Pass. Verified.** Source has no `OnShow`. Exists-paths pin `OnShow` absent and no inline `SetScript`. Nested: `GetScript("OnShow")` stays nil after wipe Show / wipe Refresh. Reviewer spy: existing / sentinel OnHide `SetScript` delta **0** on remount Show / Refresh. Sentinel identity stayed. |
| rebuild | **Pass. Verified.** Exists-paths have no `CreateFrame`. Nested wrapped `CreateFrame` stays **0** across wipe Show, wipe Refresh, second Show, third Refresh. Reviewer probe: remount Show / Refresh `CreateFrame` delta **0**. Same frame pointer. Helper still `if existing then return`. |
| not nested after `runB37C()` | **Pass.** `runB39B()` is a nested `local function` inside `runB28D()` after the `runB37C()` call (`test_fighter_card.lua` ~1237 / ~1243–1401). Packet adds no main-chunk `local`. Header comment only at file top. `luac -l -p`: main chunk **59** locals (cap 200; same as B37-C). FighterCard file locals **52**. |
| Isolated suite not exit 0 / wrap rewritten / exclusive breach | **Pass. Verified.** 731 passed, 0 failed. Writer-reported count matches. Isolation wrap stays under the first `if standalone then` (**17** nil pins). Nested B39-B re-pins Hud / UI / Toasts. Packet is the two named files. Sibling dirt vs HEAD is other lanes (`Hud.lua`, `MainFrame.lua`, `ChurchOfBeef.lua`, TOC, `tests/run.lua`, OPEN_QUESTIONS, REFORMATION_LOG). Both exclusive files are still untracked vs HEAD. |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; do not edit glue, Hud, MainFrame; no commit; no `PlaySound` | **Pass.** Named-risk check. Reviewer did not commit. |
| Existing-frame Show: `rememberSpecial(FRAME_NAME)` then keep `wireCardOnHide` | **Pass.** Brief vs `FighterCard.lua` ~594–595. Nested exists-path pin + wipe-then-Show once. |
| Existing-frame Refresh: `rememberSpecial(FRAME_NAME)` then keep `wireCardOnHide` | **Pass.** Brief vs `FighterCard.lua` ~574–575. Nested exists-path pin + wipe-then-Refresh once. |
| Do **not** reset `lastPair`. No OnShow re-wire. No rebuild | **Pass.** Named-risk check. |
| Wipe list, Show: `ChurchOfBeefFighterCard` re-listed once. Wipe again, Refresh: re-listed once | **Pass.** Nested runtime pins. Reviewer probe: neighbor stays; second Show / third Refresh stay once. |
| Hide remount (B37-C) and Init remount stay | **Pass.** Nested re-reads Hide / Init `rememberSpecial` + `wireCardOnHide`. Reviewer probe: wipe + Hide lists once; wipe + Init lists once. |
| Nest `runB39B()` after `runB37C()`; isolation wrap stays; `lua tests/test_fighter_card.lua` exit 0 | **Pass.** **731 / 0.** Wrap **17**. |

B37 leftover (`Show` / `Refresh` remounted `wireCardOnHide` only; a wiped list then Show-only or Refresh-only left ESC idle until Init or Hide) is this lane's spec. It is closed on the exclusive pair. Law 6 (Quiet after End does not keep the card), Law 10 (no close ✕), §10.6 mute tape (no `UnitHealth`, no `PlaySound`), lastPair until QUIET, wiki ESC via a named `UISpecialFrames` entry, and B20-C Morpheus hold on the exclusive pair.

### Law check

| Law | Verdict |
|---|---|
| Wiki ESC — named frame on `UISpecialFrames`; do not PlaySound `IG_CHARACTER_INFO_*` | **Hold.** `FRAME_NAME` stays `ChurchOfBeefFighterCard`. Show / Refresh remount that name. Source has no `PlaySound` / `IG_CHARACTER_INFO`. |
| Bible §10.6 mute tape / §10.7 persist through the verdict | **Hold.** No `UnitHealth`. Remount does not `forgetPersist`. Reviewer probe: post-`DeclareVictor` Refresh still paints the pair. `health` stays nil. |
| Law 6 / §19.1 Quiet hides Event chrome | **Hold.** EndEvent then Refresh is hidden. ASSEMBLY after QUIET does not revive lastPair. Card `MODE` stays Event. Quiet Show still remounts membership, then hides. |
| Law 10 / §19.3 theatrical card, no close ✕ | **Hold.** No close button. Reviewer probe: `countType(..., "Button")` is **0**. `NAME_FONT` stays `Fonts\\MORPHEUS.ttf`. |
| Law 4 — software never narrates | **Hold.** No new flavor. Existing mute-tape source pins stay. |

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| Widget Hide / ESC does not remount `rememberSpecial`. `CloseSpecialWindows` / `frame:Hide()` bypass `FighterCard:Show` / `Refresh` / `Hide` | **Allowed leftover.** Brief scoped remount on existing-frame `Show` / `Refresh`. Reviewer probe: wipe then `widget:Hide()` leaves count 0; lastView still syncs via the existing OnHide; Refresh after widget Hide still paints lastPair. |
| `ResetForTests` still `paintHidden()` and does not remount | **On contract.** Harness-only. Reviewer probe: wipe then `ResetForTests` leaves count 0. |
| `UISpecialFrames = nil` still no-ops `rememberSpecial` | **On contract.** Brief asked wipe-to-empty uniqueness. Reviewer probe: Show / Refresh with nil leave it nil; assigning `{}` then Show lists the name once. |
| No client smoke; a live remount that dropped the name is simulated by `UISpecialFrames = {}` | **Not a miss.** Brief asked isolated green + wipe-to-`{}` then Show / Refresh list once. |
| Full `lua tests/run.lua` not run | **Not a miss.** Brief asked the isolated suite. |
| Harness `Show()` / `Refresh()` are direct calls, not a real ESC key. Stub `CreateFrame` does not mint `_G["ChurchOfBeefFighterCard"]` | **Not a miss.** Reviewer probe: `_G.ChurchOfBeefFighterCard == nil`. Production `CreateFrame("Frame", FRAME_NAME, …)` does. Membership counts are pinned; the client's special-frame walk is not. |
| Lane is unsigned; no Gate or POLISH claim | **On contract.** This review does not sign the lane. |

The B37 leftover (Show / Refresh skipped `rememberSpecial`, so a wiped list stayed idle until Init or Hide) is closed on the exclusive pair.

---

## Isolation / remount / persist

**Isolation wrap — Pass.** Load list is still Common + Ranks + Store + Runtime + Gora + FighterCard. No `dofile` of Hud, UI shell, Net, DB, glue, or MainFrame. Standalone wrap is still **17** nils (Net, UI, Toasts, DB, Officer, Archive, Recognition, Sender, Codec, Snapshot, Knighting, Minimap, Console, Hud, Sound, DecreeBanner, RecordsBook). Reviewer probe: those keys are nil at load. Wrap is load-time only (unchanged). Nested B39-B re-pins Hud / UI / Toasts after restore. New asserts sit in `runB39B()` inside `runB28D()` after `runB37C()` so Lua 5.1's 200-local cap does not fire.

**Existing-frame remount — Pass.** `Show` and `Refresh` call `rememberSpecial(FRAME_NAME)` when `frame` exists, then `wireCardOnHide(frame)`, then the existing live / Quiet paint. The helper no-ops when a script exists and writes `lastView = hiddenView()` then `paintHidden` unless `hiding` only when OnHide is nil. It does not `build()`, does not `CreateFrame`, does not `PlaySound`, and does not wire OnShow. Init remount still calls `rememberSpecial` (order remains `wireCardOnHide` then `rememberSpecial`). Hide remount still `rememberSpecial` then `wireCardOnHide` then `paintHidden`. No-frame Show still `Init()` first (then remounts again). No-frame Refresh still `Init()` and returns. Reviewer spy: existing / sentinel remount `SetScript` delta 0. `CreateFrame` delta 0 on remounts.

**Persist / uniqueness — Pass.** Wipe-to-empty then Show lists `ChurchOfBeefFighterCard` once and keeps the same OnHide pointer. Wipe again, Refresh lists once. Second Show / third Refresh stay once. Remount does not `forgetPersist`. Refresh while the event is live still paints Chuckroast / Tendermage. Reviewer probe: lastPair-only subjects path after remount + Continue still paints; post-verdict remount still paints; remount Show is not `EndEvent`; ASSEMBLY after QUIET stays hidden. `health` stays nil. Suite persist / OnHide lastView / B28-D / B29-C / B30-B / B37-C pins stay above the nest.

---

## Strengths

- The delta is the brief: one `rememberSpecial(FRAME_NAME)` call on each existing-frame Show / Refresh path, before the existing OnHide remount. An existing script is not replaced. The widget is not rebuilt. Hide remount and Init remount stay. `NAME_FONT` stays `Fonts\\MORPHEUS.ttf`.
- B37 leftover (wiped list stayed empty across Show-only / Refresh-only; ESC idle until Init or Hide) is closed with a runtime remount, not only a source `find`. Second-Show / third-Refresh uniqueness would fail a scan-less append.
- Existing OnHide identity, `CreateFrame` 0, no OnShow, no `PlaySound`, and Refresh lastPair / health-nil sit next to the wipe pins, so a rebuild, a replace-every-Show helper, or a Quiet-style persist wipe on remount would fail the live path.
- Persist / health-nil / Morpheus / B28-D Init / B29-C Show/Refresh OnHide / B37-C Hide special remount / isolation pins were left above the nest. Isolation stayed gated. New locals are inside `runB39B()` inside `runB28D()` after `runB37C()`.
- Writer-reported **731 / 0** matched the re-run. Writer-reported red (**723 / 8**) matches the Show / Refresh exists-path-missing-`rememberSpecial` + remount-before-wire + wiped-list-stayed-0 cluster that pre-B39-B Show / Refresh would fail.

---

## Issues

### Critical

None.

### Important leftover — not must-fix

1. **Widget Hide / ESC does not remount `rememberSpecial`.** Reviewer probe: wipe then `widget:Hide()` leaves count 0. `CloseSpecialWindows` walks names and calls `Frame:Hide`, not `FighterCard:Show` / `Refresh` / `Hide`. A wiped list that never hits those entry points stays idle. Brief scoped remount on existing-frame Show / Refresh.

2. **No `/reload` smoke.** `CloseSpecialWindows` walks every shown name on `UISpecialFrames`. One real ESC may still hide the card with other listed chrome. Brief asked isolated remount + uniqueness once, not a client walk.

### Nit

1. **Nested lastPair pins still fire while `Gora:GetSanctioned()` is live.** `displayPair()` prefers the live pair, so those asserts would still pass if remount niled `lastPair` and immediately re-remembered from Gora. Reviewer probe closed lastPair-only (subjects Continue; post-`DeclareVictor`) and Quiet-forget. Not a miss.

2. **Neighbor uniqueness is not in-lane.** Nested wipe is to `{}`. Reviewer probe: wipe to `{ "OtherFrame" }` then Show / Refresh keeps the neighbor and lists the card once.

3. **Isolation wrap is load-only.** Seventeen pins under `if standalone then` at file load. Nested B39-B re-pins three of them. Brief said the wrap stays; it did.

4. **Exclusive-pair diff is not a vs-HEAD FighterCard delta.** Packet is the B39-B-only exists-path calls + header comment + nested pins. Both exclusive files are still untracked vs HEAD and also carry earlier card batches. Report already says this.

5. **`runB39B()` adds no new main-chunk local.** Brief asked isolation wrap stays, not zero new chunk locals. Pin locals sit inside the nest. `luac` main chunk is **59 / 200**.

6. **`UISpecialFrames = nil` is unpinned inside `runB39B()`.** Older Init-survives-missing-table behavior stays. Probe: Show / Refresh with nil leave it nil. Brief asked wipe to `{}`.

7. **Harness `Show()` / `Refresh()` are not ESC. Stub `CreateFrame` does not mint `_G["ChurchOfBeefFighterCard"]`.** Reviewer probe: `_G.ChurchOfBeefFighterCard == nil`. Same stub gap other named-special-frame lanes named.

8. **No full `lua tests/run.lua`.** Isolated **731 / 0** was re-run here.

---

## Must-fix

None.

---

## Assessment

**1. Spec PASS.** Brief: existing-frame Show / Refresh remount `rememberSpecial(FRAME_NAME)` and keep `wireCardOnHide`; do not reset `lastPair`; no OnShow re-wire; no rebuild; no `PlaySound`; wipe then Show lists `ChurchOfBeefFighterCard` once; wipe then Refresh lists once; Hide remount / Init remount stay. Live `Show` ~594–595 and `Refresh` ~574–575 match. Brief test pins sit in `runB39B()` after `runB37C()` inside `runB28D()`.

**2. Quality: Approved-with-nits.** Must-fix none. Important leftovers: widget Hide / ESC still does not remount; no `/reload` smoke. Nits listed above.

**3. Isolation count:** **731 passed, 0 failed.** Isolation wrap: **17**. Main-chunk locals: **59 / 200**.

**4. Law:** Wiki ESC holds: Show / Refresh re-list the named frame after a wipe. Law 6 holds: Quiet after End still hides; ASSEMBLY after QUIET does not revive. Law 10 holds: no close ✕; Morpheus stays. §10.6 / §10.7 hold: no `UnitHealth`, no `PlaySound`; remount does not forget lastPair. Law 4 holds: no new flavor.

**Leftovers:**
- Widget Hide / ESC does not remount `rememberSpecial`. A wiped list that never hits `FighterCard:Show` / `Refresh` / `Hide` / Init stays idle.
- `ResetForTests` does not remount. `UISpecialFrames = nil` still no-ops.
- Nested lastPair pins are live-pair-tolerant; reviewer probe closed lastPair-only.
- No `/reload` smoke; real ESC vs `CloseSpecialWindows` is unproven. ESC walks names and calls `Frame:Hide`, not `FighterCard:Hide`.
- Full `lua tests/run.lua` was not run.
- Harness membership counts are pinned; the client's special-frame walk is not. Stub `CreateFrame` does not mint `_G["ChurchOfBeefFighterCard"]`.
- Exclusive-pair packet is the B39-B-only delta, not vs HEAD.
- Isolation wrap is load-only.
- Gate W stays OPEN. Gate V stays OPEN.

Existing-frame `FighterCard:Show` and `FighterCard:Refresh` call `rememberSpecial(FRAME_NAME)` then `wireCardOnHide(frame)`. The helper does not replace an existing script and does not wire OnShow. Wipe `UISpecialFrames` to `{}`, Show lists `ChurchOfBeefFighterCard` exactly once. Wipe again, Refresh lists once. No rebuild. No `PlaySound`. lastPair until QUIET stays. `FRAME_NAME` stays `ChurchOfBeefFighterCard`. B37-C Hide remount stays. B29-C Show / Refresh OnHide remount stay. B28-D Init remount stays. `runB39B()` is nested inside `runB28D()` after `runB37C()`. Isolated `lua tests/test_fighter_card.lua` **731 passed, 0 failed**, exit 0.

Do not claim V1 / MVP complete. This review does not sign the lane. Do not claim Gate W, Gate V, or POLISH:PASS.
