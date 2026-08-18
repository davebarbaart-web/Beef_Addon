# B4-E — Fighter card left dock + display face (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Bible §10.6, §19.2–19.3, Law 4, Law 6, Law 10; brief `docs/reformation/vestments/briefs/B4-E-fightercard-dock.md`; stock note `docs/reformation/vestments/briefs/V-stock-textures.md`. B3-B mute contract kept.

Event Mode mute tale of the tape. The card shows; the Pope tells. Default dock is **LEFT** of UIParent (left third), clamped. Fighter names try stock `Fonts\MORPHEUS.TTF` via `pcall` `SetFont`; fallback `GameFontHighlight`. Titles / records stay `GameFont*`. Painted W–L and H2H stay `1-0`. Exclusive files only. No commit. Lane is not signed. **POLISH:CANDIDATE** at most.

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_fighter_card.lua` | Init/layout pins: `GetPoint` is LEFT / UIParent / LEFT. Clamp pin. Name template stays `GameFontHighlight`; titles/records stay `GameFont*`. Soft `GetFont` pin (pass if stub ignores `SetFont`). Source grep allows stock Morpheus; still bans custom `.ttf` / Media. Rebuild pins left-third + LEFT. Existing `1-0` pins unchanged. Isolation wrap stays. |
| `addon/ChurchOfBeef/UI/FighterCard.lua` | Default `SetPoint("LEFT", UIParent, "LEFT")`. `SetClampedToScreen` kept. Names `pcall` `SetFont` `Fonts\MORPHEUS.TTF` (size 16); fallback `GameFontHighlight`. Titles / records / H2H / stipulation stay `GameFont*`. Mute tape unchanged. |
| `docs/reformation/vestments/briefs/B4-E-fightercard-dock-report.md` | This file |
| `docs/reformation/vestments/briefs/B4-E-fightercard-dock.diff` | B4-E-only unified diff of the exclusive files |

Did not edit Hud, Toasts, Console, TOC, `run.lua`, Gora, Store, bootstrap, OPEN_QUESTIONS, or REFORMATION_LOG. Did not add Media files. Did not commit. Did not add a close button. Did not call `UnitHealth`. Did not switch painted H2H / record to roman.

## Contract

```lua
FighterCard:Init()
FighterCard:Show()      -- needs a sanctioned pair; else false
FighterCard:Hide()
FighterCard:Refresh()
FighterCard:GetView()   -- copy
FighterCard:ResetForTests()
```

Mode Event. Quiet / no pair still Hide. `health` stays nil.

| Field | Source / form |
|-------|----------------|
| dock | LEFT of UIParent, clamped. Width = 1/3 of parent, or **420** if unknown |
| names | `GameFontHighlight` template; `pcall` `SetFont` `Fonts\MORPHEUS.TTF`. Class color on the name only |
| titles / records / H2H / stipulation | `GameFont*`. W–L and H2H paint as `1-0` (arabic). No roman here |
| defenses | omitted (Store still nils the field) |
| health | not on the card. No `UnitHealth` |

No close / star / ✕ chrome. No faction crests. No `Media\` paths. No generated flavor.

## TDD

1. Updated `tests/test_fighter_card.lua` first (LEFT `GetPoint`, clamp, Morpheus source grep, soft `GetFont`, `GameFont*` titles/records, left-third rebuild). Kept `1-0`, `rubber` / `ordained`, isolation wrap.
2. Implemented LEFT dock + `applyNameFont` on names only.
3. Green: `lua tests/test_fighter_card.lua` — **276 passed, 0 failed**.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_fighter_card.lua   # 276 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_fighter_card.lua` standalone | **276 passed, 0 failed.** Lua 5.1. Exit 0. |

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). In-game `/reload` smoke was not run.

## Self-review

- Exclusive implementation files only. Quiet / no pair still Hide. `health` stays nil. No close button.
- Source has no `UnitHealth`, `rubber`, `ordained`, `StatusBar`, `PlaySound`, `PvPFrame`, `Media\\`. Stock Morpheus is the only `.TTF`.
- Painted rematch record and H2H stay `1-0`. Titles / records stay `GameFont*`.
- `GetView` is still a copy. Isolation asserts stay under `if standalone then`.
- `SetClampedToScreen(true)` kept. Default point is LEFT, not CENTER.

## Isolated count

**276 passed, 0 failed.**

## Concerns

- **No client smoke.** Stock Morpheus at height 16 is unsmoked on 20506. Missing font falls back to `GameFontHighlight` (`pcall`; `SetFont` success bool). License 4 / brief require stock paths. **POLISH:CANDIDATE** only.
- **Harness `SetFont` is a no-op.** `wow_ui_stub` ignores `SetFont` / `GetFont`. Names keep the `GameFontHighlight` template in the suite. Soft pin does not fail. Real client path is unproven.
- **Size is sampled once** at first `Init` (idempotent). Later `UIParent` size changes do not resize the card.
- **LEFT flush at 0,0.** Clamped, but the card may sit on the screen edge / under other left-side chrome. Brief named LEFT, not an inset.
- **`WHITE8X8` is UNCONFIRMED** in FrameXML for this checkout. Same `pcall` `SetTexture` + vertex-color path as B3-B.
- Integrator still lists the files in the TOC and `run.lua`.

## Status

**DONE_WITH_CONCERNS.** Isolated **276 / 0**. Not signed. **POLISH:CANDIDATE.**
