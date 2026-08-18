# B29-INT — Batch 29 integrator (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Wiki ESC `UISpecialFrames` / UIHANDLER OnHide; Law 6 Quiet leftover paint; Bible §19.3 stock Morpheus. B29-A/B/C/D Spec PASS.

No glue. Exclusive UI sources unopened after review. Console Hide / Toggle-hide remount ESC. Decree widget Hide after Clear blanks leftover Goldshire. Fighter card Show / Refresh restore a missing OnHide. Shown-beat Proclaim re-applies `Fonts\\MORPHEUS.ttf`. No new TOC files. No Pope name. Walk boxes untouched. No commit. **Gate W is not closed. Gate V is not closed. POLISH:PASS is not claimed. V1 / MVP is not complete.**

## Verification

```bash
lua tests/test_console.lua        # 2085 passed, 0 failed
lua tests/test_decree_ui.lua      # 427 passed, 0 failed
lua tests/test_fighter_card.lua   # 574 passed, 0 failed
lua tests/test_ui.lua             # 558 passed, 0 failed
lua tests/test_wire_glue.lua      # 552 passed, 0 failed
lua tests/run.lua                 # 13150 passed, 0 failed
```

TOC `## Interface: 20506`. Installed `rsync -a --delete` → Anniversary `Interface/AddOns/ChurchOfBeef`. Never WTF/.

## Concerns

- Decree `ensureFrame` early-return still skips a niled OnHide (create-path only).
- Fighter card `Hide` still skips a niled OnHide.
- Records page-title Morpheus still applies only in `buildFrame`, not `paint()`.
- Writer leftover “glue does not Refresh on Clear” is stale (B28 `wrapAlways`).
- Client `/reload` and two-client walk not run.

**Gate W stays OPEN. Gate V stays OPEN.**
