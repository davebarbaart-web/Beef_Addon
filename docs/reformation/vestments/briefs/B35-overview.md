# Batch 35 — HUD defense width + Confess trim + Target name keep + shell Hide persist

**Cited:** Bible §10.7 mute defense integer; §13.4 / §9 confession text optional; §8 current-subject marks; §14.2 Quiet shell persist. Anniversary `SetWidth(width)`, `Names.Trim`, `TargetUnit`, `UISpecialFrames` ESC (named frame). License 4 Console stays out this batch. One leftover family each. No roman HUD numerals. No `UnitHealth`. No dest on Codec. No SUMMON. No fan-out. No `SaveNote`. No `PlaySound` on shell Hide.

| Lane | Exclusive | Scope |
|------|-----------|--------|
| B35-A | `UI/Hud.lua`, `tests/test_hud.lua` | Cap `defenseA` / `defenseB` at width 28. Nest after `runB34A()`. |
| B35-B | `UI/Inputs.lua`, `tests/test_inputs.lua` | `Confess` trims text; empty omits `fields.text`, still sends. Nest after `runB33A()`. |
| B35-C | `UI/Markers.lua`, `tests/test_markers.lua` | `keepLastUnits` also copies omitted `nameA` / `nameB`. After B34-C block. |
| B35-D | `UI/MainFrame.lua`, `tests/test_ui.lua` | Existing-frame `Hide` remounts OnHide + `rememberSpecial` (persist teeth). Nest after B31-C inside `runB12D()`. |
| B35-INT | ledger + install | No glue unless a review Important requires it. |

**Gate W stays OPEN. Gate V stays OPEN. Do not claim POLISH:PASS.**
