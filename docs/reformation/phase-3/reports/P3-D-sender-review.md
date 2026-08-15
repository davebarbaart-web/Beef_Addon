# Phase 3 Lane D — Adversarial Review

**Lane:** Registered-Pope sender stub (fail-closed predicate)
**Exclusive files:** `addon/ChurchOfBeef/Core/Sender.lua`, `tests/test_sender.lua`
**Lane report:** `docs/reformation/phase-3/reports/P3-D-sender.md`
**Cited law:** Ten Laws 5; Bible §13.4; brief `docs/reformation/phase-3/briefs/P3-D-sender.md`; `.cursor/rules/ceremony-runtime.mdc` (discard non-Pope senders); `GATE1_DESIGN_LEAD_DIRECTIVE.md` §4 **#8 do not code**
**Writer:** [Sender](aafab8f3-07bb-4f74-b098-8064ffafba1f)

**Spec:** PASS
**Quality:** Approved

Fail-closed predicate only. `IsRegisteredPope` is always `false`. `Accept` is `true` only for `INPUT` with a non-empty sender string. STATE, SNAPSHOT, and every other kind die. No `Data/Popes.lua`. No guild-rank read. No GM-as-Pope. No config or override UX. No `SendAddonMessage`. No discarded-message store. Isolated suite: **193 passed, 0 failed**. Writer stayed inside exclusive files. Integrator listed TOC / `run.lua` after. `OPEN_QUESTIONS.md` #8 unchanged. No commit. This review did not create a Pope list.

## Verdict

Refutation of Law 5, Bible §13.4, and Design Lead #8 **fails** for this lane’s exclusive files.

Law 5 is intact on the same terms as Runtime / Codec: one writer is not this stub becoming a list. Congregation `INPUT` is the star’s input-device half — identity presence, not authority. `IsRegisteredPope` stays `false` for the same sender. Witnesses still cannot rule. No peer self-reported theater.

§13.4 is the discard gate, not the paint. Theatrical / state / snapshot kinds never `Accept`. The module does not store a rejected body for later paint. Player-typed free text is not read and not performed. Protocol version and the Quiet notice are other lanes.

#8 is intact: no workspace Pope file, no table of names, no Register / Set / Load APIs, no override UX. Attaching `Sender.popes` / `COB.Popes` does not flip either predicate. Direction stays in `OPEN_QUESTIONS.md`. This review does not code the list.

Always-false until Phase 4 is the brief and the Design Lead’s fail-closed rule, not a missing writer.

## Confirmations

| Check | Result |
|---|---|
| `IsRegisteredPope` always `false` (no guild rank, no GM, no `Data/Popes.lua`) | **Yes.** Function ignores its argument and returns `false`. Suite: name, realm suffix, `"Pope"`, `"GM"`, `"Guild Master"`, Officer, Council, `nil`, `""`, whitespace, `1`, `true`, table, `rankIndex` 0. Reviewer: attaching `popes` / `list` / `registered` / `COB.Popes` still `false`. `addon/ChurchOfBeef/Data/` is only `Ranks.lua`. Guild stubs (`GetGuildRosterInfo`, `GetGuildInfo`, `UnitIsGuildLeader`, `IsGuildLeader`, …) were installed by the suite: **0** calls. |
| `Accept` false for STATE / SNAPSHOT / theater; true only for INPUT + non-empty sender | **Yes.** `kind ~= "INPUT"` → `false`. Suite theater list includes STATE, SNAPSHOT, THEATER, proclamations, rites, HELLO, SUGGESTION, SYNC_*, RANK_COMMIT, and codec inner kinds `petition` / `favor` / `confession`. `INPUT` + `"Beefina"` is `true`. `input` / `Input` / `INPUT ` are `false`. |
| Missing sender is false | **Yes.** `nil`, `""`, whitespace, tab/newline, number, bool, table → `false` for INPUT. Presence uses Common `Names.Trim`. |
| No discarded-message store, no `SendAddonMessage`, no config UX | **Yes.** No inbox / held / queue / pending fields. `RegisterPope` / `SetPope` / `LoadPopes` / `Configure` / `OpenConfig` / `Send` / `Whisper` / `Hold` / `Grant` are `nil`. Suite stubs `SendAddonMessage` / `C_ChatInfo.SendAddonMessage` / `CreateFrame`: **0** calls. Source has none of those tokens. |
| Isolated suite green | **Yes.** Reviewer rerun: `lua tests/test_sender.lua` → **193 passed, 0 failed** (Lua 5.1.5). Loads Common + Sender only. No BeefNet / Codec / Runtime / Store / UI / Ranks / Officer / `Data/Popes.lua` `dofile`. |
| Writer did not edit BeefNet / TOC / bootstrap / `run.lua` | **Yes.** Writer transcript Writes: `tests/test_sender.lua` (first), `Core/Sender.lua`, this lane’s report. BeefNet has no `Sender` / `IsRegisteredPope` token (only `MaxInboundSenders`). `ChurchOfBeef.lua` does not call `COB.Sender`. Integrator listed `Core\Sender.lua` after Officer and `test_sender` in `tests/run.lua` — not a writer miss. |

## Attack results

| Attack | Result |
|---|---|
| Law 5 — always-false `IsRegisteredPope` means the star has no writer? | **No.** Design Lead: fail-closed is correct until Phase 4 has something true to say. Brief: always `false`. A real Pope character cannot paint theater from the wire until #8. Writer disclosed that. Not a bug. |
| Law 5 — `Accept(INPUT)` for any non-empty string is peer authority / self-reported rule? | **No.** Congregation messages are console inputs only (§13.4). `IsRegisteredPope` stays `false` for `"Pope"`, `"GM"`, and the accepted sender. No send, no Restore, no paint. |
| Law 5 / Audit V7 — rejected STATE is stored and painted later? | **No.** Rejects leave no `discarded` / `held` / `inbox` / `queue` / `pending`. No upvalue store. |
| Law 5 — GM / Officer+ / `rankIndex` 0 / the name `"Pope"` is the Church? | **No.** Those senders are not registered. Guild APIs are not called. Officer’s fail-closed stub is a different module and was not loaded. |
| §13.4 — theatrical UI can still render because this file does not discard off the wire? | **No as this schema.** This lane is the predicate. BeefNet does not call it yet (writer leftover). Missing wire is later, not a Pope list. |
| §13.4 — `Accept(INPUT)` performs player-typed free text / public theater? | **No.** Boolean only. No text field. No frames. |
| §13.4 — SNAPSHOT request from the congregation should `Accept`? | **No this lane.** Brief: `Accept` is `false` for SNAPSHOT. Request vs response is Codec’s `role`. Do not invent a fourth kind here. |
| #8 — always-false is a coded empty Pope list / `Data/Popes.lua`? | **No.** There is no file, no name table, no Register API. Reviewer: `S.popes = { "Beefina" }` does not register. `OPEN_QUESTIONS.md` item 8 still says do not code now. |
| #8 — config / override UX, or Officer turned into the Pope module? | **No.** No Configure / OpenConfig. Officer was not edited. Sender is the wire predicate the brief named. |
| Writer edited BeefNet / TOC / bootstrap / `run.lua`, wrote a Pope file, or committed? | **No.** Exclusive Writes only. No commit. |

Refutation of Law 5 (one Pope writer; INPUT is not rule), Bible §13.4 (theater / state / snapshot only from a registered Pope — none exist yet; no later-paint store), and Design Lead #8 (do not code the list) **fails** for the exclusive files.

## Leftovers (other lanes — expected; not fixed)

Writer leftovers are current except the integrator lines (already done).

### Integrator (already landed — writer report is stale)

- `ChurchOfBeef.toc` lists `Core\Sender.lua` after Officer. Writer did not edit it.
- `tests/run.lua` lists `test_sender`. Writer did not edit it.
- `ChurchOfBeef.lua` does not call `COB.Sender`. Correct.

### Later / BeefNet (do not invent here)

- Call `Accept` / `IsRegisteredPope` on inbound **STATE**, **SNAPSHOT response**, and theater. Do not use `Accept` as a blanket inbound gate: HELLO stays transport; SNAPSHOT **request** is congregation → Pope and is not Pope-originated theater.
- Pass the Codec **TYPE** (`INPUT`), not the inner kind (`petition` / `favor` / `confession`). This suite refuses those inner strings on purpose.
- Wire INPUT as console input only. Inputs never trigger public theater. Player-typed text renders only on the Pope’s console.
- Server-provided sender is the identity primitive. This module only tests presence.

### Phase 4 / #8 (do not code this review)

- Workspace registered-Pope list (Ranks.lua pattern), locally overridable. Exact file, edit path, and override UX stay uncoded.
- When the list exists, `Accept` for STATE / SNAPSHOT / theater must consult `IsRegisteredPope`. Today `Accept` is a kind gate and never calls it — equivalent while both are fail-closed. Do not only flip `IsRegisteredPope` and expect theater to pass.

### Out of scope (do not invent here)

- Director Console, whisper routing, hold-timeout seconds, Quiet version-mismatch notice, SUMMON.

## Findings

### Critical

None. No one-line Law 5, §13.4, or #8 breach in the exclusive files. No Pope list.

### Important

1. **These APIs are ungated and unwired.** Same leftover as Runtime / Codec. `Accept` / `IsRegisteredPope` run wherever the file loads; BeefNet does not call them. One writer remains a deployment rule: later Net must apply STATE / SNAPSHOT response / theater only from a Pope sender, and must treat INPUT as console input only. Do not add the list this lane (`#8`).

2. **`Accept` does not call `IsRegisteredPope`.** Theater dies because `kind ~= "INPUT"`, not because the sender failed the list. Correct for this stub. Phase 4 must teach `Accept` to consult the list for STATE / SNAPSHOT / theater. Flipping only `IsRegisteredPope` still refuse-paints (fail-closed). Flipping only `Accept` without a list would be the Law 5 hole — do not do that here.

3. **Codec TYPE vs inner INPUT kind.** Reviewer: `Accept("Beefina", "petition"|"favor"|"confession")` is `false`. Honest wire TYPE is `INPUT`. Integrator must pass `msg.type`, not `msg.kind`.

4. **SNAPSHOT request is not this predicate.** `Accept(*, "SNAPSHOT")` is always `false`, including a late-join request. Brief required that. Later Net must not run congregation snapshot requests through the Pope-sender gate the same way as responses.

### Nit

1. **Writer leftover map is stale** (`P3-D-sender.md`). TOC and `tests/run.lua` already list Sender / `test_sender`. Integrator, not a writer miss.

2. **`Names.Trim` fallback.** If Common is absent, `senderPresent` uses `type == "string" and sender ~= ""`, so `"   "` would `Accept` as INPUT. TOC loads Common first; the isolated suite dofiles it. Honest load is safe.

3. **Dot-call without `self`.** `Sender.Accept("Beefina", "INPUT")` is `false` (kind becomes `nil`). Colon form is the module style. Fail-closed.

4. **Presence is not a character name.** `Accept(".", "INPUT")` is `true`. Brief asked for a non-empty string. Server-provided sender is later.

## Brief contract

| Requirement | Result |
|---|---|
| Test-first; isolated Common + Sender | Met (193 / 0) |
| `IsRegisteredPope` always `false`; no guild rank; no GM-as-Pope | Met |
| `Accept` false for STATE, SNAPSHOT, theater | Met |
| `Accept` true only for `INPUT` + non-empty sender | Met |
| Missing sender is `false` | Met |
| No `Data/Popes.lua` / Pope list / config / override UX | Met |
| No discarded-message store; no `SendAddonMessage`; no Director Console | Met |
| Do not edit TOC / bootstrap / `run.lua` / BeefNet / Codec / Runtime / UI | Met (integrator listed Sender after) |
| No commit; do not invent product / OPEN_QUESTIONS answers | Met |

## Sections checked

- `docs/reformation/phase-0/TEN_LAWS.md` Law 5
- Brief `docs/reformation/phase-3/briefs/P3-D-sender.md`
- Writer report `docs/reformation/phase-3/reports/P3-D-sender.md`
- Bible §13.4 (and §13.1 star as context)
- `GATE1_DESIGN_LEAD_DIRECTIVE.md` §4 #8
- `.cursor/rules/ceremony-runtime.mdc` (discard non-Pope senders; no later-paint store)
- `addon/ChurchOfBeef/Core/Sender.lua`
- `tests/test_sender.lua` (isolated run: 193 / 0)
- Writer transcript ([Sender](aafab8f3-07bb-4f74-b098-8064ffafba1f)) — exclusive Writes only
- `ChurchOfBeef.toc` / `tests/run.lua` / `ChurchOfBeef.lua` (integrator listings; bootstrap does not call Sender)
- `addon/ChurchOfBeef/Net/BeefNet.lua` (read-only; no Sender call)
- `addon/ChurchOfBeef/Core/Officer.lua` (read-only; no `IsRegisteredPope`; not edited)
- `addon/ChurchOfBeef/Data/` (no `Popes.lua`)
- `docs/design/OPEN_QUESTIONS.md` (unchanged; #8 do not code)
- Reviewer probes: attached `popes`/`list`/`COB.Popes` still false; GM / rank 0 still false; INPUT missing/empty/whitespace/tab false; codec inner kinds refuse; SNAPSHOT still false; padded `INPUT ` kind false; no discarded store; no Send/Hold/Register APIs; Trim fallback only if Common missing; guild stubs 0 calls
