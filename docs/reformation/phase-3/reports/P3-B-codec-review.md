# Phase 3 Lane B — Adversarial Review

**Lane:** BeefNet v2 codecs (encode/decode only)
**Exclusive files:** `addon/ChurchOfBeef/Net/Codec.lua`, `tests/test_net_codec.lua`
**Lane report:** `docs/reformation/phase-3/reports/P3-B-codec.md`
**Cited law:** Ten Laws 5, 6; Bible §13.1, §13.4, §20.2–20.3; brief `docs/reformation/phase-3/briefs/P3-B-codec.md`; `.cursor/rules/ceremony-runtime.mdc` (Broadcast and catch-up)
**Writer:** [Codec](8ecaf0c9-f4dd-4f4c-b55c-a327e15f30d6)

**Spec:** PASS
**Quality:** Approved

Encode/decode only. Closed TYPEs are exactly **STATE**, **SNAPSHOT**, **INPUT**. STATE fields are Bible-named: protocol version, event id, state, rite type, subjects (`candidate` / `fighters`), sequence. SNAPSHOT `request` is role only; `response` is those STATE fields plus `role`. INPUT is `petition` / `favor` / `confession`; confession may carry text; none of them encode theater. Fail-closed on unknown TYPE (including HELLO / SUGGESTION / SYNC_* / RANK_COMMIT), missing version, bad role/kind, Grant/standing/points keys, and free-text rite kinds. No `SendAddonMessage`. No registered-Pope file (#8), whisper routing, or hold timers. Isolated suite: **371 passed, 0 failed**. Writer stayed inside exclusive files. Integrator listed TOC / `run.lua` after. `OPEN_QUESTIONS.md` unchanged. No commit. This review did not invent a fourth TYPE, a snapshot blob, a favor side, whisper routing, or a Quiet notice.

## Verdict

Refutation of Laws 5, 6 and Bible §13.1 / §13.4 / §20.2–20.3, and of “do not invent opcodes / snapshot schema,” **fails** for this lane’s exclusive files.

Law 5 is intact on the same terms as Runtime / Store: one writer = later send/apply, not this formatter. The module does not send, whisper, store, or paint. `EncodeState` on a congregation client produces bytes, not authority. INPUT cannot carry theater fields. HELLO / SUGGESTION / SYNC_* / RANK_COMMIT are unknown here.

Law 6 is intact: this is not a UI feature. Loading the file creates no frames, toasts, feeds, pips, or sound. `AWAITING_POPE` is not a state. `IsCompatible` does not paint the §13.4 notice. Foreign majors decode so a later receiver can drop to Quiet Mode; they are not compatible.

§13.1 matches the star as vocabulary only: STATE is the one-way sequence-numbered broadcast shape; INPUT is petition / favor / confession to the Pope console; SNAPSHOT is request / response of the same STATE fields. Channel (GUILD vs whisper) is not coded.

§13.4 is the version field plus `IsCompatible`. Sender checks and the Quiet notice are later / `#8`. Player-typed confession text is carried, not performed.

§20.2–20.3 match the Bible-named fields and the catch-up pair. Snapshot schema is not a second object: response = STATE + `role`. Hold duration stays unspecified.

The three TYPE strings are the brief’s closed wire names, not a kitchen-sink list. This review does not add another.

## Confirmations

| Check | Result |
|---|---|
| Encode/decode only; no `SendAddonMessage` | **Yes.** No `Send` / `Transmit` / `Whisper` / `SendHello`. Suite stubs `SendAddonMessage` / `C_ChatInfo.SendAddonMessage` / `CreateFrame`: zero calls through encode/decode. Reviewer: same stubs stay at 0. |
| Closed TYPEs: STATE, SNAPSHOT, INPUT only | **Yes.** `TYPES` has those three. HELLO / SUGGESTION / SYNC_STATE / SYNC_REQUEST / RANK_COMMIT / SCORE_EVENT / THEATER / SUMMON / GRANT encode and decode as `"unknown message type"`. `encodeTyped` / `Decode` are a closed if-chain: mutating `TYPES.HELLO` still cannot encode or decode HELLO. |
| STATE fields are Bible-named: version, event id, state, rite type, subjects, sequence | **Yes.** Wire is `1:STATE:eventId:state:riteType:candidate:fighters:sequence`. Subjects are only `candidate` / `fighters` (store-local ids, never name strings). Extra keys (`kind`, `text`, `schema`, `holdSeconds`) refuse `"unknown field"`. |
| SNAPSHOT response uses the same fields as STATE (no extra schema) | **Yes.** Request is `1:SNAPSHOT:request` — no event id / state / subjects / sequence. Response equals STATE on those fields plus `role = "response"`. Reviewer: no extra keys beyond STATE+`role`. `schema` / `snapshot` / `holdSeconds` / `awaitingPope` refuse. Request carrying STATE fields refuses. |
| INPUT is petition/favor/confession; never theater | **Yes.** `INPUT_KINDS` is that set. Petition/favor refuse text. `state` / `riteType` / `eventId` / `sequence` / `subjects` / `side` / `narration` refuse `"unknown field"`. Confession text may contain colons; `state` stays nil. Favor has no side field. |
| Fail closed: unknown TYPE, missing version, Grant/standing/points, free-text rites | **Yes.** Version-less / empty / `nan` payloads → `"no protocol version"` (or `"empty payload"`). `points` / `standing` / `Grant` / `GrantGora` / `granted` / nested copies refuse `"banned key"`. Reviewer: `POINTS`, `Standing`, `grantor` also match. `birthday` / `knighting` / `Custom` / `Knighting Extra` refuse. RITE without a type refuses. |
| No registered-Pope file (#8), no whisper routing, no hold timers | **Yes.** `RegisterPope` / `IsPope` / `Whisper` / `SendWhisper` / `Hold` / `holdSeconds` / `ReleaseHeld` are `nil`. No seconds constant. `OPEN_QUESTIONS.md` #8 untouched. |
| Isolated suite green | **Yes.** Reviewer rerun: `lua tests/test_net_codec.lua` → **371 passed, 0 failed** (Lua 5.1.5). Loads Common + Codec only. No BeefNet / Runtime / Store / UI / Ranks `dofile`. |
| Writer did not edit BeefNet / TOC / bootstrap / `run.lua` / Runtime | **Yes.** Writer transcript Writes: `tests/test_net_codec.lua` (first), `Net/Codec.lua`, this lane’s report. BeefNet still HELLO-only; no `Codec` token. Integrator listed `Net\Codec.lua` after Runtime and `test_net_codec` in `tests/run.lua` — not a writer miss. `ChurchOfBeef.lua` does not call `COB.Codec`. |

## Attack results

| Attack | Result |
|---|---|
| Law 5 — `EncodeState` on every client is peer authority / a second writer? | **No as this schema.** Same leftover as Runtime: these APIs run wherever the file loads. The module does not `Send`, Restore a store, or paint. Bytes are not canon. Later Net must send STATE / SNAPSHOT response only from the Pope client. Do not code `#8`. |
| Law 5 / Audit V7 — SNAPSHOT is peer gossip / Officer+ catch-up? | **No.** Encode/decode only. No channel. Request invents no STATE fields. Response is not a “peer reply” in this file — it is a string. Whisper-to-Pope-only is a later transport rule. No Council answer API. |
| Law 5 — INPUT or confession text is public theater? | **No.** Theater-shaped keys on INPUT refuse. Confession text round-trips as `text` with `state == nil`. Render stays a later Pope-console rule (§13.4). |
| Law 5 — HELLO / SUGGESTION / SYNC_* / RANK_COMMIT restored as authority? | **No.** Unknown TYPE. BeefNet still owns HELLO. Retired names die here the same way they die on the transport discard list. |
| Law 6 — Codec paints Quiet chrome / toasts / a sixth “awaiting” state? | **No.** No frames. `AWAITING_POPE` encode refuses (`"invalid state"`). `IsCompatible` returns a boolean. No chat, no Decree, no notice string. |
| Law 6 / §13.4 — foreign major Decode is a misrender? | **No in this file.** `2:STATE:…` decodes with `version == 2` and `IsCompatible == false` so a later receiver can drop to Quiet Mode instead of treating it as garbage. Painting that table without the gate would misrender — integrator leftover, not a Quiet surface here. |
| §13.1 — STATE is bidirectional / congregation-originated theater? | **No.** Direction is not coded (correct). INPUT cannot carry STATE fields. STATE cannot carry an input kind or free text. |
| §13.4 — missing sender check / registered-Pope list is a trust hole this lane must fill? | **No.** Brief forbids `#8`. Server-provided sender is a transport primitive. This module never sees a sender. |
| §20.2 — extra broadcast fields (attendance, hold, narration, Grant)? | **No.** Five Bible fields plus protocol version. Subjects are ids. Banned keys and unknown fields refuse. |
| §20.3 — hold-timeout seconds, whisper routing, or a second snapshot schema? | **No.** Request/response roles only. Response field set equals STATE. No seconds. No whisper API. |
| “Do not invent opcodes” — STATE / SNAPSHOT / INPUT are a kitchen-sink list? | **No.** Those three are the brief’s closed wire TYPEs. Reviewer: SUMMON / THEATER / SCORE_EVENT / GRANT / HELLO refuse. No `EncodeSuggestion` / `EncodeSync` / `EncodeRankCommit`. Protocol major stays **1**. |
| “Do not invent snapshot schema” — `role` + flattened candidate/fighters is a second object? | **No.** `role` is in the brief. Candidate/fighters are the Bible-named subjects, same flattening as STATE. No `schema` / `snapshot` blob. |
| Favor without `side` is an invented (or withheld) product field? | **No.** Brief did not name a side. Encode of `side = "red"` / `"left"` refuses. Do not add one here. |
| Writer edited BeefNet / TOC / bootstrap / `run.lua` / Runtime, or committed? | **No.** Exclusive Writes only. No commit. |

Refutation of Law 5 (one Pope writer; codec is not authority), Law 6 (Quiet contract; no chrome), Bible §13.1 (star vocabulary only), §13.4 (versioned; no misrender in this file), §20.2–20.3 (Bible fields; catch-up is STATE + role), and “do not invent opcodes / snapshot schema” **fails** for the exclusive files.

## Leftovers (other lanes — expected; not fixed)

Writer leftovers are current except the integrator lines (already done).

### Integrator (already landed — writer report is stale)

- `ChurchOfBeef.toc` lists `Net\Codec.lua` before `Net\BeefNet.lua`. Writer did not edit it.
- `tests/run.lua` lists `test_net_codec`. Writer did not edit it.
- `ChurchOfBeef.lua` does not call `COB.Codec`. Correct.

### Later / BeefNet (do not invent here)

- Wire these codecs onto send/recv. Transport still speaks HELLO only.
- STATE broadcast is GUILD, one-way, Pope sender only. SNAPSHOT is whisper **to the Pope’s client only** — no GUILD fan-out, no Officer+ / Council answer.
- Congregation sends INPUT only. Inputs never trigger public theater.
- §13.4: discard or refuse paint when `IsCompatible` is false; the only Quiet notice is the version-mismatch drop. Do not paint a foreign-major Decode body.
- Body-size / throttle stay on BeefNet (`MAX_BODY` 240). Codec does not truncate confession text.
- Registered-Pope list (`#8` — do not code).

### Lane A seam (do not invent a product rule this review)

- Runtime Restore is stricter than this codec: QUIET/ASSEMBLY cannot carry `riteType` or subjects; CONSEQUENCE requires a type; cold QUIET may have `eventId == nil`.
- Reviewer: Codec will encode QUIET+`Knighting`, ASSEMBLY+`Gora`, QUIET+`candidate`, and CONSEQUENCE with no type. Cold Snapshot (`eventId` nil) refuses `"invalid event id"`.
- Integrator must not `EncodeState(Runtime:Snapshot())` on cold QUIET, and must not `Runtime:Restore` a Codec-valid payload that Lane A would refuse. Do not widen Runtime or invent a third schema to “fix” this here.

### Out of scope (do not invent here)

- Director Console, SUMMON protocol, hold-timeout seconds, “awaiting the Pope” surface.
- Favor side. Brief did not name one.
- `#8` file / override UX.

## Findings

### Critical

None. No one-line Law 5 / 6 or §13.1 / §13.4 / §20.2–20.3 breach in the exclusive files. No invented fourth TYPE or second snapshot object.

### Important

1. **These APIs are ungated.** Same leftover as Runtime. `EncodeState` / `EncodeSnapshot({ role = "response" })` will format theater-shaped bytes on any client that loads the file. One writer remains a deployment rule: later Net must send those TYPEs only from the Pope client, and must apply them only from a Pope sender. Do not add a registered-Pope check this lane (`#8`).

2. **Foreign-major Decode materializes Bible-shaped fields.** Reviewer: `2:STATE:9:RITE:Gora:7:8,9:4` returns a full STATE table with `IsCompatible == false`. That is the §13.4 hook the writer disclosed, not a fail-closed miss (brief names missing version, not a foreign major). Integrator must gate paint / Restore on `IsCompatible` (and Pope sender). Do not treat the parsed body as local truth (Audit V7).

3. **Public `STATES` / `RITE_TYPES` / `INPUT_KINDS` are live tables.** There are no copy-getters (writer report overclaims). Reviewer: `Codec.RITE_TYPES.birthday = true` encodes a birthday RITE; `STATES.AWAITING_POPE = true` encodes a sixth state; `INPUT_KINDS.theater = true` encodes a theater INPUT. Honest callers do not write those tables; the suite locks the initial set. `TYPES` mutation does **not** add a working opcode (hardcoded if-chain). Do not treat the public sets as a rite-kind factory. Runtime kept the same sets local.

4. **Lane A Restore is not this codec’s gate.** Codec-valid STATE is not automatically Runtime-Restorable (QUIET/ASSEMBLY + type or subjects; CONSEQUENCE without type; cold nil `eventId`). Do not invent a product answer that collapses the two. Later wiring maps the live event object, not every string this module will accept.

### Nit

1. **Writer leftover map is stale** (`P3-B-codec.md`). TOC and `tests/run.lua` already list Codec / `test_net_codec`. Integrator, not a writer miss.

2. **“Getters return copies” is false for the closed sets.** Decode does copy `fighters`. `TYPES` / `STATES` / `RITE_TYPES` / `INPUT_KINDS` / `SNAPSHOT_ROLES` are the live module tables.

3. **Isolated suite `dofile`s Common; Codec never calls it.** Brief asked for Common + Codec. Correctly unused (no `Names` / Clock).

4. **Padded TYPE / rite type trim.** Reviewer: `1: STATE :…` decodes as STATE; `"Knighting "` encodes as Knighting. Runtime refused a trailing-space type. Do not invent a pad rule.

5. **Scientific-notation version.** `1e0:STATE:…` decodes as version 1 and is compatible. Honest Encode stamps `"1"`.

6. **Decode always yields `fighters = {}`.** Runtime empty subjects use `fighters = nil`. Restore of an honest QUIET wire still normalizes (Lane A `copyFighters({})` → nil). Not a second schema.

7. **Mutating `SNAPSHOT_ROLES.catchup` does not create a third role.** Reviewer: it falls into the response path and dies on `"invalid event id"`. Still do not add roles.

## Brief contract

| Requirement | Result |
|---|---|
| Test-first; isolated Common + Codec; no BeefNet / Runtime / Store / UI | Met (371 / 0) |
| Encode/decode only; no `SendAddonMessage` | Met |
| Closed TYPEs: STATE, SNAPSHOT, INPUT only | Met |
| STATE: protocol version, event id, state, rite type, subjects, sequence | Met |
| SNAPSHOT: role `request` / `response`; response = STATE fields; no extra schema | Met |
| INPUT: petition / favor / confession; character id; confession may carry text; never theater | Met |
| Fail closed: unknown TYPE (incl. HELLO / SUGGESTION / SYNC_* / RANK_COMMIT), missing version, bad role/kind, Grant/standing/points, free-text rites | Met |
| HELLO stays in BeefNet; do not restore SUGGESTION / SYNC_* / RANK_COMMIT | Met |
| No registered-Pope file (#8), whisper routing, Director Console, hold timers, SUMMON | Met |
| Do not edit TOC / bootstrap / `run.lua` / BeefNet / Runtime / Store / UI | Met (integrator listed Codec after) |
| No commit; do not invent product / OPEN_QUESTIONS answers | Met |

## Sections checked

- `docs/reformation/phase-0/TEN_LAWS.md` Laws 5, 6
- Brief `docs/reformation/phase-3/briefs/P3-B-codec.md`
- Writer report `docs/reformation/phase-3/reports/P3-B-codec.md`
- Bible §13.1, §13.4, §20.2–20.3
- `.cursor/rules/ceremony-runtime.mdc` (Broadcast and catch-up; do not invent opcodes / snapshot schema)
- `addon/ChurchOfBeef/Net/Codec.lua`
- `tests/test_net_codec.lua` (isolated run: 371 / 0)
- `addon/ChurchOfBeef/Net/BeefNet.lua` (read-only; HELLO-only; writer did not edit)
- Writer transcript ([Codec](8ecaf0c9-f4dd-4f4c-b55c-a327e15f30d6)) — exclusive Writes only
- `ChurchOfBeef.toc` / `tests/run.lua` / `ChurchOfBeef.lua` (integrator listings; bootstrap does not call Codec)
- `addon/ChurchOfBeef/Core/Runtime.lua` (Lane A field gates; not edited by this writer)
- `docs/design/OPEN_QUESTIONS.md` (unchanged; #8 do not code)
- Reviewer probes: HELLO/SUGGESTION/SYNC_*/RANK_COMMIT/SUMMON/THEATER unknown; SNAPSHOT response = STATE+role; request has no STATE fields; INPUT theater keys refuse; favor `side` refuse; Grant/POINTS/grantor/Standing banned; birthday/Custom rites refuse; foreign v2 STATE decodes incompatible; `IsCompatible`; no Send/Whisper/Hold/RegisterPope; TYPES.HELLO mutate still cannot encode HELLO; RITE_TYPES/STATES/INPUT_KINDS mutate punch holes; QUIET+Knighting / ASSEMBLY+Gora / CONSEQUENCE-without-type encode; cold nil eventId refuses; padded TYPE/rite; `1e0` version; confession text is not `state`; zero `SendAddonMessage`
