# B37-INT — Batch 37 integrator (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Bible §18.1 leftover highlight; License 2 / §10.6 per-event favor; wiki `UISpecialFrames`; §13.4 / §9 leftover confess text. Anniversary `EditBox:SetText`. B37-A/B/C/D Spec PASS.

No glue. Exclusive UI sources unopened after review. Dismiss drops leftover character pick. Quiet forget drops leftover congregation favor. Fighter-card Hide remounts `ChurchOfBeefFighterCard`. Quiet Hide blanks leftover confess text. No dest on Codec. No Pope name. Walk boxes untouched. No commit. **Gate W is not closed. Gate V is not closed. POLISH:PASS is not claimed. V1 / MVP is not complete.**

## Verification

```bash
lua tests/test_console.lua        # 2573 passed, 0 failed
lua tests/test_hud.lua            # 854 passed, 0 failed
lua tests/test_fighter_card.lua   # 660 passed, 0 failed
lua tests/test_inputs.lua         # 995 passed, 0 failed
lua tests/test_wire_glue.lua      # 571 passed, 0 failed
lua tests/run.lua                 # 14873 passed, 0 failed
```

TOC `## Interface: 20506`. Installed `rsync -a --delete` → Anniversary `Interface/AddOns/ChurchOfBeef`. Never WTF/.

## Concerns

- Client `/reload` and two-client walk not run.
- Widget Hide / ESC still skip FighterCard `rememberSpecial`.
- Skipping Quiet HUD Refresh still leaves leftover favor until a later forget.
- Shared Inputs `paintHidden` also blanks on Quiet Refresh / Init.

**Gate W stays OPEN. Gate V stays OPEN.**
