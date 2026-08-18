# B25-INT — Batch 25 integrator (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Bible §10.2 / §18.1 Recommend; §14.1 Decree Quiet; wiki ESC `UISpecialFrames`; §19.3 stock Morpheus. B25-A/B/C/D Spec PASS.

No glue. Exclusive sources unopened after review. Selected-pair Recommend does not inherit Core `namedOpponent`. Empty Decree `Show()` registers ESC then hides. Records Init remounts ESC. HUD re-applies Morpheus on a shown Refresh. No new TOC files. No Pope name. Walk boxes untouched. No commit. **Gate W is not closed. Gate V is not closed. POLISH:PASS is not claimed. V1 / MVP is not complete.**

## Verification

```bash
lua tests/test_console.lua        # 1841 passed, 0 failed
lua tests/test_decree_ui.lua      # 280 passed, 0 failed
lua tests/test_records.lua        # 453 passed, 0 failed
lua tests/test_hud.lua            # 747 passed, 0 failed
lua tests/test_wire_glue.lua      # 540 passed, 0 failed
lua tests/run.lua                 # 12500 passed, 0 failed
```

TOC `## Interface: 20506`. Installed `rsync -a --delete` → Anniversary `Interface/AddOns/ChurchOfBeef`. Never WTF/.

## Concerns

- Successful Start/End still leave `selectedFighterA` / `selectedFighterB`, so a later Recommend can suppress `"  names  "` unless the desk is cleared.
- Client `/reload` and two-client walk not run.

**Gate W stays OPEN. Gate V stays OPEN.**
