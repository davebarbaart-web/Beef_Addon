# B34-D — SendSnapshot destName before encode

**Exclusive:** `addon/ChurchOfBeef/Net/BeefNet.lua`, `tests/test_net_v2.lua`

**Do not edit** Codec.lua, Snapshot.lua, glue. Do not commit. Do not add dest to any codec payload. Do not look up a Pope name.

## Law

License 2 / §13.1. Anniversary `C_ChatInfo.SendAddonMessage(prefix, message, chatType, target)` — target is the whisper dest. `SendFavor` / `SendPetition` / `SendConfession` / `RequestSnapshot` already `destName` before encode. `SendSnapshot` Pope-gates then `EncodeSnapshot` then `_TransmitWhisper`, so whitespace dest still encodes.

Keep `_LocalPope()` first (existing non-pope pins stay `"not a registered pope"`). Then `destName(target)`; empty after trim is `"no target"` and does **not** `EncodeSnapshot`. Then encode + `_TransmitWhisper`. `_TransmitWhisper` still trims. No dest on SNAPSHOT body.

## Tests

After the B33-D block. Non-pope `SendSnapshot` pins stay `"not a registered pope"`. Stub `IsRegisteredPope` true: whitespace / `""` / nil dest is `"no target"`, no encode (spy `EncodeSnapshot` call count), no whisper. `"  Host  "` may encode and transmit with target `"Host"` if you stub Pope and a valid snapshot body (`role = "request"` is enough). Isolation wrap stays. No Pope-name lookup.

`lua tests/test_net_v2.lua` exit 0.

Report `docs/reformation/vestments/briefs/B34-D-snapshot-dest-report.md` + diff.
