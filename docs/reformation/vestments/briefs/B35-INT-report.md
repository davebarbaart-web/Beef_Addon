# B35-INT — Batch 35 integrator (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Bible §10.7 mute defense integer; §13.4 / §9 optional confession text; §8 current-subject marks; §14.2 Quiet shell persist. Anniversary `SetWidth`, `Names.Trim`, `TargetUnit`, `UISpecialFrames`. B35-A/B/C/D Spec PASS.

No glue. Exclusive UI sources unopened after review. Defense labels capped at 28. Confess text trimmed. Target keeps fighter names. Quiet-shell Hide remounts OnHide + persist. No dest on Codec. No Pope name. Walk boxes untouched. No commit. **Gate W is not closed. Gate V is not closed. POLISH:PASS is not claimed. V1 / MVP is not complete.**

## Verification

```bash
lua tests/test_hud.lua            # 814 passed, 0 failed
lua tests/test_inputs.lua         # 937 passed, 0 failed
lua tests/test_markers.lua        # 563 passed, 0 failed
lua tests/test_ui.lua             # 607 passed, 0 failed
lua tests/test_wire_glue.lua      # 571 passed, 0 failed
lua tests/run.lua                 # 14395 passed, 0 failed
```

TOC `## Interface: 20506`. Installed `rsync -a --delete` → Anniversary `Interface/AddOns/ChurchOfBeef`. Never WTF/.

## Concerns

- Client `/reload` and two-client walk not run.
- Harness `GetWidth` / `SetFont` are stub fields, not live clip.
- Already-hidden Quiet-shell Hide remounts OnHide but leaves stale `shown` until a real hide.
- `GetView` name vs unit stay split on purpose after Target.

**Gate W stays OPEN. Gate V stays OPEN.**
