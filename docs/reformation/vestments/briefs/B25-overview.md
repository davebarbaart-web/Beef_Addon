# Batch 25 — Selected Recommend + Decree empty Show + Records ESC + HUD Refresh font

**Cited:** Bible §10.2 / §18.1 Recommend; §14.1 Decree Quiet; wiki ESC `UISpecialFrames` (no `IG_CHARACTER_INFO_*`); §19.3 stock Morpheus. License 4 stock only. No new codec kinds. `SaveNote` nil. No SUMMON. No confession fan-out. No GuildPromote. No live HUD health. No `UnitIsDead`. No custom media. No deputy (#5). One Console leftover this batch.

| Lane | Exclusive | Scope |
|------|-----------|--------|
| B25-A | `UI/Console.lua`, `tests/test_console.lua` | Store `namedOpponent` only when Recommend did not already have a selected pair. Nest pins (200-local). |
| B25-B | `UI/Decree.lua`, `tests/test_decree_ui.lua` | `Show()` with no line still `ensureFrame` then Hide. Quiet silent. |
| B25-C | `UI/RecordsBook.lua`, `tests/test_records.lua` | `Init` early-return `rememberSpecial`. PAGE_TITLES stay 9. |
| B25-D | `UI/Hud.lua`, `tests/test_hud.lua` | `applyNameFont` on Refresh when the card is shown. `health` nil. Gates stay. |
| B25-INT | ledger + install | No glue unless a review Important requires it. |

**Gate W stays OPEN. Gate V stays OPEN. Do not claim POLISH:PASS.**
