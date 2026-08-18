# B30-C — Records paint re-applies Morpheus on the page title (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** B28 leftover (`applyFont(..., PAGE_TITLE_FONT, 18)` only in `buildFrame`; `paint()` only `SetText`); Bible §19.3 / license 4 stock only; Law 10 / Law 6 (theatrical parchment; player-opened Quiet identity/history; no Hide sound); brief `docs/reformation/vestments/briefs/B30-C-records-font.md`. When `paint()` writes `frame.PageTitle`, it calls `applyFont(frame.PageTitle, "GameFontNormalLarge", PAGE_TITLE_FONT, 18)` first. `PAGE_TITLE_FONT` stays `Fonts\\MORPHEUS.ttf`. FRIZQT / GameFont fallback in `applyFont` stays. Book chrome `TitleText` stays create-only. PAGE_TITLES stay 9. No category remap (#3). No generated prose. No custom media. Exclusive files only. No commit. Lane is not signed.

**Isolated count:** 511 passed, 0 failed (`lua tests/test_records.lua`). Isolation wrap stays under `if standalone then` at file load (**11** nil pins). Nested `runB30C()` inside `runB25C()` after `runB28C()`. No new main-chunk locals.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_records.lua` | TDD first. Nested `runB30C()` inside `runB25C()` after `runB28C()` (Lua 5.1 200-local cap; no new main-chunk locals). Source pin extracts the `paint()` body and requires `applyFont(frame.PageTitle, "GameFontNormalLarge", PAGE_TITLE_FONT, 18)` before `SetText`. `paint()` does not restyle `TitleText`. `buildFrame` still applies Morpheus on create (`pageTitle` 18 / `title` 20). PAGE_TITLES==9 / roman XIV / Hide remount / wheel / FRIZQT / GameFont / no `MORPHEUS_CYR` / isolation re-pins. Isolation wrap stays. |
| `addon/ChurchOfBeef/UI/RecordsBook.lua` | `paint()` calls `applyFont(frame.PageTitle, "GameFontNormalLarge", PAGE_TITLE_FONT, 18)` before `SetText` when the leaf writes `PageTitle`. `buildFrame` create-path apply stays. `TitleText` stays create-only. `applyFont` body / `PAGE_TITLE_FONT` / FRIZQT fallback unchanged. No new file locals. No sound. |
| `docs/reformation/vestments/briefs/B30-C-records-font-report.md` | This file |
| `docs/reformation/vestments/briefs/B30-C-records-font.diff` | B30-C-only unified diff of the exclusive implementation files vs the pre-lane working tree |

Did not edit Decree, Toasts, glue, TOC, bootstrap, `ChurchOfBeef.lua`, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not remap categories (#3). Did not add custom media. Did not add `PlaySound`. Did not change page titles, roman tallies, or honorific copy. Did not commit.

`git diff HEAD` on these two files also includes earlier Records Book batches (working tree already dirty). The brief diff is the B30-C-only delta.

## Contract

| Surface | Role |
|---------|------|
| `paint()` `PageTitle` | `applyFont(frame.PageTitle, "GameFontNormalLarge", PAGE_TITLE_FONT, 18)` then `SetText`. Re-applies when the leaf turns. |
| `paint()` `TitleText` | Unchanged. Chrome title stays create-only. |
| `paint()` body / honorifics / moments | Unchanged. `SetText` only. |
| `buildFrame` | Still applies Morpheus on mint (`title` 20 / `pageTitle` 18). |
| `applyFont` | Unchanged body. `pcall` `SetFont(path, size)`; FRIZQT face; fallback `SetFontObject(GameFont*)`. |
| `PAGE_TITLE_FONT` | Still `Fonts\\MORPHEUS.ttf`. No `MORPHEUS_CYR`. |
| Pages / dress | `PAGE_TITLES` stay 9. Roman tallies stay XIV. Honorific copy unchanged. |
| Sound | None. Source has no `PlaySound`. Paint stays silent. |

### Unchanged

- B25-C Init early-return remount.
- B28-C Hide remount / Toggle-while-shown.
- Wheel `EnableMouseWheel` / `OnMouseWheel`.
- Page / Morpheus create-path / `PAGE_TITLES==9` pins.
- Roman tally helper (`toRoman(14) == "XIV"`).
- Isolation wrap. No new main-chunk locals.

## TDD

1. Extended `tests/test_records.lua` first (`runB30C()` nested in `runB25C()` after `runB28C()`: extract `paint()` body and require `applyFont` with `PAGE_TITLE_FONT` before `SetText`; `TitleText` stays create-only; `buildFrame` still applies; PAGE_TITLES / roman / Hide remount / wheel / FRIZQT / isolation). Isolation wrap and B28-C remount pins untouched.
2. Red: `lua tests/test_records.lua` — **510 passed, 1 failed** (`paint re-applies PAGE_TITLE_FONT on PageTitle before SetText`). Create-path Morpheus / Hide remount / wheel / PAGE_TITLES / isolation pins stayed green.
3. `paint()` calls `applyFont(frame.PageTitle, "GameFontNormalLarge", PAGE_TITLE_FONT, 18)` before `SetText`. `buildFrame` call kept. `TitleText` untouched.
4. Green: `lua tests/test_records.lua` — **511 passed, 0 failed**.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_records.lua   # 511 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_records.lua` standalone | **511 passed, 0 failed.** Lua 5.1.5. Exit 0. |

**Isolated count:** 511 passed, 0 failed. Isolation wrap stays (11 nil pins at file load). Wrap pattern unchanged. `runB25C()` still re-pins 5 of them after `runB30C()`.

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run.

## Self-review

- Exclusive implementation files only. Decree / Toasts / glue / TOC not edited.
- `applyFont` runs from `paint()` when `PageTitle` is written, and still from `buildFrame` on mint.
- `TitleText` stays create-only. Page titles, roman tallies, and honorific copy are unchanged.
- `PAGE_TITLE_FONT` is `Fonts\\MORPHEUS.ttf`. No `MORPHEUS.TTF`. No `MORPHEUS_CYR`.
- FRIZQT / `SetFontObject` fallback stays. No custom media. No paint sound.
- `runB30C()` is nested inside `runB25C()` after `runB28C()`. Isolation wrap stays. No new main-chunk locals.

## Leftovers

- **No client smoke.** Anniversary `SetFont("Fonts\\MORPHEUS.ttf")` after a later leaf turn / font reset is not walked in-game this lane.
- **Harness `SetFont` is a no-op.** `wow_ui_stub` ignores `SetFont` / `GetFont`. Page titles keep the `GameFontNormalLarge` template in the suite. Soft `GetFont` is not pinned. Real client re-apply is unproven.
- **Success-bool fallback.** `applyFont` requires a truthy `SetFont` return. On the harness it always falls through to `SetFontObject(GameFontNormalLarge)`.
- **`TitleText` stays create-only.** A later chrome-title font reset would not re-apply on paint. Out of this lane.
- Full `lua tests/run.lua` was not run.
- **OPEN_QUESTIONS #3** (category remap) stays parked. This lane does not answer it.

## Status

**DONE_WITH_CONCERNS.** Isolated **511 / 0**. Isolation wrap **11**. Not signed. Do not claim Gate W, Gate V, or POLISH:PASS.
