# B31-INT — Batch 31 integrator (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Bible §20 QUIET has no event pair; B26-A recommend dies with the event; Wiki ESC OnHide; Bible §19.3 stock Morpheus. B31-A/B/C/D Spec PASS.

Glue: `afterEndEvent` Refreshs `Console` so a desk-bypassing `Runtime:EndEvent` (InspectProgress) drops leftover Recommend paint. Does not send STATE. StartEvent / Continue glue still skip Console Refresh. Exclusive UI sources unopened after review except this glue + `tests/test_wire_glue.lua`. No new TOC files. No Pope name. Walk boxes untouched. No commit. **Gate W is not closed. Gate V is not closed. POLISH:PASS is not claimed. V1 / MVP is not complete.**

## Verification

```bash
lua tests/test_console.lua        # 2145 passed, 0 failed
lua tests/test_decree_ui.lua      # 565 passed, 0 failed
lua tests/test_ui.lua             # 582 passed, 0 failed
lua tests/test_records.lua        # 536 passed, 0 failed
lua tests/test_wire_glue.lua      # 561 passed, 0 failed
lua tests/run.lua                 # 13522 passed, 0 failed
```

TOC `## Interface: 20506`. Installed `rsync -a --delete` → Anniversary `Interface/AddOns/ChurchOfBeef`. Never WTF/.

## Concerns

- Quiet-shell `Hide` still skips a niled OnHide.
- `DecreeBanner:Hide` still skips `rememberSpecial`.
- Client `/reload` and two-client walk not run.

**Gate W stays OPEN. Gate V stays OPEN.**
