# Batch 20 — Confession click + Morpheus paths + toast pump

**Cited:** Bible §9 / §13.4 / §18.1 confession desk; §19.3 stock Morpheus; wiki ESC `UISpecialFrames`; license 4 stock only. No new codec kinds. `SaveNote` nil. No SUMMON. No confession fan-out. No GuildPromote. No live HUD health. No custom media.

| Lane | Exclusive | Scope |
|------|-----------|--------|
| B20-A | `UI/Console.lua`, `tests/test_console.lua` | Confession rows click-select; mute `called` token. No new Dismiss plate. Nest pins (200-local). |
| B20-B | `UI/RecordsBook.lua`, `tests/test_records.lua` | `PAGE_TITLE_FONT` `Fonts\\MORPHEUS.ttf`. PAGE_TITLES stay 9. |
| B20-C | `UI/FighterCard.lua`, `tests/test_fighter_card.lua` | `NAME_FONT` `Fonts\\MORPHEUS.ttf`. Keep `1-0`. No drag persist. |
| B20-D | `UI/Toasts.lua`, `tests/test_ui.lua` | Small-toast OnHide `bumpGen` then `pump` so ESC advances the queue. Nest in `runB12D()`. |
| B20-INT | ledger + install | No glue unless a review Important requires it. |

**Gate W stays OPEN. Gate V stays OPEN. Do not claim POLISH:PASS.**
