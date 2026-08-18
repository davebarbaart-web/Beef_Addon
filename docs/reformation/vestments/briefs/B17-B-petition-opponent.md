# B17-B — Send/recv petition opponent

**Exclusive:** `addon/ChurchOfBeef/Net/BeefNet.lua`, `tests/test_net_v2.lua`

**Do not edit** Codec, Inputs, Gora source, Store source, glue. Do not commit. Do not invent a Pope name. Do not load Store in this suite (isolation stays Common + Runtime + Codec + Snapshot + Sender + BeefNet). Stub `COB.Store.Snapshot` when you need a name→id resolve. No new codec kind.

## Law

Bible §10.2 / §13.1 / §18.5. B4-A said "petition id only; never a named opponent." That leftover closes here. The named opponent is a **name string** (`fields.opponent`), not a Store id.

`SendPetition`:

- Still not Pope-gated. Missing target → `false, "no target"`. No Pope-name lookup.
- Body is `{ kind = "petition", characterId = fields.characterId }` and, when `fields.opponent` is a non-empty string, `opponent = fields.opponent`.
- Do not copy `namedOpponentId` onto the wire.
- Encode via `Codec:EncodeInput`. `_TransmitWhisper`. Size cap 240.

`_HandlePetition`:

- Whisper + `_LocalPope()` stay. GUILD INPUT stays unknown.
- No `opponent` → `Gora:Petition(characterId)` as today (spy pin: `namedOpponentId == nil`).
- `decoded.opponent` present: resolve via `Store:Snapshot().characters` using `COB.Names.Key` / `Names.Same` (same first-match walk as bootstrap `bindLocalCharacter`). Missing Store, missing list, or no match → `false, "unknown opponent"` and **do not** call `Petition` (do not silently drop the challenge).
- Match → `Gora:Petition(characterId, namedOpponentId)`.
- Update the file header comment: petition may carry an opponent name.

## Tests

Keep existing no-opponent pins (`1:INPUT:petition:12`; spy `namedOpponentId == nil`). Add:

- `SendPetition({ characterId = 12, opponent = "Chuckroast" }, "Host")` whispers `1:INPUT:petition:12:Chuckroast`.
- Inbound that payload as local Pope with stub Snapshot `{ characters = { { id = 7, name = "Chuckroast" } } }` spies `Petition(12, 7)`.
- Same inbound, Store nil or empty characters → `false, "unknown opponent"`; petition spy count unchanged.
- GUILD still unknown.

Isolation wrap stays. Do not `dofile` Store.

`lua tests/test_net_v2.lua` exit 0.

Report `docs/reformation/vestments/briefs/B17-B-petition-opponent-report.md` + diff.
