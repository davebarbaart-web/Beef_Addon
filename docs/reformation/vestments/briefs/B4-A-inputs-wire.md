# B4-A — Petition and confession INPUT on the wire

**Exclusive:** `addon/ChurchOfBeef/Net/BeefNet.lua`, `tests/test_net_v2.lua`

**Do not edit** Codec (kinds already exist), Snapshot.lua, Data/Popes.lua, Gora, Confession source. Do not commit. Do not invent a Pope name. Do not add a codec kind or a named-opponent field.

## Law

Bible §9, §10.2, §13.1, §13.4, §18.5. CONTINUE license 2 already opened INPUT as whisper-to-Pope for favor. Petition and confession are the other two closed `Codec.INPUT_KINDS`. They stay **whisper-to-Pope**; GUILD INPUT stays unknown.

```lua
Net:SendPetition(fields, target, nowSeconds)
Net:SendConfession(fields, target, nowSeconds)
```

Mirror `SendFavor`:

- Not Pope-gated (congregation sends).
- Missing / empty `target` → `false, "no target"`. Do not look up a Pope name.
- Encode via `Codec:EncodeInput`. Petition body: `{ kind = "petition", characterId = fields.characterId }` only.
- Confession body: `{ kind = "confession", characterId = fields.characterId, text = fields.text }` (text optional). If `text` is a string containing `"\n"`, refuse (`false, "invalid text"`) before encode.
- `_TransmitWhisper`. Size cap 240.

Inbound (`_HandleV2`):

- INPUT on a channel other than WHISPER → `unknown message type`.
- `kind == "favor"` → existing `_HandleFavor`.
- `kind == "petition"` → `_LocalPope()` or `false, "not a registered pope"`; then `Gora:Petition(characterId)` if Gora exists. No named opponent.
- `kind == "confession"` → `_LocalPope()` same; if `COB.Confession` and `Receive` exist, call `Receive(characterId, text)`. Missing module → `false` (fail-closed, do not invent a queue in BeefNet).
- Update the file header comment: petition/confession are live on whisper-to-Pope.

SendState / SendDecree stay Pope-gated. RequestSnapshot unchanged.

## Tests

Extend `tests/test_net_v2.lua` isolation. Pin:

- SendPetition / SendConfession without target → `false, "no target"`.
- With target, whisper once; petition payload `1:INPUT:petition:<id>`; confession with text encodes; newline text refused.
- Empty Popes list still blocks SendState.
- Inbound petition WHISPER as local Pope calls Gora:Petition (spy/stub).
- Inbound confession WHISPER as local Pope calls Confession:Receive when stubbed.
- GUILD INPUT petition stays unknown.

`lua tests/test_net_v2.lua` exit 0.

Report `docs/reformation/vestments/briefs/B4-A-inputs-wire-report.md` + diff.
