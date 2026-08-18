# Batch 38 — Dismiss pair + Gora-only last overlay + Quiet mark sweep + Records OnHide

**Cited:** Bible §18.1 leftover highlight; §10.7 / B32 leftover last pair is Gora-only; §8 current-subject marks; wiki `UISpecialFrames`. Anniversary `SetRaidTarget(target, 0)` clears. License 4 Console stays plain. One Console leftover. `SaveNote` nil. No SUMMON. No dest on Codec. No `UnitIsDead`. No Records remap. No `PlaySound`.

| Lane | Exclusive | Scope |
|------|-----------|--------|
| B38-A | `UI/Console.lua`, `tests/test_console.lua` | Dismiss drops leftover pair when the dismissed id is in it. Nest after `runB37A()`. |
| B38-B | `Net/Snapshot.lua`, `tests/test_net_snapshot.lua` | Last-pair overlay only when `riteType == "Gora"`. After B14-A block. |
| B38-C | `UI/Markers.lua`, `tests/test_markers.lua` | Quiet `Forget` sweeps leftover last units. After B35-C block. |
| B38-D | `UI/RecordsBook.lua`, `tests/test_records.lua` | Existing-frame Hide remounts missing OnHide. Nest after `runB31D()`. |
| B38-INT | glue + ledger + install | `afterEndEvent` → `Markers:Forget` once C lands. |

**Gate W stays OPEN. Gate V stays OPEN. Do not claim POLISH:PASS.**
