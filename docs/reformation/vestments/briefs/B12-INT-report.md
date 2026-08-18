# B12-INT — Batch 12 integrator (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Bible §20, §10.7, §19.3. B12-A/B/C/D Spec PASS.

No new TOC files. Exclusive sources unopened after review. No Pope name. Walk boxes untouched. No commit. **Gate W is not closed. Gate V is not closed. POLISH:PASS is not claimed. V1 / MVP is not complete.**

## Glue

Live sanctioned pair overlays STATE subjects in ASSEMBLY / RITE / CONSEQUENCE. Last pair still overlays only RITE / CONSEQUENCE. Post-Continue ASSEMBLY does not overlay last. Toggle-off still omits favor. Inbound ASSEMBLY + fighters Restores.

## Verification

```bash
lua tests/test_runtime.lua        # 688 passed, 0 failed
lua tests/test_console.lua        # 1232 passed, 0 failed
lua tests/test_fighter_card.lua   # 448 passed, 0 failed
lua tests/test_ui.lua             # 345 passed, 0 failed
lua tests/test_wire_glue.lua      # 472 passed, 0 failed
lua tests/run.lua                 # 10387 passed, 0 failed
```

TOC `## Interface: 20506`. `UISpecialFrames` is Classic FrameXML (wiki: Make frames closable with the Escape key). No `PlaySound` on ESC.

## Concerns

- ESC on the fighter card calls widget `Hide()`, so `lastView.shown` can stay true until Refresh; lastPair still lasts until QUIET.
- Proclaim HideAll double-bumps `theaterGen`.
- Client `/reload` and two-client walk not run.

**Gate W stays OPEN. Gate V stays OPEN.**
