# B4-E — Fighter card left dock + display face

**Exclusive:** `addon/ChurchOfBeef/UI/FighterCard.lua`, `tests/test_fighter_card.lua`

**Do not edit** TOC, Hud, Toasts, Console, Gora. Do not commit. Stock Blizzard textures/fonts only. Keep the B3-B mute contract: H2H paints as `1-0` (arabic). No close button. No `UnitHealth`. No generated flavor.

## Law

Bible §10.6, §19.2–19.3. Batch 3/4: dock the card to one side so the ring stays visible; blackletter/display face for fighter names.

1. Default anchor **LEFT** of UIParent (left third), not CENTER. Keep `SetClampedToScreen`. Do not add close / star / ✕ chrome.
2. Fighter **names** try `Fonts\\MORPHEUS.TTF` via `pcall` `SetFont` (stock). Fallback remains `GameFontHighlight`. Titles/records stay `GameFont*`.
3. Keep W–L and H2H as `1-0` (existing tests). Do not invent roman here (B3-B pin).
4. Quiet / no pair still Hide. `health` stays nil. No faction crests. No Media/ paths.

## Tests

Update Init/layout pins: frame is LEFT-anchored (GetPoint). Names may report a MORPHEUS path when SetFont is stubbed — do not fail if the stub ignores SetFont. Existing `1-0` pins stay green. No `rubber` / `ordained`. Isolation wrap stays.

`lua tests/test_fighter_card.lua` exit 0.

Report `docs/reformation/vestments/briefs/B4-E-fightercard-dock-report.md` + diff. POLISH:CANDIDATE.
