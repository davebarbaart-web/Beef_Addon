# B11-INT — Batch 11 integrator (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Bible §20.3, §13.1, §10.6, §10.7, §18.1; license 2. B11-A/B/C Spec PASS.

No new TOC files. Exclusive sources unopened after review. No Pope name. Walk boxes untouched. No commit. **Gate W is not closed. Gate V is not closed. POLISH:PASS is not claimed. V1 / MVP is not complete.**

## Glue

`stateFields` overlays live / last pair onto STATE subjects only when `state` is RITE or CONSEQUENCE (`Runtime:Restore` refuses fighters in ASSEMBLY / QUIET). Last pair may overlay after a ruling in those states. Toggle-off still omits favor but keeps the Restore-safe pair. ASSEMBLY + Sanction without OpenRite sends STATE with no fighters. Post-Continue ASSEMBLY does not overlay last pair.

## Verification

```bash
lua tests/test_net_snapshot.lua   # 610 passed, 0 failed
lua tests/test_hud.lua            # 624 passed, 0 failed
lua tests/test_console.lua        # 1175 passed, 0 failed
lua tests/test_wire_glue.lua      # 467 passed, 0 failed
lua tests/run.lua                 # 10257 passed, 0 failed
```

TOC `## Interface: 20506`. Anniversary `EnableMouseWheel` is SimpleScriptRegionAPI.

## Concerns

- B11-A ASSEMBLY live overlay encodes but Restore refuses fighters (Runtime law). Sanction-before-OpenRite catch-up still needs Open Gora (B11-C).
- Congregation leftover RITE after a remote ruling can still click plates (accepted).
- Console wheel offset is not pinned (harness scroll getters are noops).
- Client `/reload` and two-client walk not run.

**Gate W stays OPEN. Gate V stays OPEN.**
