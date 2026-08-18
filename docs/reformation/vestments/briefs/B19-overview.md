# Batch 19 — Seed petitions + toast ESC + lastPair rite gate + Morpheus path

**Cited:** Bible §10.2 present pool; §10.7 HUD persist through Gora verdict; §19.4 / wiki ESC `UISpecialFrames`; §19.3 stock Morpheus; license 4 stock only. No new codec kinds. `SaveNote` nil. No SUMMON. No GuildPromote. No live HUD health. No `UnitIsDead`. No custom media. No deputy (#5).

| Lane | Exclusive | Scope |
|------|-----------|--------|
| B19-A | `UI/Console.lua`, `tests/test_console.lua` | `presentCharacterIds` fail-opens Store characters while Roster is not `IsComplete`. Complete snapshot still filters to members. Nest pins (200-local). |
| B19-B | `UI/Toasts.lua`, `tests/test_ui.lua` | `ChurchOfBeefToast` on `UISpecialFrames`. OnHide syncs showing. No `PlaySound` on ESC. Nest in `runB12D()`. |
| B19-C | `UI/Hud.lua`, `tests/test_hud.lua` | `displayPair` does not paint `lastPair` during a non-Gora RITE. Gora CONSEQUENCE / ASSEMBLY persist stay. `health` nil. |
| B19-D | `UI/Decree.lua`, `tests/test_decree_ui.lua` | Line font `Fonts\\MORPHEUS.ttf` (match Toasts). Quiet silent. No deputy. |
| B19-INT | ledger + install | No glue unless a review Important requires it. |

**Gate W stays OPEN. Gate V stays OPEN. Do not claim POLISH:PASS.**
