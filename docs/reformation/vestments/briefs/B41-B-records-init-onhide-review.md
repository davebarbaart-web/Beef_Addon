Spec PASS

# B41-B — RecordsBook Init remounts missing OnHide (review)

**Quality:** Approved-with-nits

**Lane:** B41-B existing-frame `Init` remounts a missing OnHide
**Brief:** `docs/reformation/vestments/briefs/B41-B-records-init-onhide.md`
**Writer report:** `docs/reformation/vestments/briefs/B41-B-records-init-onhide-report.md`
**Diff:** `docs/reformation/vestments/briefs/B41-B-records-init-onhide.diff` (B41-B-only exclusive-pair packet; live `RecordsBook.lua` / `test_records.lua` also carry earlier Records Book batches vs HEAD)
**Exclusive files:** `addon/ChurchOfBeef/UI/RecordsBook.lua`, `tests/test_records.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, the provided exclusive-pair diff, live `UI/RecordsBook.lua` (`Init` ~854–863 / header ~6–10 / `wireBookOnHide` ~613–621 / `Show` ~869–876 / `Hide` ~878–885 / `buildFrame` create-path ~676–677 / `rememberSpecial` ~601–607 / `FRAME_NAME` / `pageIndex` / `PAGE_TITLES` / `paint` / `Toggle` / Close `OnClick` ~794 / `ResetForTests` ~847–852), and `tests/test_records.lua` (isolation wrap, nested `runB41B()` inside `runB25C()` after `runB40B()`, plus the B38-D / B40-B keep-strings that now expect `wireBookOnHide` in Init); then ran `lua tests/test_records.lua` (**744 passed, 0 failed**, exit 0, Lua **5.1.5**) and throwaway probes that do not live in the exclusive files. Law cited: wiki ESC via `UISpecialFrames` (named frame; do not `PlaySound` `IG_CHARACTER_INFO_*`); Law 6 / §19.4 (Quiet silent; no panel whoosh); Law 10 / Bible §19.3 / §14.2 (theatrical parchment Records Book; player-opened Quiet identity/history); B40-B leftover (`Init` remounted `rememberSpecial` but skipped `wireBookOnHide`; a niled OnHide stayed idle until Show or Hide). Existing-frame Init: remount missing OnHide (`wireBookOnHide`), then `rememberSpecial(FRAME_NAME)`. Never replace an existing script. Do **not** reset `pageIndex`. No OnShow re-wire. No rebuild. No `PlaySound` / `IG_CHARACTER_INFO_*`. No Records remap. Isolation wow_ui_stub + Common + Ranks + Store + RecordsBook only. Did not mutate `RecordsBook.lua` or `test_records.lua`. Did not commit. Did not edit glue, MainFrame, TOC, bootstrap, `ChurchOfBeef.lua`, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG.

This review does not sign the lane. Do not claim Gate W / Gate V / **POLISH:PASS**.

---

## Named risks

| Risk | Verdict |
|---|---|
| Init still skips `wireBookOnHide` | **Pass. Verified.** Live existing-frame `Init` (~854–863) is `wireBookOnHide(self.frame)` then `rememberSpecial(FRAME_NAME)` then `return self.frame`. Nested source pin: `wireBookOnHide` before `rememberSpecial(FRAME_NAME)`. Nested wrap: wipe list, nil OnHide, Init restores OnHide and lists `ChurchOfBeefRecordsBook` once. Reviewer spy: niled handler + wipe + `RecordsBook:Init()` restores OnHide, including while already hidden. Create-path is unchanged (`buildFrame` after nil frame). |
| Existing OnHide replaced | **Pass. Verified.** Helper is still `if existing then return end` after `GetScript("OnHide")`. Init body has no inline `SetScript`. Nested: second Init and third Init keep the restored identity; list stays once. Reviewer spy: a sentinel OnHide survives first / second / third Init and is not fired by Init; a custom keeper also survives Init while Init still lists the name once; Hide / close-button Hide do not replace the sentinel. |
| `pageIndex` reset | **Pass. Verified.** Init body, helper, and OnHide have no `pageIndex` assign. Nested: turn to Longest Streak, wipe + Init, title stays Longest Streak; second and third Init still do not reset. Reviewer probe: last-leaf Init then Show (paint) still paints Tournament Champions. `paint()` still only clamps; `ResetForTests` still assigns `pageIndex = 1` (harness-only). |
| `PlaySound` / `IG_CHARACTER_INFO_*` | **Pass.** Source has no `PlaySound`, no `IG_CHARACTER_INFO`, no `SetScript("OnShow"`. Nested + reviewer probe: remount Init / third Init / already-hidden Init / Toggle remount play no sound (`sounds` unchanged). Live `GetScript("OnShow")` stays nil after create and after remount Init. No `IG_CHARACTER_INFO_*`. No OnShow re-wire. |
| Records remap | **Pass.** `FRAME_NAME` stays `ChurchOfBeefRecordsBook`. PAGE_TITLES stay the nine Bible titles. `PAGE_TITLE_FONT` stays `Fonts\\MORPHEUS.ttf`. Chrome title stays `The Records Book`. `MODE` stays `QUIET`. Nested `#GetPages() == 9`. Reviewer probe: first / second / last titles unchanged. |
| B38-D / B40-B keep-strings not updated (suite red) | **Pass. Verified.** B38-D Init source pin now expects `wireBookOnHide` in Init (`test_records.lua` ~629–630). B40-B Init source pin now expects the same (~773–774). No leftover `Init remount does not remount OnHide` forbid. Isolated suite is **744 / 0**, not red. Show remount source pins stay. Hide remount source pins stay (`wireBookOnHide` then `rememberSpecial(FRAME_NAME)` then `self.frame:Hide()`). |
| Not nested after `runB40B()` | **Pass.** `runB41B()` is a nested `local function` inside `runB25C()` after the `runB40B()` call (`test_records.lua` ~865 / ~874–1009). Packet adds no main-chunk `local`. Header comment only at file top. `luac -l -p`: test main chunk still **123** locals (cap 200). RecordsBook file locals still **45**. |
| Isolated suite not exit 0 | **Pass. Verified.** 744 passed, 0 failed. Writer-reported count matches. Isolation wrap stays under the first `if standalone then` (**11** nil pins). `runB41B()` re-pins 5 of them. Packet is the two named files. Sibling dirt vs HEAD is other lanes. |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; do not edit glue, MainFrame; no commit; no Records remap; no `PlaySound`; `pageIndex` persist stays | **Pass.** Named-risk check. Reviewer did not commit. |
| Existing-frame Init: remount missing OnHide (`wireBookOnHide`), then `rememberSpecial(FRAME_NAME)` | **Pass.** Named-risk check. Brief vs `RecordsBook.lua` ~854–863. Nested order pins (`wireAt < remountAt`). Wipe + Init lists `ChurchOfBeefRecordsBook` once. |
| Never replace an existing script | **Pass.** Named-risk check. Nested third-Init identity + reviewer sentinel spy. |
| Do **not** reset `pageIndex` | **Pass.** Named-risk check. |
| No OnShow re-wire. No rebuild. No `PlaySound` / `IG_CHARACTER_INFO_*` | **Pass.** Named-risk check. Nested CreateFrame spy: remount Init is **0** creates; same frame pointer. Init remount does not paint / Show / Hide. |
| B38-D / B40-B source pins that forbade `wireBookOnHide` in Init are updated | **Pass.** Named-risk check. |
| Nest `runB41B()` after `runB40B()` inside `runB25C()`; wipe list, nil OnHide, Init: OnHide restored, name re-listed once, `pageIndex` unchanged, no sound; third Init does not replace OnHide | **Pass.** Named-risk check. |
| Isolation wrap stays; `lua tests/test_records.lua` exit 0 | **Pass.** **744 / 0.** Wrap **11**. |

Wiki ESC via a named `UISpecialFrames` entry holds on the exclusive pair: when OnHide is missing, the next `RecordsBook:Init` remounts it so a later widget Hide / ESC can re-list. Law 6 / §19.4 hold: remount Init is silent; no `IG_CHARACTER_INFO_*` whoosh. Law 10 / §19.3 / §14.2 hold: theatrical parchment tome; chrome title stays `The Records Book`; PAGE_TITLES stay 9; `PAGE_TITLE_FONT` stays `Fonts\\MORPHEUS.ttf`. The B40 leftover (`Init` skipped `wireBookOnHide`; a niled OnHide stayed idle until Show or Hide) is closed on the exclusive pair when the next open goes through `RecordsBook:Init`. A niled widget Hide / ESC still cannot remount itself — brief scoped Init remount, not widget remount.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| Widget Hide / ESC does not remount a niled OnHide | **On contract.** The missing handler cannot remount itself. `CloseSpecialWindows` / `frame:Hide()` still bypass `RecordsBook:Init` and `RecordsBook:Hide`. Brief asked Init remount + no OnShow re-wire. Reviewer probe: niled widget Hide leaves count 0 and OnHide nil; the next `RecordsBook:Init` restores both. |
| Show does not call `rememberSpecial` itself | **On contract.** Brief scoped Init remount. Listing after wipe still happens once via B25-C / B41-B Init. Hide / OnHide still remount the name. |
| No client smoke; real ESC vs `CloseSpecialWindows` on Anniversary is unproven | **Not a miss.** Brief asked the isolated suite. A live remount that dropped the name is simulated by `UISpecialFrames = {}`. A dropped handler is simulated by `SetScript("OnHide", nil)`. Reviewer widget Hide closed the remount-when-present path on the stub. |
| Full `lua tests/run.lua` not run | **Not a miss.** Brief asked the isolated suite. |
| Harness `Init()` is a direct call, not a real ESC key | **On contract.** Script identity, membership once, and pageIndex persist are pinned; the client's special-frame walk is not. Reviewer widget Hide is the stub's shown→hidden OnHide fire. |
| Lane is unsigned; no Gate or POLISH claim | **On contract.** This review does not sign the lane. |

The B40 leftover (`Init` skipped `wireBookOnHide`; a niled OnHide stayed idle until Show or Hide) is this lane's spec. It is closed on the exclusive pair when the next call goes through `RecordsBook:Init`.

---

## Isolation / remount / keep

**Isolation wrap — Pass.** Load list is still wow_ui_stub + Common + Ranks + Store + RecordsBook. No `dofile` of Runtime, Gora, Officer, MainFrame, Net, DB, Sender, Minimap, Toasts, Console, or Hud. Standalone wrap is still **11** nils (Runtime, Gora, Officer, UI, Net, DB, Sender, Minimap, Toasts, Console, Hud). Reviewer probe: those keys are nil at load. Wrap is load-time only (unchanged). Nested B41-B re-pins 5 of them (Runtime, UI, Toasts, Console, Hud). `runB25C()` still re-pins the same five after `runB41B()`.

**Remount — Pass.** `wireBookOnHide` no-ops when a script exists and writes `rememberSpecial(FRAME_NAME)` only when OnHide is nil. Existing-frame Init remounts the missing handler, then remounts `rememberSpecial`. Create-path still wires after create-time `frame:Hide()` so mint Hide does not fire the remount. Show still remounts OnHide (B40-B) after `Init()`. Hide still remounts OnHide then `rememberSpecial` then `frame:Hide()` (B38-D). Reviewer spy: wipe + widget Hide after remount lists the name once; niled handler + widget Hide does not; already-hidden `RecordsBook:Init()` still restores the handler; Toggle remounts because Toggle calls Hide or Show. Same frame pointer. Wrapped `CreateFrame` **0**. Init remount does not close an open book.

**Keep — Pass.** B40-B Show OnHide remount stays. B38-D Hide OnHide remount stays. B28-C Hide `rememberSpecial` remount stays. B25-C Init `rememberSpecial` remount stays and now also remounts OnHide. `wireBookOnHide` still does not replace. `rememberSpecial` still scan-then-append; missing table no-ops. Create-path still wires after create-time Hide. `pageIndex` persist stays. PAGE_TITLES stay 9. `PAGE_TITLE_FONT` stays `Fonts\\MORPHEUS.ttf`. `FRAME_NAME` stays `ChurchOfBeefRecordsBook`. No `PlaySound`. No Records remap. Isolation wrap stays. No new main-chunk locals in `test_records.lua`.

---

## Strengths

- The remount is one call on the existing-frame Init path. Failed-to-replace, Show, Hide, and create-path cannot empty or swap a live OnHide.
- `if existing then return` sits next to wipe + nil + Init restore, so a blanket `SetScript` on every Init would fail the third-Init identity pin and the reviewer sentinel spy.
- Init remounts OnHide before `rememberSpecial(FRAME_NAME)`, so a later widget Hide / ESC can re-list after a wipe without waiting for `RecordsBook:Show` or `RecordsBook:Hide`. That is the B40 leftover close.
- B40-B Show remount, B38-D Hide remount, B25-C Init name remount, no-replace helper, PAGE_TITLES / Morpheus, and no-sound pins sit next to the Init call, so a Show / Hide rewrite, a Records remap, or a whoosh would fail.
- `runB41B()` sits after `runB40B()` inside `runB25C()`. B38-D / B40-B keep-strings were updated so the suite is not red. Isolation wrap stays **11**. No new main-chunk locals. Writer-reported **744 / 0** matched the re-run.

---

## Issues

### Critical

None.

### Important leftover — not must-fix

1. **Widget Hide / ESC does not remount a niled OnHide.** The missing handler cannot remount itself. `CloseSpecialWindows` / `frame:Hide()` still bypass `RecordsBook:Init` and `RecordsBook:Hide`. A dropped OnHide that never hits Init / Show / Hide still leaves a wiped list idle. Brief scoped the `RecordsBook:Init` remount. Reviewer probe: niled handler + wipe + `frame:Hide()` leaves count 0. The next `RecordsBook:Init` restores the handler and lists once.

### Nit

1. **Nested pageIndex keep is painted title after Init, and Init does not paint.** Source pin forbids `pageIndex` in the early-return body. Reviewer last-leaf Init then Show (paint) still paints Tournament Champions. Nested Longest Streak title after Init would also stay if Init reset the index and skipped paint.

2. **Show does not call `rememberSpecial` itself.** Required keep of the brief's Init remount. Listing after wipe is B25-C / B41-B Init. Hide / OnHide still remount the name.

3. **`ResetForTests` still calls `self.frame:Hide()` directly** and still assigns `pageIndex = 1`. Harness-only. Brief scoped existing-frame `Init`. Production Close / Toggle / Show remount.

4. **Harness `Init()` in the nested block is a direct call**, not a real ESC key. Script identity, membership once, and pageIndex persist are pinned. Reviewer widget Hide closed the remount-when-present path on the stub. Stub `CreateFrame` still does not mint `_G["ChurchOfBeefRecordsBook"]`.

5. **Last leaf, already-hidden Init, Toggle remount, close-button Hide, and custom OnHide are reviewer probes, not nested pins.** All stay on contract. Toggle remounts only because Toggle calls Hide or Show.

6. **Exclusive-pair packet is not a vs-HEAD Records Book delta.** Packet is the B41-B-only Init call + header note + nested pins + B38-D / B40-B keep-string updates. `git diff HEAD` on the two files still includes earlier Records Book batches. Report already says this.

7. **Isolation wrap is load-only.** Eleven pins under the first `if standalone then`. Nested B41-B re-pins five of them. Brief said the wrap stays; it did.

8. **No `/reload` smoke and no full `lua tests/run.lua`.** Isolated **744 / 0** was re-run here. Real ESC vs `CloseSpecialWindows` on Anniversary is unproven.

---

## Must-fix

None.

---

## Assessment

**1. Spec PASS.** Brief: existing-frame Init remounts missing OnHide (`wireBookOnHide`), then `rememberSpecial(FRAME_NAME)`; never replace an existing script; do not reset `pageIndex`; no OnShow; no rebuild; no `PlaySound` / `IG_CHARACTER_INFO_*`; no Records remap; update the B38-D / B40-B keep-strings that forbade `wireBookOnHide` in Init. Live `Init` ~854–863 and `wireBookOnHide` ~613–621 match. Brief test pins sit in `runB41B()` after `runB40B()` inside `runB25C()`.

**2. Quality: Approved-with-nits.** Must-fix none. Important leftover: widget Hide / ESC still cannot remount a niled OnHide (brief scoped `RecordsBook:Init`). Nits listed above.

**3. Isolation count:** **744 passed, 0 failed.** Isolation wrap: **11**.

**4. Law:** Wiki ESC via `UISpecialFrames` holds when OnHide is present, and the next `RecordsBook:Init` remounts a missing handler. Law 6 / §19.4 hold: remount Init is silent. Law 10 / §19.3 / §14.2 hold: theatrical parchment tome; PAGE_TITLES stay 9; no Records remap. B40 leftover is closed on Init remount. B40-B Show remount stays. B38-D Hide remount stays.

**Leftovers:**
- Widget Hide / ESC does not remount a niled OnHide (Important, not must-fix; brief scoped `RecordsBook:Init`).
- Nested pageIndex keep is painted title without a post-Init paint (reviewer last-leaf Show paint closed it).
- Show does not call `rememberSpecial` itself (Init remount stays).
- `ResetForTests` still widget-Hides and still resets `pageIndex` (harness-only).
- Nested Init is not a real ESC key.
- Last leaf / Toggle / already-hidden / close / custom OnHide are reviewer probes.
- Exclusive-pair packet is not a vs-HEAD Records Book delta.
- Isolation wrap is load-only.
- Full `lua tests/run.lua` was not run.
- Gate W stays OPEN. Gate V stays OPEN.

Existing-frame `Init` remounts a missing OnHide, then `rememberSpecial(FRAME_NAME)`. An existing script is not replaced. `pageIndex` persist stays. No OnShow. No rebuild. No `PlaySound`. No Records remap. Wipe list, nil OnHide, Init restores OnHide and re-lists `ChurchOfBeefRecordsBook` once. Third Init keeps OnHide identity. B38-D / B40-B keep-strings were updated. `runB41B()` is nested inside `runB25C()` after `runB40B()`. Isolated `lua tests/test_records.lua` **744 passed, 0 failed**, exit 0.

Do not claim V1 / MVP complete. This review does not sign the lane. Do not claim Gate W, Gate V, or POLISH:PASS.
