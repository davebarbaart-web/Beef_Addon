# B30-INT — Batch 30 integrator (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Wiki ESC `UISpecialFrames` / UIHANDLER OnHide; Bible §19.3 stock Morpheus. B30-A/B/C/D Spec PASS.

No glue. Exclusive UI sources unopened after review. Decree `ensureFrame` remounts a missing OnHide. Fighter card Hide remounts a missing OnHide. Records `paint()` re-applies `Fonts\\MORPHEUS.ttf` on PageTitle. Event dock Hide remounts ESC. No new TOC files. No Pope name. Walk boxes untouched. No commit. **Gate W is not closed. Gate V is not closed. POLISH:PASS is not claimed. V1 / MVP is not complete.**

## Verification

```bash
lua tests/test_decree_ui.lua      # 494 passed, 0 failed
lua tests/test_fighter_card.lua   # 613 passed, 0 failed
lua tests/test_records.lua        # 511 passed, 0 failed
lua tests/test_console_dock.lua   # 476 passed, 0 failed
lua tests/test_wire_glue.lua      # 552 passed, 0 failed
lua tests/run.lua                 # 13337 passed, 0 failed
```

TOC `## Interface: 20506`. Installed `rsync -a --delete` → Anniversary `Interface/AddOns/ChurchOfBeef`. Never WTF/.

## Concerns

- `DecreeBanner:Hide` still skips a niled OnHide (ensureFrame remounts).
- Writer leftover “glue does not Refresh on Clear” is stale (B28 `wrapAlways`).
- `Runtime:EndEvent` (not via Console) still leaves `lastRecommendation`.
- Records `TitleText` Morpheus still applies only in `buildFrame`.
- Quiet-shell `Show` still skips a niled OnHide.
- Client `/reload` and two-client walk not run.

**Gate W stays OPEN. Gate V stays OPEN.**
