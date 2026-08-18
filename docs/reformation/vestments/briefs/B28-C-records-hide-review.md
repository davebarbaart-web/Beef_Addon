Spec PASS

# B28-C — Records Book Hide remounts ESC (review)

**Quality:** Approved-with-nits

**Lane:** B28-C Records Book Hide remounts ESC
**Brief:** `docs/reformation/vestments/briefs/B28-C-records-hide.md`
**Writer report:** `docs/reformation/vestments/briefs/B28-C-records-hide-report.md`
**Diff:** `docs/reformation/vestments/briefs/B28-C-records-hide.diff` (B28-C-only exclusive-pair packet; live `RecordsBook.lua` / `test_records.lua` also carry earlier Records Book batches vs HEAD)
**Exclusive files:** `addon/ChurchOfBeef/UI/RecordsBook.lua`, `tests/test_records.lua`

Task-scoped gate only. Reviewer read the brief, the writer report, the provided exclusive-pair diff, live `UI/RecordsBook.lua` (`Hide`: `rememberSpecial(FRAME_NAME)` then `self.frame:Hide()` when a frame exists; no rebuild; `Init` early-return still `rememberSpecial(FRAME_NAME)` then `return self.frame`; create-path still `buildFrame` + `rememberSpecial(FRAME_NAME)`; `rememberSpecial` still scan-then-append; `ResetForTests` still `self.frame:Hide()` direct), and `tests/test_records.lua` (isolation wrap, nested `runB28C()` inside `runB25C()` after the Init remount restore); then ran `lua tests/test_records.lua` (**487 passed, 0 failed**, exit 0, Lua 5.1.5) and throwaway probes that do not live in the exclusive files. Law cited: B25 leftover (`Hide` / Toggle-while-shown skipped `rememberSpecial`; only Init / `buildFrame` registered); wiki ESC via `UISpecialFrames`; `Hide()` remounts then Hide; no rebuild; PAGE_TITLES stay 9; `PAGE_TITLE_FONT` stays `Fonts\\MORPHEUS.ttf`; no category remap (#3); no custom media; B25-C Init remount stays; Law 6 / §14.2 (player-opened Quiet identity/history; no Hide sound); Law 10 / Bible §19.3 (theatrical parchment). Isolation wow_ui_stub + Common + Ranks + Store + RecordsBook only. Did not mutate `RecordsBook.lua` or `test_records.lua`. Did not commit. Did not edit Decree, Toasts, glue, TOC, bootstrap, `ChurchOfBeef.lua`, or `tests/run.lua`.

This review does not sign the lane.

---

## Named risks

| Risk | Verdict |
|---|---|
| `Hide` / Toggle-while-shown still skip `rememberSpecial` | **Pass. Verified.** Live `Hide` is `rememberSpecial(FRAME_NAME)` then `self.frame:Hide()` when `self.frame` exists. Toggle-while-shown is still `return self:Hide()`. Pins: Hide body has remount before Hide; wipe `UISpecialFrames` to `{}`, Hide lists `ChurchOfBeefRecordsBook` once; second Hide still once; Toggle-while-shown after a second wipe lists once. Reviewer probe: wipe leaves count 0; Hide returns true, same frame pointer, count is 1, `CreateFrame` delta 0, no sound. Close-button `OnClick` is `RecordsBook:Hide()` — wipe then click lists once. |
| Hide rebuilds the tome | **Pass. Verified.** Hide body has no `buildFrame` / `CreateFrame` / `PlaySound`. Pins: `Book.frame` stays the Init widget; `#GetPages()` stays 9. Reviewer spy: wrapped `CreateFrame` saw **0** calls on wipe+Hide, second Hide, Toggle-while-shown, close-click remount, and already-hidden Hide. |
| Wipe remount duplicates `ChurchOfBeefRecordsBook` | **Pass. Verified.** `rememberSpecial` still dedupes (`UISpecialFrames[i] == name` then return; else `# + 1`). Pins: once after wipe+Hide; second Hide still once. Reviewer probe: third Hide with the name already listed stays 1. Live source has **3** `rememberSpecial(FRAME_NAME)` sites (create-path + B25-C early-return + Hide). |
| `PAGE_TITLES` / Morpheus / category remap / custom media / Hide sound / B25-C Init remount dropped | **Pass.** Live `PAGE_TITLES` is still the nine Bible titles. `PAGE_TITLE_FONT` is still `Fonts\\MORPHEUS.ttf`. Source has no `Media\\`, no `PlaySound`. `MODE` is still `"QUIET"`. Pins: `#GetPages()==9`, `Fonts\\MORPHEUS.ttf`, refuse uppercase TTF, no `PlaySound` on Hide or the whole file; wiped `UISpecialFrames` + Init still lists the name once on the same frame. Reviewer probe: GetPages titles match the Bible list; `toRoman(14)` is still `"XIV"`; wipe+Init after the Hide block still remounts once. |
| Hide (no frame) now Inits or rebuilds | **Pass.** Live no-frame path still skips the remount block and returns true. Reviewer probe: `Book.frame = nil`, wipe, Hide returns true, frame stays nil, count stays 0, `CreateFrame` delta 0. |
| New main-chunk locals / not nested in `runB25C()` | **Pass.** `runB28C()` is a nested `local function` inside `runB25C()` after `UISpecialFrames = savedSpecial`. Packet adds no main-chunk `local`. Header comment only at file top. `luac -l -p tests/test_records.lua`: main chunk still **123 locals** (cap 200). RecordsBook file locals stay **44**. |
| Isolated suite not exit 0 / exclusive file breach | **Pass. Verified.** 487 passed, 0 failed. Writer-reported count matches. Lane implementation is the two named files. Packet is two hunks (Hide remount-then-Hide; header comment + nested `runB28C()`). Sibling dirt in this workspace is other lanes (earlier Records Book batches vs HEAD). Reviewer did not mutate the exclusive pair. |

---

## Spec Compliance

| Requirement | Verdict |
|---|---|
| Exclusive files only; do not edit Decree, Toasts, glue; no commit | **Pass.** Named-risk check. |
| `Hide()`: if a frame exists, `rememberSpecial(FRAME_NAME)` then Hide. Do not rebuild | **Pass.** Live order. Source pin in `runB28C()`. Reviewer capture is exactly that call then Hide. |
| Init remount (B25-C) stays | **Pass.** Early-return still `rememberSpecial(FRAME_NAME)` then `return self.frame`. Nested re-pin after Hide remount. Reviewer probe: wipe then Init still same frame, count 1. |
| `FRAME_NAME` is `"ChurchOfBeefRecordsBook"` | **Pass.** Live constant. Pins and probe: `GetName()` stays that string through Hide. |
| PAGE_TITLES stay 9; `PAGE_TITLE_FONT` stays `Fonts\\MORPHEUS.ttf`; no category remap (#3); no custom media | **Pass.** Named-risk check. |
| Init, wipe `UISpecialFrames` to `{}`, Hide: name listed exactly once. Same frame pointer | **Pass.** Named-risk check. Second Hide and Toggle-while-shown are extra keep-pins. |
| Isolation wrap stays; `lua tests/test_records.lua` exit 0 | **Pass.** **487 / 0.** |

The leftover (`Hide` / Toggle-while-shown skipped `rememberSpecial`) is closed on `RecordsBook:Hide`. Law 6 (Quiet identity/history; no Hide sound), Law 10 (theatrical parchment; Morpheus stays), wiki ESC via `UISpecialFrames`, B25-C Init remount, and the nine Bible PAGE_TITLES hold on the exclusive pair.

Writer concerns, judged against the brief:

| Writer concern | Gate |
|---|---|
| No client smoke; real ESC vs `CloseSpecialWindows` on the named tome is unproven on Anniversary | **Not a miss.** Brief asked isolated green + Hide remount + uniqueness once. A live remount that dropped the name is simulated by `UISpecialFrames = {}`. |
| Full `lua tests/run.lua` not run | **Not a miss.** Brief asked the isolated suite. |
| Harness `Hide()` is a direct call, not a real ESC key; membership counts are pinned, the client's special-frame walk is not | **Not a miss.** Brief asked membership counts. Close-button Hide remounts via the same path (probe). |
| `ResetForTests` still calls `self.frame:Hide()` directly and does not remount | **On contract.** Brief scoped `RecordsBook:Hide`. Harness-only. Reviewer probe: wipe then `ResetForTests` leaves count 0; production Close / Toggle / `RecordsBook:Hide` remount. |
| OPEN_QUESTIONS #3 (category remap) stays parked | **On contract.** Brief forbade a remap. Nine Bible titles stay. |
| Parked Console leftover (selected-pair inherit of Core `namedOpponent`) | **Not this lane.** Batch 28 overview parks one Console leftover on B28-A / later Console work. |
| Lane is unsigned; no Gate or POLISH claim | **On contract.** This review does not sign the lane. |

---

## Isolation / Hide remount / uniqueness

**Isolation wrap — Pass.** Load list is still wow_ui_stub + Common + Ranks + Store + RecordsBook. No `dofile` of Decree / Toasts / Console / MainFrame / glue / DB / Runtime / Net / Gora. Standalone wrap is still **11** nils (Runtime, Gora, Officer, UI, Net, DB, Sender, Minimap, Toasts, Console, Hud). Reviewer probe: those keys are nil at load. Wrap is load-time only (unchanged). `runB25C()` still re-pins **5** (Runtime, UI, Toasts, Console, Hud) after `runB28C()`. New remount locals sit in `runB28C()` inside `runB25C()`.

**Hide remount — Pass.** `if self.frame then` → `rememberSpecial(FRAME_NAME)` then `self.frame:Hide()`. It does not `buildFrame`, does not `CreateFrame`, and does not `PlaySound`. No-frame Hide still returns true and does not Init. Toggle-while-shown is Hide. Close-button `OnClick` is Hide. Init remount (B25-C) and create-path `buildFrame` register stay. `rememberSpecial` still type-guards a missing table and returns when the name is already listed.

**Uniqueness — Pass.** Wipe-to-empty then Hide lists `ChurchOfBeefRecordsBook` once. Second Hide stays once. Toggle-while-shown after a wipe lists once. Reviewer probe: third Hide stays 1; close-click after a wipe lists once; already-hidden Hide remounts once; `UISpecialFrames = nil` then Hide leaves the global nil; assigning `{}` then Hide lists once.

---

## Strengths

- The delta is the brief: one Hide `rememberSpecial(FRAME_NAME)` before `self.frame:Hide()`. Init remount, create-path register, PAGE_TITLES, and Morpheus were left alone. RecordsBook gained no new file local (`luac`: **44** locals).
- B25 leftover (Hide / Toggle-while-shown skipped `rememberSpecial`; an open tome whose name was dropped stayed off the list until the next Init) is closed on the same wipe-to-`{}` fixture, not a second register helper.
- Wipe-to-`{}` then Hide is the leftover close, not only a source `find`. Frame identity and `#GetPages()==9` are pinned. B25-C Init remount is re-pinned after the Hide block.
- `runB28C()` is nested inside `runB25C()` after the Init remount restore. Isolation wrap was not rewritten. No new main-chunk local (main chunk still **123 / 200**).
- Writer-reported **487 / 0** matched the re-run. Writer-reported red (**483 / 4**) matches the four asserts old `if self.frame then self.frame:Hide() end` would fail: Hide source `rememberSpecial` before Hide; wiped + Hide lists once; second Hide lists once; Toggle-while-shown lists once.

---

## Issues

### Critical

None.

### Important (leftover — not must-fix)

1. **No `/reload` smoke.** `CloseSpecialWindows` walks every shown name on `UISpecialFrames` and hides the widget (`Frame:Hide`), not `RecordsBook:Hide`. Reviewer probe: wipe the list, `Book.frame:Hide()`, count stays 0. Close-button / Toggle / `RecordsBook:Hide` remount. Brief asked Hide remount + uniqueness once, not a client walk. **POLISH:CANDIDATE** is the ceiling if anyone claims feel.

### Nit

1. **`ResetForTests` still calls `self.frame:Hide()` directly.** Probe: wipe then reset leaves count 0. Harness-only. Writer already named it.

2. **`UISpecialFrames = nil` is unpinned.** `rememberSpecial` no-ops when the global is not a table. Probe: Hide with nil leaves it nil; assigning `{}` then Hide lists the name once. Brief asked wipe to `{}`.

3. **Harness `Hide()` is not ESC. Stub `CreateFrame` does not mint `_G["ChurchOfBeefRecordsBook"]`.** Reviewer probe: `_G.ChurchOfBeefRecordsBook == nil`. Production `CreateFrame("Frame", FRAME_NAME, …)` does. Same stub gap other named-special-frame lanes named.

4. **Isolation wrap is load-only.** Eleven pins under `if standalone then` at file load. Nested B25-C re-pins five of them after `runB28C()`. Brief said the wrap stays; it did.

5. **Exclusive-pair diff is not a vs-HEAD Records Book delta.** Packet is the B28-C-only Hide remount + nested pins. `git diff HEAD` on the two files still includes earlier Records Book batches. Report already says this.

6. **No full `lua tests/run.lua`.** Isolated **487 / 0** was re-run here.

7. **Parked Batch 28 Console leftover** (selected-pair inherit of Core `namedOpponent`) is other work. Not this exclusive pair.

---

## Must-fix

None.

---

## Assessment

**Spec PASS. Quality: Approved-with-nits.**

**Must-fix:** none.

**Isolated count:** **487 passed, 0 failed.** Isolation wrap: **11**. `runB25C()` re-pins: **5**. Main-chunk locals: **123 / 200**.

`RecordsBook:Hide` calls `rememberSpecial(FRAME_NAME)` then Hide when a frame exists. It does not rebuild and does not `PlaySound`. Wipe `UISpecialFrames` to `{}` then Hide lists `ChurchOfBeefRecordsBook` exactly once and keeps the same frame. Toggle-while-shown remounts via Hide. PAGE_TITLES stay 9. `PAGE_TITLE_FONT` stays `Fonts\\MORPHEUS.ttf`. B25-C Init remount stays. `runB28C()` is nested inside `runB25C()`. Isolated `lua tests/test_records.lua` **487 passed, 0 failed**, exit 0.

Do not claim V1 / MVP complete. This review does not sign the lane.
