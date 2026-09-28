# Task 8 review — Packed display names + 240-byte pin

**Scope (this gate only):** live `Codec` `STATE_KEYS` / `SNAPSHOT_RES_KEYS` `names`; encode always emits the names field; `:` / `\n` refuse; decode 8-part legacy + 9/10; `Snapshot:BuildResponse` names; bootstrap `stateFields` + `stashInboundCast` / `_lastCastNames`; `_HandleState` wrap #111 dismissed flag; Hud stash paint + ASSEMBLY `congregationPair`; FighterCard stash paint; pins in `tests/test_net_codec.lua`, `tests/test_net_adversarial.lua` (`Send` / `_TransmitWhisper`), `tests/test_hud.lua`, `tests/test_wire_glue.lua`. Catalog I-04 and A-06 (A-05 is the 240 Send pin). Budget 112 / 57 / 240.

Must hold: PROTOCOL 2, SCHEMA 7, Interface 20506, no Store upsert / Ensure, no mute-card replica, no clerical beat, I-06 not inverted.

Full `lua tests/run.lua` was not re-run (per gate instruction). Working tree was not mutated except this review file.

**Spec-compliance:** PASS

**Task quality:** Approved

The implementer report matches the live tree. Packed names are one allowlisted field. Encode always emits it. `:` / `\n` fail-closed. 57 / 112 / 124 sit under `MAX_BODY` 240 through `Net:Send` and `_TransmitWhisper`. Inbound names stash on bootstrap; Runtime stays Bible fields; Hud / FighterCard paint the stash when `GetCharacter` is empty. I-04 inverted only for names. I-12 ASSEMBLY pair is live. #111 is the `_HandleState` dismissed flag. I-06 leftovers remain leftovers. `#27` unanswered.

---

## Verdict

Task 8 matches the brief, the 112 / 57 / 240 budget, and pin catalog I-04 / A-05 / A-06 / I-12. Congregation clients can see named fighters without a Store row. The 240 cap was not raised. Mute-card replica and clerical beat stayed off the wire. Task 9 (I-06 latest-wins) is untouched.

---

## Spec Compliance

| Pin | Result | Evidence |
|-----|--------|----------|
| Packed names: `candidateDisplay,fighterA,fighterB`; empty candidate → leading comma | Met | `encodeNames` subjects-mirror. Empty slots stay positional. Encode of a Gora pair is `,Chuckroast,Beefina`. Three 12-letter names round-trip |
| Encode always emits the names field (empty when no subjects) | Met | `encodeStateWire` always appends `body.names or ""`. `"2:STATE:4:RITE:Gora::8,9:3:"` / favor `"…:2,1:"` pin the trailing field so 9 = names and 10 = favor + names |
| Fail-closed on `:` or `\n` (A-06). No escape, no prefix, no send | Met | `nameIllegal` + encode `"invalid names"` for table slots, packed string, and post-`Names.Display`. Confession colon text still allowed. Decode of a colon inside names splits the grammar → `"unknown field"` |
| `Names.Display` (realm stripped) | Met | `encodeNames` / `parseNamesField` / `stateFields` / `Snapshot` overlay all run `COB.Names.Display`. `"Beefina-Whitemane"` encodes `Beefina,,` |
| I-04 invert **only** for allowlisted names; junk / `kind` / `text` / `beat` still `"unknown field"` | Met | `STATE_KEYS` / `SNAPSHOT_RES_KEYS` add `names` only. Decode of `:extra` / `:,Chuck,Beef` succeeds. `:extra:junk` still `"unknown field"`. Encode `kind` / `text` / `beat` still refuse. SNAPSHOT **request** extra and request `names` stay fail-closed |
| Decode accepts 8-part legacy + 9 / 10 | Met | `decodeStateFields`: `#parts == expected` (Task 7 Bible-only); `+1` is names or leftover favor-only (`^%d+,%d+$`); `+2` is favor + names; past that is `"unknown field"`. Foreign `1:STATE:1:QUIET::::0` still decodes as 8-part. New encodes never emit 8-part |
| A-05: worst-case names + favor through `Net:Send` and `_TransmitWhisper`; `#payload <= 240` | Met | Codec pins first-night **57**, fat STATE **112**, fat SNAPSHOT **124**. Adversarial encodes the same fat / first-night bodies and passes them through `N:Send` and `N:_TransmitWhisper`. `MAX_BODY` stays 240 (`BeefNet.lua` Send and whisper). Cap not raised. 400-byte HELLO still `"payload too large"` |
| `stateFields` emits names; inbound stash on bootstrap; no Store upsert | Met | `overlayNames` on `stateFields()`. `stashInboundCast` writes `COB._lastCastNames` / `COB._lastCast` after accepted STATE and SNAPSHOT-response. `test_wire_glue.lua`: human/character counts unchanged; `Runtime:Snapshot().names` is nil |
| `Runtime:Restore` stays Bible fields | Met | `parseEvent` builds only `eventId` / `state` / `riteType` / `subjects` / `sequence` (+ `awaitingPope`). `ApplyResponse` Restores `bibleFields` only. Snapshot suite: named response Apply leaves `names` nil |
| Hud / FighterCard paint stash when `GetCharacter` is empty | Met | Both `fighterFrom` paths use `stashedName(id)` when Store is empty. `test_hud.lua` and `test_fighter_card.lua` pin 12-letter names and no upsert |
| Snapshot `BuildResponse` / `ApplyResponse` carry the same names field; `SNAPSHOT_RES_KEYS` allowlists it | Met | `overlayNames` before `EncodeSnapshot`. Request keys have no `names`. Apply drops names. Isolated snapshot suite + codec request refuse |
| I-12: congregation `livePair` / `pickPair` show ASSEMBLY sanction | Met | Shared `congregationPair()`: ASSEMBLY `runtimePair()`, or RITE + Gora. `goraRiteGates` is gone. Pope still prefers `GetSanctioned()`. ASSEMBLY without a pair stays hidden. Empty-store ASSEMBLY paints and can SendFavor |
| #111: post-verdict `RITE` + lastPair must not re-Show the fighter card | Met | Bootstrap `_HandleState` wrap: CONSEQUENCE Hide + `_fighterCardDismissed = true`; later RITE + two fighters Shows only if dismissed is not true. `test_wire_glue.lua` pins Show count stays 1. Self-echo still skips the card branch |
| PROTOCOL 2; SCHEMA 7; Interface 20506 | Met | `Codec.PROTOCOL = 2`, `Net.PROTOCOL = 2`. `DB.lua` `SCHEMA_VERSION = 7`. TOC `## Interface: 20506` |
| I-06 not inverted | Met | `test_ceremony_chaos.lua` header still “Do NOT invent a monotonic-sequence gate.” Older Apply/Restore still overwrite later CONSEQUENCE / seq 3 / Gora |
| No mute-card replica; no clerical beat; `#27` unanswered | Met | STATE/SNAPSHOT keys have no W/L, H2H, title, stipulation, `kind`, or `beat`. Encode `"STATE does not carry a clerical beat"`. Inbound STATE does not `Toasts:Proclaim` (Pope verb wraps only). `OPEN_QUESTIONS.md` #27 still unanswered |
| Do-not: commit, Store upsert / Ensure, Console/DB unless required | Met | Stash path has no `EnsureCharacterByName` / `CreateHuman` / `LinkCharacter`. Report: no commit. Stash lives on bootstrap + Hud + FighterCard |

---

## Strengths

- I-04 is a real invert, not a blanket extra-field open. Names decode; a second extra colon, request extras, and `kind` / `text` / `beat` keys still fail-closed.
- The 240 pin is on the envelope. Fat 112 and first-night 57 go through `Send` and `_TransmitWhisper`, not codec `#` alone. `MAX_BODY` is still 240 on both paths.
- Always-emit names keeps 9 vs 10 unambiguous. Empty candidate is a leading comma, so leftover P2 clients that still send 8-part or 9-part favor-only do not fail closed.
- Stash is display-only. Ids stay on Runtime. Empty Store does not mint. That is the #26 refuse path, not a pew Ensure.
- ASSEMBLY `congregationPair` matches Pope `GetSanctioned()` timing without inventing inbound Proclaim. Knighting leftover fighters still do not paint or SendFavor.
- #111 is pinned on the live inbound wrap (CONSEQUENCE → leftover RITE), which is where the card was coming back.

---

## Issues

### Critical

None.

### Important

None.

### Minor

1. **Legacy 8-part and 9-part favor-only are code-true, weakly pinned.** Decode accepts them (`decodeStateFields` + foreign `1:STATE:1:QUIET::::0`). New encodes always emit names, so those shapes are leftover-P2 only. There is no dedicated native `"2:STATE:…:2,1"` (favor, no names) assert.

2. **SNAPSHOT inbound stash is implemented, not named-suite pinned.** `_HandleSnapshot` re-decodes the payload and `stashInboundCast`s. `test_wire_glue.lua` pins STATE stash only. Isolated snapshot suite pins Apply does not Restore names.

3. **Fat SNAPSHOT (124) is codec-sized, not whispered.** A-05’s envelope pin uses fat **STATE** through Send / `_TransmitWhisper`. 124 would pass the same 240 check; it is not the body they sent.

4. **#111 is a bootstrap dismissed flag, not a `FighterCard:Show()` change.** ESC Hide + Show still restores `lastPair` (report leftover). Late-joiner SNAPSHOT still does not Show the card; names are stashed so HUD/card paint if something else Shows.

5. **`test_net_adversarial.lua` A-05 only runs under `lua tests/run.lua`.** The file has no standalone `assert_eq` wrap (report leftover). Isolated `lua tests/test_net_adversarial.lua` is not a pin.

6. **No in-game `/reload` smoke this pass.** UI + Net were touched. Harness counts in the report (16443 / 0) were not re-checked.

---

## Assessment

**PASS / Approved.**

Packed display names + the 240 envelope pin are in the tree. I-04 / A-05 / A-06 / I-12 hold. I-06 rewind leftovers remain Task 9. `#27` stays unanswered. SCHEMA 7. Interface 20506. No pew Ensure. No mute-card replica. No clerical beat.

Do not claim `POLISH:PASS`.
