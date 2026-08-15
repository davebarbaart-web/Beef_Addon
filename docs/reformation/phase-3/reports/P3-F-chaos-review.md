# Phase 3 Lane F — Adversarial Review

**Lane:** Ceremony chaos tests (quality bar)
**Exclusive files:** `tests/test_ceremony_chaos.lua`, `docs/reformation/phase-3/reports/P3-F-chaos.md`
**Lane report:** `docs/reformation/phase-3/reports/P3-F-chaos.md`
**Cited law:** Ten Laws 4, 5, 6; Bible §20.3, §20.4, §13.1, §13.4; brief `docs/reformation/phase-3/briefs/P3-F-chaos.md`; `.cursor/rules/ceremony-runtime.mdc` (Chaos test; Disconnect); `GATE1_DESIGN_LEAD_DIRECTIVE.md` §4 **#8 do not code**. Lanes A–E are signed.
**Writer:** [Chaos](c91fd2d8-dbb1-4676-9503-200458969de4)

**Spec:** PASS
**Quality:** Approved

Compose-only isolated suite. Named §20.4 / handoff scenarios exist: late arrival, reload / mid-rite reload, Pope disconnect, no-show petitioner, disputed outcome, spoofed senders, version skew, floods, replayed sequences. Replayed sequences assert signed behavior (older snapshot Restores) and do not invent a monotonic gate. No production edits. No `Data/Popes.lua`. No `holdSeconds`. No `SendAddonMessage`. No BeefNet load. No Quiet toast. No sixth state. Isolation asserts are `if standalone then`. Isolated suite: **481 passed, 0 failed**. Writer stayed inside exclusive files. `OPEN_QUESTIONS.md` #8 unchanged. No commit. This review did not invent a sequence gate, hold timer, or Pope list.

## Verdict

Refutation of Laws 4, 5, 6, Bible §20.3 / §20.4 / §13.1 / §13.4, and “five/thirty is a quality bar, not a timer” **fails** for this lane’s exclusive files.

Law 4 is intact: the suite composes explicit Pope verbs and proves the signed APIs do not auto-open, auto-close, auto-end, Grant, Narrate, AutoAdvance, or Declare. No-show `Accept("INPUT")` may be true; Runtime stays ASSEMBLY. Disputed Gora stays RITE until `CloseRite`; CONSEQUENCE stays until `Continue`; QUIET stays until `EndEvent`. `MarkPopeLost` does not end the event. There is no hold timer that force-closes a queue.

Law 5 is intact on the same terms as Sender / Snapshot: one writer is not this suite becoming a Pope list or a peer store. `IsRegisteredPope` is always false. `Accept` is false for STATE / SNAPSHOT / theater. INPUT floods do not encode theater and do not Apply. `SYNC_*` / SUGGESTION / HELLO / RANK_COMMIT do not Apply. Bytes and Restore are not themselves star authority — the suite names ungated `ApplyResponse` and names the missing sequence reconcile. It does not invent either gate.

Law 6 is intact: this is not a UI feature. The loaded modules create no frames, toasts, feeds, pips, or sound. Version skew fail-closes and leaves Runtime; the suite does not paint Quiet Mode or a second notice. `MarkPopeLost` is Event Mode degraded (`awaitingPope` on the object), not Quiet chrome and not `AWAITING_POPE`.

§20.3 late-join / reload is `Request` (no write) then `BuildResponse` / `ApplyResponse` (or Runtime Snapshot / Restore) of Bible fields, including mid-rite. Pope disconnect holds last state; no self-promotion API; persist-into-SV is asserted absent. §20.4 five / thirty is not a constant, not `C_Timer`, and not `holdSeconds`.

§13.1 sequence numbers exist on the signed object and on the wire. Clients reconciling to the latest **Pope** sequence is later Net — current Restore / Apply replace the object. The suite asserts that leftover instead of inventing a gate.

§13.4 discard is Sender `Accept` / `IsRegisteredPope`. Protocol-version fail-closed is Snapshot `ApplyResponse`. The gentle Quiet notice stays on BeefNet. This lane adds none.

## Confirmations

| Check | Result |
|---|---|
| Exclusive files only: suite + lane report. No production edits. No `Data/Popes.lua`. No `holdSeconds` invented | **Yes.** Writer transcript Writes: `tests/test_ceremony_chaos.lua` (first), one unused-local cleanup, this lane’s report. Runtime / Codec / Snapshot / Sender / Common / BeefNet / Store / UI / TOC / bootstrap / `tests/run.lua` / `OPEN_QUESTIONS.md` were not written. `addon/ChurchOfBeef/Data/` is still only `Ranks.lua`. `holdSeconds` / `Hold` / `C_Timer` are nil on the composed modules. |
| Isolated suite: Common + Runtime + Codec + Snapshot + Sender. Isolation asserts wrapped in `if standalone then` | **Yes.** Those five `dofile`s only. `COB.Net` / `Store` / `UI` / `Popes` / `DB` / `Officer` / `Ranks` / `Archive` / `Recognition` nil-checks are inside `if standalone then`. Reviewer: `lua tests/test_ceremony_chaos.lua` → **481 passed, 0 failed** (Lua 5.1.5). |
| Named scenarios: late arrival, reload / mid-rite reload, Pope disconnect, no-show, disputed outcome, spoofed senders, version skew, floods, replayed sequences | **Yes.** Each is a labeled block that composes signed APIs. Late arrival: Event Mode RITE; `Request()` unchanged; `BuildResponse` then `ResetForTests` + `ApplyResponse` lands Bible fields; QUIET / ended QUIET is `nil, "no event"`. Reload: Apply and Runtime Restore resume event id / state / rite / subjects / sequence; `awaitingPope` round-trips on Runtime Restore only; Lane C wire strips it. |
| Replayed sequences assert actual signed behavior (older snapshot Restores); no invented monotonic gate | **Yes.** Sequence 3 CONSEQUENCE + older sequence 1 ASSEMBLY wire → Apply succeeds and rewinds. Older Runtime `Restore` also overwrites. Current-sequence replay Restores the same Bible fields. Named leftover, not “fixed.” Reviewer probe: same rewind. |
| No `SendAddonMessage`. No BeefNet load. No Quiet toast. No sixth state | **Yes.** Suite stubs `SendAddonMessage` / `C_ChatInfo.SendAddonMessage` / `CreateFrame`: **0** calls on the chaos paths. No BeefNet `dofile`. `Toast` / `WarnVersion` / `_WarnVersion` / `Notify` are nil. `Promote` / `TakeOver` / `AssumePope` / `AutoEndEvent` are nil. `MarkPopeLost` keeps RITE / ASSEMBLY; state is not `AWAITING_POPE`. Reviewer: Restore of `AWAITING_POPE` and aliases refuses. |
| Isolated suite green | **Yes.** 481 / 0 standalone. Integrator already lists `test_ceremony_chaos` in `tests/run.lua`; isolation wrap holds. Reviewer: `lua tests/run.lua` → **3727 passed, 0 failed**. |
| Writer did not edit TOC / bootstrap / `run.lua` / BeefNet / Codec / Runtime / Snapshot / Sender / Store / UI | **Yes.** Exclusive Writes only. No commit. Integrator listed the suite after — not a writer miss. |

## Attack results

| Attack | Result |
|---|---|
| Law 4 — no-show / INPUT flood auto-opens a rite, auto-ends, or Applies theater? | **No.** `Accept("INPUT")` may be true. Runtime stays ASSEMBLY. `EncodeInput` stays TYPE INPUT. `ApplyResponse` of INPUT is `"unknown message type"`. Forty (reviewer: one hundred) Accepts do not change the object. |
| Law 4 — disputed Gora auto-declares / Narrates / Grants / auto-Continues? | **No.** `Grant` / `GrantGora` / `Narrate` / `AutoAdvance` / `Declare` / `DeclareVictor` are nil. `CloseRite` / `Continue` / `EndEvent` are explicit calls. CONSEQUENCE keeps the rite until Continue. |
| Law 4 — Pope disconnect is a timer that force-closes or advances the queue? | **No.** No `holdSeconds`, no `Hold`, no `C_Timer`, no `Clock` tick. §20.4 five / thirty is not coded. `MarkPopeLost` holds last state and sets `awaitingPope`. `EndEvent` from RITE stays illegal. `EndEvent` from ASSEMBLY is still an explicit Pope verb. |
| Law 4 — `ClearPopeLost` is a hidden transition / resume-the-rite? | **No.** State, sequence, rite, and subjects unchanged. Flag clears. Not a sixth state. |
| Law 4 — error strings or comments are Pope-voice narration? | **No.** Engineering refusals (`"no event"`, `"protocol mismatch"`, `"awaiting pope from event"`). No flavor generator. |
| Law 5 — `IsRegisteredPope` / a guild-rank stub / the name `"Pope"` is a coded list? | **No.** Always false (`"Beefina"`, `"Pope"`, `"GM"`, nil). `COB.Popes` is nil. `RegisterPope` / `IsPope` are nil. Guild stubs (`GetNumGuildMembers`, `GetGuildRosterInfo`, `GetGuildInfo`, `UnitIsGuildLeader`, `IsGuildLeader`): **0** reads. Reviewer: attaching `Sender.popes` / `COB.Popes` still false. `#8` stays uncoded. |
| Law 5 — spoofed STATE / SNAPSHOT / theater is stored and painted later (Audit V7)? | **No.** `Accept` is false for the theater-kind list (including HELLO / SUGGESTION / `SYNC_*` / `RANK_COMMIT`). `Sender.discarded` is nil. Runtime unchanged. |
| Law 5 — late-arrival `ApplyResponse` without `Accept` is peer authority / a second writer? | **No as this schema.** Brief requires that compose. `ApplyResponse` has no sender argument. The suite demonstrates the leftover: `Accept("Spoof", "SNAPSHOT")` is false, then a blob still Restores if Apply is called anyway. Later Net must compose `Accept` / `IsRegisteredPope` **before** Apply. Do not add a Pope list here. |
| Law 5 / §13.1 — older snapshot rewind means the suite must invent a sequence gate? | **No.** Brief: assert what Restore / Apply actually do; do not invent a monotonic gate. They overwrite. Named leftover. Clients that reconcile “latest Pope sequence” are later Net. This review does not add the gate. |
| Law 5 / Audit V7 — SNAPSHOT catch-up is `SYNC_*` / Officer+ answer / GUILD fan-out? | **No.** `SYNC_STATE` / `SYNC_REQUEST` Apply as `"unknown message type"`. `Request()` does not send. No whisper API. No BeefNet. |
| Law 6 — version skew paints Quiet Mode / a toast / a second notice? | **No.** Foreign-major and protocol `0` → `"protocol mismatch"`, Runtime unchanged (live RITE remains). `Toast` / `WarnVersion` / `_WarnVersion` / `Notify` are nil. The only Quiet notice remains BeefNet `_WarnVersion` (full harness still prints that line from the adversarial Net suite, not from these modules). |
| Law 6 — `awaitingPope` / `MarkPopeLost` is Quiet chrome or a sixth state? | **No.** State stays RITE / ASSEMBLY. Reviewer: CONSEQUENCE + flag also holds; Restore of `AWAITING_POPE` / `HOLD` / `DEGRADED` refuses. Wire decode has no `awaitingPope`. `EncodeSnapshot({ …, awaitingPope = true })` is `"unknown field"`. |
| §20.3 — late join / reload does not land Bible fields mid-rite? | **No.** Event id, state, rite type, subjects, sequence resume. Knighting / Gora / Confession / Proclamation paths are covered across late-arrival and reload blocks. |
| §20.3 — persist into SV, whisper routing, or a hold-timeout number? | **No.** `ChurchOfBeefDB.sentinel` stays put; `ChurchOfBeefDB.runtime` is nil. `Snapshot.Whisper` / `Sender.Whisper` are nil. Hold duration stays unspecified. |
| §20.3 / §13.4 — fail-closed foreign Apply **is** the Quiet drop? | **No.** It refuses the misrender and leaves prior Runtime. Dropping to Quiet Mode with “the Church's software has advanced” is later Net. Do not paint it in this suite. |
| §20.4 — five / thirty was coded as a timer / quality-bar constant? | **No.** Flood count `40` is not a hold. No `5` / `30` timeout. The stream-survival bar remains a human Gathering / two-client pass (Bible §22.3). This harness cannot prove it. |
| Writer edited production, created `Data/Popes.lua`, invented a gate / timer, or committed? | **No.** Exclusive Writes only. No commit. |

Refutation of Law 4 (software proposes; Pope ratifies; no auto-advance / auto-declare / narration), Law 5 (one Pope writer; no peer authority; no invented list), Law 6 (Quiet contract; no toast; degrade is not Quiet chrome), Bible §20.3 (late-join / reload / disconnect / version hook without persist or hold seconds), §20.4 (chaos scenarios without a timer), §13.1 (star vocabulary; sequence leftover named), §13.4 (discard + fail-closed; no second notice), and “five/thirty is a quality bar, not a timer” **fails** for the exclusive files.

## Leftovers (other lanes — expected; not fixed)

Writer leftovers are current except the integrator line.

### Integrator (already landed — writer report is stale)

- `tests/run.lua` lists `test_ceremony_chaos`. Writer did not edit it. Isolation wrap is load-bearing and green in the full harness (**3727 / 0**).

### Later / Net (do not invent here)

- Compose `Accept` / `IsRegisteredPope` **before** `ApplyResponse`. Bytes and Restore are not star authority.
- Reconcile to the latest **Pope** sequence (§13.1). Do **not** add a monotonic-sequence gate to Runtime / Snapshot in this lane.
- On `IsCompatible` false: refuse Restore (already) **and** drop to Quiet Mode with the one §13.4 notice. This suite leaves prior Runtime in place on purpose.
- Whisper snapshot request **to the Pope’s client only**. `BuildResponse` only on the Pope client. No GUILD fan-out. No Officer+ / Council answer.
- Congregation theater that reads `awaitingPope` and paints “awaiting the Pope.” Apply of a Pope `BuildResponse` after disconnect does not land the flag (Lane C strips it). That paint is Event Mode degraded — not Quiet chrome, not a toast, not a sixth state.
- Persist the Pope event object into `ChurchOfBeefDB` so the console resumes after disconnect (§20.3). This suite asserts the modules do not write SV.

### Phase 4 / #8 (do not code this review)

- Workspace registered-Pope list (Ranks.lua pattern), locally overridable. Exact file, edit path, and override UX stay uncoded. Fail-closed `IsRegisteredPope` remains the product until then — including a real Pope character.

### Out of scope (do not invent here)

- Hold duration. §20.4 five / thirty is the quality bar, not a timer.
- Director Console, SUMMON, input dedup-by-character (§20.3 congregation crash), two-client smoke, human Gathering (Bible §22.3).
- A sixth state. A Quiet toast. A second version-mismatch notice.

## Findings

### Critical

None. No one-line Law 4 / 5 / 6, §20.3 / §20.4 / §13.1 / §13.4, or “five/thirty is a timer” breach in the exclusive files. No production edit. No Pope list. No invented sequence gate. No `holdSeconds`.

### Important

1. **`ApplyResponse` is ungated.** Same leftover Lane C / D named. `Accept("Spoof", "SNAPSHOT")` is false; `ApplyResponse(blob)` has no sender and Restores if called. Later Net must keep Pope-sender apply. Do not add a Pope list this lane (`#8`).

2. **There is no sequence gate.** An older SNAPSHOT Apply and an older Runtime Restore overwrite later state (sequence 3 CONSEQUENCE → sequence 1 ASSEMBLY). That is signed behavior, not a test gap. Clients that reconcile “latest Pope sequence” (§13.1) are later Net. Do not invent the gate to make the suite look stricter than the APIs.

3. **Foreign-major Apply leaves prior theater in place.** Live RITE + `2:SNAPSHOT:response:…` → `"protocol mismatch"`, state unchanged. That refuses the misrender; it is not the Quiet drop. Later Net must still degrade stale clients per §13.4 / §20.3. Do not invent the notice here.

4. **`awaitingPope` is not a §20.2 broadcast field.** Runtime Restore round-trips it. `BuildResponse` / `ApplyResponse` strip it. A congregation that only Applys after disconnect does not land degraded. Presentation is later. Not a sixth state. Not a toast.

5. **These composed APIs are ungated wherever the files load.** Same leftover as Runtime / Sender / Snapshot. One writer remains a deployment rule. Do not treat `MarkPopeLost` as promotion.

### Nit

1. **Writer leftover map is stale** (`P3-F-chaos.md` integrator row). `tests/run.lua` already lists `test_ceremony_chaos`. Integrator, not a writer miss.

2. **Suite does not Restore `AWAITING_POPE`, or `MarkPopeLost` from CONSEQUENCE.** Reviewer probes pass (aliases refuse; CONSEQUENCE holds; `EndEvent` from degraded CONSEQUENCE is still a Pope verb). Lane E already owns those cases.

3. **Suite does not Apply a SNAPSHOT request.** Reviewer: `"1:SNAPSHOT:request"` → `"invalid role"`, Runtime unchanged. Lane C coverage.

4. **`assert_eq(COB.Popes, nil)` is repeated outside `standalone`.** Harmless while #8 is uncoded; the isolation wrap already covers the listing case. Do not create `Data/Popes.lua` to “fix” it.

5. **Late arrival uses RITE/Gora as the Event Mode source.** ASSEMBLY is also Event Mode; reload / disconnect blocks cover ASSEMBLY and CONSEQUENCE. Not a missing named scenario.

## Brief contract

| Requirement | Result |
|---|---|
| Exclusive files: `tests/test_ceremony_chaos.lua` + lane report | Met |
| Do not edit TOC / bootstrap / `run.lua` / BeefNet / Codec / Runtime / Snapshot / Sender / Store / UI | Met (integrator listed the suite after) |
| Isolated: Common + Runtime + Codec + Snapshot + Sender | Met |
| Isolation asserts in `if standalone then` | Met |
| Named scenarios: late arrival, reload / mid-rite reload, Pope disconnect, no-show, disputed, spoofed, version skew, floods, replayed sequences | Met |
| Replayed sequences assert older Restore; do not invent a sequence gate | Met |
| No `SendAddonMessage`; no BeefNet; no Quiet toast; no sixth state | Met |
| No `Data/Popes.lua`; no `holdSeconds`; #8 do not code | Met |
| Isolated suite green | Met (481 / 0; harness 3727 / 0) |
| No commit; do not invent product / OPEN_QUESTIONS answers | Met |

## Sections checked

- `docs/reformation/phase-0/TEN_LAWS.md` Laws 4, 5, 6
- Brief `docs/reformation/phase-3/briefs/P3-F-chaos.md`
- Writer report `docs/reformation/phase-3/reports/P3-F-chaos.md`
- Bible §13.1, §13.4, §20.3, §20.4
- `.cursor/rules/ceremony-runtime.mdc` (Chaos test; Disconnect; do not invent opcodes / hold seconds / snapshot schema)
- `.cursor/rules/quiet-event-modes.mdc` (only Quiet notice is §13.4)
- `docs/reformation/phase-1/GATE1_DESIGN_LEAD_DIRECTIVE.md` §4 (#8 do not code)
- `tests/test_ceremony_chaos.lua` (isolated run: 481 / 0)
- Signed production (read only): `Core/Runtime.lua`, `Net/Codec.lua`, `Net/Snapshot.lua`, `Core/Sender.lua`
- Writer transcript ([Chaos](c91fd2d8-dbb1-4676-9503-200458969de4)) — exclusive Writes only
- `tests/run.lua` (integrator lists this suite; writer did not edit)
- `docs/design/OPEN_QUESTIONS.md` (unchanged; #8 do not code)
- `addon/ChurchOfBeef/Data/` (no `Popes.lua`)
- Reviewer probes: `AWAITING_POPE` / alias Restore refuse; CONSEQUENCE `MarkPopeLost` holds; older Apply rewinds; attached popes table does not register; foreign-major leaves RITE; wire has no `awaitingPope`; `EncodeSnapshot` refuses that field; 100 INPUT Accepts do not advance; request role does not Apply; STATE does not Apply; no `holdSeconds`; no SV write
- Full harness: `lua tests/run.lua` → 3727 / 0
