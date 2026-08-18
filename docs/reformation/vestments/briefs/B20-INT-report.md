# B20-INT — Batch 20 integrator (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Bible §9 / §13.4 / §18.1 confession desk; §19.3 stock Morpheus; wiki ESC `UISpecialFrames`; license 4. B20-A/B/C/D Spec PASS.

No glue. Exclusive sources unopened after review. Confession rows click-select; mute `"  called"`. Records page titles and fighter-card names use `Fonts\\MORPHEUS.ttf`. Small-toast ESC advances one queued toast. No new TOC files. No Pope name. Walk boxes untouched. No commit. **Gate W is not closed. Gate V is not closed. POLISH:PASS is not claimed. V1 / MVP is not complete.**

## Verification

```bash
lua tests/test_console.lua        # 1514 passed, 0 failed
lua tests/test_records.lua        # 425 passed, 0 failed
lua tests/test_fighter_card.lua   # 486 passed, 0 failed
lua tests/test_ui.lua             # 455 passed, 0 failed
lua tests/test_wire_glue.lua      # 540 passed, 0 failed
lua tests/run.lua                 # 11792 passed, 0 failed
```

TOC `## Interface: 20506`. Installed `rsync -a --delete` → Anniversary `Interface/AddOns/ChurchOfBeef`. Never WTF/.

## Concerns

- Presence still member-filters during the login seed (petitions only fail-open).
- Recommend `namedOpponent` still not painted on the Gora desk.
- Desk `after()` still double-cues with Proclaim.
- Knighting CONSEQUENCE can still paint lastPair (B9-E persist; B19-C gated RITE only).
- `interruptShowing` can still present a queued row before an interrupting Push lands.
- Client `/reload` and two-client walk not run.

**Gate W stays OPEN. Gate V stays OPEN.**
