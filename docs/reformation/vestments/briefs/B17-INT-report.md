# B17-INT — Batch 17 integrator (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Bible §10.2 challenges; §13.1 / §18.5 input; §10.7 HUD persist. B17-A/B/C/D Spec PASS.

No glue. Exclusive sources unopened after review. Petition INPUT may carry an opponent **name**. Pope resolve is first-match Store Snapshot. Inputs names `UnitName("target")` when it is not the whisper dest and not the player. HUD no longer paints leftover fighters during a non-Gora RITE. No new TOC files. No Pope name. Walk boxes untouched. No commit. **Gate W is not closed. Gate V is not closed. POLISH:PASS is not claimed. V1 / MVP is not complete.**

## Verification

```bash
lua tests/test_net_codec.lua      # 480 passed, 0 failed
lua tests/test_net_v2.lua         # 551 passed, 0 failed
lua tests/test_inputs.lua         # 505 passed, 0 failed
lua tests/test_hud.lua            # 672 passed, 0 failed
lua tests/test_wire_glue.lua      # 540 passed, 0 failed
lua tests/run.lua                 # 11368 passed, 0 failed
```

TOC `## Interface: 20506`. Installed `rsync -a --delete` → Anniversary `Interface/AddOns/ChurchOfBeef`. Never WTF/.

## Concerns

- Whitespace-only `UnitName` strings can still reach `SendPetition` (Codec omits empty after trim).
- Confess box still overlaps the Inputs TitleBar (HEIGHT 72).
- Name resolve is first Snapshot match; duplicate names pick lowest id.
- Congregation Store is empty until a Store Restore exists — unknown opponent fail-closed on the Pope client if the name is not in the Pope store.
- Client `/reload` and two-client walk not run.

**Gate W stays OPEN. Gate V stays OPEN.**
