# Batch 22 — Recommend names + HUD Morpheus + player resolve + dock ESC

**Cited:** Bible §10.2 / §18.1 Recommend + dock; §10.7 / §19.3 HUD names; wiki ESC `UISpecialFrames`; Anniversary `SetFont` / `SetRaidTarget` / `UnitName` (20506). License 4 stock only. No new codec kinds. `SaveNote` nil. No SUMMON. No confession fan-out. No GuildPromote. No live HUD health. No `UnitIsDead`. No custom media. No deputy (#5). One Console leftover this batch.

| Lane | Exclusive | Scope |
|------|-----------|--------|
| B22-A | `UI/Console.lua`, `tests/test_console.lua` | Recommendation line appends mute `"  names  "` when `Gora:Recommend.namedOpponent`. Nest pins (200-local). |
| B22-B | `UI/Hud.lua`, `tests/test_hud.lua` | Fighter name labels `Fonts\\MORPHEUS.ttf`. Titles stay GameFont. `health` nil. |
| B22-C | `UI/Markers.lua`, `tests/test_markers.lua` | `resolveUnit` player token does not require `GetNumGroupMembers`. Scan still type-guards it. |
| B22-D | `UI/ConsoleDock.lua`, `tests/test_console_dock.lua` | `ChurchOfBeefConsoleDock` on `UISpecialFrames`. No `PlaySound` on ESC. |
| B22-INT | ledger + install | No glue unless a review Important requires it. |

Parked (later Console batch): desk `after()` double cue.

**Gate W stays OPEN. Gate V stays OPEN. Do not claim POLISH:PASS.**
