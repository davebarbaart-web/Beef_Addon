# B26-INT — Batch 26 integrator (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Bible §18.1 / §20 event lifetime; wiki ESC `UISpecialFrames`; Law 6 Quiet leftover paint. B26-A/B/C/D Spec PASS.

No glue. Exclusive sources unopened after review. Successful Start/End clear the selected pair. Toast Init restores a missing OnHide. Empty Decree Show blanks leftover Line/Flavor. Dock Init remounts ESC. No new TOC files. No Pope name. Walk boxes untouched. No commit. **Gate W is not closed. Gate V is not closed. POLISH:PASS is not claimed. V1 / MVP is not complete.**

## Verification

```bash
lua tests/test_console.lua        # 1922 passed, 0 failed
lua tests/test_ui.lua             # 528 passed, 0 failed
lua tests/test_decree_ui.lua      # 302 passed, 0 failed
lua tests/test_console_dock.lua   # 353 passed, 0 failed
lua tests/test_wire_glue.lua      # 540 passed, 0 failed
lua tests/run.lua                 # 12654 passed, 0 failed
```

TOC `## Interface: 20506`. Installed `rsync -a --delete` → Anniversary `Interface/AddOns/ChurchOfBeef`. Never WTF/.

## Concerns

- Decree wipe is on empty Show only; Core Clear / Hide can still leave leftover FontStrings until Show.
- Dock Refresh / Show still skip remount.
- Quiet-shell Init still does not restore a missing OnHide.
- Client `/reload` and two-client walk not run.

**Gate W stays OPEN. Gate V stays OPEN.**
