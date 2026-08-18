# Batch 26 — Selection dies with the event + toast OnHide remount + Quiet Decree wipe + dock ESC remount

**Cited:** Bible §18.1 / §20 event lifetime; wiki ESC `UISpecialFrames` (no `IG_CHARACTER_INFO_*`); Law 6 Quiet leftover paint. License 4 stock only. No new codec kinds. `SaveNote` nil. No SUMMON. No confession fan-out. No GuildPromote. No live HUD health. No `UnitIsDead`. No custom media. No deputy (#5). One Console leftover this batch.

| Lane | Exclusive | Scope |
|------|-----------|--------|
| B26-A | `UI/Console.lua`, `tests/test_console.lua` | Successful `StartEvent` / `EndEvent` also clear `selectedFighterA` / `selectedFighterB`. Nest pins (200-local). |
| B26-B | `UI/Toasts.lua`, `tests/test_ui.lua` | Init early-return restores missing OnHide; do not replace an existing script. Nest in `runB12D()`. |
| B26-C | `UI/Decree.lua`, `tests/test_decree_ui.lua` | Empty `Show()` blanks leftover Line/Flavor then Hide. Quiet silent. |
| B26-D | `UI/ConsoleDock.lua`, `tests/test_console_dock.lua` | `Init` remounts `rememberSpecial` when the frame already exists. |
| B26-INT | ledger + install | No glue unless a review Important requires it. |

**Gate W stays OPEN. Gate V stays OPEN. Do not claim POLISH:PASS.**
