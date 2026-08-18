# B40-B — RecordsBook Show remounts missing OnHide (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Wiki ESC via `UISpecialFrames` (named frame; do **not** PlaySound `IG_CHARACTER_INFO_*`); Law 6 / §19.4 (Quiet silent; no panel whoosh); Law 10 / Bible §19.3 / §14.2 (theatrical parchment Records Book; player-opened Quiet identity/history); B38-D leftover (`Show` skipped `wireBookOnHide`; a niled OnHide stayed idle until Hide); brief `docs/reformation/vestments/briefs/B40-B-records-show-onhide.md`. `FRAME_NAME` stays `ChurchOfBeefRecordsBook`. pageIndex persist stays. PAGE_TITLES stay 9. `PAGE_TITLE_FONT` stays `Fonts\\MORPHEUS.ttf`. No Records remap. No sound. Exclusive files only. No commit. Lane is not signed.

Existing-frame `Show`: remount missing OnHide via `wireBookOnHide`, then paint / `frame:Show()`. Never replace an existing script. Does not reset `pageIndex`. Does not rebuild. No OnShow re-wire. Show did not already remount `rememberSpecial` (Init remount stays), so Show does not add that call. `FRAME_NAME` stays `ChurchOfBeefRecordsBook`.

**Isolated count:** 682 passed, 0 failed (`lua tests/test_records.lua`). Isolation wrap stays under `if standalone then` at file load (**11** nil pins). Nested `runB40B()` inside `runB25C()` after `runB38D()`. No new main-chunk locals.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_records.lua` | Nested `runB40B()` inside `runB25C()` after `runB38D()` (no new main-chunk locals). Updated the B38-D keep-string that forbade `wireBookOnHide` in Show (source + live nile). Source pin: Show remounts via `wireBookOnHide` before `paint()` then `frame:Show()`. Helper never replaces; no OnShow / `PlaySound` / `IG_CHARACTER_INFO_*` / rebuild / `pageIndex` reset. Wipe list, nil OnHide, Show: OnHide restored, `ChurchOfBeefRecordsBook` re-listed once, pageIndex stays on Longest Streak, no sound, no rebuild. Third Show does not replace OnHide. Isolation wrap stays. |
| `addon/ChurchOfBeef/UI/RecordsBook.lua` | Existing-frame `Show` remounts missing OnHide (`wireBookOnHide(frame)`), then paint / `frame:Show()`. Does not replace an existing script. Does not reset `pageIndex`. Does not rebuild. Header notes the remount. No `PlaySound`. No Records remap. |
| `docs/reformation/vestments/briefs/B40-B-records-show-onhide-report.md` | This file |
| `docs/reformation/vestments/briefs/B40-B-records-show-onhide.diff` | B40-B-only unified diff of the exclusive implementation files vs the pre-lane working tree |

Did not edit glue, MainFrame, TOC, bootstrap, `ChurchOfBeef.lua`, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not add sound. Did not remap Records. Did not reset `pageIndex`. Did not commit.

`git diff HEAD` on these two files also includes earlier Records Book batches (working tree already dirty). The brief diff is the B40-B-only delta.

## Contract

| Surface | Role |
|---------|------|
| `Show` (frame exists) | `Init()` (B25-C remounts `rememberSpecial`), then `wireBookOnHide(frame)`, then `paint()` / `frame:Show()`. Same frame pointer. |
| `Show` (no frame) | Unchanged create path via `Init()`, then the remount helper (no-replace). |
| `wireBookOnHide` | Unchanged. If `GetScript("OnHide")` is nil, wire: `rememberSpecial(FRAME_NAME)`. Do not replace an existing script. Do not wire OnShow. Do not reset `pageIndex`. |
| `Hide` (frame exists) | Unchanged (B38-D). `wireBookOnHide` then `rememberSpecial(FRAME_NAME)` then `self.frame:Hide()`. |
| `Init` remount | Unchanged (B25-C). Existing-frame Init still remounts `rememberSpecial`. Does not remount OnHide. |
| Wipe remount | `UISpecialFrames = {}` then nil OnHide, Show lists `ChurchOfBeefRecordsBook` exactly once. |
| Rebuild | Existing-frame Show does not call `buildFrame` / `CreateFrame`. |
| pageIndex | Show does not assign `pageIndex`. Second-leaf Show after wipe still paints Longest Streak. |
| Sound / dress | None. No `PlaySound`. No `IG_CHARACTER_INFO_*`. `FRAME_NAME` stays `ChurchOfBeefRecordsBook`. PAGE_TITLES stay 9. |

### Unchanged

- Theatrical parchment tome. Chrome title stays `The Records Book`.
- PAGE_TITLES stay the nine Bible titles. `PAGE_TITLE_FONT` stays `Fonts\\MORPHEUS.ttf`.
- B38-D Hide OnHide remount. B28-C Hide `rememberSpecial` remount. B25-C Init remount. `rememberSpecial` scan-then-append. Missing table no-ops.
- B30-C / B31-D paint() PAGE_TITLE_FONT re-apply. Wheel / roman / persist `ui.recordsBook` stay.
- Isolation wrap. No new main-chunk locals in `test_records.lua`.

## TDD

1. Extended `tests/test_records.lua` (`runB40B()` nested inside `runB25C()` after `runB38D()`: Show remount body has `wireBookOnHide` then `paint()` then `frame:Show()`; helper never replaces; no OnShow / rebuild / `PlaySound` / `pageIndex` reset; wipe list, nil OnHide, Show restores OnHide and keeps the second leaf; third Show keeps identity). Updated the B38-D keep-string that pinned Show has no `wireBookOnHide`. Isolation wrap and existing Init / Hide remount / Morpheus / PAGE_TITLES pins stay.
2. Existing-frame `Show` remounts missing OnHide, then paint / `frame:Show()`. Hide / Init remount kept. `pageIndex` not reset. Show did not already remount `rememberSpecial`, so that call stays on Init / Hide / OnHide.
3. Green: `lua tests/test_records.lua` — **682 passed, 0 failed**.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_records.lua   # 682 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_records.lua` standalone | **682 passed, 0 failed.** Lua 5.1.5. Exit 0. |

**Isolated count:** 682 passed, 0 failed. Isolation wrap stays (11 nil pins at file load). Wrap pattern unchanged. `runB40B()` re-pins 5 of them.

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run.

## Self-review

- Exclusive implementation files only. UI → Core only. Glue / MainFrame / TOC not edited.
- Existing-frame `Show` remounts a missing OnHide, re-registers `ChurchOfBeefRecordsBook` (via Init remount), and does not rebuild. An existing script is not replaced.
- Wipe-to-empty then Show lists the name exactly once. Same frame pointer. Third Show keeps OnHide identity. pageIndex stays on the second leaf.
- B38-D Hide OnHide remount stays. B28-C Hide `rememberSpecial` remount stays. B25-C Init remount stays.
- PAGE_TITLES / Morpheus / no-sound / no-remap stay. No OnShow re-wire.
- `runB40B()` is nested inside `runB25C()` after `runB38D()`. No new main-chunk locals (`luac`: test main chunk still **123** locals; RecordsBook file locals still **45**).
- Isolation wrap stays.

## Leftovers

- **Init remount still skips a niled OnHide.** Brief asked Show remount and no OnShow re-wire. A niled handler that only hits Init stays idle until Show or Hide.
- **Show does not call `rememberSpecial` itself.** Brief said remount it if Show already remounted it. Show did not; listing after wipe still happens once via B25-C Init. Hide / OnHide still remount the name.
- **Widget Hide / ESC does not remount a niled OnHide.** The missing handler cannot remount itself. `CloseSpecialWindows` / `frame:Hide()` still bypass `RecordsBook:Hide` and `RecordsBook:Show`. A dropped OnHide that never hits those verbs still leaves a wiped list idle until Show / Init / Hide.
- **No client smoke.** Real ESC vs `CloseSpecialWindows` on Anniversary is unproven. A live remount that dropped the name is simulated by `UISpecialFrames = {}`. A dropped handler is simulated by `SetScript("OnHide", nil)`.
- **Full harness not run.** Exclusive lane; `tests/run.lua` not edited.
- **Harness `Show()` in this suite is a direct call**, not a real ESC key. Script identity, membership counts, and pageIndex persist are pinned; the client's special-frame walk is not.

## Status

**DONE_WITH_CONCERNS.** Isolated **682 / 0**. Isolation wrap **11**. Not signed. No Gate / **POLISH:PASS** claim. Gate W stays OPEN. Gate V stays OPEN.
