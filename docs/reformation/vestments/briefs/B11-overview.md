# Batch 11 — Catch-up last pair + leftover picks + console wheel

**Cited:** Bible §13.1 star, §20.3 catch-up, §10.6 favor, §10.7 persist through verdict, §18.1 glanceable console. License 2 (favor on STATE/SNAPSHOT only while the Pope toggle is on). No new codec kinds. `SaveNote` nil. No SUMMON. No post-show clipboard. No custom media. No `UnitHealth`.

| Lane | Exclusive | Scope |
|------|-----------|--------|
| B11-A | `Net/Snapshot.lua`, `tests/test_net_snapshot.lua` | `BuildResponse` overlays live / last pair (and toggle-gated favor) |
| B11-B | `UI/Hud.lua`, `tests/test_hud.lua` | Plate clicks never use lastPair; Pope clicks need a live `GetSanctioned` |
| B11-C | `UI/Console.lua`, `tests/test_console.lua` | Desk `EnableMouseWheel`; Open Gora subjects fall back to the Gora pair |
| B11-INT | `ChurchOfBeef.lua`, `tests/test_wire_glue.lua` | Last-pair STATE overlay is CONSEQUENCE-only; live pair overlays even with favor off |

Integrator (after reviews): exclusive sources unopened; harness green; reinstall Anniversary AddOns. **Gate W stays OPEN. Gate V stays OPEN. Do not claim POLISH:PASS.**
