# Batch 21 — Presence seed + lastPair CONSEQUENCE + toast interrupt + player fail-closed

**Cited:** Bible §10.2 present pool; §10.7 HUD persist through a **Gora** verdict; wiki ESC `UISpecialFrames`; Anniversary `UnitName` (20506). License 4 stock only. No new codec kinds. `SaveNote` nil. No SUMMON. No confession fan-out. No GuildPromote. No live HUD health. No `UnitIsDead`. No custom media. No deputy (#5). One Console leftover this batch.

| Lane | Exclusive | Scope |
|------|-----------|--------|
| B21-A | `UI/Console.lua`, `tests/test_console.lua` | `GetPresence` fail-opens Store characters while Roster is not complete (mirror `presentCharacterIds`). Nest pins (200-local). |
| B21-B | `UI/Hud.lua`, `tests/test_hud.lua` | `displayPair` does not paint `lastPair` during a non-Gora CONSEQUENCE. Gora CONSEQUENCE / ASSEMBLY persist stay. `health` nil. |
| B21-C | `UI/Toasts.lua`, `tests/test_ui.lua` | Small-toast OnHide idle-returns when `showing` is already nil so `interruptShowing` does not pump a queued row. Nest in `runB12D()`. |
| B21-D | `UI/Inputs.lua`, `tests/test_inputs.lua` | `petitionOpponent` omits opponent when `UnitName("player")` pcall fails. Nest in `runB18A()`. |
| B21-INT | ledger + install | No glue unless a review Important requires it. |

Parked (later Console batch): Recommend `namedOpponent` paint (`"  names  "`). Desk `after()` double cue.

**Gate W stays OPEN. Gate V stays OPEN. Do not claim POLISH:PASS.**
