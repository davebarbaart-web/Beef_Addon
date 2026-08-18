# Batch 28 — Console Show remount + Decree Refresh + Records Hide remount + card OnHide

**Cited:** Wiki ESC `UISpecialFrames` / UIHANDLER OnHide (do **not** PlaySound `IG_CHARACTER_INFO_*`); Law 6 Quiet leftover paint. License 4 stock only. No new codec kinds. `SaveNote` nil. No SUMMON. No confession fan-out. No GuildPromote. No live HUD health. No `UnitIsDead`. No custom media. No deputy (#5). No Clear Decree chrome. One Console leftover this batch.

| Lane | Exclusive | Scope |
|------|-----------|--------|
| B28-A | `UI/Console.lua`, `tests/test_console.lua` | `Show` / `Refresh` remount `rememberSpecial`. Nest pins (200-local). |
| B28-B | `UI/Decree.lua`, `tests/test_decree_ui.lua` | `Refresh()` wipe+Hide when there is no line. Quiet silent. |
| B28-C | `UI/RecordsBook.lua`, `tests/test_records.lua` | `Hide()` remounts `rememberSpecial`. PAGE_TITLES stay 9. |
| B28-D | `UI/FighterCard.lua`, `tests/test_fighter_card.lua` | Init restores missing OnHide; do not replace an existing script. |
| B28-INT | glue + ledger + install | Wrap `Decree:Clear` → `DecreeBanner:Refresh` if B28-B lands. |

**Gate W stays OPEN. Gate V stays OPEN. Do not claim POLISH:PASS.**
