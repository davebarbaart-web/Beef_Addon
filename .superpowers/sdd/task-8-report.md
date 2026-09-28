# Task 8 report — Packed display names + 240-byte pin

**Status:** DONE  
**Date:** 2026-09-14  
**PROTOCOL:** 2 (unchanged)  
**SCHEMA_VERSION:** 7 (untouched)  
**Interface:** 20506 (untouched)

No git commit. No phase ticks. Not POLISH:PASS. Not MVP.

## What landed

- STATE / SNAPSHOT-response always emit one packed `names` field: `candidateDisplay,fighterA,fighterB`. Empty candidate → leading comma. Empty when no subjects, so 9 = names and 10 = favor + names.
- `COB.Names.Display` (realm stripped). Encode refuses `:` or `\n` (`invalid names`). No escape, no prefix, no send.
- I-04 inverted **only** for that names field. Junk / `kind` / `text` / `beat` still `"unknown field"`. SNAPSHOT **request** extra stays fail-closed.
- A-05: first-night 12-letter pair + favor is **57** bytes; codec-legal fat STATE is **112**; fat SNAPSHOT is **124**. All three go through `Net:Send` and `_TransmitWhisper` with `#payload <= 240`. Cap not raised.
- Bootstrap stashes `COB._lastCast` / `COB._lastCastNames` after accepted inbound STATE / SNAPSHOT. `Runtime:Restore` stays Bible fields. Hud / FighterCard paint stash names when `Store:GetCharacter` is empty. **No Store upsert. No Ensure.**
- Congregation HUD `livePair` / `pickPair` show an ASSEMBLY sanctioned pair (`Runtime` subjects / `GetSanctioned()`), not only Gora RITE.
- Fighter card #111: after inbound CONSEQUENCE hide, post-verdict `RITE` + lastPair does not `Show` again.

## Harness

| Suite | Result |
|-------|--------|
| `lua tests/test_net_codec.lua` | 516 passed, 0 failed |
| `lua tests/test_hud.lua` | 988 passed, 0 failed |
| `lua tests/test_net_snapshot.lua` | 839 passed, 0 failed |
| `lua tests/test_fighter_card.lua` | 926 passed, 0 failed |
| `lua tests/test_wire_glue.lua` | 810 passed, 0 failed |
| `lua tests/run.lua` | **16443 passed, 0 failed**, exit 0 |

`test_net_adversarial.lua` is harness-only (no standalone `assert_eq` wrap). The 240 Send / `_TransmitWhisper` pin ran inside `run.lua`.

## Concerns

- Decode still accepts Task 7’s 8-part (no names) and 9-part favor-only wires so leftover P2 clients do not fail closed. New encodes always emit names.
- #111 is a bootstrap dismissed flag on the `_HandleState` wrap, not a `FighterCard:Show()` change. ESC Hide + Show still restores `lastPair`.
- Late-joiner SNAPSHOT still does not `Show` the fighter card (pre-existing). Names are stashed so HUD/card paint if something else Shows.
- No in-game `/reload` smoke this pass. UI + Net were touched; client path is unverified here.
- Mute-card replica (W/L, H2H, title, stipulation) and clerical beat (#27) were not added.
