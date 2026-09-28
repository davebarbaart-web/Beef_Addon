# Wave 2 test pin catalog

**Date:** 2026-09-14  
**Source:** `docs/superpowers/plans/2026-09-14-church-of-beef-first-night-wave-2.md` (all Tasks).  
**Scope:** catalog only. Do not implement. Do not edit addon Lua or existing tests.

**Law:** Bible v1.1.1 wins. No congregation `EnsureCharacterByName` / `CreateHuman` / `LinkCharacter`. No inbound `Toasts:Proclaim`. `SCHEMA_VERSION` stays **7**.

**Already inverted:** none.

| Action | Count |
|--------|------:|
| Invert (required; not yet flipped) | **12** |
| Add (no current assertion) | **7** |
| Conditional invert (only if a listed production choice lands) | **2** |

Companion `1:` / `2:` wire literals that must retarget when `PROTOCOL` becomes 2 are **fixtures of I-05**, not extra pins.

---

## Invert (12)

### I-01 — Task 3: unknown slash toggles the card

**File:** `tests/test_wire_glue.lua`  
**Already inverted:** no.

Current:

```lua
assert_eq(cardToggles, 2, "unrecognised arguments toggle the player card")
assert_eq(cardToggles, 3, "retired subcommands fall through to the card")
```

Bare `/beef` still toggles — **keep**:

```lua
assert_eq(cardToggles, 1, "/beef toggles the player card")
```

**Required new pin:** `SlashCmdList["CHURCHOFBEEF"]("anything")` and retired tokens (`petition`, and any other unknown arg) do **not** increment `PlayerCard:Toggle`. They print help or a one-line refuse. Do not advertise `/beef console` to congregation.

---

### I-02 — Task 7: version skew keeps the live event (`test_net_v2`)

**File:** `tests/test_net_v2.lua`  
**Already inverted:** no.

Current (foreign fixture is `"2:STATE:…"` / `"2:SNAPSHOT:…"`):

```lua
assert_eq(Runtime:Snapshot().state, "ASSEMBLY", "version skew does not drop the live event")
```

Nearby keep-as-shape (retarget the foreign major; see I-05): discard still names `"protocol mismatch"`; `_WarnVersion` still fires once; no toast family.

**Required new pin:** after a foreign-major STATE/SNAPSHOT, Event chrome drops to Quiet presentation; Runtime presentation is Quiet (or Event furniture is hidden). §13.4 sentence once per session. No toast kind.

---

### I-03 — Task 7: version skew keeps the live rite (`test_ceremony_chaos`)

**File:** `tests/test_ceremony_chaos.lua`  
**Already inverted:** no.

Current:

```lua
assert_eq(Runtime:Snapshot().state, "RITE", "version skew does not drop the live rite")
assert_eq(Runtime:Snapshot().state ~= "QUIET", true, "this lane does not paint Quiet Mode")
```

**Required new pin:** same as I-02. Flip the Quiet companion: this lane **does** drop to Quiet presentation. Still no toast.

---

### I-04 — Task 7 / 8: extra colon part is always `"unknown field"`

**Files:** `tests/test_net_codec.lua`; `tests/test_net_snapshot.lua`  
**Already inverted:** no. Invert **only** for the allowlisted packed **names** field.

Current:

```lua
refuse(function() return Codec:Decode("1:STATE:1:QUIET::::0:extra") end, "unknown field", "STATE extra wire field")
refuse(function() return Codec:Decode("1:SNAPSHOT:response:1:ASSEMBLY::::0:extra") end,
  "unknown field", "response extra wire field")
```

`test_net_snapshot.lua` request extra stays fail-closed (requests do not grow a names field):

```lua
refuse_apply("1:SNAPSHOT:request:1", "unknown field", "request extra wire field")
```

**Required new pin:** Decode of STATE / SNAPSHOT-response with the packed **names** field succeeds. Any other extra colon part still `"unknown field"`. No clerical kind / beat. `SNAPSHOT_RES_KEYS` allowlists names only.

---

### I-05 — Task 7: `PROTOCOL` stays 1; protocol 2 is the foreign major

**Files:** `tests/test_net_codec.lua`; `tests/test_net_v2.lua`; `tests/test_ceremony_chaos.lua`; `tests/test_net_snapshot.lua`  
**Already inverted:** no.

Current:

```lua
assert_eq(Codec.PROTOCOL, 1, "protocol major stays 1; v2 is the vocabulary")
assert_eq(Net.PROTOCOL, 1, "protocol major stays 1")
assert_eq(quietMsg.version, 1, "every message carries a protocol version")
assert_eq(Codec:IsCompatible(2), false, "protocol 2 is incompatible")
```

Same `"protocol 2 is incompatible"` text also appears in `test_ceremony_chaos.lua` and `test_net_snapshot.lua`. Skew fixtures use `"2:STATE:…"` / `"2:SNAPSHOT:…"` as **foreign**. After the bump those bodies are native.

**Required new pin:** `Codec.PROTOCOL == 2` and `Net.PROTOCOL == 2`. Old v1 bodies are incompatible (`IsCompatible(1) == false`). Foreign-major fixtures must not use `2`. `_WarnVersion` + drop (I-02 / I-03). Retarget every `1:` STATE/SNAPSHOT/INPUT literal in these suites to `2:` as a fixture update, not as a new pin.

---

### I-06 — Task 9: chaos rewind (older snapshot Restores)

**File:** `tests/test_ceremony_chaos.lua`  
**Already inverted:** no.

Header still says “Do NOT invent a monotonic-sequence gate. Older snapshots Restore.”

Current:

```lua
assert_eq(replayed, true, "ApplyResponse of an older snapshot succeeds")
assert_eq(replayErr, nil, "older Apply has no error")
assert_eq(afterOlder.sequence, 1, "leftover: older Apply Restores the earlier sequence")
assert_eq(afterOlder.state, "ASSEMBLY", "leftover: older Apply overwrites later state")
assert_eq(afterOlder.riteType, nil, "leftover: older Apply drops the later rite")
assert_bible(afterOlder, earlySnap, "leftover: Apply has no monotonic-sequence gate")
assert_eq(Runtime:Restore(earlySnap), true, "Restore of an older object succeeds")
assert_eq(Runtime:Snapshot().sequence, 1, "leftover: older Restore also has no sequence gate")
assert_eq(Runtime:Snapshot().state, "ASSEMBLY", "leftover: older Restore overwrites later state")
```

Equal-sequence replay may stay applied (favor overlay uses `>=`). Different `eventId` still applies.

**Required new pin:** ceremony fields apply only if `sequence` is **greater**. Older Apply/Restore leaves later ceremony fields unchanged. Favor overlay applies when `eventId` matches and `sequence >= current`. Equal sequence must not fire theater. Snapshot apply uses the same rule.

---

### I-07 — Task 12: Inputs source forbids `IsRegisteredPope`

**File:** `tests/test_inputs.lua`  
**Already inverted:** no. Five copies of the same scan.

Current:

```lua
assert_eq(src:find("IsRegisteredPope", 1, true), nil, "source has no IsRegisteredPope")
assert_eq(persistSrc:find("IsRegisteredPope", 1, true), nil, "persist source has no IsRegisteredPope")
assert_eq(challengeSrc:find("IsRegisteredPope", 1, true), nil, "source has no IsRegisteredPope")
assert_eq(destSrc:find("IsRegisteredPope", 1, true), nil, "dest-trim source has no IsRegisteredPope")
assert_eq(uqSrc:find("IsRegisteredPope", 1, true), nil, "U-Q source has no IsRegisteredPope")
```

**Required new pin:** `UI/Inputs.lua` **does** call `Sender:IsRegisteredPope` (or the same listed-Pope predicate) so the strip hides on the Pope. Do not mint `localCharacterId` via Store. Do not add congregation `EnsureCharacterByName`.

---

### I-08 — Task 14: pair name click is `DeclareVictor`

**File:** `tests/test_console.lua`  
**Already inverted:** no. The live click is `PairVictorB`; same pin family as `PairVictorA`.

Current:

```lua
-- The pair line's fighter names are clickable verdicts while the Gora lives.
stub.fire(frame.PairVictorB, "OnClick")
assert_eq(Store:GetCharacter(cB.id).gora.wins, 1, "clicking a fighter name declares them victor")
assert_eq(Gora:GetSanctioned(), nil, "the ruling clears the live pair")
```

Name labels themselves may stay (`"pair victor A names fighter A"`).

**Required new pin:** `PairVictorA` / `PairVictorB` OnClick selects the subject only. Wins stay 0; live pair stays. `DECLARE VICTOR` is the commit.

---

### I-09 — Task 6: named opponent missing from Store returns `"unknown opponent"`

**File:** `tests/test_net_v2.lua`  
**Already inverted:** no. `tests/test_gora.lua` has **no** `"unknown opponent"` quote (Core still returns that string for an unknown **id**).

Current:

```lua
assert_eq(nilOk, false, "named-opponent petition without Store is refused")
assert_eq(nilWhy, "unknown opponent", "missing Store names unknown opponent")
assert_eq(emptyOk, false, "named-opponent petition with empty characters is refused")
assert_eq(emptyWhy, "unknown opponent", "empty characters names unknown opponent")
```

**Required new pin:** unknown named opponent is ignored; the ask is still recorded. Do **not** return `"unknown opponent"`. No Store upsert. No congregation `EnsureCharacterByName`.

---

### I-10 — Task 6: inbound INPUT is keyed by payload `characterId`

**File:** `tests/test_net_v2.lua`  
**Already inverted:** no.

Current:

```lua
assert_eq(favorCalls[1].characterId, 2, "RecordFavor receives characterId")
assert_eq(petitionCalls[1].characterId, 12, "Petition receives characterId")
assert_eq(confessionCalls[1].characterId, 3, "Receive receives characterId")
assert_eq(hit.characterId, 12, "resolved Petition receives characterId")
assert_eq(hit.namedOpponentId, 7, "resolved Petition receives namedOpponentId")
```

**Required new pin:** `_HandlePetition` / `_HandleFavor` / `_HandleConfession` ignore payload `characterId`. Key by `Names.Key(sender)`. `RecordFavor` must not write `favorPicks[foreignId]` for a spoofed number. Unknown sender → unsigned name-key row in Gora memory; no `CreateHuman`.

---

### I-11 — Task 12: Inputs header is `EVENT INPUT`

**File:** `tests/test_inputs.lua`  
**Already inverted:** no. Plan: face **Ask to fight**; header is not `EVENT INPUT`.

Current:

```lua
assert_true(src:find('"EVENT INPUT"', 1, true) ~= nil, "source labels the surface")
assert_eq(frame.HeaderText and frame.HeaderText:GetText(), "EVENT INPUT", "panel identifies its purpose")
```

**Required new pin:** header / face is **Ask to fight**. Source must not require the string `EVENT INPUT`.

---

### I-12 — Task 8: congregation pair gated to Gora `RITE` only

**File:** `tests/test_hud.lua`  
**Already inverted:** no.

Current:

```lua
assert_true(goraRiteGates >= 2,
  "livePair and pickPair both gate runtimePair to Gora RITE")
```

`ASSEMBLY without a sanctioned pair stays hidden` stays lawful (no pair yet). Pope `GetSanctioned()` already lives in ASSEMBLY.

**Required new pin:** `livePair` / `pickPair` show an ASSEMBLY **sanction**. Align congregation paint with `GetSanctioned()` on the Pope client. Do not invent inbound Proclaim.

---

## Add (7)

### A-01 — Task 1: `initUi` pcall + Hud fail still reaches `Net:Init`

**File:** `tests/test_wire_glue.lua` (extend).  
**Current:** no pin for forced **Hud** failure or the chat line. Related existing pin is **not** this pin — it throws `Console.Init` and checks later Inits + Net, with **no** chat assert:

```lua
assert_eq(table.concat(order, ","), contractOrder,
  "a throwing Console.Init does not prevent later module Inits")
assert_eq(netInits, 2, "Net Init runs again on the second OnLogin")
```

Production today: Minimap, RecordsBook, PlayerCard, Hud run **bare**; Console/Toasts/DecreeBanner/Sound/FighterCard/Inputs/Markers are `pcall`'d. No `Church of Beef: <module> failed to start.` line.

**Required new pin:** every `Init` in `initUi` is inside `pcall` (source or spy). Forced Hud `Init` error → `Net:Init` still runs. Exactly one chat line `Church of Beef: <module> failed to start.`

---

### A-02 — Task 1: Hud inherit / `_template` source pin

**File:** `tests/test_hud.lua`  
**Current:** no HUD frame `_template` / `BackdropTemplate` / inherit pin. Child font `_template` pins are unrelated.

Production: `CreateFrame("Frame", FRAME_NAME, parent, "BackdropTemplate")`.

**Required new pin:** Hud source names the inherit string actually used (`BackdropTemplate` or none). Stub acceptance is not client proof. Do not invert Inputs BackdropTemplate unless the live 20506 client aborts (C-01).

---

### A-03 — Task 4: `ui.welcomeSeen` + schema 7

**Files:** `tests/test_db.lua`; new `tests/test_welcome.lua` (register in `tests/run.lua`).  
**Current:** no `welcomeSeen` pin. `tests/test_welcome.lua` does not exist.

Already present — **keep, do not bump**:

```lua
assert_eq(ChurchOfBeefDB.version, 7, "schema version is 7")
assert_eq(ChurchOfBeefDB.ui.streamerMode, true, "unknown ui key survives Init")
```

**Required new pin:** missing `ui.welcomeSeen` fills `false`. Unknown `ui` keys still survive. `SCHEMA_VERSION == 7` (no version 8). Welcome Init is `pcall`'d. Flag `welcomeSeen` on close only. Copy must not say “Director Console.” No inbound Proclaim.

---

### A-04 — Task 6: empty pew Store stays empty after login bind

**Files:** `tests/test_wire_glue.lua`; `tests/test_net_v2.lua`; `tests/test_gora.lua`  
**Current:** no congregation-login human/character count pin. `ChurchOfBeef.lua` `bindLocalCharacter` only walks existing Snapshot rows — it does **not** call `EnsureCharacterByName` today. Wave 1 pew-Ensure was never implemented, so there is **no** Ensure pin to invert in these files.

`tests/test_store.lua` `EnsureCharacterByName` is the **Pope** target-verb spine — **keep**. Do not invert it. Do not add a pew `Ensure`.

**Required new pin:** empty congregation Store → **zero** new `humans` / `characters` after login bind. No pew `EnsureCharacterByName` / `CreateHuman` / `LinkCharacter`.

---

### A-05 — Task 8: 240-byte pin through `Net:Send`

**Files:** `tests/test_net_codec.lua`; `tests/test_net_adversarial.lua`  
**Current:** no worst-case **names + favor** `#payload <= 240` pin through `Send` / `_TransmitWhisper`. Codec has no `MAX_BODY` assert. Adversarial only pins a 400-byte HELLO:

```lua
assert_eq(envelopeWhy, "payload too large", "with a reason that names the envelope")
```

**Required new pin:** worst-case fighter/candidate names + favor, encoded then passed through `Net:Send` and/or `_TransmitWhisper`, `#payload <= 240`. Codec round-trip alone is not enough.

---

### A-06 — Task 8: packed names fail-closed on `:`

**File:** `tests/test_net_codec.lua` (and glue if Send is in the path).  
**Current:** none. Confession text may contain colons (keep). Subjects on the wire today are store integers.

**Required new pin:** packed display names for fighters / candidate only. A name containing `:` fail-closes. No Store upsert. `Runtime:Restore` stays Bible fields; Hud / FighterCard paint from inbound name stash when `GetCharacter` is empty.

---

### A-07 — Task 6: unsigned name-key petition / favor

**Files:** `tests/test_gora.lua`; `tests/test_net_v2.lua`; `tests/test_console.lua`  
**Current:** none. Existing Gora pool is character-id keyed (`"the pool is not keyed by a name string"`; `"Petition refuses a name string"`). Those stay until an **unsigned** path exists — do not reuse them as pew-Ensure.

**Required new pin:** unknown sender → unsigned petition/favor row keyed by `Names.Key(sender)`. Desk paints the name. No `CreateHuman`. Pope-only persist (Task 11) may store those name-keys under schema **7**.

---

## Conditional invert (2)

### C-01 — Task 1: Inputs `BackdropTemplate` (only if inherit is dropped)

**File:** `tests/test_inputs.lua`  
**Already inverted:** no. **Do not invert yet.** Plan: invert only if the live 20506 client errors on `CreateFrame(..., "BackdropTemplate")`. Do not claim the template is missing until that happens. `wow_ui_stub` accepts the template and never throws.

Current (keep until a client abort):

```lua
assert_eq(frame._template, "BackdropTemplate", "functional panel uses stock tooltip backdrop support")
assert_eq(frame._template, "BackdropTemplate", "U-Q panel uses stock tooltip backdrop support")
```

**Required new pin if dropped:** `_template` is not `BackdropTemplate` (nil / no inherit). Add A-02 on Hud in the same change.

---

### C-02 — Task 11: `rootKeys` if root `gora` is added

**File:** `tests/test_db.lua`  
**Already inverted:** no. Invert **only** if persist adds root `gora`. `SCHEMA_VERSION` stays 7 either way.

Current:

```lua
assert_eq(rootKeys(ChurchOfBeefDB), "decree,event,store,ui,version", "fresh SV is { version, ui, store, event, decree }")
assert_eq(ChurchOfBeefDB.store.gora, nil, "store hook is not a Gora schema")
```

**Required new pin if root `gora` lands:** `rootKeys` includes `gora`; version stamp stays 7. Congregation must not write `gora = {}` over a shared-account SV. Restore gora **after** event restore.

---

## Not pins (do not invent / do not invert)

| Item | Why |
|------|-----|
| Congregation `EnsureCharacterByName` | OPEN_QUESTIONS **#26**. Wave 1 pew-Ensure never landed. A-04 is the refuse path. |
| `tests/test_store.lua` Ensure suite | Pope target-verb spine. Keep. |
| Inbound `Toasts:Proclaim` / Sound | OPEN_QUESTIONS **#27**. Out of slice. |
| `SCHEMA_VERSION` 8 / existing `version, 7` pins | Keep. Do not invert. |
| `unknown ui key survives Init` | Keep. A-03 only adds `welcomeSeen`. |
| Task 2 leftovers / README / gitignore | Docs only. No test pin. |
| Task 5 / 13 / 14 copy (except I-08, I-11) | Behavior work; plan did not label a pin. |
| Task 10 login split / Task 11 persist API | Required product work; no current quote the plan named to invert. Add tests when implementing; do not gate `DB:Init` on `UnitName`. |
| Task 3 `Show()` + `stubPope()` | Adapt existing `test_console.lua` Show paths when the gate lands. Verbs already pin `"not a registered pope"` — keep that string. Suite header still forbids slash tests. |
| `wow_ui_stub` BackdropTemplate / missing `C_Timer` | Stub-only pins are not client proof. |

---

## Search notes (named suites)

| Term | Where it lives | Catalog |
|------|----------------|---------|
| version skew | `test_net_v2.lua`, `test_ceremony_chaos.lua` | I-02, I-03 |
| BackdropTemplate | `test_inputs.lua` only (not Hud) | C-01; A-02 adds Hud |
| unknown slash | `test_wire_glue.lua` `"unrecognised arguments toggle the player card"` | I-01 |
| EnsureCharacterByName | **not** in the nine named suites; only `tests/test_store.lua` | A-04; do not invert Store |
| extra field | `test_net_codec.lua` `"STATE extra wire field"` / `"response extra wire field"` | I-04 |
| PROTOCOL | `Codec.PROTOCOL` / `Net.PROTOCOL` stay 1; `"protocol 2 is incompatible"` | I-05 |
