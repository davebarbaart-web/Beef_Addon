# B39-INT — Batch 39 integrator (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Bible §18.1 leftover highlight; §10.7 persist is the Gora pair; wiki `UISpecialFrames`. B38-B SNAPSHOT last overlay is Gora CONSEQUENCE only. B39-A/B/C/D Spec PASS.

Glue: `canCarryLast` also requires `riteType == "Gora"` so live STATE matches SNAPSHOT. Exclusive UI sources unopened after review except this glue + `tests/test_wire_glue.lua`. No new TOC files. No Pope name. Walk boxes untouched. No commit. **Gate W is not closed. Gate V is not closed. POLISH:PASS is not claimed. V1 / MVP is not complete.**

## Verification

```bash
lua tests/test_console.lua        # 2798 passed, 0 failed
lua tests/test_fighter_card.lua   # 731 passed, 0 failed
lua tests/test_ui.lua             # 621 passed, 0 failed
lua tests/test_console_dock.lua   # 630 passed, 0 failed
lua tests/test_wire_glue.lua      # 627 passed, 0 failed
lua tests/run.lua                 # 15466 passed, 0 failed
```

TOC `## Interface: 20506`. Installed `rsync -a --delete` → Anniversary `Interface/AddOns/ChurchOfBeef`. Never WTF/.

## Concerns

- Client `/reload` and two-client walk not run.
- OpenRite Gora after Continue still succeeds with nil subjects (Runtime accepts Gora without fighters).
- Widget Hide / ESC still skip remount until a Lua Show / Hide / HideAll path.
- Dock Refresh / Init still skip a niled OnHide.

**Gate W stays OPEN. Gate V stays OPEN.**
