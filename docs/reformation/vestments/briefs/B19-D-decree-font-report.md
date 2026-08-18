# B19-D — Decree line uses FrameXML Morpheus casing (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Bible §19.3 / license 4 stock only; Law 6 (Quiet silent); brief `docs/reformation/vestments/briefs/B19-D-decree-font.md`. V-A leftover: FrameXML / game font is `Fonts\MORPHEUS.ttf`. Toasts already uses `Fonts\\MORPHEUS.ttf`. No custom media. No deputy. No sound.

`LINE_FONT` is now `Fonts\\MORPHEUS.ttf`. Body `FRIZQT__.TTF` stays. `applyFont` still falls back to GameFont if `SetFont` fails. No `MORPHEUS_CYR`. Header copy, church name, QuestBG, no cross glyphs stay. Exclusive files only. No commit. Lane is not signed.

**Isolated count:** 246 passed, 0 failed (`lua tests/test_decree_ui.lua`). **18** isolation pins under `if standalone then`.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_decree_ui.lua` | TDD first. Source pins: `Fonts\\MORPHEUS.ttf`; no `MORPHEUS.TTF`; no `MORPHEUS_CYR`; `FRIZQT__.TTF` stays; `SetFontObject` fallback stays. Existing paint / Quiet hide / persist / `UISpecialFrames` pins stay. Isolation wrap stays. |
| `addon/ChurchOfBeef/UI/Decree.lua` | `LINE_FONT` casing only: `Fonts\\MORPHEUS.ttf`. `applyFont` unchanged. |
| `docs/reformation/vestments/briefs/B19-D-decree-font-report.md` | This file |
| `docs/reformation/vestments/briefs/B19-D-decree-font.diff` | B19-D-only unified diff of the exclusive implementation files vs the pre-lane working tree |

Did not edit Toasts, Records, FighterCard, glue, TOC, bootstrap, `ChurchOfBeef.lua`, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not add deputy. Did not add sound. Did not commit.

`git diff` vs HEAD on these two files also includes earlier vestment batches (working tree already dirty). The brief diff is the B19-D-only delta.

## Contract

```lua
local LINE_FONT = "Fonts\\MORPHEUS.ttf"
local BODY_FONT = "Fonts\\FRIZQT__.TTF"
-- applyFont(fs, template, path, size): SetFont, else SetFontObject(template)
```

| Surface | Role |
|---------|------|
| Line | FrameXML `Fonts\\MORPHEUS.ttf` (match Toasts). GameFont fallback if `SetFont` fails. |
| Body / header / church name | `FRIZQT__.TTF` unchanged. |
| GlueFonts | No `MORPHEUS_CYR`. |
| Quiet | Silent. No `PlaySound`. No deputy. |
| Header copy / church name / QuestBG / no cross glyphs | Unchanged. |

Keep:

- Existing decree paint / Quiet hide / persist / `UISpecialFrames` pins
- Isolation wrap (wow_ui_stub + Common + Decree + Decree UI + Minimap)
- `applyFont` fallback

## TDD

1. Extended `tests/test_decree_ui.lua` first (source pin for `Fonts\\MORPHEUS.ttf`; refuse `MORPHEUS.TTF` and `MORPHEUS_CYR`; body FRIZQT and `SetFontObject` stay). Isolation wrap untouched.
2. Red: `lua tests/test_decree_ui.lua` — **244 passed, 2 failed** (`LINE_FONT` was still `Fonts\\MORPHEUS.TTF`).
3. `LINE_FONT` set to `Fonts\\MORPHEUS.ttf`. `applyFont` not edited.
4. Green: `lua tests/test_decree_ui.lua` — **246 passed, 0 failed**.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_decree_ui.lua   # 246 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_decree_ui.lua` standalone | **246 passed, 0 failed.** Lua 5.1.5. Exit 0. |

**Isolated count:** 18 pins under `if standalone then` at file load (slash, Decree slash, DB, Store, Runtime, Net, Console, Hud, RecordsBook, Toasts, Sender, Sound, Officer, Archive, Gora, Knighting, Recognition, MainFrame). Wrap unchanged.

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run.

## Self-review

- Exclusive implementation files only. Toasts / Records / FighterCard / glue / TOC were not edited.
- `LINE_FONT` is `Fonts\\MORPHEUS.ttf`. Body `FRIZQT__.TTF` stays.
- `applyFont` still falls back to GameFont. No `MORPHEUS_CYR`. No deputy. No sound.
- Header copy, church name, QuestBG, no cross glyphs stay.
- Isolation wrap stays.

## Isolated count

**246 passed, 0 failed.** Isolation wrap: **18**.

## Leftovers

- **No client smoke / full harness.** Memory-only. Anniversary `SetFont("Fonts\\MORPHEUS.ttf")` is not walked in-game this lane.
- **Records Book and FighterCard still use `Fonts\\MORPHEUS.TTF`.** Out of exclusive pair. V-A leftover continues there.
- **`applyFont` fallback is source-pinned, not client-proven.** Missing-face load still depends on GameFont.
- Lane is unsigned. No Gate or POLISH claim.

## Status

**DONE_WITH_CONCERNS.** Isolated **246 / 0**. Isolation wrap **18**. Not signed.
