# B36-INT — Batch 36 integrator (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Bible §13.4 / §9 optional confession text; §18.1 leftover highlight after End; §14.1 Decree ESC; Event dock dismiss persist. Anniversary `C_ChatInfo.SendAddonMessage`, `Names.Trim`, wiki `UISpecialFrames`. B36-A/B/C/D Spec PASS.

No glue. Exclusive UI / Net sources unopened after review. SendConfession trims text. EndEvent drops leftover human / character selection. Dock Hide remounts OnHide. Decree Hide remounts `ChurchOfBeefDecree` on `UISpecialFrames`. No dest on Codec. No Pope name. Walk boxes untouched. No commit. **Gate W is not closed. Gate V is not closed. POLISH:PASS is not claimed. V1 / MVP is not complete.**

## Verification

```bash
lua tests/test_net_v2.lua         # 727 passed, 0 failed
lua tests/test_console.lua        # 2490 passed, 0 failed
lua tests/test_console_dock.lua   # 563 passed, 0 failed
lua tests/test_decree_ui.lua      # 615 passed, 0 failed
lua tests/test_wire_glue.lua      # 571 passed, 0 failed
lua tests/run.lua                 # 14655 passed, 0 failed
```

TOC `## Interface: 20506`. Installed `rsync -a --delete` → Anniversary `Interface/AddOns/ChurchOfBeef`. Never WTF/.

## Concerns

- Client `/reload` and two-client walk not run.
- Widget Hide / ESC still cannot remount a niled dock OnHide or Decree `rememberSpecial` (those bypass the Lua Hide methods).
- ElevateToLord / Enqueue / Skip leftover ids after End were not separately pinned.
- StartEvent still keeps a Quiet human pick on purpose.

**Gate W stays OPEN. Gate V stays OPEN.**
