# Batch 40 — Console OnHide + Records Show + dock Refresh + already-hidden persist

**Cited:** Wiki `UISpecialFrames` (named frame; ESC). License 4 Console stays plain. One Console leftover. `SaveNote` nil. No SUMMON. No dest on Codec. No `UnitIsDead`. No Records remap. No `PlaySound`. Do not refuse empty OpenRite Gora (B39-A keep).

| Lane | Exclusive | Scope |
|------|-----------|--------|
| B40-A | `UI/Console.lua`, `tests/test_console.lua` | Hide remounts missing OnHide. Nest after `runB39A()`. |
| B40-B | `UI/RecordsBook.lua`, `tests/test_records.lua` | Show remounts missing OnHide. Nest after `runB38D()`. |
| B40-C | `UI/ConsoleDock.lua`, `tests/test_console_dock.lua` | Refresh remounts missing OnHide. Nest after `runB39D()`. |
| B40-D | `UI/MainFrame.lua`, `tests/test_ui.lua` | Already-hidden Hide still writes `shown = false`. Nest inside `runB12D()`. |
| B40-INT | ledger + install | No glue unless a review Important requires it. |

**Gate W stays OPEN. Gate V stays OPEN. Do not claim POLISH:PASS.**
