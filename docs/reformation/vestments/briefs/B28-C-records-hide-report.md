# B28-C — Records Book Hide remounts ESC (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** B25 leftover (`Hide` / Toggle-while-shown skipped `rememberSpecial`; only Init / `buildFrame` registered); wiki ESC via `UISpecialFrames`; Law 6 / §14.2 (player-opened Quiet identity/history; no Hide sound); Law 10 / Bible §19.3 (theatrical parchment; `PAGE_TITLE_FONT` stays `Fonts\\MORPHEUS.ttf`); brief `docs/reformation/vestments/briefs/B28-C-records-hide.md`. PAGE_TITLES stay 9. No category remap (#3). No custom media. B25-C Init remount stays. Exclusive files only. No commit. Lane is not signed.

`RecordsBook:Hide` (`if self.frame then`) now calls `rememberSpecial(FRAME_NAME)` then Hide. It does not rebuild. Toggle-while-shown is Hide. Create-path uniqueness still dedupes (`rememberSpecial` scan-then-append). Init remount (B25-C) stays. `FRAME_NAME` is `"ChurchOfBeefRecordsBook"`.

**Isolated count:** 487 passed, 0 failed (`lua tests/test_records.lua`). Isolation wrap stays under `if standalone then` at file load (**11** nil pins). Nested `runB28C()` inside `runB25C()` after the Init remount restore. No new main-chunk locals.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_records.lua` | TDD first. Nested `runB28C()` inside `runB25C()` after the Init remount restore (Lua 5.1 200-local cap; no new main-chunk locals). Source pin: Hide body has `rememberSpecial(FRAME_NAME)` before `self.frame:Hide()` and no `buildFrame` / `CreateFrame` / `PlaySound`. Init, wipe `UISpecialFrames` to `{}`, Hide: `ChurchOfBeefRecordsBook` listed exactly once. Same frame pointer (no rebuild). Second Hide still once. Toggle-while-shown after a second wipe lists the name once. PAGE_TITLES==9 / Morpheus / B25-C Init remount re-pins. Isolation wrap stays. |
| `addon/ChurchOfBeef/UI/RecordsBook.lua` | Hide calls `rememberSpecial(FRAME_NAME)` then Hide when a frame exists. Does not rebuild. Init remount (B25-C) unchanged. No new file locals. No sound. |
| `docs/reformation/vestments/briefs/B28-C-records-hide-report.md` | This file |
| `docs/reformation/vestments/briefs/B28-C-records-hide.diff` | B28-C-only unified diff of the exclusive implementation files vs the pre-lane working tree |

Did not edit Decree, Toasts, glue, TOC, bootstrap, `ChurchOfBeef.lua`, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not remap categories (#3). Did not add custom media. Did not add `PlaySound`. Did not commit.

`git diff HEAD` on these two files also includes earlier Records Book batches (working tree already dirty). The brief diff is the B28-C-only delta.

## Contract

| Surface | Role |
|---------|------|
| `Hide` (frame exists) | `rememberSpecial(FRAME_NAME)` then Hide. Return true. |
| `Hide` (no frame) | Unchanged. Return true. Does not Init or rebuild. |
| `Toggle` while shown | Unchanged. Calls `Hide()`, so remounts. |
| Init remount (B25-C) | Unchanged. Early-return still `rememberSpecial(FRAME_NAME)` then return the frame. |
| Create path | Unchanged. `buildFrame` still calls `rememberSpecial(FRAME_NAME)` once. |
| Wipe remount | `UISpecialFrames = {}` then Hide lists `ChurchOfBeefRecordsBook` exactly once. |
| Frame identity | Hide returns success and keeps the same frame. No rebuild. |
| Sound | None. Source has no `PlaySound`. Hide stays silent. |
| Pages / dress | `PAGE_TITLES` stay 9. `PAGE_TITLE_FONT` stays `Fonts\\MORPHEUS.ttf`. |

### Unchanged

- B25-C Init early-return remount.
- Existing first-create uniqueness pin (`UISpecialFrames` lists `ChurchOfBeefRecordsBook`).
- Page / wheel / Morpheus / `PAGE_TITLES==9` pins.
- Roman tally helper (`toRoman(14) == "XIV"`).
- Isolation wrap. No new main-chunk locals.

## TDD

1. Extended `tests/test_records.lua` first (`runB28C()` nested in `runB25C()` after the Init remount restore: Hide source has `rememberSpecial(FRAME_NAME)` before Hide; Init, wipe `UISpecialFrames` to `{}`, Hide lists the name once and keeps the same frame; Toggle-while-shown after a second wipe lists once; PAGE_TITLES / Morpheus / B25-C Init remount / isolation). Isolation wrap and B25-C remount pins untouched.
2. Red: `lua tests/test_records.lua` — **483 passed, 4 failed** (Hide source missing `rememberSpecial(FRAME_NAME)` before Hide; wiped list stayed 0 after Hide / second Hide / Toggle-while-shown). Same-frame / PAGE_TITLES / Morpheus / B25-C Init remount pins stayed green.
3. `Hide()` calls `rememberSpecial(FRAME_NAME)` when `self.frame` exists, then Hide. Toggle-while-shown is Hide. Init remount kept.
4. Green: `lua tests/test_records.lua` — **487 passed, 0 failed**.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_records.lua   # 487 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_records.lua` standalone | **487 passed, 0 failed.** Lua 5.1.5. Exit 0. |

**Isolated count:** 487 passed, 0 failed. Isolation wrap stays (11 nil pins at file load). Wrap pattern unchanged. `runB25C()` still re-pins 5 of them after `runB28C()`.

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run.

## Self-review

- Exclusive implementation files only. Decree / Toasts / glue / TOC not edited.
- Hide re-registers `ChurchOfBeefRecordsBook` and does not rebuild.
- Wipe-to-empty then Hide lists the name exactly once. Second Hide still once. Toggle-while-shown after a wipe lists once.
- PAGE_TITLES stay 9. `PAGE_TITLE_FONT` stays `Fonts\\MORPHEUS.ttf`. B25-C Init remount stays. No custom media. No Hide sound.
- `runB28C()` is nested inside `runB25C()`. Isolation wrap stays. No new main-chunk locals.

## Leftovers

- **No client smoke.** Real ESC vs `CloseSpecialWindows` on the named tome is unproven on Anniversary. A live remount that dropped the name is simulated by `UISpecialFrames = {}`.
- **Full harness not run.** Exclusive lane; `tests/run.lua` not edited.
- **Harness membership counts are pinned;** the client's special-frame walk is not. `Hide()` in this suite is a direct call, not a real ESC key. Close-button Hide remounts via the same path.
- **`ResetForTests` still calls `self.frame:Hide()` directly** and does not remount. Harness-only; production Close / Toggle / `RecordsBook:Hide` remount.
- **OPEN_QUESTIONS #3** (category remap) stays parked. This lane does not answer it.
- **Parked Console leftover** (overview): selected-pair inherit of Core `namedOpponent`. Later / sibling Console batch.

## Status

**DONE_WITH_CONCERNS.** Isolated **487 / 0**. Not signed. No Gate / **POLISH:PASS** claim. Gate W stays OPEN. Gate V stays OPEN.
