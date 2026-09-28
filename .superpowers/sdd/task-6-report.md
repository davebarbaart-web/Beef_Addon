# Task 6 Report — Sender-keyed INPUT + unsigned desk

**Status:** DONE (implementer [Sender-keyed INPUT](7b58c465-64f5-42be-ad5f-97708d753ba9); controller verified + Dismiss follow-up)  
**Commits:** none  
**Interface:** 20506  
**SCHEMA_VERSION:** 7  
**OPEN_QUESTIONS #26:** unanswered (no pew Ensure; no Pope-side Ensure on apply)

## What landed

Congregation INPUT apply keys by server-provided sender. Payload `characterId` is ignored. Unknown senders sit as unsigned name-key rows. Unknown named opponents are dropped; the ask is still recorded. No `CreateHuman` / `EnsureCharacterByName` / `LinkCharacter` on apply.

### Per-file

- `addon/ChurchOfBeef/Core/Gora.lua`  
  `PetitionFromSender(sender, namedOpponentId)` — known names resolve via lookup-only `lookupCharacterId`; unknown senders `{ senderKey, name, eventId }`. `Petition(id)` still refuses name strings / unknown character / unknown opponent. `RecordFavorFromSender` writes `favorPicks[nameKey]`, never `favorPicks[payloadId]`. `GetPetitions` includes unsigned rows without a present-id flag. `Dismiss` accepts a name-key.

- `addon/ChurchOfBeef/Core/Confession.lua`  
  `ReceiveFromSender(sender, text)` — known names call `Receive(id)`; unknown senders sit as a name-key inbox row. No Store mint.

- `addon/ChurchOfBeef/Net/BeefNet.lua`  
  `_HandlePetition` / `_HandleFavor` / `_HandleConfession` ignore payload `characterId`. Petition no longer returns `unknown opponent`. Opponent name is lookup-only; miss → nil, ask still recorded.

- `addon/ChurchOfBeef/UI/Console.lua`  
  `petitionLine` paints `row.name` first, then character name / senderKey. No auto-sanction. Pope-desk `EnsureCharacterByName` on target+verb remains (writer path).

### Pins (verified in tree)

| Pin | Evidence |
|-----|----------|
| Empty store + Zipfresh petition → name-key, Store counts unchanged | `tests/test_gora.lua` Zipfresh block; `tests/test_wire_glue.lua` Task 6 block |
| Spoofed favor `characterId` does not write `favorPicks[thatId]` | `test_gora.lua` unsigned favor; `test_wire_glue.lua` `picks[99] == nil` |
| Unknown opponent still records the ask | Gora + Net + wire_glue |
| `Gora:Petition(id)` suite still refuses names | `test_gora.lua` `Petition("Zipfresh")` |
| Desk paints unsigned display name | `test_console.lua` `findButton(..., "Zipfresh")`; `petitionLine` prefers `row.name` |
| No pew Ensure on apply | BeefNet / Gora have no Ensure/CreateHuman/Link calls |
| Codec stays PROTOCOL 1 this task | `Net/Codec.lua` not in this packet |

## Tests (controller re-run)

```text
lua tests/test_gora.lua        # 544 passed, 0 failed
lua tests/test_console.lua     # 2647 passed, 0 failed
lua tests/test_wire_glue.lua   # 787 passed, 0 failed
lua tests/run.lua              # 16323 passed, 0 failed
```

## Do-not list

No commit. No `ChurchOfBeef.lua` / `DB.lua` / `Hud.lua` / `Codec.lua` for this task. No inbound Proclaim / Sound. #26 not resolved.

## Concerns

1. Implementer flagged unsigned-strip Dismiss passing `row.characterId` (nil). Controller follow-up: strip `onAction` now passes `characterId or senderKey`. Harness pin: click Dismiss retires Zipfresh, Store counts unchanged.
2. Favor INPUT always name-keys (`RecordFavorFromSender`) — brief, not a leftover. #26 unanswered.
3. No client `/reload` smoke. Two-client INPUT still belongs to Task 15.
4. Unsigned confession is name-key inbox only; no confession UI (brief).
