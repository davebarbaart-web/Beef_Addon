## Task 6: Sender-keyed INPUT + unsigned desk

**Files:** `Net/BeefNet.lua`; `Core/Gora.lua`; `UI/Console.lua`; `tests/test_net_v2.lua`; `tests/test_gora.lua`; `tests/test_wire_glue.lua` (and `tests/test_console.lua` if you need a desk-paint pin)

**Spec:** Wave 2 review §2.1. Do **not** resolve OPEN_QUESTIONS **#26**.

### Pins

- Empty congregation Store → **zero** new `humans` / `characters` after a login-bind / INPUT apply. Invert any test that called `EnsureCharacterByName` on the pew. Congregation code paths in this task must not call `EnsureCharacterByName` / `CreateHuman` / `LinkCharacter`.
- `_HandlePetition` / `_HandleFavor` / `_HandleConfession` **ignore** payload `characterId` as authority. Key by `Names.Key(sender)`.
- Unknown sender: unsigned petition/favor row in Gora memory (name-key). No `CreateHuman`. Desk paints the **name**.
- Unknown named opponent: **ignore** the opponent, still record the ask. Do **not** return `unknown opponent` from `_HandlePetition`.
- `RecordFavor` must not write `favorPicks[foreignId]` for a spoofed numeric payload. Favor keys by sender name-key until a Pope verb writes a Store row.
- Codec INPUT body may still carry `characterId` (closed wire). Apply ignores it.

### Current code to change

- `Net:_HandlePetition` currently `Gora:Petition(decoded.characterId, namedOpponentId)` and returns `unknown opponent` when `resolveOpponentId` misses.
- `Net:_HandleFavor` currently `Gora:RecordFavor(decoded.characterId, pick)`.
- `Net:_HandleConfession` currently `Confession:Receive(decoded.characterId, text)` which refuses unknown characters — do not mint a Store row. Key by sender; unsigned confession may sit as a name-key inbox row if Confession already has a place; if not, record without CreateHuman or leave a named refuse that does not write Store. Prefer a name-key inbox over dropping silently if a one-function extension is enough. Do not build confession UI.
- `Gora:Petition` currently refuses unknown character ids and unknown opponents. Add a sender-keyed API (e.g. `PetitionFromSender(senderKey, namedOpponentId)`) rather than teaching `Petition` to accept arbitrary strings as character ids (existing suite refuses name strings on `Petition`).
- Console petition strip: paint unsigned name-keys. No auto-sanction. `EnsureCharacterByName` on the **Pope desk subject** (target + verb) may remain — that is the Pope writer. Do not call it from INPUT apply.

### Tests

- Empty store + inbound petition from sender `"Zipfresh"` → petitions include that name-key; `Store` human/character counts unchanged.
- Spoofed `characterId` on favor does not write `favorPicks[thatId]`.
- Unknown opponent name still accepts the petition (opponent field nil/ignored).
- Existing known-character `Gora:Petition(id)` suite stays green.
- Desk `GetPetitions` / paint includes unsigned display name.

### Do not

- Commit.
- Touch `ChurchOfBeef.lua`, `Core/DB.lua`, `UI/Hud.lua`, `Net/Codec.lua` (Codec stays PROTOCOL 1 this task).
- Add inbound `Toasts:Proclaim` / Sound.
- Resolve #26 (no Pope-side Ensure on apply either).

`lua tests/run.lua` must exit 0.
