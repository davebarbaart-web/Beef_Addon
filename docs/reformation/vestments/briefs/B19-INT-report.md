# B19-INT — Batch 19 integrator (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Bible §10.2 present pool; §10.7 HUD persist; wiki ESC `UISpecialFrames`; §19.3 stock Morpheus. B19-A/B/C/D Spec PASS.

No glue. Exclusive sources unopened after review. Petitions fail-open Store characters until Roster is complete. Small toast ESC via `UISpecialFrames`. lastPair does not paint through a non-Gora RITE. Decree line font is `Fonts\\MORPHEUS.ttf`. No new TOC files. No Pope name. Walk boxes untouched. No commit. **Gate W is not closed. Gate V is not closed. POLISH:PASS is not claimed. V1 / MVP is not complete.**

## Verification

```bash
lua tests/test_console.lua        # 1438 passed, 0 failed
lua tests/test_ui.lua             # 415 passed, 0 failed
lua tests/test_hud.lua            # 714 passed, 0 failed
lua tests/test_decree_ui.lua      # 246 passed, 0 failed
lua tests/test_wire_glue.lua      # 540 passed, 0 failed
lua tests/run.lua                 # 11671 passed, 0 failed
```

TOC `## Interface: 20506`. Installed `rsync -a --delete` → Anniversary `Interface/AddOns/ChurchOfBeef`. Never WTF/.

## Concerns

- Presence still member-filters during the login seed (petitions only fail-open).
- Fail-open is not an alive scrape.
- ESC on the small toast does not drain pending.
- Knighting CONSEQUENCE can still paint lastPair (B9-E persist).
- Records Book and FighterCard still use `MORPHEUS.TTF`.
- Client `/reload` and two-client walk not run.

**Gate W stays OPEN. Gate V stays OPEN.**
