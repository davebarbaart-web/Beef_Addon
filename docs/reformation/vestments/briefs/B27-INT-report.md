# B27-INT — Batch 27 integrator (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Wiki ESC `UISpecialFrames`; Law 6 Quiet leftover paint; Bible §18.1 dock. B27-A/B/C/D Spec PASS.

No glue. Exclusive sources unopened after review. Console Init remounts ESC. Decree Hide blanks leftover Line/Flavor when the line is gone. Quiet-shell Init restores a missing OnHide. Dock Refresh / Show remount ESC. No new TOC files. No Pope name. Walk boxes untouched. No commit. **Gate W is not closed. Gate V is not closed. POLISH:PASS is not claimed. V1 / MVP is not complete.**

## Verification

```bash
lua tests/test_console.lua        # 1970 passed, 0 failed
lua tests/test_ui.lua             # 548 passed, 0 failed
lua tests/test_decree_ui.lua      # 328 passed, 0 failed
lua tests/test_console_dock.lua   # 414 passed, 0 failed
lua tests/test_wire_glue.lua      # 540 passed, 0 failed
lua tests/run.lua                 # 12800 passed, 0 failed
```

TOC `## Interface: 20506`. Installed `rsync -a --delete` → Anniversary `Interface/AddOns/ChurchOfBeef`. Never WTF/.

## Concerns

- Core `Decree:Clear()` still does not wipe a banner left visible until Hide or empty Show.
- Console `Refresh` / `Show` / `Toggle` still skip remount.
- Client `/reload` and two-client walk not run.

**Gate W stays OPEN. Gate V stays OPEN.**
