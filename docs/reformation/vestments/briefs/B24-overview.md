# Batch 24 — Recommendation dies with the event + dock per-event dismiss + ESC re-register

**Cited:** Bible §18.1 / §20 event lifetime; wiki ESC `UISpecialFrames` (do **not** PlaySound `IG_CHARACTER_INFO_*`). License 4 stock only. No new codec kinds. `SaveNote` nil. No SUMMON. No confession fan-out. No GuildPromote. No live HUD health. No `UnitIsDead`. No custom media. No deputy (#5). One Console leftover this batch.

| Lane | Exclusive | Scope |
|------|-----------|--------|
| B24-A | `UI/Console.lua`, `tests/test_console.lua` | `lastRecommendation = nil` on successful `StartEvent` / `EndEvent`. Nest pins (200-local). |
| B24-B | `UI/ConsoleDock.lua`, `tests/test_console_dock.lua` | Dismiss is keyed to Runtime `eventId`. A new event shows the dock again. |
| B24-C | `UI/MainFrame.lua`, `tests/test_ui.lua` | `UI:Init` early-return still `rememberSpecial`. Nest in `runB12D()`. |
| B24-D | `UI/Decree.lua`, `tests/test_decree_ui.lua` | `ensureFrame` early-return still `rememberSpecial`. Quiet silent. |
| B24-INT | ledger + install | No glue unless a review Important requires it. |

Parked (later Console batch): selected-pair inherit of Core `namedOpponent`.

**Gate W stays OPEN. Gate V stays OPEN. Do not claim POLISH:PASS.**
