# B16-INT — Batch 16 integrator (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Bible §8 / §5 elevation; §10.6 favor; §18.5 Inputs; §8 marks. B16-A/B/C/D Spec PASS.

No glue. Exclusive sources unopened after review. `ElevateToLord` refuses rank > 4. Inputs drag is a 12px TitleBar. Congregation favor plates send only during a Gora RITE. Grouped self-mark uses the `"player"` token. No new TOC files. No Pope name. Walk boxes untouched. No commit. **Gate W is not closed. Gate V is not closed. POLISH:PASS is not claimed. V1 / MVP is not complete.**

## Verification

```bash
lua tests/test_knighting.lua      # 419 passed, 0 failed
lua tests/test_inputs.lua         # 419 passed, 0 failed
lua tests/test_hud.lua            # 646 passed, 0 failed
lua tests/test_markers.lua        # 319 passed, 0 failed
lua tests/test_wire_glue.lua      # 540 passed, 0 failed
lua tests/run.lua                 # 11197 passed, 0 failed
```

TOC `## Interface: 20506`. Installed `rsync -a --delete` → Anniversary `Interface/AddOns/ChurchOfBeef`. Never WTF/.

## Concerns

- Confess box still overlaps the lower 4px of the Inputs TitleBar (HEIGHT stayed 72).
- HUD may still paint leftover fighters during a non-Gora RITE (send gate only).
- `Store:SetRank` can still write rank 4 onto a Butcher or Council.
- Client `/reload` and two-client walk not run.

**Gate W stays OPEN. Gate V stays OPEN.**
