# B25-C — Records Book Init early-return re-registers ESC (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** B25-C leftover (`RecordsBook:Init` returned the existing frame and skipped `rememberSpecial`; only `buildFrame` registered); wiki ESC via `UISpecialFrames`; Law 6 / §14.2 (player-opened Quiet identity/history; no Init sound); Law 10 / Bible §19.3 (theatrical parchment; `PAGE_TITLE_FONT` stays `Fonts\\MORPHEUS.ttf`); brief `docs/reformation/vestments/briefs/B25-C-records-special.md`. PAGE_TITLES stay 9. No category remap (#3). No custom media. Wheel / roman tallies stay. First-create uniqueness pin stays. Exclusive files only. No commit. Lane is not signed.

`RecordsBook:Init` early-return (`if self.frame then`) now calls `rememberSpecial(FRAME_NAME)` then returns the frame. It does not rebuild. Create-path uniqueness still dedupes (`rememberSpecial` scan-then-append from `buildFrame`). First-create uniqueness pin stays.

**Isolated count:** 453 passed, 0 failed (`lua tests/test_records.lua`). Isolation wrap stays under `if standalone then` at file load (**11** nil pins). Nested `runB25C()` after the first-create uniqueness pin. One new main-chunk local (`runB25C`).

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_records.lua` | TDD first. Nested `runB25C()` after the first-create uniqueness pin (Lua 5.1 200-local cap). Source pin: early-return body has `rememberSpecial(FRAME_NAME)` and no `buildFrame` / `PlaySound`. Init, wipe `UISpecialFrames` to `{}`, second Init: `ChurchOfBeefRecordsBook` listed exactly once. Second Init returns the same frame (no rebuild). Third Init still once. PAGE_TITLES==9 / Morpheus / wheel / roman re-pins. Isolation wrap stays. |
| `addon/ChurchOfBeef/UI/RecordsBook.lua` | Early-return calls `rememberSpecial(FRAME_NAME)` then returns the frame. Does not rebuild. `buildFrame` still registers once. No new file locals. No sound. |
| `docs/reformation/vestments/briefs/B25-C-records-special-report.md` | This file |
| `docs/reformation/vestments/briefs/B25-C-records-special.diff` | B25-C-only unified diff of the exclusive implementation files vs the pre-lane working tree |

Did not edit Decree, Toasts, glue, TOC, bootstrap, `ChurchOfBeef.lua`, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not remap categories (#3). Did not add custom media. Did not add `PlaySound`. Did not commit.

`git diff HEAD` on these two files also includes earlier Records Book batches (working tree already dirty). The brief diff is the B25-C-only delta.

## Contract

| Surface | Role |
|---------|------|
| `Init` early-return | `rememberSpecial(FRAME_NAME)` then return the existing frame. |
| Create path | Unchanged. `buildFrame` still calls `rememberSpecial(FRAME_NAME)` once. |
| Wipe remount | `UISpecialFrames = {}` then second Init lists `ChurchOfBeefRecordsBook` exactly once. |
| Frame identity | Second Init returns the same frame. No rebuild. |
| Sound | None. Source has no `PlaySound`. Init stays silent. |
| Pages / dress | `PAGE_TITLES` stay 9. `PAGE_TITLE_FONT` stays `Fonts\\MORPHEUS.ttf`. Wheel / roman tallies stay. |

### Unchanged

- Existing first-create uniqueness pin (`UISpecialFrames` lists `ChurchOfBeefRecordsBook`).
- Page / wheel / Morpheus / `PAGE_TITLES==9` pins.
- Roman tally helper (`toRoman(14) == "XIV"`).
- Isolation wrap. No new main-chunk locals except `runB25C`.

## TDD

1. Extended `tests/test_records.lua` first (`runB25C()` nested after the first-create uniqueness pin: early-return source has `rememberSpecial(FRAME_NAME)`; Init, wipe `UISpecialFrames` to `{}`, second Init lists the name once and returns the same frame; PAGE_TITLES / Morpheus / wheel / roman / isolation). Isolation wrap and first-create uniqueness pin untouched.
2. Red: `lua tests/test_records.lua` — **450 passed, 3 failed** (early-return source missing `rememberSpecial(FRAME_NAME)`; wiped list stayed 0 after second / third Init). Same-frame / PAGE_TITLES / Morpheus / wheel / first-create uniqueness pins stayed green.
3. Early-return calls `rememberSpecial(FRAME_NAME)` then returns the frame.
4. Green: `lua tests/test_records.lua` — **453 passed, 0 failed**.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_records.lua   # 453 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_records.lua` standalone | **453 passed, 0 failed.** Lua 5.1.5. Exit 0. |

**Isolated count:** 453 passed, 0 failed. Isolation wrap stays (11 nil pins at file load). Wrap pattern unchanged. `runB25C()` re-pins 5 of them.

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run.

## Self-review

- Exclusive implementation files only. Decree / Toasts / glue / TOC not edited.
- Early-return re-registers `ChurchOfBeefRecordsBook` and does not rebuild.
- Wipe-to-empty then second Init lists the name exactly once. Third Init still once.
- PAGE_TITLES stay 9. `PAGE_TITLE_FONT` stays `Fonts\\MORPHEUS.ttf`. Wheel / roman stay. No custom media. No Init sound.
- `runB25C()` is nested after the first-create uniqueness pin. Isolation wrap stays.

## Leftovers

- **No client smoke.** Real ESC vs `CloseSpecialWindows` on the named tome is unproven on Anniversary. A live remount that dropped the name is simulated by `UISpecialFrames = {}`.
- **Full harness not run.** Exclusive lane; `tests/run.lua` not edited.
- **Harness membership counts are pinned;** the client's special-frame walk is not. `Hide()` in this suite is a direct call, not a real ESC key.
- **OPEN_QUESTIONS #3** (category remap) stays parked. This lane does not answer it.
- **Parked Console leftover** (overview): selected-pair inherit of Core `namedOpponent`. Later / sibling Console batch.

## Status

**DONE_WITH_CONCERNS.** Isolated **453 / 0**. Not signed. No Gate / **POLISH:PASS** claim. Gate W stays OPEN. Gate V stays OPEN.
