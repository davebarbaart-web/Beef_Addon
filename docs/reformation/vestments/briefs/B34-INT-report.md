# B34-INT — Batch 34 integrator (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Law 10 / §19.3 class color; Bible §18.1 Presence; §8 current-subject marks; License 2 / §13.1 whisper dest. Anniversary `FontInstance:SetTextColor`, `Region:SetAlpha`, `TargetUnit`, `C_ChatInfo.SendAddonMessage`. B34-A/B/C/D Spec PASS.

No glue. Exclusive UI / Net sources unopened after review. HUD names re-tint after font apply. Leftover Presence hide resets alpha. Successful Target keeps last mark units. SendSnapshot dest-trims before encode. No dest on Codec. No Pope name. Walk boxes untouched. No commit. **Gate W is not closed. Gate V is not closed. POLISH:PASS is not claimed. V1 / MVP is not complete.**

## Verification

```bash
lua tests/test_hud.lua            # 779 passed, 0 failed
lua tests/test_console.lua        # 2398 passed, 0 failed
lua tests/test_markers.lua        # 543 passed, 0 failed
lua tests/test_net_v2.lua         # 682 passed, 0 failed
lua tests/test_wire_glue.lua      # 571 passed, 0 failed
lua tests/run.lua                 # 14232 passed, 0 failed
```

TOC `## Interface: 20506`. Installed `rsync -a --delete` → Anniversary `Interface/AddOns/ChurchOfBeef`. Never WTF/.

## Concerns

- Client `/reload` and two-client walk not run.
- Harness `SetFont` / `SetAlpha` often no-ops; class-color restore and leftover alpha are source/recorder pins.
- Successful Target GetView can show the targeted name with the prior mark unit.
- `SendSnapshot` dest-trims twice on the happy path (`SendSnapshot` then `_TransmitWhisper`).

**Gate W stays OPEN. Gate V stays OPEN.**
