# B38-D — RecordsBook Hide remounts missing OnHide (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Wiki ESC via `UISpecialFrames` (named frame; do **not** PlaySound `IG_CHARACTER_INFO_*`); Law 6 / §19.4 (Quiet silent; no panel whoosh); Law 10 / Bible §19.3 / §14.2 (theatrical parchment Records Book; player-opened Quiet identity/history); B28-C leftover (`Hide` remounted `rememberSpecial` then `frame:Hide()` only; ESC / `CloseSpecialWindows` bypass `RecordsBook:Hide` and there was no OnHide, so a wiped list stayed idle until Show / Init); brief `docs/reformation/vestments/briefs/B38-D-records-onhide.md`. `FRAME_NAME` stays `ChurchOfBeefRecordsBook`. pageIndex persist stays. PAGE_TITLES stay 9. `PAGE_TITLE_FONT` stays `Fonts\\MORPHEUS.ttf`. No Records remap. No sound. Exclusive files only. No commit. Lane is not signed.

Extracted `wireBookOnHide` (never replace an existing script; no OnShow). Existing-frame `Hide`: remount missing OnHide, then `rememberSpecial(FRAME_NAME)`, then `self.frame:Hide()`. OnHide remounts `rememberSpecial` so ESC still re-lists. Create-path calls the helper after create-time `frame:Hide()`. Does not reset `pageIndex`. Does not rebuild.

**Isolated count:** 620 passed, 0 failed (`lua tests/test_records.lua`). Isolation wrap stays under `if standalone then` at file load (**11** nil pins). Nested `runB38D()` inside `runB25C()` after `runB31D()`. No new main-chunk locals.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_records.lua` | Nested `runB38D()` inside `runB25C()` after `runB31D()` (no new main-chunk locals). Source pin: Hide remounts via `wireBookOnHide` before `rememberSpecial(FRAME_NAME)` then `self.frame:Hide()`. Helper never replaces; no OnShow / `PlaySound` / `IG_CHARACTER_INFO_*` / rebuild / `pageIndex` reset. Create-path wires after create-time Hide. Wipe list, nil OnHide, Show, Hide: OnHide restored, `ChurchOfBeefRecordsBook` re-listed once, pageIndex stays on Longest Streak, no sound, no rebuild. Third Hide does not replace OnHide. Show / Init remount do not remount OnHide. Isolation wrap stays. |
| `addon/ChurchOfBeef/UI/RecordsBook.lua` | Extracted `wireBookOnHide` (never replace an existing script; no OnShow). Create-path calls it after create-time Hide. Existing-frame `Hide` remounts missing OnHide, then `rememberSpecial(FRAME_NAME)`, then `self.frame:Hide()`. OnHide remounts `rememberSpecial`. Does not reset `pageIndex`. Does not rebuild. Header notes the remount. No `PlaySound`. No Records remap. |
| `docs/reformation/vestments/briefs/B38-D-records-onhide-report.md` | This file |
| `docs/reformation/vestments/briefs/B38-D-records-onhide.diff` | B38-D-only unified diff of the exclusive implementation files vs the pre-lane working tree |

Did not edit glue, MainFrame, TOC, bootstrap, `ChurchOfBeef.lua`, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not add sound. Did not remap Records. Did not reset `pageIndex`. Did not commit.

`git diff HEAD` on these two files also includes earlier Records Book batches (working tree already dirty). The brief diff is the B38-D-only delta.

## Contract

| Surface | Role |
|---------|------|
| `wireBookOnHide` | If `GetScript("OnHide")` is nil, wire: `rememberSpecial(FRAME_NAME)`. Do not replace an existing script. Do not wire OnShow. Do not reset `pageIndex`. |
| `Hide` (frame exists) | `wireBookOnHide(self.frame)` then `rememberSpecial(FRAME_NAME)` then `self.frame:Hide()`. Same frame pointer. |
| `Hide` (no frame) | Unchanged. Still returns true. |
| `buildFrame` | Unchanged except create-path calls `wireBookOnHide(frame)` after create-time `frame:Hide()`. |
| `Show` existing-frame | Unchanged. Still Init / paint / `frame:Show()`. Does not remount OnHide. Does not re-wire OnShow. |
| `Init` remount | Unchanged (B25-C). Existing-frame Init still remounts `rememberSpecial`. Does not remount OnHide. |
| Wipe remount | `UISpecialFrames = {}` then nil OnHide, Show, Hide lists `ChurchOfBeefRecordsBook` exactly once. |
| Rebuild | Existing-frame Hide does not call `buildFrame` / `CreateFrame` / `Show`. |
| pageIndex | Hide / OnHide do not assign `pageIndex`. Second-leaf Show after Hide still paints Longest Streak. |
| Sound / dress | None. No `PlaySound`. No `IG_CHARACTER_INFO_*`. `FRAME_NAME` stays `ChurchOfBeefRecordsBook`. PAGE_TITLES stay 9. |

### Unchanged

- Theatrical parchment tome. Chrome title stays `The Records Book`.
- PAGE_TITLES stay the nine Bible titles. `PAGE_TITLE_FONT` stays `Fonts\\MORPHEUS.ttf`.
- B28-C Hide `rememberSpecial` remount. B25-C Init remount. `rememberSpecial` scan-then-append. Missing table no-ops.
- B30-C / B31-D paint() PAGE_TITLE_FONT re-apply. Wheel / roman / persist `ui.recordsBook` stay.
- Isolation wrap. No new main-chunk locals in `test_records.lua`.

## TDD

1. Extended `tests/test_records.lua` (`runB38D()` nested inside `runB25C()` after `runB31D()`: Hide remount body has `wireBookOnHide` then `rememberSpecial(FRAME_NAME)` then `self.frame:Hide()`; helper never replaces; no OnShow / rebuild / `PlaySound` / `pageIndex` reset; wipe list, nil OnHide, Show, Hide restores OnHide and keeps the second leaf; third Hide keeps identity). Isolation wrap and existing Init / Hide remount / Morpheus / PAGE_TITLES pins untouched.
2. Red: `lua tests/test_records.lua` — first run died after 2 source-pin fails (`wireBookOnHide` missing; `wireBook` nil then `wireBook:find` raised). Existing B25-C / B28-C / B30-C / B31-D / isolation pins stayed green before the crash.
3. Extracted `wireBookOnHide`. Existing-frame `Hide` remounts missing OnHide, then `rememberSpecial(FRAME_NAME)`, then `self.frame:Hide()`. Create-path calls the helper after create-time Hide. Show / Init remount kept. `pageIndex` not reset.
4. Green: `lua tests/test_records.lua` — **620 passed, 0 failed**.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_records.lua   # 620 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_records.lua` standalone | **620 passed, 0 failed.** Lua 5.1.5. Exit 0. |

**Isolated count:** 620 passed, 0 failed. Isolation wrap stays (11 nil pins at file load). Wrap pattern unchanged. `runB38D()` re-pins 5 of them.

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run.

## Self-review

- Exclusive implementation files only. UI → Core only. Glue / MainFrame / TOC not edited.
- Existing-frame `Hide` remounts a missing OnHide, re-registers `ChurchOfBeefRecordsBook`, and does not rebuild. An existing script is not replaced.
- Wipe-to-empty then Show + Hide lists the name exactly once. Same frame pointer. Third Hide keeps OnHide identity. pageIndex stays on the second leaf.
- B28-C Hide `rememberSpecial` remount stays. B25-C Init remount stays. Show / Init do not remount OnHide.
- PAGE_TITLES / Morpheus / no-sound / no-remap stay. No OnShow re-wire.
- `runB38D()` is nested inside `runB25C()` after `runB31D()`. No new main-chunk locals.
- Isolation wrap stays.

## Leftovers

- **Widget Hide / ESC does not remount a niled OnHide.** The missing handler cannot remount itself. `CloseSpecialWindows` / `frame:Hide()` still bypass `RecordsBook:Hide`. A dropped OnHide that never hits `RecordsBook:Hide` still leaves a wiped list idle until Show / Init.
- **Show / Init remount do not remount OnHide.** Brief asked Hide-only remount and no OnShow re-wire. A niled handler that only hits Show / Init stays idle.
- **No client smoke.** Real ESC vs `CloseSpecialWindows` on Anniversary is unproven. A live remount that dropped the name is simulated by `UISpecialFrames = {}`. A dropped handler is simulated by `SetScript("OnHide", nil)`.
- **Full harness not run.** Exclusive lane; `tests/run.lua` not edited.
- **Harness `Hide()` in this suite is a direct call**, not a real ESC key. Script identity, membership counts, and pageIndex persist are pinned; the client's special-frame walk is not.

## Status

**DONE_WITH_CONCERNS.** Isolated **620 / 0**. Isolation wrap **11**. Not signed. No Gate / **POLISH:PASS** claim. Gate W stays OPEN. Gate V stays OPEN.
