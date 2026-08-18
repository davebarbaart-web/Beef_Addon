# Batch 29 — Console Hide remount + Decree OnHide wipe + card Show OnHide + Proclaim font

**Cited:** Wiki ESC `UISpecialFrames` / UIHANDLER OnHide (do **not** PlaySound `IG_CHARACTER_INFO_*`); Law 6 Quiet leftover paint; Bible §19.3 stock Morpheus. License 4 stock only. No new codec kinds. `SaveNote` nil. No SUMMON. No confession fan-out. No GuildPromote. No live HUD health. No `UnitIsDead`. No custom media. No deputy (#5). One Console leftover this batch.

| Lane | Exclusive | Scope |
|------|-----------|--------|
| B29-A | `UI/Console.lua`, `tests/test_console.lua` | `Hide` remounts `rememberSpecial` (Toggle-hide). Nest pins (200-local). |
| B29-B | `UI/Decree.lua`, `tests/test_decree_ui.lua` | Banner OnHide wipePaints when there is no line. Quiet silent. |
| B29-C | `UI/FighterCard.lua`, `tests/test_fighter_card.lua` | `Show` / `Refresh` restore missing OnHide. Do not replace an existing script. |
| B29-D | `UI/Toasts.lua`, `tests/test_ui.lua` | `Proclaim` re-applies `applyHeadlineFont`. Nest in `runB12D()`. |
| B29-INT | ledger + install | No glue unless a review Important requires it. |

**Gate W stays OPEN. Gate V stays OPEN. Do not claim POLISH:PASS.**
