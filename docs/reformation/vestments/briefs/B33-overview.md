# Batch 33 — dest trim + Presence here dim + Markers keep-last + BeefNet dest refuse

**Cited:** License 2 / §13.1 whisper dest; Bible §18.1 Presence is who is here; §8 current-subject marks; Anniversary `C_ChatInfo.SendAddonMessage(..., WHISPER, target)`. License 4 Console stays plain. One Console leftover. `SaveNote` nil. No SUMMON. No fan-out. No `UnitIsDead`. No dest on Codec. No new Presence copy ("offline"). No roman HUD numerals.

| Lane | Exclusive | Scope |
|------|-----------|--------|
| B33-A | `UI/Inputs.lua`, `tests/test_inputs.lua` | `SetInputTarget` trims dest; empty after trim is no target. Nest after `runB23D()`. |
| B33-B | `UI/Console.lua`, `tests/test_console.lua` | Presence `here == false` stock `SetAlpha` (~0.45). Nest after `runB32B()`. |
| B33-C | `UI/Markers.lua`, `tests/test_markers.lua` | Gate `refuse` keeps remembered units. After B32-D block. |
| B33-D | `Net/BeefNet.lua`, `tests/test_net_v2.lua` | Trim / refuse whitespace dest. Do not edit Codec. |
| B33-INT | ledger + install | No glue unless a review Important requires it. |

**Gate W stays OPEN. Gate V stays OPEN. Do not claim POLISH:PASS.**
