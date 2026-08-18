# B41-INT — Batch 41 integrator (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Wiki `UISpecialFrames`; License 4 Console stays plain. B41-A/B/C/D Spec PASS.

No glue. Exclusive UI sources unopened after review. Console Refresh remounts missing OnHide. Records Init remounts missing OnHide. Dock Init remounts missing OnHide. Existing-frame Toasts Init remounts `ChurchOfBeefProclaim`. No Pope name. Walk boxes untouched. No commit. **Gate W is not closed. Gate V is not closed. POLISH:PASS is not claimed. V1 / MVP is not complete.**

## Verification

```bash
lua tests/test_console.lua        # 3045 passed, 0 failed
lua tests/test_records.lua        # 744 passed, 0 failed
lua tests/test_console_dock.lua   # 775 passed, 0 failed
lua tests/test_ui.lua             # 664 passed, 0 failed
lua tests/test_wire_glue.lua      # 627 passed, 0 failed
lua tests/run.lua                 # 15997 passed, 0 failed
```

TOC `## Interface: 20506`. Installed `rsync -a --delete` → Anniversary `Interface/AddOns/ChurchOfBeef`. Never WTF/.

## Concerns

- Client `/reload` and two-client walk not run.
- Widget Hide / ESC still cannot remount a niled OnHide by themselves.
- Console Init still skips a niled OnHide.
- First-create Toasts Init still remounts toast only (existing-frame remounts both).
- Empty OpenRite Gora still succeeds with nil subjects (B39-A keep).

**Gate W stays OPEN. Gate V stays OPEN.**
