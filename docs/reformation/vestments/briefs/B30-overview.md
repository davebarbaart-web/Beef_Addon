# Batch 30 — Decree remount OnHide + card Hide OnHide + Records paint font + dock Hide remount

**Cited:** Wiki ESC `UISpecialFrames` / UIHANDLER OnHide (do **not** PlaySound `IG_CHARACTER_INFO_*`); Law 6 Quiet leftover paint; Bible §19.3 stock Morpheus. License 4 stock only. No new codec kinds. `SaveNote` nil. No SUMMON. No confession fan-out. No GuildPromote. No live HUD health. No `UnitIsDead`. No custom media. No deputy (#5). No Records category remap (#3). No Console leftover this batch.

| Lane | Exclusive | Scope |
|------|-----------|--------|
| B30-A | `UI/Decree.lua`, `tests/test_decree_ui.lua` | `ensureFrame` early-return remounts a missing OnHide. Nest after `runB29B()`. |
| B30-B | `UI/FighterCard.lua`, `tests/test_fighter_card.lua` | `Hide` remounts a missing OnHide. Nest after `runB29C()`. |
| B30-C | `UI/RecordsBook.lua`, `tests/test_records.lua` | `paint()` re-applies `PAGE_TITLE_FONT` on `PageTitle`. Nest after `runB28C()`. |
| B30-D | `UI/ConsoleDock.lua`, `tests/test_console_dock.lua` | `Hide` remounts `rememberSpecial`. Nest after `runB27D()`. |
| B30-INT | ledger + install | No glue unless a review Important requires it. |

**Gate W stays OPEN. Gate V stays OPEN. Do not claim POLISH:PASS.**
