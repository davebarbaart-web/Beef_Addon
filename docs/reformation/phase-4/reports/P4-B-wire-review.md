# Phase 4 Lane B — Adversarial Review

**Lane:** BeefNet v2 wire (STATE + SNAPSHOT only)
**Exclusive files:** `addon/ChurchOfBeef/Net/BeefNet.lua`, `tests/test_net_v2.lua`
**Lane report:** `docs/reformation/phase-4/reports/P4-B-wire.md`
**Cited law:** Ten Laws 5, 6; Bible §13.1, §13.4, §20.2–20.3; brief `docs/reformation/phase-4/briefs/P4-B-wire.md`; `.cursor/rules/ceremony-runtime.mdc` (Broadcast and catch-up; discard non-Pope; whisper to Pope only); `GATE1_DESIGN_LEAD_DIRECTIVE.md` §4 **#8 do not code**
**Writer:** [Wire](e6dccf4a-5e77-45bb-ab29-fe7cd8a1ee87)

**Spec:** PASS
**Quality:** Approved

Signed codecs on the kept transport. HELLO is unchanged (prefix `COB`, channel `GUILD`, throttle, `_WarnVersion`). Inbound STATE is GUILD-only and Restores Bible fields only after `Sender:Accept`; today Accept is false — discard, no later-paint store. Inbound SNAPSHOT is WHISPER-only: response uses Accept then `ApplyResponse`; request is not the theater gate and `BuildResponse`s only if local `IsRegisteredPope` (always false — no one else answers; no GUILD fan-out). `SendState` / `SendSnapshot` only if local `IsRegisteredPope` — no send today. No live INPUT channel or inbox. Retired `SUGGESTION` / `SYNC_*` / `RANK_COMMIT` discarded unread. No `Data/Popes.lua`, no `holdSeconds`, no second Quiet notice. Isolated suite: **298 passed, 0 failed**. Writer stayed inside exclusive files. Integrator listed `test_net_v2` in `tests/run.lua`. `OPEN_QUESTIONS.md` #8 unchanged. No commit. This review did not create a Pope list, invent an INPUT channel, or edit BeefNet / the suite.

## Verdict

Refutation of Laws 5, 6, Bible §13.1 / §13.4 / §20.2–20.3, and “catch-up is not peer SYNC / do not invent INPUT channel / #8” **fails** for this lane’s exclusive files.

Law 5 and §13.1 are intact on the wire. One writer remains a deployment rule the signed Sender stub enforces: `Accept` is false for STATE / SNAPSHOT, and `_LocalPope()` is `IsRegisteredPope(PlayerName())` — always false. Congregation clients can decode bytes; they cannot Restore, Apply, answer a snapshot request, or send STATE / SNAPSHOT through the v2 APIs. HELLO still seats presence only. Witnesses still cannot rule. No peer self-reported theater. Catch-up is the signed SNAPSHOT pair on WHISPER, not `SYNC_STATE` / `SYNC_REQUEST` rebuilt as gossip.

Law 6 is intact. Incompatible STATE / SNAPSHOT reuse the existing `_WarnVersion` door (one chat, `warnedVersion` once). That is the sole permitted Quiet notice (Design Lead Gate 1; Bible §13.4 / §20.3). No toast, no second chat, no pip, no `holdSeconds` degrade chrome. Discarded theater does not paint.

§13.4 is the Accept gate plus no later-paint store. Theatrical apply is `Runtime:Restore` / `Snapshot:ApplyResponse` only after Accept. Player-typed confession INPUT is Codec-decodable and still `"unknown message type"` on this wire — no inbox, no Restore, no paint.

§20.2–20.3 match the Bible-named fields and the catch-up pair. Restore passes `eventId`, `state`, `riteType`, `subjects`, `sequence` only — not `awaitingPope`. Snapshot request is congregation → Pope and is not run through the theater Accept gate. Today no client answers, including a character named `"Pope"`. Hold duration stays unspecified.

#8 is intact: no workspace Pope file, no name table, no Register / lookup APIs. Attaching `COB.Popes` / `Sender.popes` does not flip either predicate. Direction stays in `OPEN_QUESTIONS.md`. This review does not code the list.

Always-false until the list exists is the brief and the Design Lead’s fail-closed rule, not a missing writer. A real Pope character cannot paint theater from the wire and cannot answer a snapshot request. Writer disclosed that. Not a bug.

## Confirmations

| Check | Result |
|---|---|
| HELLO unchanged (GUILD, prefix `COB`, throttle, `_WarnVersion`) | **Yes.** `Prefix = "COB"`, `Channel = "GUILD"`, `PROTOCOL = 1`, `TYPES = { HELLO = true }` (local; STATE / SNAPSHOT not added). `SendHello` / `HandleHello` / `PeerCount` / outbound burst-10 refill-1 / inbound burst-5 at 0.2/s / `_WarnVersion` once. Suite: HELLO framing `1:HELLO:0.1.0`; RAID / WHISPER HELLO refused; self echo is not a peer. Reviewer: `test_net_validate.lua` **70 / 0**; `test_net_adversarial.lua` **35 / 0**. Those files were not edited (mtime Aug 14). |
| Inbound STATE on GUILD only; Accept then Restore Bible fields; today Accept false — discard, no later-paint store | **Yes.** Channel check before Accept. Accept false → `"not accepted"`; no `Restore`. No `pendingState` / `held` / `lastState` / `discarded`. Sender named `"Pope"` still discarded. Self echo discarded. WHISPER / RAID STATE return false without Restore. Reviewer (Accept stubbed true): GUILD Restores `eventId` / `state` / `riteType` / `subjects` / `sequence`; `awaitingPope` stays nil; WHISPER / RAID still refuse. |
| Inbound SNAPSHOT on WHISPER only; response uses Accept; request `BuildResponse` only if local `IsRegisteredPope` (false — no one else answers); no GUILD fan-out | **Yes.** Non-WHISPER returns before Accept / Build. Response: Accept then `ApplyResponse(payload)`. Request: not `Accept`; `_LocalPope()` then `BuildResponse` + `_TransmitWhisper(blob, sender)`. Today `"not a registered pope"`; `#wire == 0`. GUILD request / response discarded. Reviewer (`IsRegisteredPope` stubbed true): whisper request answers once, target is the requester, channel `WHISPER`, body is local Runtime SNAPSHOT response, no `awaitingPope`; same request on GUILD does not send. |
| `SendState` / `SendSnapshot` only if local `IsRegisteredPope` — no send today | **Yes.** Both return `false, "not a registered pope"` before Encode. No queue, no `SendAddonMessage`. `SendSnapshot({ role = "request" }, "Pope")` is still Pope-gated — no Pope-name lookup. Reviewer: attaching `COB.Popes` still no send. Flip-only `IsRegisteredPope("Beefina")`: `SendState` → GUILD; `SendSnapshot` → WHISPER to the given target. |
| No live INPUT channel or inbox | **Yes.** `_HandleV2` accepts only decoded `STATE` / `SNAPSHOT`. Codec INPUT (petition / favor / confession) → `"unknown message type"`. `SendInput` / `HandleInput` / `inbox` / `Inbox` / `pendingInput` are `nil`. Suite: `Accept("Petitioner", "INPUT")` may be true — Net still does not wire it. Reviewer: same with Accept stubbed to INPUT-only; GUILD and WHISPER; no Restore, no fan-out. |
| Retired `SUGGESTION` / `SYNC_*` / `RANK_COMMIT` discarded | **Yes.** `RETIRED_TYPES` by name, before `_HandleV2`. GUILD and WHISPER. No Restore, no peer, no fan-out. `SendSuggestion` / `HandleSuggestion` / `ApplySync` / `SendSync` are `nil`. |
| No `Data/Popes.lua`, no `holdSeconds`, no second Quiet notice | **Yes.** `addon/ChurchOfBeef/Data/` is only `Ranks.lua`. `Net.holdSeconds` / `Hold` / `ReleaseHeld` / `MaxHeld` / `RegisterPope` / `LookupPope` / `FindPope` / `Toast` are `nil`. Incompatible STATE / SNAPSHOT: `_WarnVersion` + `"protocol mismatch"`; second call does not chat. Foreign-major INPUT does not warn (not a live channel). |
| Isolated suite green | **Yes.** Reviewer rerun: `lua tests/test_net_v2.lua` → **298 passed, 0 failed** (Lua 5.1.5). Loads Common + Runtime + Codec + Snapshot + Sender + BeefNet. Standalone wraps “other modules nil.” Writer reported 296 — see Nit. Full harness (integrator list): **4180 passed, 0 failed**. |
| Writer did not edit TOC / bootstrap / `run.lua` / Codec / Snapshot / Runtime / Sender / UI / DB | **Yes.** Transcript Writes: `tests/test_net_v2.lua` (first), `Net/BeefNet.lua`, this lane’s report. Those other paths were Read only. Mtimes: Codec 06:30, Snapshot / TOC 06:38, Runtime / Sender 06:37, bootstrap / UI / `OPEN_QUESTIONS.md` Aug 14, `test_net_validate.lua` Aug 14, DB 07:01 (Lane A). BeefNet / report 07:02. `tests/run.lua` 07:02 lists `test_net_v2` — integrator, not a writer miss. |
| Integrator may have listed `test_net_v2` and added a trailing `Net:ResetForTests` | **Yes, listing.** `tests/run.lua` line 44 is `test_net_v2`. There is no trailing `Net:ResetForTests` in the runner. The suite’s final `reset()` calls `Net:ResetForTests()` (and Runtime). Later UI suites stayed clean (harness 4180 / 0). Not a writer miss. |

## Attack results

| Attack | Result |
|---|---|
| Law 5 — `SendState` / `SendSnapshot` on every client is a second writer? | **No.** Both die on `_LocalPope()` before Encode. Today always false. Bytes are not canon. Reviewer: `COB.Popes = { Beefina = true }` still false. |
| Law 5 — always-false `IsRegisteredPope` means the star has no writer? | **No.** Design Lead: fail-closed is correct until Phase 4 has something true to say. Brief: always false; do not invent a list to make one true. A real Pope cannot paint or answer until #8. Disclosed. Not a bug. |
| Law 5 / Audit V7 — SNAPSHOT request/response is peer SYNC / Officer+ catch-up? | **No.** Retired `SYNC_*` die by name on GUILD and WHISPER. SNAPSHOT off WHISPER is discarded. Request is not Accept-theater; only local `IsRegisteredPope` answers; no one else does. No Council / Officer+ path. No GUILD fan-out. Reviewer: even with local Pope stubbed true, a GUILD request does not send. |
| Law 5 / V7 — rejected STATE / SNAPSHOT is stored and painted later? | **No.** Accept-false returns before Restore / Apply. No `pending*` / `held` / `lastState` / `discarded` / inbox. Flood of valid STATE: 0 applies, then `"sender is talking too fast"`. Live local rite is not overwritten. |
| Law 5 — a sender named `"Pope"` / GM / `rankIndex` 0 is the Church? | **No.** Accept ignores the name. `IsRegisteredPope("Pope")` is false. Guild stubs (`GetGuildRosterInfo`, `UnitIsGuildLeader`, `IsGuildLeader`, …) were installed by the suite: **0** calls on v2 paths. Reviewer: same with Accept/Pope stubbed — still 0 guild-rank reads. |
| Law 5 — `Accept(INPUT)` is a live input channel / public theater? | **No.** INPUT never reaches Restore or an inbox. `_HandleV2` requires STATE / SNAPSHOT. Confession text is not read by Net. |
| Law 5 — generic `Net:Send(Codec STATE)` is peer authority? | **No as authority.** `Send()` is the pre-existing HELLO transport (must stay ungated or HELLO dies). Reviewer: congregation `Send(state_wire)` transmits on GUILD; receiver still `"not accepted"`; Runtime stays QUIET. Underscored `_TransmitWhisper` is Lua-public the same way; Apply still Accept-gates. Do not Pope-gate `Send()`. |
| Law 5 — flip only `IsRegisteredPope` and inbound theater paints? | **No.** Reviewer: inbound STATE still `"not accepted"`. Outbound send then works (local gate). That is the signed stub: `Accept` does not call `IsRegisteredPope`. #8 must teach Accept. Do not only flip the list. |
| Law 6 — STATE / SNAPSHOT mismatch is a second Quiet notice / toast? | **No.** Same `_WarnVersion` flag as HELLO. Reviewer: foreign-major STATE chats once; foreign-major SNAPSHOT does not chat again; `Net.Toast` is nil; live event is not dropped to a sixth state. Copy stays the HELLO line — brief said `_WarnVersion` stays; do not invent Bible-quote chrome. |
| Law 6 — opening WHISPER at the top is ambient Quiet chrome? | **No.** WHISPER is the §20.3 catch-up door. HELLO on WHISPER still returns before `HandleHello`. No peer, no toast, no paint. |
| §13.1 — STATE is bidirectional / congregation-originated theater? | **No.** Outbound STATE is Pope-gated and GUILD. Inbound STATE on WHISPER dies. Congregation INPUT is not a channel this lane. |
| §13.4 — missing sender check / no Pope list is a trust hole this lane must fill? | **No.** Brief and GATE1 §4 forbid `#8`. Server-provided sender is passed to Accept. Accept is false. Do not create `Data/Popes.lua` here. |
| §13.4 — player-typed free text renders off the Pope console? | **No.** Confession INPUT is unknown. No inbox. No paint. |
| §20.2 — Restore encodes `awaitingPope` / extra fields / Grant? | **No.** Explicit Bible table only. Reviewer (Accept stubbed): RITE / Knighting / candidate / sequence land; `awaitingPope` is nil. `Net.Grant` is nil. |
| §20.3 — catch-up request send being Pope-gated blocks late join? | **Leftover, not a miss.** Brief: snapshot send only if local `IsRegisteredPope`. `Snapshot:Request()` still only encodes. Do not invent `RequestSnapshot` or a Pope-name lookup. Fail-closed: no client asks, and no client answers. |
| §20.3 — hold-timeout seconds / “awaiting the Pope” notice invented? | **No.** No `holdSeconds`. BeefNet does not call `MarkPopeLost`. Version skew does not invent degrade chrome. |
| “Do not invent INPUT channel” — Codec still encodes INPUT, so the channel exists? | **No.** Codec TYPE is signed Phase 3. This lane does not send, recv-apply, or queue it. Channel remains unspecified. |
| “Catch-up is not peer SYNC” — `BuildResponse` of local Runtime is a peer reply? | **No.** A Pope snapshot response is not a peer reply (ceremony-runtime.mdc). Today `_LocalPope()` is false, so the branch is dead. When #8 exists, only the registered Pope client answers. |
| Writer edited TOC / bootstrap / `run.lua` / Codec / Snapshot / Runtime / Sender / UI / DB, wrote a Pope file, invented INPUT, or committed? | **No.** Exclusive Writes only. No commit. |

Refutation of Law 5 (one Pope writer; Accept / `_LocalPope` fail-closed; catch-up is not SYNC), Law 6 (one Quiet version notice; no toast), Bible §13.1 (star: GUILD STATE one-way, whisper snapshot, no congregation theater), §13.4 (Pope-sender gate; no later-paint store; free text not performed), §20.2–20.3 (Bible fields; whisper catch-up; no holdSeconds), “do not invent INPUT,” and GATE1 `#8` (do not code the list) **fails** for the exclusive files.

## Leftovers (other lanes — expected; not fixed)

Writer leftovers are current except the integrator listing (already done).

### Integrator (already landed — writer report is stale)

- `tests/run.lua` lists `test_net_v2`. Writer did not edit it.
- TOC / bootstrap already load BeefNet (and Codec / Snapshot / Sender / Runtime). Writer did not touch them.
- No trailing `Net:ResetForTests` in the runner. The suite’s final `reset()` clears Net / Runtime. Harness later UI suites stayed green.

### #8 / later (do not invent here)

- Workspace registered-Pope list (Ranks.lua pattern), locally overridable. Exact file, edit path, and override UX stay uncoded (`OPEN_QUESTIONS.md` #8; GATE1 §4). Until that list exists, no client paints theater from the wire and no client answers a snapshot request — including a real Pope character.
- When the list exists, `Accept` for STATE / SNAPSHOT / theater must consult `IsRegisteredPope`. Today `Accept` is a kind gate and never calls it — equivalent while both are fail-closed. Do not only flip `IsRegisteredPope` and expect inbound theater to pass. Do not flip `Accept` without a list.
- Congregation late-join still needs a send path for `Snapshot:Request()` that is **not** Pope-gated and does **not** look up a Pope name. Do not add that API in this review. Do not invent an INPUT channel to carry it.

### Whisper throttle (unreachable today)

- `_TransmitWhisper` does not share the GUILD outbound token bucket. Unreachable while `IsRegisteredPope` is false. Do not invent a second queue until a Pope can send.

### INPUT (channel unspecified)

- Codec still encodes INPUT. This lane does not add a live channel or console inbox. Inputs never trigger public theater. Player-typed text renders only on the Pope’s console — later.

### Out of scope (do not invent here)

- Director Console, Gora loop, holdSeconds, peer SYNC, `#8`, a fourth TYPE, SUMMON.

## Findings

### Critical

None. No one-line Law 5, Law 6, §13.1 / §13.4 / §20.2–20.3, “catch-up is SYNC,” invented INPUT, or #8 breach in the exclusive files. No Pope list.

### Important

1. **These APIs are fail-closed and that is the product until #8.** `SendState` / `SendSnapshot` / snapshot-request answer / inbound Restore / Apply are all dead on a real Pope character. Writer disclosed it. Do not stub `IsRegisteredPope` true to “see theater.” Do not create `Data/Popes.lua` in review.

2. **`Accept` does not call `IsRegisteredPope`.** Inbound theater dies because `kind ~= "INPUT"`, not because the sender failed a list. Correct for the signed stub. Phase 4 #8 must teach `Accept` to consult the list for STATE / SNAPSHOT / theater. Reviewer: flip-only `IsRegisteredPope` still refuse-paints inbound; flip-only `Accept` would Restore from any sender — that is the Law 5 hole. Do not do that here.

3. **Congregation catch-up request is unsendable.** `SendSnapshot` is Pope-gated for every role, including `request`. Brief required that. `Snapshot:Request()` only encodes. A later lane may add a non-lookup request send. Do not invent a Pope-name directory to make §20.3 live.

4. **`Send()` remains the ungated HELLO transport.** A client can `Net:Send` a Codec STATE string on GUILD. Receivers still Accept-discard. Do not treat that as peer SYNC, and do not Pope-gate `Send()` (HELLO would die).

### Nit

1. **Writer leftover map is stale** (`P4-B-wire.md`). `tests/run.lua` already lists `test_net_v2`. Integrator, not a writer miss.

2. **Isolated count is 298, not 296.** Reviewer rerun of the current suite is **298 / 0**. The extra two are the trailing `reset()` asserts (`Runtime:ResetForTests` / `Net:ResetForTests`). HELLO-only counts match the writer (70 / 35).

3. **`_HandleV2` collapses every failed Codec decode to `"unknown message type"`** (invalid STATE, bad SNAPSHOT role, INPUT). Fail-closed. HELLO-only suites stay green, including `N:Encode("STATE", "QUIET")` when Codec is already loaded in the harness.

4. **`TYPES` is a local, not `Net.TYPES`.** Writer dropped a suite peek at it (transcript). Transport Encode of HELLO is the lock. Fine.

## Brief contract

| Requirement | Result |
|---|---|
| Test-first; isolated Common + Runtime + Codec + Snapshot + Sender + BeefNet; standalone wraps “other modules nil” | Met (298 / 0) |
| HELLO stays; prefix `COB`; channel `GUILD`; throttle; `_WarnVersion` | Met |
| Inbound STATE on GUILD; Accept then Restore Bible fields only; Accept false → discard, no later-paint store | Met |
| Inbound SNAPSHOT on WHISPER; response Accept + Apply; request not theater Accept; `BuildResponse` only if local `IsRegisteredPope` (false); no GUILD fan-out | Met |
| Outbound `SendState` / snapshot send only if local `IsRegisteredPope` (false — no send); no Pope-name lookup | Met |
| No live INPUT channel or inbox; INPUT does not Restore or paint | Met |
| Retired `SUGGESTION` / `SYNC_*` / `RANK_COMMIT` discarded unread | Met |
| Stale clients: `_WarnVersion` + discard; no second notice / toast | Met |
| No `Data/Popes.lua`; no `holdSeconds`; no Director Console; no peer SYNC; no `#8` | Met |
| Do not edit TOC / bootstrap / `run.lua` / Codec / Snapshot / Runtime / Sender / UI / DB; do not edit HELLO suites unless forced | Met (integrator listed `test_net_v2`) |
| No commit; do not invent product / OPEN_QUESTIONS answers | Met |

## Sections checked

- `docs/reformation/phase-0/TEN_LAWS.md` Laws 5, 6
- Brief `docs/reformation/phase-4/briefs/P4-B-wire.md`
- Writer report `docs/reformation/phase-4/reports/P4-B-wire.md`
- Bible §13.1, §13.4, §20.2–20.3
- `.cursor/rules/ceremony-runtime.mdc` (Broadcast and catch-up; discard non-Pope; whisper to Pope only)
- `GATE1_DESIGN_LEAD_DIRECTIVE.md` §4 #8
- `.cursor/rules/quiet-event-modes.mdc` (sole Quiet notice)
- `addon/ChurchOfBeef/Net/BeefNet.lua`
- `tests/test_net_v2.lua` (isolated run: 298 / 0)
- Signed read-only: `Net/Codec.lua`, `Net/Snapshot.lua`, `Core/Sender.lua`, `Core/Runtime.lua`
- Writer transcript ([Wire](e6dccf4a-5e77-45bb-ab29-fe7cd8a1ee87)) — exclusive Writes only
- `ChurchOfBeef.toc` / `ChurchOfBeef.lua` / `tests/run.lua` (integrator listing; bootstrap does not call SendState)
- `tests/test_net_validate.lua` (70 / 0) / `tests/test_net_adversarial.lua` (35 / 0)
- `addon/ChurchOfBeef/Data/` (no `Popes.lua`)
- `docs/design/OPEN_QUESTIONS.md` (unchanged; #8 do not code)
- Full harness: 4180 / 0
- Reviewer probes: attached `COB.Popes` / `Sender.popes` still false; flip-only `IsRegisteredPope` sends but does not Restore; flip-only Accept Restores Bible fields on GUILD STATE and Applies WHISPER SNAPSHOT response, not wrong-channel; local-Pope stub answers whisper request only, no GUILD fan-out, no `awaitingPope`; INPUT still unknown; generic `Send(STATE)` is not authority; direct `_TransmitWhisper` still Accept-gates; retired SYNC unread; no SV write; no guild-rank read; one Quiet notice
