# Batch 34 — HUD re-tint + leftover Presence alpha + Target keep-last + SendSnapshot dest

**Cited:** Law 10 / §19.3 class color on HUD names; Bible §18.1 Presence; §8 current-subject marks; License 2 / §13.1 whisper dest. Anniversary `FontInstance:SetTextColor`, `Region:SetAlpha`, `TargetUnit`, `C_ChatInfo.SendAddonMessage(..., WHISPER, target)`. License 4 Console stays plain. One Console leftover. `SaveNote` nil. No SUMMON. No fan-out. No `UnitIsDead`. No dest on Codec. No new Presence copy. No roman HUD numerals. No `UnitHealth`. No defense `SetWidth` (same HUD pair).

| Lane | Exclusive | Scope |
|------|-----------|--------|
| B34-A | `UI/Hud.lua`, `tests/test_hud.lua` | After shown `applyNameFont`, restore class tint. Nest after `runB32A()`. |
| B34-B | `UI/Console.lua`, `tests/test_console.lua` | Hidden leftover Presence buttons `SetAlpha(1)`. Nest after `runB33B()`. |
| B34-C | `UI/Markers.lua`, `tests/test_markers.lua` | Successful Target keeps omitted last units. After B33-C block. |
| B34-D | `Net/BeefNet.lua`, `tests/test_net_v2.lua` | Early `destName` on `SendSnapshot` after Pope gate. After B33-D block. |
| B34-INT | ledger + install | No glue unless a review Important requires it. |

**Gate W stays OPEN. Gate V stays OPEN. Do not claim POLISH:PASS.**
