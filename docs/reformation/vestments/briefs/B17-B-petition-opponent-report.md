# B17-B — Send/recv petition opponent (report)

**Status:** DONE_WITH_CONCERNS

**Cited:** Bible §10.2 / §13.1 / §18.5; brief `docs/reformation/vestments/briefs/B17-B-petition-opponent.md`. B4-A leftover ("petition id only; never a named opponent") closes here. The named opponent is a **name string** (`fields.opponent`), not a Store id. No Pope-name lookup. No new codec kind. Isolation stays Common + Runtime + Codec + Snapshot + Sender + BeefNet. Exclusive files only. No commit. Lane is not signed.

`SendPetition` may include a non-empty `fields.opponent` in the `EncodeInput` body. `namedOpponentId` is not copied onto the wire. Missing target still `false, "no target"`. `_HandlePetition` with no opponent still calls `Gora:Petition(characterId)` (`namedOpponentId == nil`). Opponent present: first-match walk of stubbable `COB.Store:Snapshot().characters` via `COB.Names.Key` / `Names.Same`. Hit → `Gora:Petition(characterId, namedOpponentId)`. Miss / no Store / empty list → `false, "unknown opponent"` and **do not** call `Petition`. GUILD INPUT stays unknown.

**Isolated count:** 551 passed, 0 failed (`lua tests/test_net_v2.lua`). **11** isolation pins under `if standalone then` at file load; **2** Store/Gora re-pins after the B17-B stub. Main-chunk locals stay **86** (new pins nested in a `do` block).

## Files written

| Path | What changed |
|------|----------------|
| `tests/test_net_v2.lua` | TDD first. Nested `do` block after the existing no-opponent Pope pins. `SendPetition({ characterId = 12, opponent = "Chuckroast" }, "Host")` → `1:INPUT:petition:12:Chuckroast`. `namedOpponentId = 99` does not appear on the wire. Inbound that payload with stub Snapshot `{ characters = { { id = 7, name = "Chuckroast" } } }` spies `Petition(12, 7)`. Store nil / empty characters → `false, "unknown opponent"`; spy count unchanged. GUILD stays unknown. Isolation wrap stays. No `dofile` Store. |
| `addon/ChurchOfBeef/Net/BeefNet.lua` | Header: petition may carry an opponent name. `SendPetition` copies a non-empty string `opponent` into `EncodeInput`. `_HandlePetition` resolves via `resolveOpponentId` (Snapshot characters, first `Names.Same` hit). |
| `docs/reformation/vestments/briefs/B17-B-petition-opponent-report.md` | This file |
| `docs/reformation/vestments/briefs/B17-B-petition-opponent.diff` | B17-B-only unified diff of the exclusive implementation files vs the pre-lane working tree |

Did not edit Codec, Inputs, Gora source, Store source, glue, TOC, bootstrap, `ChurchOfBeef.lua`, `tests/run.lua`, OPEN_QUESTIONS, or REFORMATION_LOG. Did not invent a Pope name. Did not `dofile` Store. Did not commit.

`git diff` vs HEAD on these two files also includes earlier BeefNet batches (working tree already dirty). The brief diff is the B17-B-only delta.

## Contract

```lua
Net:SendPetition(fields, target)
  -- no Pope gate. missing / empty target → false, "no target"
  -- body = { kind = "petition", characterId }
  -- if fields.opponent is a non-empty string: body.opponent = fields.opponent
  -- do not copy namedOpponentId
  -- Codec:EncodeInput → _TransmitWhisper (size cap 240)

Net:_HandlePetition(decoded, channel, sender)
  -- WHISPER + _LocalPope() stay. GUILD INPUT stays unknown.
  -- no opponent → Gora:Petition(characterId)   -- namedOpponentId == nil
  -- opponent present:
  --   resolve via Store:Snapshot().characters, Names.Key / Names.Same, first match
  --   hit  → Gora:Petition(characterId, namedOpponentId)
  --   miss / no Store / no list → false, "unknown opponent"; do not Petition
```

| Path | Result |
|------|--------|
| `SendPetition(..., "Host")` + `opponent = "Chuckroast"` | whisper `1:INPUT:petition:12:Chuckroast` |
| `namedOpponentId` also set | still `1:INPUT:petition:12:Chuckroast` |
| no `opponent` (existing) | `1:INPUT:petition:12`; spy `namedOpponentId == nil` |
| inbound name hits Snapshot id 7 | `Petition(12, 7)` |
| Store nil / empty `characters` | `false, "unknown opponent"`; spy unchanged |
| GUILD INPUT | `unknown message type` |

Keep:

- Missing target → `false, "no target"`. No Pope-name lookup.
- Existing no-opponent send/recv pins.
- GUILD INPUT unknown.
- Isolation wrap (no Store / UI / DB / Popes / Gora at load).
- Closed TYPES. No new codec kind.

## TDD

1. Extended `tests/test_net_v2.lua` first (opponent send, no `namedOpponentId` leak, inbound resolve, Store nil, empty characters, GUILD unknown). Isolation wrap untouched. Existing no-opponent pins left in place. New pins nested in a `do` block.
2. Red: `lua tests/test_net_v2.lua` — send still encoded `1:INPUT:petition:12`; inbound five-part petition was `"unknown message type"` (Codec had not yet accepted `opponent`). After BeefNet copied `opponent` into `EncodeInput` and before B17-A landed: send returned `false, "unknown field"`.
3. Implemented `SendPetition` opponent copy + `_HandlePetition` Snapshot resolve. Encode/decode of the five-part wire is Codec (B17-A); this lane does not edit Codec.
4. Green: `lua tests/test_net_v2.lua` — **551 passed, 0 failed**.

## Verification

```bash
cd /Volumes/AI_Design_Drive/Beef_Addon
lua tests/test_net_v2.lua   # 551 passed, 0 failed
```

| Suite | Result |
|-------|--------|
| `tests/test_net_v2.lua` standalone | **551 passed, 0 failed.** Lua 5.1.5. Exit 0. |

**Isolated count:** 11 pins under `if standalone then` at file load (Store, UI, DB, Popes, Officer, Ranks, Archive, Recognition, Gora, Decree, Confession). Wrap unchanged. B17-B `do` block stubs `Store.Snapshot` in-file and re-pins Store / Gora nil after. No `dofile` Store. Main-chunk locals stay 86.

Full `lua tests/run.lua` was not run (exclusive lane; `run.lua` not edited). Two-client whisper smoke was not run.

## Self-review

- Exclusive implementation files only. Codec / Inputs / Gora / Store / glue / TOC were not edited.
- `SendPetition` is still not Pope-gated. Missing target is still `"no target"`. No Pope-name lookup (`LookupPope` / `FindPope` stay nil).
- Body copies `characterId` and a non-empty string `opponent` only. `namedOpponentId` is not a body field.
- No opponent → `Petition(characterId, nil)` — existing spy `namedOpponentId == nil` stays.
- Opponent present and unresolved → `"unknown opponent"`; `Petition` is not called.
- Resolve is first-match `Names.Same` on `Snapshot().characters`. Missing Store / missing list / no match fail closed.
- GUILD INPUT stays unknown before `_HandlePetition`.
- Isolation asserts stay under `if standalone then`. Store is never `dofile`d.

## Isolated count

**551 passed, 0 failed.** Isolation wrap stays (Common + Runtime + Codec + Snapshot + Sender + BeefNet). Store stub is in-file, then nilled.

## Concerns

- **No two-client smoke.** Congregation `SendPetition` with a target name and Pope-side resolve against a live Store are unproven in Anniversary. Harness uses `Net.transmit` and an in-file `Store.Snapshot` stub.
- **B17-A Codec is a load-time dependency.** Five-part encode/decode is not this lane. If Codec drops `opponent`, send returns the codec error and inbound five-part stays unknown.
- **First-match only.** Duplicate `Names.Same` rows pick the first Snapshot array index. A characters hash (not a list) has `#chars == 0` and refuses as `"unknown opponent"`.
- **Populated-list miss is not a separate pin.** Brief asked Store nil or empty `characters`; a wrong name in a non-empty list takes the same refuse path and is unpinned.
- **Production `Gora:Petition` still validates the id.** This lane passes the Snapshot `row.id` through. A stub id that is not a known character would fail inside Gora, not here. Gora source was not edited.
- Gate W stays OPEN. Gate V stays OPEN.

## Status

**DONE_WITH_CONCERNS.** Not signed. No Gate / **POLISH:PASS** claim.
