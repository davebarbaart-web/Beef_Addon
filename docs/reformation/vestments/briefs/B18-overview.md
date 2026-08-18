# Batch 18 — Inputs handle + challenge desk pin + HideAll gen + Clear player

**Cited:** Bible §10.2 / §18.5 Inputs; §18.1 petition desk; §19.4 theater; §8 marks; license 4 stock only. No new codec kinds. `SaveNote` nil. No SUMMON. No GuildPromote. No live HUD health. No custom media. No `UnitIsDead` (not in the Anniversary MCP catalog).

| Lane | Exclusive | Scope |
|------|-----------|--------|
| B18-A | `UI/Inputs.lua`, `tests/test_inputs.lua` | Confess box below the 12px TitleBar. Trim opponent. HEIGHT 72 stays. |
| B18-B | `UI/Console.lua`, `tests/test_console.lua` | Pin petition line `names` + click selects both fighters. Copy stays; do not invent "DEMANDED". Nest pins (200-local). |
| B18-C | `UI/Toasts.lua`, `tests/test_ui.lua` | `HideAll` must not double-bump `theaterGen`. Nest pins in `runB12D()`. |
| B18-D | `UI/Markers.lua`, `tests/test_markers.lua` | Grouped `Clear` of the local name spies `SetRaidTarget("player", 0)`. |
| B18-INT | ledger + install | No glue unless a review Important requires it. |

**Gate W stays OPEN. Gate V stays OPEN. Do not claim POLISH:PASS.**
