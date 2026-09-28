## Task 8: Packed display names + 240-byte pin

**Files:** `Net/Codec.lua`; `Net/Snapshot.lua`; `ChurchOfBeef.lua` `stateFields` + inbound stash; `UI/Hud.lua`; `UI/FighterCard.lua`; `tests/test_net_codec.lua`; `tests/test_net_adversarial.lua`; `tests/test_hud.lua`; `tests/test_wire_glue.lua`

**Depends on:** Task 7 (`PROTOCOL = 2`).

### Pins

- Packed names for fighters / candidate only. Fail-closed if a name contains `:`.
- **Pin through `Net:Send` / `_TransmitWhisper`:** worst-case names + favor `#payload <= 240`. Codec round-trip alone is not enough. See `docs/superpowers/plans/2026-09-14-state-byte-budget.md`.
- Inbound stash `lastCast` / names on bootstrap. `Runtime:Restore` stays Bible fields. Hud / FighterCard paint from stash when `GetCharacter` is empty. **No Store upsert.**
- Snapshot `BuildResponse` / `ApplyResponse` carry the same names field. `SNAPSHOT_RES_KEYS` allowlist it.
- Congregation HUD `livePair` / `pickPair` must show ASSEMBLY sanction (Pope already sanctions in ASSEMBLY). Align with `GetSanctioned()` on the Pope client.
- Fighter card must not re-show on post-verdict `RITE` + lastPair (spec #111).

### Do not

- Commit. Mute-card replica (W/L, H2H, title, stipulation). Clerical beat. Store upsert.
- Touch `UI/Console.lua` / `Core/DB.lua` unless required for stash — prefer bootstrap + Hud + FighterCard.

`lua tests/run.lua` must exit 0.
