# Phase 3 Lane C — Adversarial Review

**Lane:** Snapshot request / response (Core apply)
**Exclusive files:** `addon/ChurchOfBeef/Net/Snapshot.lua`, `tests/test_net_snapshot.lua`
**Lane report:** `docs/reformation/phase-3/reports/P3-C-snapshot.md`
**Cited law:** Ten Laws 5, 6; Bible §20.3, §13.1, §13.4; brief `docs/reformation/phase-3/briefs/P3-C-snapshot.md`; `.cursor/rules/ceremony-runtime.mdc` (whisper to the Pope only; catch-up is not peer SYNC); `GATE1_DESIGN_LEAD_DIRECTIVE.md` §4 **#8 do not code**
**Writer:** [Snapshot](626d8b02-d282-4e68-a7a7-17769bd35a9f)

**Spec:** PASS
**Quality:** Approved

Apply/build only. `Request()` is `Codec:EncodeSnapshot({ role = "request" })` and does not touch Runtime. `BuildResponse()` encodes `Runtime:Snapshot()` as a SNAPSHOT **response** using the Bible STATE fields only (`eventId`, `state`, `riteType`, `subjects`, `sequence`); QUIET (cold or after EndEvent) is `nil, "no event"`. `ApplyResponse` Restores those fields and fail-closes on bad decode, incompatible version, request role, and SUGGESTION / SYNC_* / STATE / INPUT / HELLO / RANK_COMMIT. No `SendAddonMessage`, whisper routing, #8 Pope list, peer SYNC, extra snapshot schema, or `holdSeconds`. Isolated suite: **471 passed, 0 failed**. Writer stayed inside exclusive files. Integrator listed TOC / `run.lua` after. `OPEN_QUESTIONS.md` #8 unchanged. No commit. This review did not create a Pope list, invent a fourth TYPE, or edit Snapshot / the suite.

## Verdict

Refutation of Laws 5, 6, Bible §20.3 / §13.1, and “catch-up is not peer SYNC” **fails** for this lane’s exclusive files.

Law 5 is intact on the same terms as Runtime / Codec: one writer = later send/apply, not this formatter. The module does not send, whisper, route, or paint. `Request()` invents no event. `BuildResponse()` copies the live Runtime object; it does not StartEvent, increment sequence, or declare a verdict. `ApplyResponse` is §20.3 resume of Bible fields, not a second store and not `SYNC_*`. Bytes and Restore are not themselves star authority. This lane must not invent a registered-Pope list (`#8`).

Law 6 is intact: this is not a UI feature. Loading the file creates no frames, toasts, feeds, pips, or sound. BuildResponse from QUIET refuses — Quiet Mode is not catch-up. `AWAITING_POPE` is not a state and is not a snapshot field. `IsCompatible` false refuses Restore; it does not paint the §13.4 notice.

§13.1 matches the star as apply/build only: congregation Request; Pope-shaped response; no GUILD fan-out, no Officer+/Council answer, no peer body stored for later paint. Channel (whisper-to-Pope) is not coded.

§20.3 late-join / reload is the Restore path: a response lands mid-rite on the same STATE fields Lane B already named. Hold duration, “awaiting the Pope,” and persist-into-SV stay other lanes. Snapshot schema is not a second object: response = STATE + `role`.

Catch-up is not peer SYNC: `SYNC_STATE` / `SYNC_REQUEST` die as `"unknown message type"`. Request is role-only. A Pope snapshot response is not a “peer reply” in this file — it is a string, then Restore of the writer’s fields.

## Confirmations

| Check | Result |
|---|---|
| `Request()` encodes SNAPSHOT `role=request`; does not change Runtime | **Yes.** Wire is `1:SNAPSHOT:request`. Equals `Codec:EncodeSnapshot({ role = "request" })`. Extra args ignored. Cold QUIET and mid-RITE Snapshots are unchanged. Decoded request has no `eventId` / `state` / `riteType` / `subjects` / `sequence` / `schema`. |
| `BuildResponse()` encodes `Runtime:Snapshot()` as SNAPSHOT response using Bible STATE fields only; `nil, err` when QUIET | **Yes.** ASSEMBLY / RITE (all four types) / CONSEQUENCE / post-Continue ASSEMBLY match `Codec:EncodeSnapshot({ role = "response", ...STATE fields })`. Cold QUIET and EndEvent QUIET (leftover `eventId`) return `nil, "no event"`. Sequence does not increment. `schema` / `holdSeconds` / `awaitingPope` / `kind` are absent on the wire. Extra args ignored. |
| `ApplyResponse` fail-closed: bad decode, incompatible version, request role, SUGGESTION / SYNC_* / STATE / INPUT / HELLO | **Yes.** Nil/empty/garbage/version-less → decode err, Runtime unchanged. Request blob / `1:SNAPSHOT:request` → `"invalid role"`. Protocol `2` and `0` decode then `"protocol mismatch"`. SUGGESTION / SYNC_STATE / SYNC_REQUEST / RANK_COMMIT / HELLO / INPUT / EncodeState(ASSEMBLY) → `"unknown message type"`. Codec-valid bodies Runtime refuses (CONSEQUENCE without type, ASSEMBLY with a type, QUIET with a candidate, free-text rite, `AWAITING_POPE`) fail at Restore and leave Runtime unchanged. |
| No `SendAddonMessage`, whisper routing, #8 Pope list, peer SYNC, extra snapshot schema, `holdSeconds` | **Yes.** Source has none of those tokens (comment only: does not send, whisper, or route). `Send` / `Whisper` / `Hold` / `holdSeconds` / `RegisterPope` / `IsPope` / `IsRegisteredPope` / `Grant` / `ApplySync` / `SCHEMA` / `TYPES` are `nil`. Suite + reviewer stubs `SendAddonMessage` / `C_ChatInfo.SendAddonMessage` / `CreateFrame`: **0** calls. No `Data/Popes.lua`. `OPEN_QUESTIONS.md` #8 untouched. |
| Isolated suite green (Common + Runtime + Codec + Snapshot) | **Yes.** Reviewer rerun: `lua tests/test_net_snapshot.lua` → **471 passed, 0 failed** (Lua 5.1.5). No BeefNet / Store / UI / Ranks / DB / Sender `dofile`. Standalone asserts `COB.Net` / `Store` / `UI` / `DB` are nil. |
| Writer did not edit BeefNet / TOC / bootstrap / `run.lua` / Codec / Runtime / UI | **Yes.** Writer transcript Writes: `tests/test_net_snapshot.lua` (first), `Net/Snapshot.lua`, this lane’s report. One unused-local cleanup in the suite. Codec / Runtime were Read only. BeefNet has no `Snapshot` / `ApplyResponse` / `BuildResponse` token. `ChurchOfBeef.lua` does not call `COB.Snapshot`. Integrator listed `Net\Snapshot.lua` after Codec and `test_net_snapshot` in `tests/run.lua` — not a writer miss. |

## Attack results

| Attack | Result |
|---|---|
| Law 5 — `BuildResponse` / `ApplyResponse` on every client is peer authority / a second writer? | **No as this schema.** Same leftover as Runtime / Codec: these APIs run wherever the file loads. The module does not `Send`, write `ChurchOfBeefDB`, or paint. Restore is local resume of Bible fields. Later Net must call `BuildResponse` only on the Pope client and apply only from a Pope sender. Do not code `#8`. |
| Law 5 / Audit V7 — SNAPSHOT is `SYNC_STATE` / `SYNC_REQUEST` renamed (peer gossip / Officer+ catch-up)? | **No.** `SYNC_*` refuse `"unknown message type"`. Request invents no STATE fields and does not change Runtime. Response is not a “peer reply” in this file — it is Codec STATE + `role`. No GUILD fan-out, no Officer+/Council answer, no discarded-body inbox. Whisper-to-Pope-only is a later transport rule. |
| Law 5 — congregation `ApplyResponse` stores a peer body and paints it later (V7)? | **No.** Immediate Restore of a decoded **response**. Rejected blobs leave Runtime unchanged and are not stored. No `held` / `inbox` / `queue`. Congregation theater from a Pope-shaped snapshot is §20.3, not a peer database. |
| Law 5 — `Request()` is a congregation write / self-reported theater? | **No.** Encode only. Mid-rite Runtime is unchanged. Apply of that blob is `"invalid role"`. |
| Law 5 — HELLO / SUGGESTION / STATE / INPUT / RANK_COMMIT Restore as authority? | **No.** Unknown TYPE. STATE is the broadcast shape, not a snapshot response. INPUT is not applied. |
| Law 6 — Snapshot paints Quiet chrome / toasts / a sixth “awaiting” state? | **No.** No frames. `AWAITING_POPE` apply → `"invalid state"`. `awaitingPope` is not a wire field (see below). No chat, no Decree, no notice string. |
| Law 6 — EndEvent leftover `eventId` is still catch-up / Event Mode? | **No.** `BuildResponse` keys off `state == "QUIET"`, not `eventId ~= nil`. Ended QUIET is `"no event"`. Event Mode stays `state ~= "QUIET"`. |
| Law 6 / §13.4 — foreign-major Decode is a misrender / Quiet toast? | **No in this file.** `2:SNAPSHOT:response:…` decodes; `IsCompatible` is false; Apply returns `"protocol mismatch"` and leaves Runtime in place. That is the §13.4 hook, not a Quiet notice. Forcing QUIET or painting “the Church's software has advanced” is later / BeefNet. |
| §13.1 — snapshot is bidirectional guild broadcast / congregation-originated theater? | **No.** Direction and channel are not coded (correct). Request cannot carry STATE fields (`"unknown field"`). Response cannot be applied as a request. |
| §13.1 / §13.4 — missing sender check / registered-Pope list is a trust hole this lane must fill? | **No.** Brief and Design Lead #8 forbid the list. This module never sees a sender. |
| §20.3 — hold-timeout seconds, whisper routing, or a second snapshot schema? | **No.** Request/response roles only. Response field set equals STATE. No seconds. No whisper API. `bibleFields` is a projection of the five Bible names, not a fourth TYPE or a `schema` table. |
| §20.3 / Lane E — `awaitingPope` is encoded as a second snapshot schema? | **No.** Reviewer: `MarkPopeLost` then `BuildResponse` wires `1:SNAPSHOT:response:1:RITE:Gora::1,2:2` — decode keys are type/version/role + Bible fields only. `EncodeSnapshot({ …, awaitingPope = true })` refuses (`unknown field`). Apply of that honest wire Restores RITE with `awaitingPope == nil`. Lane E stays on Runtime. |
| “Catch-up is not peer SYNC” — landing mid-rite is a congregation StartEvent? | **No.** Apply is Restore. Sequence is resumed, not incremented. Honest verbs after land bump from the restored value. StartEvent / OpenRite are not this module. |
| Writer edited BeefNet / TOC / bootstrap / `run.lua` / Codec / Runtime / UI, coded #8, or committed? | **No.** Exclusive Writes only. No commit. |

Refutation of Law 5 (one Pope writer; apply/build is not authority), Law 6 (Quiet contract; QUIET is not catch-up; no chrome), Bible §13.1 (star vocabulary only), §20.3 (late-join Restore of STATE fields; no hold / second schema), and “catch-up is not peer SYNC” **fails** for the exclusive files.

## Leftovers (other lanes — expected; not fixed)

Writer leftovers are current except the integrator lines (already done).

### Integrator (already landed — writer report is stale)

- `ChurchOfBeef.toc` lists `Net\Snapshot.lua` after Codec, before BeefNet. Writer did not edit it.
- `tests/run.lua` lists `test_net_snapshot`. Writer did not edit it.
- `ChurchOfBeef.lua` does not call `COB.Snapshot`. Correct.

### Later / BeefNet (do not invent here)

- Send `Request()` on whisper **to the Pope’s client only**. Call `BuildResponse()` only on the Pope client. Apply only from a registered Pope-character sender (#8 — do not code). No GUILD fan-out. No Officer+/Council answer.
- On `IsCompatible` false: refuse Restore (already) **and** drop to Quiet Mode with the one §13.4 notice. This file leaves prior Runtime in place on purpose — do not treat that as the notice.
- Do not `Send` a QUIET response. `BuildResponse` already refuses. A crafted `1:SNAPSHOT:response:…:QUIET:…` will Restore (Codec + Runtime allow ended-QUIET). That is not honest catch-up.
- Registered-Pope list (`#8` — do not code).

### Lane E / Runtime seam (do not invent a product rule this review)

- `awaitingPope` is Event Mode degraded, not a snapshot field. This lane strips it. Do not add it to Codec `SNAPSHOT_RES_KEYS` to “round-trip degrade.”
- Persist-into-SV so the Pope console resumes after disconnect (§20.3) is later. This file does not write `ChurchOfBeefDB`.

### Out of scope (do not invent here)

- Director Console, SUMMON, hold-timeout seconds, “awaiting the Pope” surface, Quiet version-mismatch notice.

## Findings

### Critical

None. No one-line Law 5 / 6 or §20.3 / §13.1 breach in the exclusive files. No peer `SYNC_*`. No fourth TYPE. No #8 Pope list. No `holdSeconds`.

### Important

1. **These APIs are ungated.** Same leftover as Runtime / Codec. `BuildResponse` / `ApplyResponse` will encode and Restore on any client that loads the file. One writer remains a deployment rule: later Net must respond only on the Pope client and apply only from a Pope sender. Do not add a registered-Pope check this lane (`#8`).

2. **Foreign-major Apply leaves prior theater in place.** Reviewer: live ASSEMBLY + `2:SNAPSHOT:response:…` → `"protocol mismatch"`, state unchanged. That refuses the misrender; it is not the Quiet drop. Integrator / BeefNet must still degrade stale clients per §13.4 / §20.3. Do not invent the notice here.

3. **Crafted QUIET responses Restore.** Honest `BuildResponse` never emits them. Reviewer: `1:SNAPSHOT:response:1:QUIET::::0` lands QUIET; a mid-rite client can be wiped by `…:QUIET:…`. Same Codec/Runtime seam Lane B disclosed. Later sender + “no event” rule cover this. Do not add a refuse-QUIET-apply product gate this review.

### Nit

1. **Writer leftover map is stale** (`P3-C-snapshot.md`). TOC and `tests/run.lua` already list Snapshot / `test_net_snapshot`. Integrator, not a writer miss.

2. **Suite does not `MarkPopeLost` then Build/Apply.** Implementation strips `awaitingPope` via `bibleFields`; reviewer confirmed the wire and the Restore. Coverage only, not a second schema.

3. **Isolated suite `dofile`s Common; Snapshot never calls it.** Brief asked for Common + Runtime + Codec + Snapshot. Correctly unused (no `Names` / Clock).

4. **`bibleFields` shares the `subjects` table reference.** `Runtime:Snapshot()` is already a deepcopy; Codec copies fighters on encode/decode; Restore parses again. Reviewer: mutating a landed Snapshot copy does not change live state. Not a second schema.

## Brief contract

| Requirement | Result |
|---|---|
| Test-first; isolated Common + Runtime + Codec + Snapshot; no BeefNet / Store / UI | Met (471 / 0) |
| `Request()` = `EncodeSnapshot({ role = "request" })`; does not change Runtime | Met |
| `BuildResponse()` = `Runtime:Snapshot()` as SNAPSHOT response, Bible STATE fields only | Met |
| QUIET (no event) → `nil, err`; do not invent a second snapshot schema | Met |
| `ApplyResponse` = `DecodeSnapshot` then `Restore` of Bible-named fields only | Met |
| Fail closed: bad decode, `IsCompatible` false, role not `response`; do not apply a request | Met |
| Do not apply SUGGESTION / SYNC_* (also STATE / INPUT / HELLO / RANK_COMMIT) | Met |
| No `SendAddonMessage`; no whisper routing; no Officer+/Council answer; no GUILD fan-out | Met |
| No registered-Pope file (#8); no hold timers | Met |
| `awaitingPope` is Lane E — not a second snapshot schema | Met |
| Do not edit TOC / bootstrap / `run.lua` / BeefNet / Codec / Runtime / UI | Met (integrator listed Snapshot after) |
| No commit; do not invent product / OPEN_QUESTIONS answers | Met |

## Sections checked

- `docs/reformation/phase-0/TEN_LAWS.md` Laws 5, 6
- Brief `docs/reformation/phase-3/briefs/P3-C-snapshot.md`
- Writer report `docs/reformation/phase-3/reports/P3-C-snapshot.md`
- Bible §13.1, §13.4, §20.3
- `.cursor/rules/ceremony-runtime.mdc` (Broadcast and catch-up; ban peer SYNC; do not invent snapshot schema / hold seconds)
- `docs/reformation/phase-1/GATE1_DESIGN_LEAD_DIRECTIVE.md` §4 (#8 do not code)
- `addon/ChurchOfBeef/Net/Snapshot.lua`
- `tests/test_net_snapshot.lua` (isolated run: 471 / 0)
- `addon/ChurchOfBeef/Net/Codec.lua` (field set only; TYPEs remain STATE / SNAPSHOT / INPUT)
- `addon/ChurchOfBeef/Core/Runtime.lua` (`awaitingPope` is Lane E; Snapshot does not encode it)
- Writer transcript ([Snapshot](626d8b02-d282-4e68-a7a7-17769bd35a9f)) — exclusive Writes only
- `ChurchOfBeef.toc` / `tests/run.lua` / `ChurchOfBeef.lua` (integrator listings; bootstrap does not call Snapshot)
- `addon/ChurchOfBeef/Net/BeefNet.lua` (read-only; no Snapshot token)
- `docs/design/OPEN_QUESTIONS.md` (unchanged; #8 do not code)
- Reviewer probes: Request mid-rite unchanged; BuildResponse QUIET / ended-QUIET refuse; awaitingPope stripped on Build/Apply; Encode of `awaitingPope` unknown field; crafted QUIET Apply Restores; foreign v2 leaves ASSEMBLY in place; STATE / SYNC_* / request refuse; `AWAITING_POPE` invalid state; no Send/CreateFrame; landed copy mutation; sequence not incremented; Codec TYPES still three; no `Data/Popes.lua`
