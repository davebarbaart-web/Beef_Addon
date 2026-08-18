# B38-INT — Batch 38 integrator (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Bible §18.1 leftover highlight; §10.7 persist is the Gora pair; §8 current-subject marks; wiki `UISpecialFrames`. Anniversary `SetRaidTarget(target, userIndex)` — index `0` clears. B38-A/B/C/D Spec PASS.

Glue: `afterEndEvent` pcalls `Markers:Forget` after Console Refresh. Skips `_inspecting`. Does not Hud:Refresh again. Does not Toasts:HideAll. Exclusive UI/Net sources unopened after review except this glue + `tests/test_wire_glue.lua`. No new TOC files. No Pope name. Walk boxes untouched. No commit. **Gate W is not closed. Gate V is not closed. POLISH:PASS is not claimed. V1 / MVP is not complete.**

## Verification

```bash
lua tests/test_console.lua        # 2674 passed, 0 failed
lua tests/test_net_snapshot.lua   # 826 passed, 0 failed
lua tests/test_markers.lua        # 634 passed, 0 failed
lua tests/test_records.lua        # 620 passed, 0 failed
lua tests/test_wire_glue.lua      # 602 passed, 0 failed
lua tests/run.lua                 # 15177 passed, 0 failed
```

TOC `## Interface: 20506`. Installed `rsync -a --delete` → Anniversary `Interface/AddOns/ChurchOfBeef`. Never WTF/.

## Concerns

- Client `/reload` and two-client walk not run.
- Widget Hide / ESC still skip a niled Records OnHide until `RecordsBook:Hide`.
- Forget uses remembered tokens, not names; a roster shuffle can clear the wrong person.
- Confession / Proclamation CONSEQUENCE leftover refuse is not separately pinned (gate is `riteType == "Gora"`).
- Dismiss B is source-pinned, not a separate live case.

**Gate W stays OPEN. Gate V stays OPEN.**
