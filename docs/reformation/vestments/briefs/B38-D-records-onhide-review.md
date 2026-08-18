Spec PASS

# B38-D — RecordsBook Hide remounts missing OnHide (review)

**Quality:** Approved-with-nits

**Lane:** B38-D RecordsBook Hide remounts missing OnHide
**Brief:** `docs/reformation/vestments/briefs/B38-D-records-onhide.md`
**Writer report:** `docs/reformation/vestments/briefs/B38-D-records-onhide-report.md`
**Diff:** `docs/reformation/vestments/briefs/B38-D-records-onhide.diff` (B38-D-only exclusive-pair packet; live `RecordsBook.lua` / `test_records.lua` also carry earlier Records Book batches vs HEAD)
**Exclusive files:** `addon/ChurchOfBeef/UI/RecordsBook.lua`, `tests/test_records.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, the provided exclusive-pair diff, live `UI/RecordsBook.lua` (`wireBookOnHide` ~611–619; `Hide` ~874–881; `buildFrame` create-path ~674–675; `Init` / `Show`; `FRAME_NAME`; `rememberSpecial`; `pageIndex`), and `tests/test_records.lua` (isolation wrap, nested `runB38D()` after `runB31D()` inside `runB25C()` ~538); then ran `lua tests/test_records.lua` (**620 passed, 0 failed**, exit 0, Lua **5.1.5**) and throwaway probes that do not live in the exclusive files. Law cited: wiki ESC via `UISpecialFrames` (named frame; do not `PlaySound` `IG_CHARACTER_INFO_*`); Law 6 / §19.4 (Quiet silent; no panel whoosh); Law 10 / Bible §19.3 / §14.2 (theatrical parchment Records Book; player-opened Quiet identity/history); B28-C leftover (`Hide` remounted `rememberSpecial` then `frame:Hide()` only; ESC / `CloseSpecialWindows` bypass `RecordsBook:Hide` and there was no OnHide, so a wiped list stayed idle until Show / Init). Extract `wireBookOnHide` (never replace an existing script). Existing-frame Hide: remount missing OnHide, then `rememberSpecial(FRAME_NAME)`, then `frame:Hide()`. OnHide remounts `rememberSpecial` so ESC still re-lists. Do not reset `pageIndex`. No OnShow re-wire. No rebuild. No `PlaySound` / `IG_CHARACTER_INFO_*`. No Records remap. Isolation wow_ui_stub + Common + Ranks + Store + RecordsBook only. Did not mutate `RecordsBook.lua` or `test_records.lua`. Did not commit. Did not edit glue, MainFrame, TOC, bootstrap, `ChurchOfBeef.lua`, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG.

This review does not sign the lane. Do not claim Gate W / Gate V / **POLISH:PASS**.

---

## Named risks

| Risk | Verdict |
|---|---|
| Hide still has no OnHide remount (ESC wipe stays idle) | **Pass. Verified.** Live existing-frame `Hide` is `wireBookOnHide(self.frame)` then `rememberSpecial(FRAME_NAME)` then `self.frame:Hide()`. Nested: Hide remount body has that exact order. Wipe list, nil OnHide, Show, Hide restores OnHide and lists `ChurchOfBeefRecordsBook` once. Reviewer probe: after remount, wipe then widget `Hide()` (ESC / `CloseSpecialWindows` path) re-lists once via OnHide. Close-button `OnClick` is still `RecordsBook:Hide()` — niled handler + wipe + click remounts OnHide and lists once. |
| `wireBookOnHide` replaces an existing script | **Pass. Verified.** Helper is `if existing then return end` after `GetScript("OnHide")`. Nested: source pin plus second / third Hide keep the restored identity. Reviewer spy: a sentinel OnHide survives Hide, a second Hide, and a third Hide. |
| Hide resets `pageIndex` | **Pass. Verified.** Hide body, helper, and OnHide have no `pageIndex` assign. Nested: turn to Longest Streak, wipe + Hide, Show still paints Longest Streak; second Hide still does not reset. Reviewer probe: widget Hide also keeps Longest Streak. |
| `PlaySound` / `IG_CHARACTER_INFO_*` / Records remap | **Pass.** Source has no `PlaySound`, no `IG_CHARACTER_INFO`, no `SetScript("OnShow"`. `FRAME_NAME` stays `ChurchOfBeefRecordsBook`. PAGE_TITLES stay the nine Bible titles. Nested + reviewer probe: remount Hide / third Hide / widget Hide play no sound (`sounds` unchanged). |
| OnShow re-wire added | **Pass.** `wireBookOnHide`, Hide, Show, and Init early-return have no OnShow. Live `GetScript("OnShow")` stays nil after create and after remount Hide. Nested Show pin: no `wireBookOnHide` / no OnShow. |
| Existing-frame Hide rebuilds the frame | **Pass. Verified.** Hide body has no `buildFrame` / `CreateFrame` / `:Show()`. Nested CreateFrame spy: remount Hide is **0** creates; same frame pointer; name stays `ChurchOfBeefRecordsBook`. Reviewer spy: remount Hide, widget Hide, and no-frame Hide are all **0** creates. |
| Third Hide replaces OnHide identity | **Pass. Verified.** Nested: second Hide and third Hide keep the restored function; list stays once. Reviewer spy: sentinel identity survives three Hides; remounted identity survives a second and third Hide. |
| Wipe list + nil OnHide + Show + Hide does not re-list `ChurchOfBeefRecordsBook` once | **Pass. Verified.** Nested: wipe to 0, nil OnHide, Show (handler still nil, page stays Longest Streak), Hide restores OnHide and lists once. Third Hide still once. Reviewer probe: Hide after a niled widget Hide also lists once. `rememberSpecial` still scan-then-append. |
| New main-chunk locals / not nested after `runB31D` | **Pass.** `runB38D()` is a nested `local function` inside `runB25C()` after the `runB31D()` call (`test_records.lua` ~528–720). Packet adds no main-chunk `local`. Header comment only at file top. `luac -l -p`: test main chunk still **123** locals (cap 200). RecordsBook file locals are **45** (was 44; the extract is `wireBookOnHide`). |
| Isolation wrap rewritten / suite not exit 0 / exclusive breach | **Pass. Verified.** 620 passed, 0 failed. Writer-reported count matches. Isolation wrap stays under the first `if standalone then` (**11** nil pins). `runB38D()` re-pins 5 of them. Packet is the two named files. Sibling dirt vs HEAD (MainFrame, TOC, glue, `run.lua`, OPEN_QUESTIONS, REFORMATION_LOG) is other lanes. |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; do not edit glue, MainFrame; no commit | **Pass.** Named-risk check. Reviewer did not commit. |
| Extract `wireBookOnHide` (never replace an existing script) | **Pass.** Live ~611–619. Nested exact-body pin + reviewer sentinel spy. |
| Existing-frame Hide: remount missing OnHide, then `rememberSpecial(FRAME_NAME)`, then `frame:Hide()` | **Pass.** Brief vs `RecordsBook.lua` ~874–881. Nested order pins (`wireAt < remountAt < hideAt`). |
| OnHide remounts `rememberSpecial` so ESC still re-lists | **Pass.** Named-risk check. Reviewer widget-Hide probe. |
| Do **not** reset `pageIndex` | **Pass.** Named-risk check. |
| No OnShow re-wire. No rebuild. No `PlaySound` / `IG_CHARACTER_INFO_*` | **Pass.** Named-risk check. |
| Create-path calls the helper after create-time `frame:Hide()` | **Pass.** Live ~672–675. Nested: `frame:Hide()` then `wireBookOnHide`; no inline `SetScript("OnHide"`. |
| Show / Init remount do not remount OnHide | **Pass.** Nested Show / early-Init refuse pins. Reviewer probe: Show and Init leave a niled OnHide nil; Init still remounts the name (B25-C). |
| Wipe list, nil OnHide, Show, Hide: OnHide restored, name re-listed once, pageIndex unchanged, no sound | **Pass.** Named-risk check. |
| Third Hide does not replace OnHide | **Pass.** Named-risk check. |
| Nest `runB38D()` after `runB31D()` inside `runB25C()`; no new main-chunk locals | **Pass.** Named-risk check. |
| Isolation wrap stays; `lua tests/test_records.lua` exit 0 | **Pass.** **620 / 0.** Wrap **11**. |

Wiki ESC via a named `UISpecialFrames` entry holds on the exclusive pair: when OnHide is present, widget Hide remounts `ChurchOfBeefRecordsBook`. Law 6 / §19.4 hold: remount Hide is silent; no `IG_CHARACTER_INFO_*` whoosh. Law 10 / §19.3 / §14.2 hold: theatrical parchment tome; chrome title stays `The Records Book`; PAGE_TITLES stay 9; `PAGE_TITLE_FONT` stays `Fonts\\MORPHEUS.ttf`. The B28 leftover (ESC bypassed `RecordsBook:Hide` and there was no OnHide) is closed on the Hide remount plus the OnHide `rememberSpecial` hook. A niled handler that never hits `RecordsBook:Hide` still cannot remount itself — brief scoped Hide remount, not widget remount.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| Widget Hide / ESC does not remount a niled OnHide | **On contract.** The missing handler cannot remount itself. `CloseSpecialWindows` / `frame:Hide()` still bypass `RecordsBook:Hide`. Brief asked Hide remount + no OnShow re-wire. Reviewer probe: niled widget Hide leaves count 0 and OnHide nil; the next `RecordsBook:Hide` restores both. |
| Show / Init remount do not remount OnHide | **On contract.** Brief forbade OnShow re-wire and asked Hide-only remount. B25-C Init still remounts the name. |
| No client smoke; real ESC vs `CloseSpecialWindows` on Anniversary is unproven | **Not a miss.** Brief asked the isolated suite. A live remount that dropped the name is simulated by `UISpecialFrames = {}`. A dropped handler is simulated by `SetScript("OnHide", nil)`. Reviewer widget Hide closed the remount-when-present path on the stub. |
| Full `lua tests/run.lua` not run | **Not a miss.** Brief asked the isolated suite. |
| Harness `Hide()` is a direct call, not a real ESC key | **Not a miss.** Brief asked script identity, membership once, and pageIndex persist. Reviewer widget Hide is the stub's shown→hidden OnHide fire. |
| Lane is unsigned; no Gate or POLISH claim | **On contract.** This review does not sign the lane. |

The B28 leftover (Hide remounted `rememberSpecial` then `frame:Hide()` only; ESC / `CloseSpecialWindows` bypass `RecordsBook:Hide` and there was no OnHide) is this lane's spec. It is closed on the exclusive pair when the next hide goes through `RecordsBook:Hide` or when OnHide is already present.

---

## Isolation / keep

**Isolation wrap — Pass.** Load list is still wow_ui_stub + Common + Ranks + Store + RecordsBook. No `dofile` of Runtime, Gora, Officer, MainFrame, Net, DB, Sender, Minimap, Toasts, Console, or Hud. Standalone wrap is still **11** nils (Runtime, Gora, Officer, UI, Net, DB, Sender, Minimap, Toasts, Console, Hud). Reviewer probe: those keys are nil at load. Wrap is load-time only (unchanged). Nested B38-D re-pins 5 of them (Runtime, UI, Toasts, Console, Hud). `runB25C()` still re-pins the same five after `runB38D()`.

**Hide remount — Pass.** Existing-frame Hide remounts a missing OnHide, then `rememberSpecial(FRAME_NAME)`, then `self.frame:Hide()`. Same frame pointer. An existing script is not replaced. Create-path wires after create-time Hide so mint Hide does not fire remount. Show / Init do not remount OnHide. No-frame Hide still returns true, does not Init, and does not list. Toggle-while-shown is still Hide. Close-button `OnClick` is still Hide.

**Keep — Pass.** `pageIndex` persist stays. Second-leaf Show after Hide still paints Longest Streak. B28-C Hide `rememberSpecial` remount stays. B25-C Init remount stays. `rememberSpecial` still scan-then-append; missing table no-ops. PAGE_TITLES stay 9. `PAGE_TITLE_FONT` stays `Fonts\\MORPHEUS.ttf`. `FRAME_NAME` stays `ChurchOfBeefRecordsBook`. No `PlaySound`. No Records remap. Isolation wrap stays. No new main-chunk locals in `test_records.lua`.

---

## Strengths

- The remount is one extracted helper plus one call at the top of the existing-frame Hide block. Failed-to-replace, no-frame, Show, and Init paths cannot empty or swap a live OnHide.
- `if existing then return` sits next to wipe + nil + Show + Hide restore, so a blanket `SetScript` on every Hide would fail the third-Hide identity pin and the reviewer sentinel spy.
- OnHide remounts `rememberSpecial`, so a later widget Hide / ESC re-lists after a wipe without going through `RecordsBook:Hide`. That is the B28 leftover close.
- Create-path wires after create-time Hide. Show / Init refuse pins keep the remount Hide-only.
- `runB38D()` sits after `runB31D()` inside `runB25C()`. Isolation wrap stays **11**. No new main-chunk locals. Writer-reported **620 / 0** matched the re-run.

---

## Issues

### Critical

None.

### Important leftover — not must-fix

1. **Widget Hide / ESC does not remount a niled OnHide.** Brief forbade OnShow re-wire and asked Hide remount only. Reviewer probe: niled handler + wipe + `frame:Hide()` leaves count 0. The next `RecordsBook:Hide` restores the handler and lists once. Do not expand this exclusive pair to remount from Show / Init / widget Hide.

### Nit

1. **Show / Init remount do not remount OnHide.** Required keep. A niled handler that only hits Show / Init stays idle until Hide.

2. **`ResetForTests` still calls `self.frame:Hide()` directly** and still assigns `pageIndex = 1`. Harness-only. Brief scoped `RecordsBook:Hide`. Production Close / Toggle / Hide remount.

3. **Harness `Hide()` in the nested block is a direct call**, not a real ESC key. Script identity, membership once, and pageIndex persist are pinned. Reviewer widget Hide closed the remount-when-present path on the stub. Stub `CreateFrame` still does not mint `_G["ChurchOfBeefRecordsBook"]`.

4. **Exclusive-pair packet is not a vs-HEAD Records Book delta.** Packet is the B38-D-only helper + Hide call + create-path wire + nested pins. `git diff HEAD` on the two files still includes earlier Records Book batches. Report already says this.

5. **Isolation wrap is load-only.** Eleven pins under the first `if standalone then`. Nested B38-D re-pins five of them. Brief said the wrap stays; it did.

6. **No `/reload` smoke and no full `lua tests/run.lua`.** Isolated **620 / 0** was re-run here. Real ESC vs `CloseSpecialWindows` on Anniversary is unproven.

7. **RecordsBook file locals are 45** (`luac`). B28-C measured 44. The extra local is the required `wireBookOnHide` extract, not a test-file main-chunk local.

---

## Must-fix

None.

---

## Assessment

**1. Spec PASS.** Brief: extract `wireBookOnHide` (never replace); existing-frame Hide remounts missing OnHide, then `rememberSpecial(FRAME_NAME)`, then `frame:Hide()`; OnHide remounts `rememberSpecial`; do not reset `pageIndex`; no OnShow; no rebuild; no `PlaySound` / `IG_CHARACTER_INFO_*`. Live `Hide` ~874–881 and `wireBookOnHide` ~611–619 match. Brief test pins sit in `runB38D()` after `runB31D()` inside `runB25C()`.

**2. Quality: Approved-with-nits.** Must-fix none. Important leftover: widget Hide / ESC does not remount a niled OnHide (required Hide-only remount). Nits listed above.

**3. Isolation count:** **620 passed, 0 failed.** Isolation wrap: **11**.

**4. Law:** Wiki ESC via `UISpecialFrames` holds when OnHide is present. Law 6 / §19.4 hold: remount Hide is silent. Law 10 / §19.3 / §14.2 hold: theatrical parchment tome; PAGE_TITLES stay 9; no Records remap. B28 leftover is closed on Hide remount plus the OnHide `rememberSpecial` hook.

**Leftovers:**
- Widget Hide / ESC does not remount a niled OnHide (Important, not must-fix; required keep).
- Show / Init remount do not remount OnHide (on contract).
- `ResetForTests` still widget-Hides and still resets `pageIndex` (harness-only).
- Nested Hide is not a real ESC key.
- Exclusive-pair packet is not a vs-HEAD Records Book delta.
- Isolation wrap is load-only.
- Full `lua tests/run.lua` was not run.
- Gate W stays OPEN. Gate V stays OPEN.

Existing-frame `Hide` remounts a missing OnHide, then `rememberSpecial(FRAME_NAME)`, then `frame:Hide()`. An existing script is not replaced. `pageIndex` persist stays. No OnShow. No rebuild. No `PlaySound`. Wipe list, nil OnHide, Show, Hide restores OnHide and re-lists `ChurchOfBeefRecordsBook` once. Third Hide keeps OnHide identity. `runB38D()` is nested inside `runB25C()` after `runB31D()`. Isolated `lua tests/test_records.lua` **620 passed, 0 failed**, exit 0.

Do not claim V1 / MVP complete. This review does not sign the lane. Do not claim Gate W, Gate V, or POLISH:PASS.
