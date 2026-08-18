# Batch 41 — Console Refresh + Records/Dock Init OnHide + toast Init proclaim list

**Cited:** Wiki `UISpecialFrames` (named frame; ESC). License 4 Console stays plain. One Console leftover. `SaveNote` nil. No SUMMON. No dest on Codec. No `UnitIsDead`. No Records remap. No `PlaySound`. Do not refuse empty OpenRite Gora (B39-A keep).

| Lane | Exclusive | Scope |
|------|-----------|--------|
| B41-A | `UI/Console.lua`, `tests/test_console.lua` | Refresh remounts missing OnHide. Nest after `runB40A()`. |
| B41-B | `UI/RecordsBook.lua`, `tests/test_records.lua` | Init remounts missing OnHide. Nest after `runB40B()`. |
| B41-C | `UI/ConsoleDock.lua`, `tests/test_console_dock.lua` | Init remounts missing OnHide. Nest after `runB40C()`. |
| B41-D | `UI/Toasts.lua`, `tests/test_ui.lua` | Init remounts `ChurchOfBeefProclaim`. Nest inside `runB12D()`. |
| B41-INT | ledger + install | No glue unless a review Important requires it. |

**Gate W stays OPEN. Gate V stays OPEN. Do not claim POLISH:PASS.**
