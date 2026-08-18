# B13-INT — Batch 13 integrator (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Bible §20.3, §14.2, §18.1. B13-A/B/C/D Spec PASS.

No new TOC files. Exclusive sources unopened after review. No glue. No Pope name. Walk boxes untouched. No commit. **Gate W is not closed. Gate V is not closed. POLISH:PASS is not claimed. V1 / MVP is not complete.**

## Verification

```bash
lua tests/test_net_snapshot.lua   # 640 passed, 0 failed
lua tests/test_fighter_card.lua   # 482 passed, 0 failed
lua tests/test_records.lua        # 391 passed, 0 failed
lua tests/test_console.lua        # 1286 passed, 0 failed
lua tests/run.lua                 # 10521 passed, 0 failed
```

TOC `## Interface: 20506`. `EnableMouseWheel` is SimpleScriptRegionAPI. EditBox ESC ClearFocus follows the wiki OnEscapePressed note. No `PlaySound` on ESC.

## Concerns

- Records wheel is on the outer frame; chrome hover may eat the wheel in-game.
- Console ClearFocus vs UISpecialFrames is unproven on the client.
- Client `/reload` and two-client walk not run.

**Gate W stays OPEN. Gate V stays OPEN.**
