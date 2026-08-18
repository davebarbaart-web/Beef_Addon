# V-D — HUD iron/parchment dress (after V-B)

**Exclusive files:**
- `addon/ChurchOfBeef/UI/Hud.lua`
- `tests/test_hud.lua`

**Do not edit** Toasts, Console, Decree, Records, Gora, Net, bootstrap, TOC. Do not commit. No custom media. No faction icons.

## Law

Bible §10.7, §19.3. Batch 2 §D **dress only**. W-F favor contract stays: Pope split from Gora; congregation from `SetBroadcastFavor`; `health` **nil** (A01); plate `PickFavor` unchanged.

License 4: stock textures/fonts. See `docs/reformation/vestments/briefs/V-stock-textures.md`.

- Keep `Interface\\TargetingFrame\\UI-StatusBar` for favor halves.
- Frame: iron/parchment via QuestBG `pcall` + `WHITE8X8` / tooltip border. Height **≤ 12%** of `UIParent` (if unknown, keep near current height + favor row; do not grow into a toast).
- Center: **not** Horde/Alliance. Use `Interface\\Buttons\\UI-EmptySlot-White` or `Interface\\Minimap\\MiniMap-TrackingBorder`, or no crest (VS + FAVOR is enough).
- Class color on **names** (already). Do not invent live health bars. Decorative mute rails tinted with `nameColor` are allowed if they do not read as live HP (no `UnitHealth`, no percent health).
- Head-to-head line stays. Title format remains Church title, not “Beef Paladin”.
- No `OnUpdate`. No new sound. Quiet still hides the HUD.

## Tests

Keep W-F favor / PickFavor / health nil / no nameplates pins. Add: no `Interface\\PvPFrame\\` / `PVP-Banner` / `UI-PVP-Horde` / `UI-PVP-Alliance` in source; height budget pin if you can read frame height; GetView still copies. Isolation under `if standalone then`.

## Verify

`lua tests/test_hud.lua` exit 0.

Report `docs/reformation/vestments/briefs/V-D-hud-report.md` + `V-D-hud.diff`. POLISH:CANDIDATE. Do not sign.
