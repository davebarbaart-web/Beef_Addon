# B22-INT — Batch 22 integrator (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Bible §10.2 / §18.1 Recommend + dock; §19.3 HUD names; wiki ESC `UISpecialFrames`; Anniversary `SetFont` / `SetRaidTarget` / `UnitName`. B22-A/B/C/D Spec PASS.

No glue. Exclusive sources unopened after review. Recommendation paints mute `"  names  "` when Core flags a named opponent. HUD fighter names try `Fonts\\MORPHEUS.ttf`. Self-mark no longer needs `GetNumGroupMembers`. Event dock ESC via `UISpecialFrames`. No new TOC files. No Pope name. Walk boxes untouched. No commit. **Gate W is not closed. Gate V is not closed. POLISH:PASS is not claimed. V1 / MVP is not complete.**

## Verification

```bash
lua tests/test_console.lua        # 1645 passed, 0 failed
lua tests/test_hud.lua            # 741 passed, 0 failed
lua tests/test_markers.lua        # 349 passed, 0 failed
lua tests/test_console_dock.lua   # 233 passed, 0 failed
lua tests/test_wire_glue.lua      # 540 passed, 0 failed
lua tests/run.lua                 # 12064 passed, 0 failed
```

TOC `## Interface: 20506`. Installed `rsync -a --delete` → Anniversary `Interface/AddOns/ChurchOfBeef`. Never WTF/.

## Concerns

- Desk `after()` still double-cues with Proclaim.
- Dock ESC Hide does not sync `lastView`; a later Refresh can re-show while the event is live.
- Client `/reload` and two-client walk not run.

**Gate W stays OPEN. Gate V stays OPEN.**
