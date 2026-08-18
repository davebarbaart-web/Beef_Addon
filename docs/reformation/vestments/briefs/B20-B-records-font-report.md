# B20-B — Records title uses FrameXML Morpheus casing (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Bible §19.3 / license 4 stock only; Law 10 (theatrical parchment); brief `docs/reformation/vestments/briefs/B20-B-records-font.md`. V-A leftover: FrameXML / game font is `Fonts\MORPHEUS.ttf`. Decree and Toasts already use `Fonts\\MORPHEUS.ttf`. No custom media. No category remap (#3). PAGE_TITLES stay 9.

`PAGE_TITLE_FONT` is now `Fonts\\MORPHEUS.ttf`. `FALLBACK_TITLE_FONT` `FRIZQT__.TTF` stays. `applyFont` still tries the title face, then FRIZQT, then GameFont if `SetFont` fails. No `MORPHEUS_CYR`. Roman tallies stay. Wheel pins stay. Exclusive files only. No commit. Lane is not signed.

**Isolated count:** 425 passed, 0 failed (`lua tests/test_records.lua`). **11** isolation pins under `if standalone then`.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_records.lua` | TDD first. Source pins: `Fonts\\MORPHEUS.ttf`; no `MORPHEUS.TTF`; no `MORPHEUS_CYR`; `FRIZQT__.TTF` stays; `SetFontObject` fallback stays. Existing page / identity / wheel pins stay. Isolation wrap stays. |
| `addon/ChurchOfBeef/UI/RecordsBook.lua` | `PAGE_TITLE_FONT` casing only: `Fonts\\MORPHEUS.ttf`. `applyFont` unchanged. |
| `docs/reformation/vestments/briefs/B20-B-records-font-report.md` | This file |
| `docs/reformation/vestments/briefs/B20-B-records-font.diff` | B20-B-only unified diff of the exclusive implementation files vs the pre-lane working tree |

Did not edit Decree, Toasts, FighterCard, glue, TOC, bootstrap, `ChurchOfBeef.lua`, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not remap `PAGE_TITLES`. Did not add `MORPHEUS_CYR`. Did not commit.

`git diff` vs HEAD on these two files also includes earlier vestment batches (working tree already dirty). The brief diff is the B20-B-only delta.

## Contract

```lua
local PAGE_TITLE_FONT = "Fonts\\MORPHEUS.ttf"
local FALLBACK_TITLE_FONT = "Fonts\\FRIZQT__.TTF"
-- applyFont(fs, template, path, size): SetFont path, else FRIZQT, else SetFontObject(template)
```

| Surface | Role |
|---------|------|
| Page title | FrameXML `Fonts\\MORPHEUS.ttf` (match Decree / Toasts). GameFont fallback if `SetFont` fails. |
| Fallback face | `FRIZQT__.TTF` unchanged. |
| GlueFonts | No `MORPHEUS_CYR`. |
| `PAGE_TITLES` | Nine Bible names, Bible order. No category remap. |
| Roman / wheel | Unchanged. |

Keep:

- Existing page / identity / wheel pins
- Isolation wrap (wow_ui_stub + Common + Ranks + Store + RecordsBook)
- `applyFont` fallback

## TDD

1. Extended `tests/test_records.lua` first (source pin for `Fonts\\MORPHEUS.ttf`; refuse `MORPHEUS.TTF` and `MORPHEUS_CYR`; FRIZQT and `SetFontObject` stay). Isolation wrap untouched.
2. Red: `lua tests/test_records.lua` — **423 passed, 2 failed** (`PAGE_TITLE_FONT` was still `Fonts\\MORPHEUS.TTF`).
3. `PAGE_TITLE_FONT` set to `Fonts\\MORPHEUS.ttf`. `applyFont` not edited.
4. Green: `lua tests/test_records.lua` — **425 passed, 0 failed**.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_records.lua   # 425 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_records.lua` standalone | **425 passed, 0 failed.** Lua 5.1.5. Exit 0. |

**Isolated count:** 11 pins under `if standalone then` at file load (Runtime, Gora, Officer, MainFrame, BeefNet, DB, Sender, Minimap, Toasts, Console, Hud). Wrap unchanged.

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run.

## Self-review

- Exclusive implementation files only. Decree / Toasts / FighterCard / glue / TOC were not edited.
- `PAGE_TITLE_FONT` is `Fonts\\MORPHEUS.ttf`. Fallback `FRIZQT__.TTF` stays.
- `applyFont` still falls back to FRIZQT then GameFont. No `MORPHEUS_CYR`. PAGE_TITLES stay 9.
- Roman tallies and wheel pins stay.
- Isolation wrap stays.

## Isolated count

**425 passed, 0 failed.** Isolation wrap: **11**.

## Leftovers

- **No client smoke / full harness.** Memory-only. Anniversary `SetFont("Fonts\\MORPHEUS.ttf")` is not walked in-game this lane.
- **FighterCard still uses `Fonts\\MORPHEUS.TTF`.** Out of exclusive pair. V-A leftover continues there.
- **`applyFont` fallback is source-pinned, not client-proven.** Missing-face load still depends on FRIZQT then GameFont.
- Lane is unsigned. No Gate or POLISH claim.

## Status

**DONE_WITH_CONCERNS.** Isolated **425 / 0**. Isolation wrap **11**. Not signed.
