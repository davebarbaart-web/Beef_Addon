# B28-INT — Batch 28 integrator (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Wiki ESC `UISpecialFrames` / UIHANDLER OnHide; Law 6 Quiet leftover paint. B28-A/B/C/D Spec PASS.

Glue: `wrapAlways` on `Decree:Clear` (Clear returns nil, so `wrapAfter` would skip) calls `DecreeBanner:Refresh`. Does not send DECREE or STATE. Exclusive UI sources unopened after review. Console Show/Refresh remount ESC. Decree Refresh wipe+Hide when the line is gone. Records Hide remounts ESC. Fighter card Init restores a missing OnHide. No new TOC files. No Pope name. Walk boxes untouched. No commit. **Gate W is not closed. Gate V is not closed. POLISH:PASS is not claimed. V1 / MVP is not complete.**

## Verification

```bash
lua tests/test_console.lua        # 2026 passed, 0 failed
lua tests/test_decree_ui.lua      # 369 passed, 0 failed
lua tests/test_records.lua        # 487 passed, 0 failed
lua tests/test_fighter_card.lua   # 528 passed, 0 failed
lua tests/test_wire_glue.lua      # 552 passed, 0 failed
lua tests/run.lua                 # 12981 passed, 0 failed
```

TOC `## Interface: 20506`. Installed `rsync -a --delete` → Anniversary `Interface/AddOns/ChurchOfBeef`. Never WTF/.

## Concerns

- Console Toggle-hide still skips remount.
- Widget `frame:Hide()` after Clear still leaves leftover paint until Refresh.
- Client `/reload` and two-client walk not run.

**Gate W stays OPEN. Gate V stays OPEN.**
