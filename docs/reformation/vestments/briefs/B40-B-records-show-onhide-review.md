Spec PASS

# B40-B — RecordsBook Show remounts missing OnHide (review)

**Quality:** Approved-with-nits

**Lane:** B40-B existing-frame `Show` remounts a missing OnHide
**Brief:** `docs/reformation/vestments/briefs/B40-B-records-show-onhide.md`
**Writer report:** `docs/reformation/vestments/briefs/B40-B-records-show-onhide-report.md`
**Diff:** `docs/reformation/vestments/briefs/B40-B-records-show-onhide.diff` (B40-B-only exclusive-pair packet; live `RecordsBook.lua` / `test_records.lua` also carry earlier Records Book batches vs HEAD)
**Exclusive files:** `addon/ChurchOfBeef/UI/RecordsBook.lua`, `tests/test_records.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, the provided exclusive-pair diff, live `UI/RecordsBook.lua` (`Show` ~867–873 / header ~6–8 / `wireBookOnHide` ~612–619 / `Hide` ~876–882 / `Init` ~853–860 / `buildFrame` create-path ~675–676 / `rememberSpecial` / `FRAME_NAME` / `pageIndex` / `PAGE_TITLES` / `paint` / `Toggle` / Close `OnClick`), and `tests/test_records.lua` (isolation wrap, nested `runB40B()` inside `runB25C()` after `runB38D()`, plus the B38-D keep-string that now expects `wireBookOnHide` in Show); then ran `lua tests/test_records.lua` (**682 passed, 0 failed**, exit 0, Lua **5.1.5**) and throwaway probes that do not live in the exclusive files. Law cited: wiki ESC via `UISpecialFrames` (named frame; do not `PlaySound` `IG_CHARACTER_INFO_*`); Law 6 / §19.4 (Quiet silent; no panel whoosh); Law 10 / Bible §19.3 / §14.2 (theatrical parchment Records Book; player-opened Quiet identity/history); B38-D leftover (`Show` skipped `wireBookOnHide`; a niled OnHide stayed idle until Hide). Existing-frame Show: remount missing OnHide (`wireBookOnHide`), then paint / `frame:Show()`. Show did not already remount `rememberSpecial` (Init remount stays), so Show does not add that call. Never replace an existing script. Do **not** reset `pageIndex`. No OnShow re-wire. No rebuild. No `PlaySound` / `IG_CHARACTER_INFO_*`. No Records remap. Isolation wow_ui_stub + Common + Ranks + Store + RecordsBook only. Did not mutate `RecordsBook.lua` or `test_records.lua`. Did not commit. Did not edit glue, MainFrame, TOC, bootstrap, `ChurchOfBeef.lua`, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG.

This review does not sign the lane. Do not claim Gate W / Gate V / **POLISH:PASS**.

---

## Named risks

| Risk | Verdict |
|---|---|
| Show still skips `wireBookOnHide` | **Pass. Verified.** Live existing-frame `Show` is `Init()`, then `wireBookOnHide(frame)`, then `paint()`, then `frame:Show()`. Nested source pin: Show remount body has `wireBookOnHide` before `paint()` before `frame:Show()`. Wipe list, nil OnHide, Show restores OnHide. Reviewer spy: Init-only leaves a niled OnHide nil; the next `RecordsBook:Show` remounts it. Toggle-from-hidden is still Show and remounts. |
| Existing OnHide replaced | **Pass. Verified.** Helper is still `if existing then return end` after `GetScript("OnHide")`. Show body has no inline `SetScript`. Nested: second Show and third Show keep the restored identity; list stays once. Reviewer spy: a sentinel OnHide survives first / second / third Show and is not fired by Show; a custom keeper also survives Show while Init still lists the name once. |
| `pageIndex` reset | **Pass. Verified.** Show body, helper, and OnHide have no `pageIndex` assign. Nested: turn to Longest Streak, wipe + Show, title stays Longest Streak; second and third Show still do not reset. Reviewer probe: last-leaf Show still paints Tournament Champions. `paint()` still only clamps; `ResetForTests` still assigns `pageIndex = 1` (harness-only). |
| `PlaySound` / `IG_CHARACTER_INFO_*` | **Pass.** Source has no `PlaySound`, no `IG_CHARACTER_INFO`, no `SetScript("OnShow"`. Nested + reviewer probe: remount Show / third Show / Toggle-Show / Hide-only remount play no sound (`sounds` unchanged). Live `GetScript("OnShow")` stays nil after create and after remount Show. |
| Records remap | **Pass.** `FRAME_NAME` stays `ChurchOfBeefRecordsBook`. PAGE_TITLES stay the nine Bible titles. `PAGE_TITLE_FONT` stays `Fonts\\MORPHEUS.ttf`. Chrome title stays `The Records Book`. `MODE` stays `QUIET`. Nested `#GetPages() == 9`. Reviewer probe: first / second / last titles unchanged. |
| B38-D keep-string not updated (suite red) | **Pass. Verified.** B38-D Show source pin now expects `wireBookOnHide` in Show (`test_records.lua` ~618–619). B38-D live nile after wipe + Show now expects OnHide restored (~677–678). Isolated suite is **682 / 0**, not red. Hide remount source pins stay (`wireBookOnHide` then `rememberSpecial(FRAME_NAME)` then `self.frame:Hide()`). |
| Not nested after `runB38D()` | **Pass.** `runB40B()` is a nested `local function` inside `runB25C()` after the `runB38D()` call (`test_records.lua` ~721 / ~730–864). Packet adds no main-chunk `local`. Header comment only at file top. `luac -l -p`: test main chunk still **123** locals (cap 200). RecordsBook file locals still **45**. |
| Isolated suite not exit 0 | **Pass. Verified.** 682 passed, 0 failed. Writer-reported count matches. Isolation wrap stays under the first `if standalone then` (**11** nil pins). `runB40B()` re-pins 5 of them. Packet is the two named files. Sibling dirt vs HEAD (MainFrame, TOC, glue, `run.lua`, OPEN_QUESTIONS, REFORMATION_LOG) is other lanes. |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; do not edit glue, MainFrame; no commit; no Records remap; no `PlaySound`; `pageIndex` persist stays | **Pass.** Named-risk check. Reviewer did not commit. |
| Existing-frame Show: remount missing OnHide (`wireBookOnHide`), then `rememberSpecial` if you already remount it, then paint / `frame:Show()` | **Pass.** Brief vs `RecordsBook.lua` ~867–873. Show did not already remount `rememberSpecial`; Init remount stays. Nested order pins (`wireAt < paintAt < showAt`). Wipe + Show lists `ChurchOfBeefRecordsBook` once via Init. |
| Never replace an existing script | **Pass.** Named-risk check. Nested third-Show identity + reviewer sentinel spy. |
| Do **not** reset `pageIndex` | **Pass.** Named-risk check. |
| No OnShow re-wire. No rebuild. No `PlaySound` / `IG_CHARACTER_INFO_*` | **Pass.** Named-risk check. Nested CreateFrame spy: remount Show is **0** creates; same frame pointer. |
| B38-D source pin that forbade `wireBookOnHide` in Show is updated | **Pass.** Named-risk check. |
| Nest `runB40B()` after `runB38D()` inside `runB25C()`; wipe list, nil OnHide, Show: OnHide restored, name re-listed once, `pageIndex` unchanged, no sound; third Show does not replace OnHide | **Pass.** Named-risk check. |
| Isolation wrap stays; `lua tests/test_records.lua` exit 0 | **Pass.** **682 / 0.** Wrap **11**. |

Wiki ESC via a named `UISpecialFrames` entry holds on the exclusive pair: when OnHide is missing, the next `RecordsBook:Show` remounts it so a later widget Hide / ESC can re-list. Law 6 / §19.4 hold: remount Show is silent; no `IG_CHARACTER_INFO_*` whoosh. Law 10 / §19.3 / §14.2 hold: theatrical parchment tome; chrome title stays `The Records Book`; PAGE_TITLES stay 9; `PAGE_TITLE_FONT` stays `Fonts\\MORPHEUS.ttf`. The B38 leftover (`Show` skipped `wireBookOnHide`; a niled OnHide stayed idle until Hide) is closed on the exclusive pair when the next open goes through `RecordsBook:Show`. A niled handler that only hits Init, or a niled widget Hide / ESC, still cannot remount itself — brief scoped Show remount, not Init / widget remount.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| Init remount still skips a niled OnHide | **On contract.** Brief asked Show remount and no OnShow re-wire. B25-C Init still remounts the name. Reviewer probe: Init leaves OnHide nil; the next Show restores it. |
| Show does not call `rememberSpecial` itself | **On contract.** Brief said remount it if Show already remounted it. Show did not; listing after wipe still happens once via B25-C Init. Hide / OnHide still remount the name. |
| Widget Hide / ESC does not remount a niled OnHide | **On contract.** The missing handler cannot remount itself. `CloseSpecialWindows` / `frame:Hide()` still bypass `RecordsBook:Show` and `RecordsBook:Hide`. Brief asked Show remount + no OnShow re-wire. Reviewer probe: niled widget Hide leaves count 0 and OnHide nil; the next `RecordsBook:Show` restores both. |
| No client smoke; real ESC vs `CloseSpecialWindows` on Anniversary is unproven | **Not a miss.** Brief asked the isolated suite. A live remount that dropped the name is simulated by `UISpecialFrames = {}`. A dropped handler is simulated by `SetScript("OnHide", nil)`. Reviewer widget Hide closed the remount-when-present path on the stub. |
| Full `lua tests/run.lua` not run | **Not a miss.** Brief asked the isolated suite. |
| Harness `Show()` is a direct call, not a real ESC key | **Not a miss.** Brief asked script identity, membership once, and pageIndex persist. Reviewer widget Hide is the stub's shown→hidden OnHide fire. |
| Lane is unsigned; no Gate or POLISH claim | **On contract.** This review does not sign the lane. |

The B38 leftover (`Show` skipped `wireBookOnHide`; a niled OnHide stayed idle until Hide) is this lane's spec. It is closed on the exclusive pair when the next open goes through `RecordsBook:Show`.

---

## Isolation / clear / keep

**Isolation wrap — Pass.** Load list is still wow_ui_stub + Common + Ranks + Store + RecordsBook. No `dofile` of Runtime, Gora, Officer, MainFrame, Net, DB, Sender, Minimap, Toasts, Console, or Hud. Standalone wrap is still **11** nils (Runtime, Gora, Officer, UI, Net, DB, Sender, Minimap, Toasts, Console, Hud). Reviewer probe: those keys are nil at load. Wrap is load-time only (unchanged). Nested B40-B re-pins 5 of them (Runtime, UI, Toasts, Console, Hud). `runB25C()` still re-pins the same five after `runB40B()`.

**Clear-before-Show — Pass.** Wipe `UISpecialFrames`, nil OnHide, then `RecordsBook:Show` restores OnHide and lists `ChurchOfBeefRecordsBook` once. Same frame pointer. An existing script is not replaced. `pageIndex` stays on the second leaf. No sound. No rebuild. Reviewer spy: Init-only after the same wipe still leaves OnHide nil and still lists the name (B25-C). Hide-only after a niled handler still remounts OnHide (B38-D).

**Keep — Pass.** B38-D Hide OnHide remount stays. B28-C Hide `rememberSpecial` remount stays. B25-C Init remount stays and still does not remount OnHide. `wireBookOnHide` still does not replace. `rememberSpecial` still scan-then-append; missing table no-ops. Create-path still wires after create-time Hide. `pageIndex` persist stays. PAGE_TITLES stay 9. `PAGE_TITLE_FONT` stays `Fonts\\MORPHEUS.ttf`. `FRAME_NAME` stays `ChurchOfBeefRecordsBook`. No `PlaySound`. No Records remap. Isolation wrap stays. No new main-chunk locals in `test_records.lua`.

---

## Strengths

- The remount is one call on the existing-frame Show path. Failed-to-replace, Init, Hide, and create-path cannot empty or swap a live OnHide.
- `if existing then return` sits next to wipe + nil + Show restore, so a blanket `SetScript` on every Show would fail the third-Show identity pin and the reviewer sentinel spy.
- Show remounts OnHide before paint / `frame:Show()`, so a later widget Hide / ESC can re-list after a wipe without waiting for `RecordsBook:Hide`. That is the B38 leftover close.
- B38-D Hide remount, B25-C Init remount, no-replace helper, PAGE_TITLES / Morpheus, and no-sound pins sit next to the Show call, so a Hide rewrite, a Records remap, or a whoosh would fail.
- `runB40B()` sits after `runB38D()` inside `runB25C()`. B38-D keep-string was updated so the suite is not red. Isolation wrap stays **11**. No new main-chunk locals. Writer-reported **682 / 0** matched the re-run.

---

## Issues

### Critical

None.

### Important leftover — not must-fix

1. **Init remount still skips a niled OnHide.** Brief asked Show remount and no OnShow re-wire. Reviewer probe: niled handler + wipe + `Init` lists the name and leaves OnHide nil. The next `RecordsBook:Show` restores the handler.

2. **Widget Hide / ESC does not remount a niled OnHide.** The missing handler cannot remount itself. `CloseSpecialWindows` / `frame:Hide()` still bypass `RecordsBook:Show` and `RecordsBook:Hide`. Reviewer probe: niled handler + wipe + `frame:Hide()` leaves count 0. The next `RecordsBook:Show` restores the handler and lists once.

### Nit

1. **B38-D wipe + Show + Hide no longer independently proves Hide remounts a *missing* OnHide.** After the required keep-string update, Show already restores the handler; the Hide assert is now keep-identity. Hide remount source pins stay. Reviewer Hide-only probe: nil then `RecordsBook:Hide` (no intervening Show) still remounts OnHide and lists once.

2. **Show does not call `rememberSpecial` itself.** Required keep of the brief's "if you already remount it." Listing after wipe is B25-C Init. Hide / OnHide still remount the name.

3. **`ResetForTests` still calls `self.frame:Hide()` directly** and still assigns `pageIndex = 1`. Harness-only. Brief scoped `RecordsBook:Show`. Production Close / Toggle / Show remount.

4. **Harness `Show()` in the nested block is a direct call**, not a real ESC key. Script identity, membership once, and pageIndex persist are pinned. Reviewer widget Hide closed the remount-when-present path on the stub. Stub `CreateFrame` still does not mint `_G["ChurchOfBeefRecordsBook"]`.

5. **Last leaf, Toggle-from-hidden, close-button Hide, and custom OnHide are reviewer probes, not nested pins.** All stay on contract.

6. **Exclusive-pair packet is not a vs-HEAD Records Book delta.** Packet is the B40-B-only Show call + header note + nested pins + B38-D keep-string update. `git diff HEAD` on the two files still includes earlier Records Book batches. Report already says this.

7. **Isolation wrap is load-only.** Eleven pins under the first `if standalone then`. Nested B40-B re-pins five of them. Brief said the wrap stays; it did.

8. **No `/reload` smoke and no full `lua tests/run.lua`.** Isolated **682 / 0** was re-run here. Real ESC vs `CloseSpecialWindows` on Anniversary is unproven.

---

## Must-fix

None.

---

## Assessment

**1. Spec PASS.** Brief: existing-frame Show remounts missing OnHide (`wireBookOnHide`), then paint / `frame:Show()`; never replace an existing script; do not reset `pageIndex`; no OnShow; no rebuild; no `PlaySound` / `IG_CHARACTER_INFO_*`; no Records remap; update the B38-D keep-string that forbade `wireBookOnHide` in Show. Live `Show` ~867–873 matches. Brief test pins sit in `runB40B()` after `runB38D()` inside `runB25C()`.

**2. Quality: Approved-with-nits.** Must-fix none. Important leftovers: Init remount still skips a niled OnHide (required keep); widget Hide / ESC does not remount a niled OnHide (required Show remount, not widget remount). Nits listed above.

**3. Isolation count:** **682 passed, 0 failed.** Isolation wrap: **11**.

**4. Law:** Wiki ESC via `UISpecialFrames` holds when OnHide is present, and the next `RecordsBook:Show` remounts a missing handler. Law 6 / §19.4 hold: remount Show is silent. Law 10 / §19.3 / §14.2 hold: theatrical parchment tome; PAGE_TITLES stay 9; no Records remap. B38 leftover is closed on Show remount. B38-D Hide remount stays.

**Leftovers:**
- Init remount still skips a niled OnHide (Important, not must-fix; required keep).
- Widget Hide / ESC does not remount a niled OnHide (Important, not must-fix; required keep).
- B38-D wipe + Show + Hide no longer independently proves Hide remounts a missing OnHide (reviewer Hide-only probe closed it).
- Show does not call `rememberSpecial` itself (Init remount stays).
- `ResetForTests` still widget-Hides and still resets `pageIndex` (harness-only).
- Nested Show is not a real ESC key.
- Last leaf / Toggle / close / custom OnHide are reviewer probes.
- Exclusive-pair packet is not a vs-HEAD Records Book delta.
- Isolation wrap is load-only.
- Full `lua tests/run.lua` was not run.
- Gate W stays OPEN. Gate V stays OPEN.

Existing-frame `Show` remounts a missing OnHide, then paint / `frame:Show()`. An existing script is not replaced. `pageIndex` persist stays. No OnShow. No rebuild. No `PlaySound`. No Records remap. Wipe list, nil OnHide, Show restores OnHide and re-lists `ChurchOfBeefRecordsBook` once. Third Show keeps OnHide identity. B38-D keep-string was updated. `runB40B()` is nested inside `runB25C()` after `runB38D()`. Isolated `lua tests/test_records.lua` **682 passed, 0 failed**, exit 0.

Do not claim V1 / MVP complete. This review does not sign the lane. Do not claim Gate W, Gate V, or POLISH:PASS.
