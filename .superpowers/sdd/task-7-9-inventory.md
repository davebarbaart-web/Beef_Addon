# Wave 2 Tasks 7–9 — read-only inventory

**Date:** 2026-09-14  
**Checkout:** `/Volumes/AI_Design_Drive/Beef_Addon`  
**Scope:** live tests + `Net/BeefNet.lua` + `Net/Codec.lua` + `Net/Snapshot.lua` + `Core/Runtime.lua`. No addon Lua edited.

Companion plan notes: `docs/superpowers/plans/2026-09-14-wave-2-pin-catalog.md` (I-02, I-03, I-05, I-06); `docs/superpowers/plans/2026-09-14-wave-2-code-freshness.md` Task 7.

---

## 1. Pins that lock the *local* protocol as `1`

Two classes:

- **Constant / compatibility** — `PROTOCOL == 1`, “protocol major stays 1”, `IsCompatible(1)`.
- **Local emit** — encode/send expected bodies that start with `1:HELLO` / `1:STATE` / `1:INPUT` / `1:SNAPSHOT`.

Refuse fixtures that *decode* a `1:` body to test another error (invalid role, extra field, …) are **local-major fixtures**, not extra PROTOCOL pins. They are listed in §1.5 because Task 7 / I-05 must retarget them when the major bumps. Foreign-major fixtures (`2:…`, `0:…`) are **not** local-protocol pins.

`tests/test_ceremony_chaos.lua` does **not** assert `Codec.PROTOCOL` or `Net.PROTOCOL`. `tests/test_net_adversarial.lua` has no PROTOCOL / `1:HELLO|STATE|INPUT|SNAPSHOT` pins.

### 1.1 Constant / compatibility

| File:line | Assertion message |
|-----------|-------------------|
| `tests/test_net_codec.lua:72` | `protocol major stays 1; v2 is the vocabulary` (`Codec.PROTOCOL`, `1`) |
| `tests/test_net_v2.lua:193` | `protocol major stays 1` (`Net.PROTOCOL`, `1`) |
| `tests/test_net_validate.lua:41` | `this cut does not invent a v2 protocol number` (`N.PROTOCOL`, `1`) |
| `tests/test_net_snapshot.lua:499` | `protocol major stays on Codec` (`Snapshot.PROTOCOL`, `nil`) |
| `tests/test_net_codec.lua:523` | `this protocol is compatible` (`Codec:IsCompatible(1)`, `true`) |
| `tests/test_net_codec.lua:143` | `every message carries a protocol version` (decoded STATE `version`, `1`) |
| `tests/test_net_codec.lua:237` | `request carries a protocol version` (decoded SNAPSHOT request `version`, `1`) |
| `tests/test_net_codec.lua:288` | `petition carries a protocol version` (decoded INPUT `version`, `1`) |
| `tests/test_net_snapshot.lua:231` | `ASSEMBLY response carries protocol 1` (decoded SNAPSHOT response `version`, `1`) |
| `tests/test_net_validate.lua:48` | `the version is read back` (transport HELLO `version`, `1`) |

Related (not a `1:` type, same local major): `tests/test_net_codec.lua:425` `decree carries a protocol version` (`version`, `1`).

Production constants (not tests): `addon/ChurchOfBeef/Net/Codec.lua:9` `PROTOCOL = 1`; `addon/ChurchOfBeef/Net/BeefNet.lua:31` `PROTOCOL = 1`. Both `IsCompatible` implementations are `finite(version) == self.PROTOCOL`.

### 1.2 Encode / send pins — local body is `1:HELLO`

| File:line | Assertion message | Expected |
|-----------|-------------------|----------|
| `tests/test_net_validate.lua:44` | `payload is version, type, then fields` | `1:HELLO:0.1.0` |
| `tests/test_net_v2.lua:232` | `HELLO framing is unchanged` | `1:HELLO:0.1.0` |
| `tests/test_net_v2.lua:1336` | `HELLO is still the transport type` | `1:HELLO:0.1.0` |

### 1.3 Encode / send pins — local body is `1:STATE`

| File:line | Assertion message | Expected |
|-----------|-------------------|----------|
| `tests/test_net_codec.lua:139` | `STATE wire starts with version and type` | prefix `1:STATE:` |
| `tests/test_net_codec.lua:774` | `STATE without favor stays eight fields` | `1:STATE:4:RITE:Gora::8,9:3` |
| `tests/test_net_codec.lua:784` | `STATE favor is countA,countB after sequence` | `1:STATE:4:RITE:Gora::8,9:3:2,1` |

`tests/test_net_v2.lua` builds STATE via `state_wire()` → `Codec:EncodeState` and does **not** `assert_eq` the exact `1:STATE:…` string. After a PROTOCOL bump those bodies change with the codec.

### 1.4 Encode / send pins — local body is `1:INPUT`

| File:line | Assertion message | Expected |
|-----------|-------------------|----------|
| `tests/test_net_codec.lua:300` | `petition still has four wire parts` | `1:INPUT:petition:3` |
| `tests/test_net_codec.lua:305` | `favor wire is kind, picker, pick` | `1:INPUT:favor:8:9` |
| `tests/test_net_codec.lua:339` | `named petition is five wire parts` | `1:INPUT:petition:3:Chuckroast` |
| `tests/test_net_codec.lua:352` | `unified Encode accepts petition opponent` | `1:INPUT:petition:3:Chuckroast` |
| `tests/test_net_codec.lua:358` | `opponent is trimmed on encode` | `1:INPUT:petition:3:Chuckroast` |
| `tests/test_net_codec.lua:364` | `empty opponent is omitted` | `1:INPUT:petition:3` |
| `tests/test_net_codec.lua:366` | `whitespace opponent is omitted` | `1:INPUT:petition:3` |
| `tests/test_net_v2.lua:520` | `SendFavor encodes favor+pick` | `1:INPUT:favor:2:1` |
| `tests/test_net_v2.lua:556` | `SendPetition encodes petition+id only` | `1:INPUT:petition:12` |
| `tests/test_net_v2.lua:578` | `SendConfession encodes confession+text` | `1:INPUT:confession:3:free text` |
| `tests/test_net_v2.lua:587` | `SendConfession encodes id without text` | `1:INPUT:confession:3` |
| `tests/test_net_v2.lua:728` | `SendPetition padded dest has no dest on INPUT` | `1:INPUT:petition:12` |
| `tests/test_net_v2.lua:734` | `SendConfession padded dest has no dest on INPUT` | `1:INPUT:confession:3:free text` |
| `tests/test_net_v2.lua:747` | `SendFavor padded dest has no dest on INPUT` | `1:INPUT:favor:2:1` |
| `tests/test_net_v2.lua:881` | `SendConfession encodes trimmed text` | `1:INPUT:confession:3:forgive me` |
| `tests/test_net_v2.lua:892` | `SendConfession whitespace text omits text` | `1:INPUT:confession:3` |
| `tests/test_net_v2.lua:899` | `SendConfession empty text omits text` | `1:INPUT:confession:3` |
| `tests/test_net_v2.lua:910` | `SendConfession no-text payload stays` | `1:INPUT:confession:3` |
| `tests/test_net_v2.lua:923` | `SendConfession padded dest still has no dest on INPUT` | `1:INPUT:confession:3:free text` |
| `tests/test_net_v2.lua:1178` | `SendPetition encodes petition+id+opponent name` | `1:INPUT:petition:12:Chuckroast` |
| `tests/test_net_v2.lua:1192` | `SendPetition does not copy namedOpponentId onto the wire` | `1:INPUT:petition:12:Chuckroast` |
| `tests/test_net_v2.lua:1363` | `listed-Pope Petition body is unchanged` | `1:INPUT:petition:12` |
| `tests/test_net_v2.lua:1369` | `listed-Pope SendFavor body is unchanged` | `1:INPUT:favor:2:1` |
| `tests/test_net_v2.lua:1374` | `listed-Pope SendConfession body is unchanged` | `1:INPUT:confession:3:free text` |

Nearby decode-of-literal (same local prefix, not encode): `tests/test_net_v2.lua:758–760` (`petition kind is unchanged` / `favor kind is unchanged` / `confession kind is unchanged`) decode `1:INPUT:petition:12`, `1:INPUT:favor:2:1`, `1:INPUT:confession:3:free text`.

### 1.5 Encode / send pins — local body is `1:SNAPSHOT`

| File:line | Assertion message | Expected |
|-----------|-------------------|----------|
| `tests/test_net_codec.lua:233` | `SNAPSHOT wire starts with version and type` | prefix `1:SNAPSHOT:` |
| `tests/test_net_snapshot.lua:168` | `Request wire is role only` | `1:SNAPSHOT:request` |
| `tests/test_net_snapshot.lua:187` | `Request mid-rite is still role only` | `1:SNAPSHOT:request` |
| `tests/test_net_snapshot.lua:191` | `Request ignores leftover args` | `1:SNAPSHOT:request` |
| `tests/test_ceremony_chaos.lua:185` | `Request wire is role only` | `1:SNAPSHOT:request` |
| `tests/test_net_v2.lua:408` | `Request wire is role only` | `1:SNAPSHOT:request` |
| `tests/test_net_v2.lua:625` | `RequestSnapshot encodes request role only` | `1:SNAPSHOT:request` |
| `tests/test_net_v2.lua:741` | `RequestSnapshot padded dest body is unchanged` | `1:SNAPSHOT:request` |
| `tests/test_net_v2.lua:753` | `_TransmitWhisper padded dest body is unchanged` | `1:SNAPSHOT:request` |
| `tests/test_net_v2.lua:845` | `SendSnapshot has no dest on SNAPSHOT` | `1:SNAPSHOT:request` |
| `tests/test_net_v2.lua:1381` | `listed-Pope RequestSnapshot body is unchanged` | `1:SNAPSHOT:request` |

`tests/test_net_snapshot.lua` `encode_expected()` / `encode_overlay()` call `Codec:EncodeSnapshot` and compare whole wires. They do not hard-code `1:`; they inherit `Codec.PROTOCOL`.

### 1.6 Local-major decode / refuse fixtures (I-05 retarget, not extra PROTOCOL pins)

These treat `1:` as the well-formed local major while testing another rule. After a bump they must become `2:` (or whatever the new local major is). Foreign fixtures stay non-`1`.

**`tests/test_net_codec.lua`**

| Line | Message | Body |
|------|---------|------|
| 353 | `DecodeInput accepts petition opponent` | `1:INPUT:petition:3:Chuckroast` |
| 361 | (decode; opponent trim) | `1:INPUT:petition:3: Chuckroast ` |
| 367–374 | empty/whitespace fifth part | `1:INPUT:petition:3:` / `1:INPUT:petition:3:   ` |
| 376 | `fifth petition part is a legal opponent` | `1:INPUT:petition:1:please` |
| 414 | `petition sixth part` | `1:INPUT:petition:1:please:extra` |
| 540 | `wire ask` | `1:SNAPSHOT:ask` |
| 541 | `wire REQUEST` | `1:SNAPSHOT:REQUEST` |
| 547 | `wire Petition` | `1:INPUT:Petition:1` |
| 548 | `wire theater` | `1:INPUT:theater:1` |
| 595 | `wire birthday` | `1:STATE:1:RITE:birthday:::1` |
| 596 | `wire free-text rite` | `1:STATE:1:RITE:Knighting Extra:::1` |
| 603 | `wire RITE without a type` | `1:STATE:1:RITE::::1` |
| 616 | `wire LIVE` | `1:STATE:1:LIVE::::0` |
| 657 | `wire name candidate` | `1:STATE:1:QUIET::Beefina::0` |
| 658 | `wire bad fighter` | `1:STATE:1:RITE:Gora::4,x:1` |
| 664 | `wire name character` | `1:INPUT:petition:Beefina` |
| 680 | `wire favor without pick` | `1:INPUT:favor:8` |
| 681 | `wire favor non-id pick` | `1:INPUT:favor:1:red` |
| 682 | `wire favor text after pick` | `1:INPUT:favor:1:2:red` |
| 752 | `response extra wire field` | `1:SNAPSHOT:response:1:ASSEMBLY::::0:extra` |
| 754 | `STATE extra wire field` | `1:STATE:1:QUIET::::0:extra` |
| 755 | `request extra wire field` | `1:SNAPSHOT:request:1` |
| 843–845 | (no-send smoke; no message) | `1:STATE:1:QUIET::::0`, `1:SNAPSHOT:request`, `1:INPUT:confession:1:hello` |

**`tests/test_net_snapshot.lua`**

| Line | Message | Body |
|------|---------|------|
| 376–377 | `ApplyResponse refuses a request wire` / `request wire is not response` | `1:SNAPSHOT:request` |
| 423 | `ask is not a role` | `1:SNAPSHOT:ask` |
| 424 | `REQUEST is not a role` | `1:SNAPSHOT:REQUEST` |
| 425 | `reply is not a role` | `1:SNAPSHOT:reply` |
| 426 | `response missing STATE fields` | `1:SNAPSHOT:response` |
| 427 | `request extra wire field` | `1:SNAPSHOT:request:1` |
| 433 | `HELLO is not applied` | `1:HELLO` |
| 434 | `INPUT is not a snapshot` | `1:INPUT:petition:3` |
| 445 | `CONSEQUENCE without a rite type is not restored` | `1:SNAPSHOT:response:1:CONSEQUENCE::::1` |
| 447 | `ASSEMBLY with a rite type is not restored` | `1:SNAPSHOT:response:1:ASSEMBLY:Gora:::1` |
| 449 | `QUIET with a candidate is not restored` | `1:SNAPSHOT:response:1:QUIET::5::0` |
| 451 | `free-text rite type is not restored` | `1:SNAPSHOT:response:1:RITE:Builder:::1` |
| 453 | `sixth state is not restored` | `1:SNAPSHOT:response:1:AWAITING_POPE::::1` |
| 483 | (no-send smoke) | `1:SNAPSHOT:request` |

**`tests/test_ceremony_chaos.lua`**

| Line | Message | Body |
|------|---------|------|
| 493 | `HELLO does not Apply` | `1:HELLO` |
| 551 | (no-send smoke) | `1:HELLO` |

**`tests/test_net_validate.lua`** retired-type delivers use `1:RANK_COMMIT` / `1:SYNC_*` / `1:SUGGESTION` (transport major 1, not Codec STATE/INPUT/SNAPSHOT).

**`tests/test_net_v2.lua`** also *calls* `_TransmitWhisper("1:SNAPSHOT:request", …)` at 680 / 703 / 706 / 749 (dest refuse; not `assert_eq` of local emit). Inbound named-petition fixture `namedWire = "1:INPUT:petition:12:Chuckroast"` at 1210.

---

## 2. “Version skew does not drop the live event” pins

Exact phrase **only** here:

| File:line | Assertion |
|-----------|-----------|
| `tests/test_net_v2.lua:1280` | `assert_eq(Runtime:Snapshot().state, "ASSEMBLY", "version skew does not drop the live event")` |

Sister pin (same leftover: foreign major discarded, live Runtime stays Event Mode):

| File:line | Assertion |
|-----------|-----------|
| `tests/test_ceremony_chaos.lua:448` | `assert_eq(Runtime:Snapshot().state, "RITE", "version skew does not drop the live rite")` |
| `tests/test_ceremony_chaos.lua:449` | `assert_eq(Runtime:Snapshot().state ~= "QUIET", true, "this lane does not paint Quiet Mode")` |

### Setup around those pins (not the invert phrase, but the block)

**`test_net_v2.lua` 1252–1287** (after `Runtime:StartEvent()` → ASSEMBLY):

- Foreign fixtures: `"2:STATE:1:ASSEMBLY::::1"`, `"2:SNAPSHOT:response:1:ASSEMBLY::::1"`, then `"0:STATE:1:RITE:Gora::3,4:2"`.
- Nearby keep-as-shape: `incompatible STATE is discarded` (1266), `incompatible STATE names the mismatch` (1267, `"protocol mismatch"`), `incompatible STATE is the Quiet version notice` (1268), `incompatible STATE chats once` (1269), `incompatible STATE does not Restore` (1270), SNAPSHOT twins (1274–1279), `_WarnVersion(2)` still once (1277), `no second Quiet notice` (1278).
- Protocol 0: discarded / mismatch / same Quiet notice; `protocol 0 does not Restore` leaves `QUIET` because that block `reset()`s first (1282–1287) — it does **not** re-assert the live-event leftover.

**`test_ceremony_chaos.lua` 424–454** (after `StartEvent` + `OpenRite("Proclamation")` → RITE):

- Foreign: `"2:SNAPSHOT:response:1:ASSEMBLY::::1"` then `"0:SNAPSHOT:response:1:RITE:Gora::3,4:2"`.
- `ApplyResponse refuses an incompatible version` / `incompatible version fails closed` (`"protocol mismatch"`).
- `foreign-major SNAPSHOT does not Restore` (447); protocol 0 twins (452–454).
- This suite does **not** load BeefNet; no `_WarnVersion` chat. Pins: `Runtime has no toast` / `Runtime has no WarnVersion` / `Runtime has no _WarnVersion` (432–434).

Pin catalog invert targets: I-02 (`test_net_v2.lua:1280`), I-03 (`test_ceremony_chaos.lua:448–449`). After invert, Event chrome must drop to Quiet presentation; §13.4 sentence once; no toast family.

---

## 3. `Net:_WarnVersion` today

**Function:** `Net:_WarnVersion(version)` at `addon/ChurchOfBeef/Net/BeefNet.lua:523–530`.

**Once-per-session flag:** `self.warnedVersion` (boolean). First call sets it `true` and chats. Later calls return `false` without chatting.

**Chat helper:** local `chat(text)` at `BeefNet.lua:140–144`. If `DEFAULT_CHAT_FRAME.AddMessage` exists:

```lua
DEFAULT_CHAT_FRAME:AddMessage("|cffffaa00Church of Beef|r: " .. text)
```

**Current body string** (the `string.format` argument, not the gold prefix):

```
a guildmate is running BeefNet v%s; this client speaks v%d. Update for matching addon messages.
```

`%s` = `tostring(version)` (peer / foreign major). `%d` = `self.PROTOCOL` (local; today `1`).

**Rendered line** (prefix + body), e.g. first HELLO mismatch with version `2`:

```
|cffffaa00Church of Beef|r: a guildmate is running BeefNet v2; this client speaks v1. Update for matching addon messages.
```

Not Bible §13.4 (“the Church's software has advanced”). Suites pin once-per-session / discard; **no test asserts this sentence**.

**Returns:** `true` on first fire, `false` if `warnedVersion` is already set.

**Cleared:** `Net:ResetForTests()` sets `self.warnedVersion = nil` (`BeefNet.lua:923`).

**Call sites (after incompatible):**

| Site | File:line | When |
|------|-----------|------|
| `Net:HandleHello` | 568–570 | transport HELLO, `not IsCompatible(message.version)` |
| `Net:OnAddonMessage` | 614–616 | `TYPES` path (`HELLO` only); same mismatch → `"protocol mismatch"` |
| `Net:_HandleV2` | 644–646 | Codec STATE / SNAPSHOT / DECREE / INPUT; same → `"protocol mismatch"` |

HELLO mismatch warns in `HandleHello` **and** the `TYPES` gate can warn first. STATE/SNAPSHOT/INPUT mismatch warns only in `_HandleV2` (STATE is not in transport `TYPES`).

**Does not:** toast, `NotifyStatus`, Hide Event chrome, `Runtime:Restore` QUIET, wipe Store. Mismatch is discard + one chat.

---

## 4. How inbound STATE is applied

**No sequence compare. No favor overlay on apply.** Last accepted Restore wins.

### 4.1 BeefNet path

`OnAddonMessage` (`BeefNet.lua:596–624`):

1. Prefix must be `COB`. Channel `GUILD` or `WHISPER` (RAID/other die).
2. Non-self senders spend the inbound token bucket; flood → `"sender is talking too fast"` (unread).
3. Transport `Decode`. Retired types (`RANK_COMMIT`, `SYNC_*`, `SUGGESTION`) die unread.
4. Transport `TYPES` is `{ HELLO = true }` only. STATE is **not** HELLO; it falls through to `_HandleV2`.

`_HandleV2` (`627–655`):

1. `Codec:Decode(payload)`.
2. Type must be STATE / SNAPSHOT / DECREE / INPUT.
3. INPUT on GUILD → `"unknown message type"`.
4. `Codec:IsCompatible(decoded.version)` else `_WarnVersion` + `"protocol mismatch"`.
5. STATE: if `Sender:Accept(sender, "STATE")` then `self._lastStateSender = sender` (raw string). Then `_HandleState`.

`_HandleState` (`674–695`):

1. Channel must be `self.Channel` (`GUILD`). WHISPER/RAID STATE → `false` (no Restore).
2. `Sender:Accept(sender, "STATE")` again. Unstubbed `Accept` for STATE is `IsRegisteredPope` (`Core/Sender.lua:72–73`) → **false** unless listed Pope / `popeOverrides`. Refuse → `"not accepted"`.
3. `Runtime:Restore({ eventId, state, riteType, subjects, sequence })` only.

**Favor is decoded by Codec and dropped here.** `_HandleState` does not pass `decoded.favor`. Comment: “Bible fields only. Do not encode or Restore awaitingPope.”

`SendState` (`363–375`) is Pope-gated encode + GUILD send. It does not apply locally.

### 4.2 Runtime:Restore

`Core/Runtime.lua:185–191`: `parseEvent(snap)` then **replace** the live event object. `nextEventId = (parsed.eventId or 0) + 1`.

`parseEvent` (`117–167`) validates state / event id / sequence / rite / subjects. Sequence must be a valid seq (`isSeq`); it is **not** compared to `current().sequence`. Older, equal, or newer all overwrite if the snapshot is well-formed.

Runtime event has no `favor` field. Extra keys (`favor`, `holdSeconds`, …) are ignored (`test_runtime.lua`: Restore ignores extras).

### 4.3 Snapshot catch-up (not STATE, same Restore)

`Snapshot:ApplyResponse` (`Net/Snapshot.lua:135–144`): DecodeSnapshot → `IsCompatible` → role `response` → `Runtime:Restore(bibleFields(msg))`.

`BIBLE = { "eventId", "state", "riteType", "subjects", "sequence" }`. **Favor stays off Restore** (file header lines 9–10; `test_net_snapshot.lua` `Restore does not keep favor`).

`BuildResponse` **may** overlay Gora live/last pair and toggle-gated favor onto the **encoded** SNAPSHOT only. Runtime is not mutated on build.

### 4.4 What the harness actually applies

Default `test_net_v2` inbound STATE: Accept false → discard, no Restore (`316–336`).

Lane W stub (`test_net_v2.lua:1490–1501`): `Sender.Accept = function() return true end` then GUILD STATE → `accepted STATE restores` / `a second accepted STATE restores`. Those pins check `_lastStateSender`, not sequence monotonicity or favor.

---

## 5. `STATE_KEYS` and `SNAPSHOT_RES_KEYS`

From `addon/ChurchOfBeef/Net/Codec.lua:27–54`. Locals (not on `Codec.`). `firstUnknown(fields, allowlist)` → `"unknown field"`.

### `STATE_KEYS` (lines 27–36)

| Key | Role |
|-----|------|
| `type` | encode stamp / closed-set |
| `version` | optional on encode; must match `PROTOCOL` if present |
| `eventId` | Bible |
| `state` | Bible |
| `riteType` | Bible |
| `subjects` | Bible (`candidate`, `fighters` only) |
| `sequence` | Bible |
| `favor` | optional `{ a, b }` after sequence on the wire |

**Not allowlisted:** `names`, `role`, `kind`, `text`, `schema`, `holdSeconds`, `awaitingPope`, `dest`. Extra colon part after optional favor → `"unknown field"` (`test_net_codec.lua:754`).

Wire without favor: `VERSION:STATE:eventId:state:riteType:candidate:fighters:sequence` (eight fields). With favor: ninth `countA,countB`.

### `SNAPSHOT_RES_KEYS` (lines 44–54)

| Key | Role |
|-----|------|
| `type` | encode stamp |
| `version` | same as STATE |
| `role` | must be `response` |
| `eventId` | same as STATE |
| `state` | same as STATE |
| `riteType` | same as STATE |
| `subjects` | same as STATE |
| `sequence` | same as STATE |
| `favor` | same optional split |

**Not allowlisted:** `names`, `schema`, `holdSeconds`, `awaitingPope`, `dest`. Extra colon on response → `"unknown field"` (`test_net_codec.lua:752`).

Sibling **`SNAPSHOT_REQ_KEYS`** (38–42): `type`, `version`, `role` only. Request wire is `VERSION:SNAPSHOT:request`. Extra part → `"unknown field"`. Request cannot carry `favor` or STATE fields.

---

## 6. `test_ceremony_chaos.lua` — rewind / latest-wins

**There is no “latest-wins” pin.** The suite pins the opposite leftover: **older snapshot / Restore overwrites later ceremony fields.** Header at 497–499:

```
-- Replayed sequences: assert what Restore / Apply actually do.
-- Do NOT invent a monotonic-sequence gate. Older snapshots Restore.
```

Pin catalog I-06 is this block (`497–530`). Required Wave 2 invert: ceremony apply only if `sequence` is **greater**; favor overlay when `eventId` matches and `sequence >= current`. Live code and these pins do not do that.

### Sequence / rewind pins

| File:line | Assertion message | What it locks |
|-----------|-------------------|---------------|
| 505 | `early ASSEMBLY sequence is 1` | after `StartEvent` |
| 509 | `later CONSEQUENCE sequence is 3` | after `OpenRite("Gora")` + `CloseRite` |
| 510 | `later state is CONSEQUENCE` | later object |
| 513 | `ApplyResponse of an older snapshot succeeds` | older `BuildResponse` wire Applys |
| 514 | `older Apply has no error` | `replayErr == nil` |
| 516 | `leftover: older Apply Restores the earlier sequence` | live `sequence` becomes `1` |
| 517 | `leftover: older Apply overwrites later state` | live state becomes `ASSEMBLY` |
| 518 | `leftover: older Apply drops the later rite` | `riteType` nil |
| 519 | `leftover: Apply has no monotonic-sequence gate` | `assert_bible(afterOlder, earlySnap)` |
| 521 | `Restore of the later object succeeds` | can walk back to seq 3 |
| 522 | `later Restore returns to sequence 3` | |
| 523 | `Restore of an older object succeeds` | Runtime:Restore also ungated |
| 524 | `leftover: older Restore also has no sequence gate` | sequence back to `1` |
| 525 | `leftover: older Restore overwrites later state` | ASSEMBLY again |
| 527 | `same-object Restore is also ungated` | equal-sequence Restore applies |
| 529 | `replay of the current sequence Applys` | equal-sequence SNAPSHOT Applys |
| 530 | `current-sequence replay Restores the same Bible fields` | `assert_bible` vs `laterSnap` |

### Related (not rewind, same Apply = last write)

| File:line | Message |
|-----------|---------|
| 185 | `Request wire is role only` (`1:SNAPSHOT:request`) |
| 198 | `ApplyResponse lands the late arrival` |
| 200 | `late arrival lands Bible fields` |
| 206 | `late arrival resumes sequence` (copy, not increment) |
| 228 | `mid-rite ApplyResponse` |
| 229 | `mid-rite reload resumes Bible fields` |
| 421 | `ApplyResponse is ungated if called without Accept` |
| 447 | `foreign-major SNAPSHOT does not Restore` |
| 448–449 | skew does **not** drop the live rite / does **not** paint Quiet |

Reload / late-arrival Apply is last-write-wins of Bible fields. `awaitingPope` is Runtime-only; BuildResponse/Apply strip it (lines 218–219, 258+).

Favor: this suite does not stub Gora/Console and does not pin favor overlay or favor apply. Snapshot apply elsewhere: favor on the wire, **not** on Restore.

---

## Task map (7–9)

| Task | Live leftover this inventory locks |
|------|-------------------------------------|
| **7** Version drop + PROTOCOL 2 | Local major is `1` (§1). Skew **keeps** ASSEMBLY/RITE (§2). `_WarnVersion` engineer sentence, once via `warnedVersion` (§3). No Quiet drop. |
| **8** Packed names on STATE/SNAPSHOT | `names` is **not** in `STATE_KEYS` / `SNAPSHOT_RES_KEYS`. Extra colon still `"unknown field"`. |
| **9** Latest-wins + favor overlay | Restore/Apply are **ungated last write**. Older seq **rewinds**. BeefNet STATE apply **drops favor**. Snapshot Apply **strips favor**. |
