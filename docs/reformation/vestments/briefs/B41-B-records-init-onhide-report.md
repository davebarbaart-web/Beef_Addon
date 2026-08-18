# B41-B — RecordsBook Init remounts missing OnHide (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Wiki ESC via `UISpecialFrames` (named frame; do **not** PlaySound `IG_CHARACTER_INFO_*`); Law 6 / §19.4 (Quiet silent; no panel whoosh); Law 10 / Bible §19.3 / §14.2 (theatrical parchment Records Book; player-opened Quiet identity/history); B40-B leftover (`Init` remounted `rememberSpecial` but skipped `wireBookOnHide`; a niled OnHide stayed idle until Show or Hide); brief `docs/reformation/vestments/briefs/B41-B-records-init-onhide.md`. `FRAME_NAME` stays `ChurchOfBeefRecordsBook`. pageIndex persist stays. PAGE_TITLES stay 9. `PAGE_TITLE_FONT` stays `Fonts\\MORPHEUS.ttf`. No Records remap. No sound. Exclusive files only. No commit. Lane is not signed.

Existing-frame `Init`: remount missing OnHide via `wireBookOnHide`, then `rememberSpecial(FRAME_NAME)`. Never replace an existing script. Does not reset `pageIndex`. Does not rebuild. No OnShow re-wire. No paint / Show / Hide on the remount path. `FRAME_NAME` stays `ChurchOfBeefRecordsBook`.

**Isolated count:** 744 passed, 0 failed (`lua tests/test_records.lua`). Isolation wrap stays under `if standalone then` at file load (**11** nil pins). Nested `runB41B()` inside `runB25C()` after `runB40B()`. No new main-chunk locals.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_records.lua` | Nested `runB41B()` inside `runB25C()` after `runB40B()` (no new main-chunk locals). Updated the B38-D / B40-B keep-strings that forbade `wireBookOnHide` in Init. Source pin: Init remounts via `wireBookOnHide` then `rememberSpecial(FRAME_NAME)`. Helper never replaces; no OnShow / `PlaySound` / `IG_CHARACTER_INFO_*` / rebuild / `pageIndex` reset / paint. Wipe list, nil OnHide, Init: OnHide restored, `ChurchOfBeefRecordsBook` re-listed once, pageIndex stays on Longest Streak, no sound, no rebuild. Third Init does not replace OnHide. Isolation wrap stays. |
| `addon/ChurchOfBeef/UI/RecordsBook.lua` | Existing-frame `Init` remounts missing OnHide (`wireBookOnHide(self.frame)`), then `rememberSpecial(FRAME_NAME)`. Does not replace an existing script. Does not reset `pageIndex`. Does not rebuild. Header notes the remount. No `PlaySound`. No Records remap. |
| `docs/reformation/vestments/briefs/B41-B-records-init-onhide-report.md` | This file |
| `docs/reformation/vestments/briefs/B41-B-records-init-onhide.diff` | B41-B-only unified diff of the exclusive implementation files vs the pre-lane working tree |

Did not edit glue, MainFrame, TOC, bootstrap, `ChurchOfBeef.lua`, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not add sound. Did not remap Records. Did not reset `pageIndex`. Did not commit.

`git diff HEAD` on these two files also includes earlier Records Book batches (working tree already dirty). The brief diff is the B41-B-only delta.

## Contract

| Surface | Role |
|---------|------|
| `Init` (frame exists) | `wireBookOnHide(self.frame)` then `rememberSpecial(FRAME_NAME)`. Same frame pointer. |
| `Init` (no frame) | Unchanged create path via `buildFrame()`. |
| `wireBookOnHide` | Unchanged. If `GetScript("OnHide")` is nil, wire: `rememberSpecial(FRAME_NAME)`. Do not replace an existing script. Do not wire OnShow. Do not reset `pageIndex`. |
| `Show` (frame exists) | Unchanged (B40-B). `Init()` (now remounts OnHide + `rememberSpecial`), then `wireBookOnHide(frame)` (no-replace), then `paint()` / `frame:Show()`. |
| `Hide` (frame exists) | Unchanged (B38-D). `wireBookOnHide` then `rememberSpecial(FRAME_NAME)` then `self.frame:Hide()`. |
| Wipe remount | `UISpecialFrames = {}` then nil OnHide, Init lists `ChurchOfBeefRecordsBook` exactly once. |
| Rebuild | Existing-frame Init does not call `buildFrame` / `CreateFrame`. |
| pageIndex | Init does not assign `pageIndex`. Second-leaf Init after wipe still paints Longest Streak. |
| Sound / dress | None. No `PlaySound`. No `IG_CHARACTER_INFO_*`. `FRAME_NAME` stays `ChurchOfBeefRecordsBook`. PAGE_TITLES stay 9. |

### Unchanged

- Theatrical parchment tome. Chrome title stays `The Records Book`.
- PAGE_TITLES stay the nine Bible titles. `PAGE_TITLE_FONT` stays `Fonts\\MORPHEUS.ttf`.
- B40-B Show OnHide remount. B38-D Hide OnHide remount. B28-C Hide `rememberSpecial` remount. B25-C Init `rememberSpecial` remount. `rememberSpecial` scan-then-append. Missing table no-ops.
- B30-C / B31-D paint() PAGE_TITLE_FONT re-apply. Wheel / roman / persist `ui.recordsBook` stay.
- Isolation wrap. No new main-chunk locals in `test_records.lua`.

## TDD

1. Extended `tests/test_records.lua` (`runB41B()` nested inside `runB25C()` after `runB40B()`: Init remount body has `wireBookOnHide` then `rememberSpecial(FRAME_NAME)`; helper never replaces; no OnShow / rebuild / `PlaySound` / `pageIndex` reset; wipe list, nil OnHide, Init restores OnHide and keeps the second leaf; third Init keeps identity). Updated the B38-D / B40-B keep-strings that pinned Init has no `wireBookOnHide`. Isolation wrap and existing Show / Hide remount / Morpheus / PAGE_TITLES pins stay.
2. Existing-frame `Init` remounts missing OnHide, then `rememberSpecial(FRAME_NAME)`. Show / Hide remount kept. `pageIndex` not reset.
3. Green: `lua tests/test_records.lua` — **744 passed, 0 failed**.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_records.lua   # 744 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_records.lua` standalone | **744 passed, 0 failed.** Lua 5.1.5. Exit 0. |

**Isolated count:** 744 passed, 0 failed. Isolation wrap stays (11 nil pins at file load). Wrap pattern unchanged. `runB41B()` re-pins 5 of them.

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run.

## Self-review

- Exclusive implementation files only. UI → Core only. Glue / MainFrame / TOC not edited.
- Existing-frame `Init` remounts a missing OnHide, re-registers `ChurchOfBeefRecordsBook`, and does not rebuild. An existing script is not replaced.
- Wipe-to-empty then Init lists the name exactly once. Same frame pointer. Third Init keeps OnHide identity. pageIndex stays on the second leaf.
- B40-B Show OnHide remount stays. B38-D Hide OnHide remount stays. B28-C Hide `rememberSpecial` remount stays. B25-C Init `rememberSpecial` remount stays.
- PAGE_TITLES / Morpheus / no-sound / no-remap stay. No OnShow re-wire.
- `runB41B()` is nested inside `runB25C()` after `runB40B()`. No new main-chunk locals (`luac`: test main chunk still **123** locals; RecordsBook file locals still **45**).
- Isolation wrap stays.

## Leftovers

- **Widget Hide / ESC does not remount a niled OnHide.** The missing handler cannot remount itself. `CloseSpecialWindows` / `frame:Hide()` still bypass `RecordsBook:Hide` and `RecordsBook:Init`. A dropped OnHide that never hits those verbs still leaves a wiped list idle until Init / Show / Hide.
- **Show does not call `rememberSpecial` itself.** Brief scoped Init remount. Listing after wipe still happens once via B25-C / B41-B Init. Hide / OnHide still remount the name.
- **No client smoke.** Real ESC vs `CloseSpecialWindows` on Anniversary is unproven. A live remount that dropped the name is simulated by `UISpecialFrames = {}`. A dropped handler is simulated by `SetScript("OnHide", nil)`.
- **Full harness not run.** Exclusive lane; `tests/run.lua` not edited.
- **Harness `Init()` in this suite is a direct call**, not a real ESC key. Script identity, membership counts, and pageIndex persist are pinned; the client's special-frame walk is not.

## Status

**DONE_WITH_CONCERNS.** Isolated **744 / 0**. Isolation wrap **11**. Not signed. No Gate / **POLISH:PASS** claim.
