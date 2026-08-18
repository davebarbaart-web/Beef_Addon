# B3-E — Congregation Snapshot request send

**Exclusive:** `addon/ChurchOfBeef/Net/BeefNet.lua`, `tests/test_net_v2.lua`

**Do not edit** Codec, Snapshot.lua (encode already exists), Data/Popes.lua. Do not commit. Do not invent a Pope name.

## Law

Bible §20.3: late join / reload requests current state from the Pope (whisper). Inbound request is already answered only if `_LocalPope()`. Missing piece: congregation **send**.

```lua
Net:RequestSnapshot(target, nowSeconds)
```

- Not Pope-gated (congregation asks).
- Requires `target` (whisper destination). Missing → `false, "no target"`. Do not look up a Pope name.
- Body: `Snapshot:Request()` / `Codec:EncodeSnapshot({ role = "request" })`.
- `_TransmitWhisper`. Size cap 240.

Do not add a new codec kind. Petition/confession stay unknown. SendState/SendDecree stay Pope-gated.

## Tests

RequestSnapshot without target fails. With target, whisper enqueue/send (reuse suite spies). Empty Popes list still blocks SendState. Isolation under `if standalone then`.

`lua tests/test_net_v2.lua` exit 0.

Report `docs/reformation/vestments/briefs/B3-E-snapshot-report.md` + diff.
