# B33-INT — Batch 33 integrator (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** License 2 / §13.1 whisper dest; Bible §18.1 Presence; §8 current-subject marks; Anniversary `C_ChatInfo.SendAddonMessage` target. B33-A/B/C/D Spec PASS.

No glue. Exclusive UI / Net sources unopened after review. Inputs dest trim. Presence fail-open rows dim. Markers refuse keeps last units. BeefNet refuses whitespace dest. No dest on Codec. No Pope name. Walk boxes untouched. No commit. **Gate W is not closed. Gate V is not closed. POLISH:PASS is not claimed. V1 / MVP is not complete.**

## Verification

```bash
lua tests/test_inputs.lua         # 848 passed, 0 failed
lua tests/test_console.lua        # 2297 passed, 0 failed
lua tests/test_markers.lua        # 491 passed, 0 failed
lua tests/test_net_v2.lua         # 632 passed, 0 failed
lua tests/test_wire_glue.lua      # 571 passed, 0 failed
lua tests/run.lua                 # 14023 passed, 0 failed
```

TOC `## Interface: 20506`. Installed `rsync -a --delete` → Anniversary `Interface/AddOns/ChurchOfBeef`. Never WTF/.

## Concerns

- Hidden leftover Presence buttons keep last alpha until reused.
- Successful `Target` still wipes `last.unit`.
- Client `/reload` and two-client walk not run.

**Gate W stays OPEN. Gate V stays OPEN.**
