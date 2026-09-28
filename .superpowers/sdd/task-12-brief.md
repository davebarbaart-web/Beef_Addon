## Task 12: Ask to fight (no Store write)

**Files:** `UI/Inputs.lua`; `Net/BeefNet.lua`; `tests/test_inputs.lua`

**Depends on:** Task 6 (sender-keyed apply). Hide-on-Pope can land without Task 14.

### Pins

- Face: **Ask to fight**. Header is not `EVENT INPUT`.
- Hide the strip on listed Pope (`IsRegisteredPope`). Invert `test_inputs.lua` source scan that forbids `IsRegisteredPope`.
- Dest line and send dest both call the same helper as `Net` `defaultDest()` (last STATE sender else `Popes.List[1]`).
- Reasons that can fire: not in a guild; send failed; you already asked (no TTL); this is a Knighting, not a fight (#107 can land here).
- After a successful send: strip says asked / waiting. Unknown opponent does not refuse.
- Do not mint `localCharacterId` via Store. Codec may still send a placeholder id; apply ignores it (Task 6).

No commit. No BackdropTemplate drop unless a live 20506 abort (there has not been one). `lua tests/run.lua` exit 0.
