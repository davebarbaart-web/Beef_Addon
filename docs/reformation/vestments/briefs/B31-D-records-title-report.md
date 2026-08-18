# B31-D — Records paint re-applies Morpheus on the book title (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** B30 leftover (`TitleText` Morpheus applies only in `buildFrame`; `paint()` already re-applies PageTitle in B30-C); Bible §19.3 / license 4 stock only; Law 10 / Law 6 (theatrical parchment; player-opened Quiet identity/history; no Hide sound); brief `docs/reformation/vestments/briefs/B31-D-records-title.md`. When `paint()` runs and `frame.TitleText` exists, it calls `applyFont(frame.TitleText, "GameFontNormalHuge", PAGE_TITLE_FONT, 20)`. Chrome title copy stays `"The Records Book"`. PageTitle apply (B30-C) stays. `PAGE_TITLE_FONT` stays `Fonts\\MORPHEUS.ttf`. FRIZQT / GameFont fallback in `applyFont` stays. PAGE_TITLES stay 9. No category remap (#3). No generated prose. No custom media. Exclusive files only. No commit. Lane is not signed.

**Isolated count:** 536 passed, 0 failed (`lua tests/test_records.lua`). Isolation wrap stays under `if standalone then` at file load (**11** nil pins). Nested `runB31D()` inside `runB25C()` after `runB30C()`. No new main-chunk locals.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_records.lua` | TDD first. Nested `runB31D()` inside `runB25C()` after `runB30C()` (Lua 5.1 200-local cap; no new main-chunk locals). Source pin extracts the `paint()` body and requires `applyFont(frame.TitleText, "GameFontNormalHuge", PAGE_TITLE_FONT, 20)`. PageTitle paint pin stays. `paint()` does not `SetText` on `TitleText`. Chrome copy stays `"The Records Book"`. `buildFrame` still applies Morpheus on create (`title` 20 / `pageTitle` 18). PAGE_TITLES==9 / roman XIV / Hide remount / wheel / FRIZQT / GameFont / no `MORPHEUS_CYR` / isolation re-pins. B30-C leftover pin (`paint` does not restyle `TitleText`) dropped so the new apply can land. Isolation wrap stays. |
| `addon/ChurchOfBeef/UI/RecordsBook.lua` | `paint()` calls `applyFont(frame.TitleText, "GameFontNormalHuge", PAGE_TITLE_FONT, 20)` when `frame.TitleText` exists. PageTitle apply / `SetText` stay. `buildFrame` create-path apply stays. Chrome title string stays `"The Records Book"`. `applyFont` body / `PAGE_TITLE_FONT` / FRIZQT fallback unchanged. No new file locals. No sound. |
| `docs/reformation/vestments/briefs/B31-D-records-title-report.md` | This file |
| `docs/reformation/vestments/briefs/B31-D-records-title.diff` | B31-D-only unified diff of the exclusive implementation files vs the pre-lane working tree |

Did not edit Decree, Toasts, glue, TOC, bootstrap, `ChurchOfBeef.lua`, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not remap categories (#3). Did not add custom media. Did not add `PlaySound`. Did not change page titles, roman tallies, honorific copy, or the chrome title string. Did not commit.

`git diff HEAD` on these two files also includes earlier Records Book batches (working tree already dirty). The brief diff is the B31-D-only delta.

## Contract

| Surface | Role |
|---------|------|
| `paint()` `TitleText` | `applyFont(frame.TitleText, "GameFontNormalHuge", PAGE_TITLE_FONT, 20)` when the leaf exists. Does not `SetText`. |
| `paint()` `PageTitle` | Unchanged. `applyFont(frame.PageTitle, "GameFontNormalLarge", PAGE_TITLE_FONT, 18)` then `SetText`. |
| `paint()` body / honorifics / moments | Unchanged. `SetText` only. |
| `buildFrame` | Still applies Morpheus on mint (`title` 20 / `pageTitle` 18). Chrome `SetText("The Records Book")` stays. |
| `applyFont` | Unchanged body. `pcall` `SetFont(path, size)`; FRIZQT face; fallback `SetFontObject(GameFont*)`. |
| `PAGE_TITLE_FONT` | Still `Fonts\\MORPHEUS.ttf`. No `MORPHEUS_CYR`. |
| Pages / dress | `PAGE_TITLES` stay 9. Roman tallies stay XIV. Honorific copy unchanged. |
| Sound | None. Source has no `PlaySound`. Paint stays silent. |

### Unchanged

- B25-C Init early-return remount.
- B28-C Hide remount / Toggle-while-shown.
- B30-C PageTitle paint apply.
- Wheel `EnableMouseWheel` / `OnMouseWheel`.
- Page / Morpheus create-path / `PAGE_TITLES==9` pins.
- Roman tally helper (`toRoman(14) == "XIV"`).
- Isolation wrap. No new main-chunk locals.

## TDD

1. Extended `tests/test_records.lua` first (`runB31D()` nested in `runB25C()` after `runB30C()`: extract `paint()` body and require `applyFont` on `TitleText` with `PAGE_TITLE_FONT`; PageTitle paint pin stays; chrome copy stays `"The Records Book"`; `paint()` does not `SetText` `TitleText`; `buildFrame` still applies; PAGE_TITLES / roman / Hide remount / wheel / FRIZQT / isolation). Dropped the B30-C leftover pin that forbade `TitleText` in `paint()`. Isolation wrap and B28-C remount pins untouched.
2. Red: `lua tests/test_records.lua` — **535 passed, 1 failed** (`paint re-applies PAGE_TITLE_FONT on TitleText`). PageTitle paint / Hide remount / wheel / PAGE_TITLES / isolation pins stayed green.
3. `paint()` calls `applyFont(frame.TitleText, "GameFontNormalHuge", PAGE_TITLE_FONT, 20)` when `frame.TitleText` exists. PageTitle apply kept. Chrome `SetText("The Records Book")` untouched.
4. Green: `lua tests/test_records.lua` — **536 passed, 0 failed**.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_records.lua   # 536 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_records.lua` standalone | **536 passed, 0 failed.** Lua 5.1.5. Exit 0. |

**Isolated count:** 536 passed, 0 failed. Isolation wrap stays (11 nil pins at file load). Wrap pattern unchanged. `runB25C()` still re-pins 5 of them after `runB31D()`.

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run.

## Self-review

- Exclusive implementation files only. Decree / Toasts / glue / TOC not edited.
- `applyFont` runs from `paint()` when `TitleText` exists, and still from `buildFrame` on mint. PageTitle paint apply stays.
- Chrome title string stays `"The Records Book"`. Page titles, roman tallies, and honorific copy are unchanged.
- `PAGE_TITLE_FONT` is `Fonts\\MORPHEUS.ttf`. No `MORPHEUS.TTF`. No `MORPHEUS_CYR`.
- FRIZQT / `SetFontObject` fallback stays. No custom media. No paint sound.
- `runB31D()` is nested inside `runB25C()` after `runB30C()`. Isolation wrap stays. No new main-chunk locals.

## Leftovers

- **No client smoke.** Anniversary `SetFont("Fonts\\MORPHEUS.ttf")` after a later leaf turn / font reset is not walked in-game this lane.
- **Harness `SetFont` is a no-op.** `wow_ui_stub` ignores `SetFont` / `GetFont`. Chrome and page titles keep the `GameFontNormalHuge` / `GameFontNormalLarge` templates in the suite. Soft `GetFont` is not pinned. Real client re-apply is unproven.
- **Success-bool fallback.** `applyFont` requires a truthy `SetFont` return. On the harness it always falls through to `SetFontObject(GameFont*)`.
- **B30-C create-path pin wording.** `runB30C()` still says `TitleText stays create-only Morpheus` while checking the `buildFrame` apply. Paint now also applies. Out of this lane's pin rewrite.
- Full `lua tests/run.lua` was not run.
- **OPEN_QUESTIONS #3** (category remap) stays parked. This lane does not answer it.

## Status

**DONE_WITH_CONCERNS.** Isolated **536 / 0**. Isolation wrap **11**. Not signed. Do not claim Gate W, Gate V, or POLISH:PASS.
