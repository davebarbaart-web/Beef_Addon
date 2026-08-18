# B24-INT — Batch 24 integrator (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Bible §18.1 / §20 event lifetime; wiki ESC `UISpecialFrames`. B24-A/B/C/D Spec PASS.

No glue. Exclusive sources unopened after review. Recommendation clears on successful StartEvent / EndEvent. Dock dismiss is per Runtime `eventId`. Quiet shell and Decree re-register ESC on Init early-return. No new TOC files. No Pope name. Walk boxes untouched. No commit. **Gate W is not closed. Gate V is not closed. POLISH:PASS is not claimed. V1 / MVP is not complete.**

## Verification

```bash
lua tests/test_console.lua        # 1766 passed, 0 failed
lua tests/test_console_dock.lua   # 314 passed, 0 failed
lua tests/test_ui.lua             # 507 passed, 0 failed
lua tests/test_decree_ui.lua      # 265 passed, 0 failed
lua tests/test_wire_glue.lua      # 540 passed, 0 failed
lua tests/run.lua                 # 12385 passed, 0 failed
```

TOC `## Interface: 20506`. Installed `rsync -a --delete` → Anniversary `Interface/AddOns/ChurchOfBeef`. Never WTF/.

## Concerns

- Selected-pair Recommend can still inherit Core `namedOpponent`.
- Decree `Show()` with no active line still returns before `ensureFrame`.
- Client `/reload` and two-client walk not run.

**Gate W stays OPEN. Gate V stays OPEN.**
