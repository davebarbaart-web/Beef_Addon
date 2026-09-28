# Task 6 review — Sender-keyed INPUT + unsigned desk

**Scope (this gate only):** live `Gora:PetitionFromSender` / `RecordFavorFromSender` / `GetPetitions` / `Petition(id)` refuse; `Confession:ReceiveFromSender`; BeefNet `_HandlePetition` / `_HandleFavor` / `_HandleConfession`; Console `petitionLine`; Zipfresh / spoofed-favor pins in `tests/test_gora.lua`, `tests/test_wire_glue.lua`, `tests/test_console.lua`.

OPEN_QUESTIONS **#26** is not resolved. Full `lua tests/run.lua` was not re-run (per gate instruction).

**Spec-compliance:** PASS

**Task quality:** Approved

The implementer report matches the live tree. INPUT apply keys by server sender. Payload `characterId` is ignored. Unknown senders sit as unsigned name-key rows. Unknown named opponents are dropped; the ask is still recorded. No Pope-side `Ensure` on apply. Codec stays PROTOCOL 1.

---

## Verdict

Task 6 matches Wave 2 review §2.1 and the Task 6 brief. Congregation apply does not mint. The Pope desk paints Zipfresh. `Gora:Petition(id)` still refuses name strings. Favor from a spoofed id does not write `favorPicks[thatId]`. `#26` stays the refuse path (unsigned desk), not an answer.

---

## Spec Compliance

| Pin | Result | Evidence |
|-----|--------|----------|
| Empty store + Zipfresh petition → name-key; Store counts unchanged | Met | `Gora:PetitionFromSender` writes `{ senderKey, name, eventId }` at `petitions[key]`. `test_gora.lua` Zipfresh block: humans/characters stay 0. `test_wire_glue.lua` Task 6: inbound `1:INPUT:petition:99:Nobody` from `"Zipfresh"` lands `senderKey = "zipfresh"`, `characterId` nil |
| `_HandlePetition` / `_HandleFavor` / `_HandleConfession` ignore payload `characterId`; key by `Names.Key(sender)` | Met | Handlers never read `decoded.characterId`. Petition/favor/confession call `*FromSender(sender, …)`. `test_net_v2.lua` spies the server sender |
| Unknown sender: unsigned petition/favor row; no `CreateHuman` | Met | Unknown petition is a name-key row. `RecordFavorFromSender` writes `favorPicks[key]`. Comments + source have no `Ensure` / `CreateHuman` / `LinkCharacter` |
| Unknown named opponent: ignore, still record; do not return `unknown opponent` | Met | `resolveOpponentId` miss → nil; `_HandlePetition` still `PetitionFromSender`. `test_net_v2.lua` Store-nil / empty-characters pins accept. `Petition(id)` still returns `"unknown opponent"` on the id path |
| Spoofed favor `characterId` does not write `favorPicks[thatId]` | Met | `test_gora.lua` `picks[99] == nil`; `test_wire_glue.lua` same after `characterId = 99` |
| `Gora:Petition(id)` still refuses name strings / unknown character | Met | `isId` + `knownCharacter`. `Petition("Zipfresh")` still refuses. Existing id-path suite unchanged |
| Desk `GetPetitions` / paint includes unsigned display name | Met | Unsigned rows skip the present-id flag. `petitionLine` prefers `row.name`. `test_console.lua` `findButton(..., "Zipfresh")` |
| No pew / apply `EnsureCharacterByName` / `CreateHuman` / `LinkCharacter` | Met | Zero call sites in BeefNet / Gora / Confession apply. Lookups walk `Store:Snapshot().characters` only. Console `EnsureCharacterByName` stays on `ensureSubjectId` (target + verb) |
| Codec stays PROTOCOL 1 (Task 7 has not landed) | Met | `Net/Codec.lua` `PROTOCOL = 1`. INPUT body may still carry `characterId` |
| Do not resolve #26; no Pope-side Ensure on apply | Met | `OPEN_QUESTIONS.md` #26 still unanswered. Apply paths do not Ensure |
| No inbound `Toasts:Proclaim` / Sound | Met | INPUT handlers do not toast or play sound |
| Do-not files for this task | Met | `ChurchOfBeef.lua` has no `EnsureCharacterByName`. Codec not bumped |

---

## Strengths

- Sender-keyed verbs sit beside the existing id APIs. `Petition` / `RecordFavor` / `Receive` keep the old refuses; INPUT does not teach them to accept arbitrary strings as ids.
- Known senders resolve by lookup only (`Names.Same` on Snapshot). A hit reuses `Petition(id)` / `Receive(id)`. A miss stays unsigned. No silent link.
- Favor always keys by name-key, including known names. The spoofed numeric payload cannot steal `favorPicks[foreignId]`. `favorSplitFor` still counts those picks.
- B17-B `"unknown opponent"` refuse is inverted on the wire without dropping the ask. Opponent resolve stays lookup-only.
- Desk paint is name-first. Strip Dismiss passes `row.characterId or row.senderKey`. Sanction stays a separate Pope verb.
- Pins are real inversions: empty-store Zipfresh, spoofed id 99, missing Store still `PetitionFromSender`.

---

## Issues

### Critical

None.

### Important

None.

### Minor

1. **Unsigned petition row-click clears the working subject.** Strip `onRow` is `SelectCharacter(row.characterId)`. For a name-key row that id is nil, and `SelectCharacter(nil)` clears the subject. Paint and Dismiss still work. OQ26 Option A’s “fill an empty fighter slot by name” is not a Task 6 pin and is not a #26 answer.

2. **`tests/test_confession.lua` has no `ReceiveFromSender` pin.** Live `ReceiveFromSender` is lookup-only and mints nothing. `test_net_v2.lua` spies the Net dispatch. An empty-store confession Store-count pin is missing. Brief asked no confession UI.

3. **`Confession:Dismiss` / `CallForward` stay id-only.** Unsigned inbox rows cannot be retired through those verbs. Out of scope for this desk task.

4. **`Gora:Dismiss` name-key is implemented, not pinned** in the Zipfresh block. Console strip uses the senderKey fallback.

---

## Assessment

**PASS / Approved.**

Night-one refuse path for #26 is in the tree: unsigned desk, no congregation mint, no Pope-side Ensure on INPUT. Task 7 (PROTOCOL 2) has not landed. Leftovers are strip-click subject clear, confession Core pins, and id-only confession retire — not fix-before-pass.

Full harness counts in the report (16323 / 0) were not re-checked. No client `/reload` smoke. Do not claim `POLISH:PASS`.
