# B40-INT — Batch 40 integrator (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Wiki `UISpecialFrames`; License 4 Console stays plain. B40-A/B/C/D Spec PASS.

No glue. Exclusive UI sources unopened after review. Console Hide remounts missing OnHide. Records Show remounts missing OnHide. Dock Refresh remounts missing OnHide. Already-hidden Quiet-shell Hide writes `shown = false`. No Pope name. Walk boxes untouched. No commit. **Gate W is not closed. Gate V is not closed. POLISH:PASS is not claimed. V1 / MVP is not complete.**

## Verification

```bash
lua tests/test_console.lua        # 2930 passed, 0 failed
lua tests/test_records.lua        # 682 passed, 0 failed
lua tests/test_console_dock.lua   # 702 passed, 0 failed
lua tests/test_ui.lua             # 642 passed, 0 failed
lua tests/test_wire_glue.lua      # 627 passed, 0 failed
lua tests/run.lua                 # 15739 passed, 0 failed
```

TOC `## Interface: 20506`. Installed `rsync -a --delete` → Anniversary `Interface/AddOns/ChurchOfBeef`. Never WTF/.

## Concerns

- Client `/reload` and two-client walk not run.
- Widget Hide / ESC still cannot remount a niled OnHide by themselves.
- Console Show / Init / Refresh still skip a niled OnHide until Hide.
- Records Init still skips a niled OnHide.
- Dock Init remount body still has no `wireDockOnHide`.
- Empty OpenRite Gora still succeeds with nil subjects (B39-A keep).

**Gate W stays OPEN. Gate V stays OPEN.**
