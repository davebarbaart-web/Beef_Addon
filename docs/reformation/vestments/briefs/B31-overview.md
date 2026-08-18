# Batch 31 — QUIET Recommend drop + Decree Hide OnHide + shell Show OnHide + Records title font

**Cited:** Bible §20 QUIET has no event pair; B26-A selection/recommend dies with the event; Wiki ESC OnHide (do **not** PlaySound `IG_CHARACTER_INFO_*`); Bible §19.3 stock Morpheus. License 4 stock only. One Console leftover this batch. `SaveNote` nil. No SUMMON. No confession fan-out. No GuildPromote. No live HUD health. No `UnitIsDead`. No custom media. No deputy (#5). No Records category remap (#3).

| Lane | Exclusive | Scope |
|------|-----------|--------|
| B31-A | `UI/Console.lua`, `tests/test_console.lua` | Refresh in QUIET nils `lastRecommendation` only. Update the B24-A leftover pin. Nest after `runB29A()`. |
| B31-B | `UI/Decree.lua`, `tests/test_decree_ui.lua` | `Hide` remounts a missing OnHide. Nest after `runB30A()`. |
| B31-C | `UI/MainFrame.lua`, `tests/test_ui.lua` | `Show` remounts a missing OnHide. Nest in `runB12D()`. |
| B31-D | `UI/RecordsBook.lua`, `tests/test_records.lua` | `paint()` re-applies `PAGE_TITLE_FONT` on `TitleText`. Nest after `runB30C()`. |
| B31-INT | ledger + install | No glue unless a review Important requires it. |

**Gate W stays OPEN. Gate V stays OPEN. Do not claim POLISH:PASS.**
