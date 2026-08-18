# Batch 23 — Theater owns cues + dock ESC stay + toast special re-register + empty player omit

**Cited:** Bible §19.4 five cues (theater owns them); §18.1 dock; wiki ESC `UISpecialFrames` (do **not** PlaySound `IG_CHARACTER_INFO_*`); Anniversary `UnitName` (20506). License 4 stock only. No new codec kinds. `SaveNote` nil. No SUMMON. No confession fan-out. No GuildPromote. No live HUD health. No `UnitIsDead`. No custom media. No deputy (#5). One Console leftover this batch.

| Lane | Exclusive | Scope |
|------|-----------|--------|
| B23-A | `UI/Console.lua`, `tests/test_console.lua` | `playCue` no-ops when `Toasts.Proclaim` exists. Isolated Sound pins stay (no Toasts). Nest pins (200-local). |
| B23-B | `UI/ConsoleDock.lua`, `tests/test_console_dock.lua` | Widget OnHide syncs `lastView` and remembers dismiss while the event is live. Refresh does not re-show. |
| B23-C | `UI/Toasts.lua`, `tests/test_ui.lua` | `Init` early-return still `rememberSpecial("ChurchOfBeefToast")`. Nest in `runB12D()`. |
| B23-D | `UI/Inputs.lua`, `tests/test_inputs.lua` | Empty / whitespace `UnitName("player")` omits opponent. Nest in `runB18A()`. |
| B23-INT | ledger + install | No glue unless a review Important requires it. |

Parked (later Console batch): `lastRecommendation` lifetime across EndEvent; selected-pair inherit of Core `namedOpponent`.

**Gate W stays OPEN. Gate V stays OPEN. Do not claim POLISH:PASS.**
