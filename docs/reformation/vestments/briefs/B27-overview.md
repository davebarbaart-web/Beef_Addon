# Batch 27 — Console ESC remount + Decree Hide wipe + Quiet-shell OnHide + dock Refresh remount

**Cited:** Wiki ESC `UISpecialFrames` (do **not** PlaySound `IG_CHARACTER_INFO_*`); Law 6 Quiet leftover paint; Bible §18.1 dock. License 4 stock only. No new codec kinds. `SaveNote` nil. No SUMMON. No confession fan-out. No GuildPromote. No live HUD health. No `UnitIsDead`. No custom media. No deputy (#5). One Console leftover this batch.

| Lane | Exclusive | Scope |
|------|-----------|--------|
| B27-A | `UI/Console.lua`, `tests/test_console.lua` | `Init` early-return `rememberSpecial`. Nest pins (200-local). |
| B27-B | `UI/Decree.lua`, `tests/test_decree_ui.lua` | `Hide()` `wipePaint`s when there is no active Decree. Quiet silent. |
| B27-C | `UI/MainFrame.lua`, `tests/test_ui.lua` | `UI:Init` early-return restores missing OnHide; do not replace an existing script. Nest in `runB12D()`. |
| B27-D | `UI/ConsoleDock.lua`, `tests/test_console_dock.lua` | `Refresh` / `Show` remount `rememberSpecial` when the frame exists. B24-B dismiss stays. |
| B27-INT | ledger + install | No glue unless a review Important requires it. |

**Gate W stays OPEN. Gate V stays OPEN. Do not claim POLISH:PASS.**
