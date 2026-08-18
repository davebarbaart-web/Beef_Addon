# B23-INT — Batch 23 integrator (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Bible §19.4 theater-owned cues; wiki ESC `UISpecialFrames` (no `IG_CHARACTER_INFO_*`); Anniversary `UnitName`. B23-A/B/C/D Spec PASS.

No production glue. Exclusive sources unopened after review except `tests/test_console.lua`: full harness loads Toasts before the console suite, so the legacy Sound-spy block now nils `COB.Toasts` inside a `do` block (Lua 5.1 200-local). Theater still owns cues when `Proclaim` exists. Dock ESC stays hidden until `Show` or QUIET. Toast `Init` re-registers `ChurchOfBeefToast`. Empty / whitespace player name omits opponent. No new TOC files. No Pope name. Walk boxes untouched. No commit. **Gate W is not closed. Gate V is not closed. POLISH:PASS is not claimed. V1 / MVP is not complete.**

## Verification

```bash
lua tests/test_console.lua        # 1693 passed, 0 failed
lua tests/test_console_dock.lua   # 280 passed, 0 failed
lua tests/test_ui.lua             # 489 passed, 0 failed
lua tests/test_inputs.lua         # 756 passed, 0 failed
lua tests/test_wire_glue.lua      # 540 passed, 0 failed
lua tests/run.lua                 # 12245 passed, 0 failed
```

TOC `## Interface: 20506`. Installed `rsync -a --delete` → Anniversary `Interface/AddOns/ChurchOfBeef`. Never WTF/.

## Concerns

- `lastRecommendation` still lives across EndEvent.
- Selected-pair Recommend can still inherit Core `namedOpponent`.
- Client `/reload` and two-client walk not run.

**Gate W stays OPEN. Gate V stays OPEN.**
