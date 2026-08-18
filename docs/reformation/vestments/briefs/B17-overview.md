# Batch 17 — Petition challenge on the wire + HUD leftover hide

**Cited:** Bible §10.2 challenges; §13.1 / §18.5 congregation input; §10.7 HUD persist; license 4 stock only. No new codec **kinds**. `opponent` is an optional name field on existing petition INPUT. `SaveNote` nil. No SUMMON. No GuildPromote. No live HUD health. No custom media. No Pope-name lookup.

Core `Gora:Petition(characterId, namedOpponentId)` and the Console petition desk already understand a named opponent. B4-A deliberately dropped it on the wire. Congregation can name a desired opponent via `UnitName("target")` once STATE has injected the Pope whisper dest.

| Lane | Exclusive | Scope |
|------|-----------|--------|
| B17-A | `Net/Codec.lua`, `tests/test_net_codec.lua` | Optional petition `opponent` (character **name** string). Four-part petition unchanged. Not a new kind. |
| B17-B | `Net/BeefNet.lua`, `tests/test_net_v2.lua` | `SendPetition` may encode `opponent`. Inbound Pope resolves name → Store id, then `Gora:Petition(id, namedOpponentId)`. Isolation does not load Store — stub Snapshot. |
| B17-C | `UI/Inputs.lua`, `tests/test_inputs.lua` | Petition includes `UnitName("target")` when it is not the whisper dest and not the local player. |
| B17-D | `UI/Hud.lua`, `tests/test_hud.lua` | `livePair` runtime arm requires RITE + Gora. Knighting leftover fighters do not paint. lastPair persist and live Sanction during Knighting stay. |
| B17-INT | ledger + install | No glue unless a review Important requires it. |

**Gate W stays OPEN. Gate V stays OPEN. Do not claim POLISH:PASS.**
