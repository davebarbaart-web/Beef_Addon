# B20-C — Fighter card name uses FrameXML Morpheus casing (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Bible §19.3 / license 4 stock only; brief `docs/reformation/vestments/briefs/B20-C-card-font.md`. V-A leftover: FrameXML / game font is `Fonts\MORPHEUS.ttf`. Decree and Toasts already use `Fonts\\MORPHEUS.ttf`. No custom media. No `UnitHealth`. No drag persist. No `MORPHEUS_CYR`.

`NAME_FONT` is now `Fonts\\MORPHEUS.ttf`. `applyNameFont` still `pcall` `SetFont` then `SetFontObject(GameFontHighlight)`. Painted W–L and H2H stay `1-0`. Left-third dock and `UISpecialFrames` stay. lastPair remains until QUIET. Exclusive files only. No commit. Lane is not signed.

**Isolated count:** 486 passed, 0 failed (`lua tests/test_fighter_card.lua`). **17** isolation pins under `if standalone then`.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_fighter_card.lua` | TDD first. Source pins: `Fonts\\MORPHEUS.ttf`; no `MORPHEUS.TTF`; no `MORPHEUS_CYR`; `SetFontObject` fallback stays. Custom-font grep strips the lowercase stock path. Existing dock / persist / ESC / `1-0` / health-nil pins stay. Isolation wrap stays. |
| `addon/ChurchOfBeef/UI/FighterCard.lua` | `NAME_FONT` casing only: `Fonts\\MORPHEUS.ttf`. `applyNameFont` unchanged. |
| `docs/reformation/vestments/briefs/B20-C-card-font-report.md` | This file |
| `docs/reformation/vestments/briefs/B20-C-card-font.diff` | B20-C-only unified diff of the exclusive implementation files vs the pre-lane working tree |

Did not edit Decree, Records, Toasts, glue, TOC, bootstrap, `ChurchOfBeef.lua`, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not add drag persist. Did not add `UnitHealth`. Did not commit.

`git diff` vs HEAD on these two files also includes earlier vestment batches (working tree already dirty). The brief diff is the B20-C-only delta.

## Contract

```lua
local NAME_FONT = "Fonts\\MORPHEUS.ttf"
-- applyNameFont: pcall SetFont(NAME_FONT, 16), else SetFontObject(GameFontHighlight)
```

| Surface | Role |
|---------|------|
| Names | FrameXML `Fonts\\MORPHEUS.ttf` (match Decree / Toasts). GameFontHighlight fallback if `SetFont` fails. |
| Titles / records / H2H / stipulation | `GameFont*` unchanged. Arabic `1-0` unchanged. |
| Dock | LEFT of UIParent, clamped. No drag persist. |
| ESC | `UISpecialFrames` stays. |
| Persist | lastPair until QUIET. |
| Health | nil. No `UnitHealth`. |
| GlueFonts | No `MORPHEUS_CYR`. |

Keep:

- Existing dock / persist / ESC / `1-0` / health-nil pins
- Isolation wrap (wow_ui_stub + Common + Ranks + Store + Runtime + Gora + FighterCard)
- `applyNameFont` pcall fallback

## TDD

1. Extended `tests/test_fighter_card.lua` first (source pin for `Fonts\\MORPHEUS.ttf`; refuse `MORPHEUS.TTF` and `MORPHEUS_CYR`; `SetFontObject` stays; custom-font grep strips `.ttf`). Isolation wrap untouched.
2. Red: `lua tests/test_fighter_card.lua` — **484 passed, 2 failed** (`NAME_FONT` was still `Fonts\\MORPHEUS.TTF`).
3. `NAME_FONT` set to `Fonts\\MORPHEUS.ttf`. `applyNameFont` not edited.
4. Green: `lua tests/test_fighter_card.lua` — **486 passed, 0 failed**.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_fighter_card.lua   # 486 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_fighter_card.lua` standalone | **486 passed, 0 failed.** Lua 5.1.5. Exit 0. |

**Isolated count:** 17 pins under `if standalone then` (Net, UI, Toasts, DB, Officer, Archive, Recognition, Sender, Codec, Snapshot, Knighting, Minimap, Console, Hud, Sound, Decree, Records Book). Wrap unchanged.

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run.

## Self-review

- Exclusive implementation files only. Decree / Records / Toasts / glue / TOC were not edited.
- `NAME_FONT` is `Fonts\\MORPHEUS.ttf`. `applyNameFont` still falls back to GameFontHighlight.
- No `MORPHEUS_CYR`. No `UnitHealth`. No drag persist. ESC `UISpecialFrames` stays. `1-0` stays.
- Isolation wrap stays.

## Isolated count

**486 passed, 0 failed.** Isolation wrap: **17**.

## Leftovers

- **No client smoke / full harness.** Memory-only. Anniversary `SetFont("Fonts\\MORPHEUS.ttf")` is not walked in-game this lane.
- **Records Book still uses `Fonts\\MORPHEUS.TTF`.** Out of exclusive pair. V-A leftover continues there (B20-B).
- **`applyNameFont` fallback is source-pinned, not client-proven.** Missing-face load still depends on GameFontHighlight. Soft `GetFont` pin does not fail when the stub ignores `SetFont`.
- Lane is unsigned. No Gate or POLISH claim.

## Status

**DONE_WITH_CONCERNS.** Isolated **486 / 0**. Isolation wrap **17**. Not signed.
