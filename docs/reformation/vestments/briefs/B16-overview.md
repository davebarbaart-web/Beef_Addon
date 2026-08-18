# Batch 16 — Elevation refuse + drag handle + Gora-only picks + player mark

**Cited:** Bible §8 / §5 elevation; §10.6 favor; §18.5 Inputs; license 4 stock only. No new codec kinds. `SaveNote` nil. No SUMMON. No GuildPromote. No live HUD health. No custom media.

| Lane | Exclusive | Scope |
|------|-----------|--------|
| B16-A | `Core/Knighting.lua`, `tests/test_knighting.lua` | `ElevateToLord` refuses rank ≥ 5 (Butcher / Council). Re-elevate of a Lord stays. No GuildPromote. |
| B16-B | `UI/Inputs.lua`, `tests/test_inputs.lua` | Thin TitleBar drag handle so buttons do not eat drag. HEIGHT 72. Persist still `ui.inputs`. ESC ClearFocus stays. Not on `UISpecialFrames`. |
| B16-C | `UI/Hud.lua`, `tests/test_hud.lua` | Congregation `pickPair` requires `riteType == "Gora"` (plus RITE). Knighting leftover fighters do not SendFavor. Pope still live `GetSanctioned` only. |
| B16-D | `UI/Markers.lua`, `tests/test_markers.lua` | `resolveUnit` tries `"player"` when the name is the local player. Still Event + Pope + grouped. `SetRaidTarget` UnitToken. |
| B16-INT | ledger + install | No glue unless a review Important requires it. |

**Gate W stays OPEN. Gate V stays OPEN. Do not claim POLISH:PASS.**
