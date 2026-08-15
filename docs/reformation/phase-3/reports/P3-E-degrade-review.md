# Phase 3 Lane E — Adversarial Review

**Lane:** Pope-disconnect degrade (not a sixth state)
**Exclusive files:** `addon/ChurchOfBeef/Core/Runtime.lua`, `tests/test_runtime.lua`
**Lane report:** `docs/reformation/phase-3/reports/P3-E-degrade.md`
**Cited law:** Ten Laws 4, 5, 6; Bible §20.2, §20.3, §13.4; brief `docs/reformation/phase-3/briefs/P3-E-degrade.md`; `.cursor/rules/ceremony-runtime.mdc` (Disconnect); Lane A signed (`P3-A-runtime-review.md`)
**Writer:** [Degrade](dbc64275-59b2-4f4f-9b7d-2628f7e12922)

**Spec:** PASS
**Quality:** Approved

Harness-driven `awaitingPope` flag only. States remain exactly **QUIET, ASSEMBLY, RITE, CONSEQUENCE**. `AWAITING_POPE` is not a state. `MarkPopeLost` / `ClearPopeLost` are not transitions: state / rite / subjects / sequence / event id do not change. Snapshot / Restore round-trip the flag when set; QUIET Restore drops it. No `holdSeconds`, no auto-EndEvent, no toast, no second Quiet notice, no congregation takeover. Isolated suite: **648 passed, 0 failed**. Writer stayed inside exclusive files. `OPEN_QUESTIONS.md` unchanged. No commit. This review did not invent a hold-timeout number, a Director Console, or an “awaiting the Pope” surface.

## Verdict

Refutation of Laws 4, 5, 6, Bible §20.3 / §13.4, and “awaiting the Pope is Event Mode degraded, not a sixth state” **fails** for this lane’s exclusive files.

Law 4 is intact: degrade is a flag, not a ceremony verb that advances the skeleton. `MarkPopeLost` does not close a rite, declare a verdict, announce, or `EndEvent`. `ClearPopeLost` does not resume a rite. There is no timer, queue, observer, or narration. Pope verbs still require a click. `EndEvent` → QUIET clearing the flag is the QUIET invariant (Event Mode degraded cannot live in Quiet), not auto-advance.

Law 5 is intact on the same terms as Lane A / Store: one writer = these APIs on the Pope’s client. `MarkPopeLost` is not self-promotion. There is no `Promote` / `TakeOver` / second writer. Congregation takeover was not added. Existing verbs remain Pope-owned and ungated (brief: they may still run as the Pope client). Later Net/UI must not treat the flag as a promotion.

Law 6 is intact: this is not a UI feature. Loading the file creates no frames, toasts, feeds, pips, or sound. Degrade is **Event Mode degraded**, not Quiet chrome. `MarkPopeLost` from QUIET fails. QUIET Restore drops the flag. Ended QUIET (leftover `eventId`) is still QUIET — not awaiting. The only Quiet notice remains BeefNet `_WarnVersion` (§13.4). This lane adds none.

§20.2 broadcast fields are still event id, state, rite type, subjects, sequence. `awaitingPope` is a degrade flag on the event object for resume, not a sixth broadcast field and not a sixth state.

§20.3 matches the brief: clients hold last state (fields unchanged); degrade is the flag, not a new state; no client promotes itself; persist into SavedVariables stays later. Hold duration stays unspecified. §20.4 five / thirty is not coded.

## Confirmations

| Check | Result |
|---|---|
| States remain exactly QUIET, ASSEMBLY, RITE, CONSEQUENCE — no `AWAITING_POPE` | **Yes.** `STATES` is those four names. Suite refuses Restore of `AWAITING_POPE`. Reviewer: `AwaitingPope` / `awaiting_pope` / `HOLD` / `EVENT` / `EVENT_MODE` / `DEGRADED` / `AWAITING` also refuse. `MarkPopeLost` keeps ASSEMBLY / RITE / CONSEQUENCE. |
| `MarkPopeLost()` while not QUIET sets `awaitingPope`; state / rite / subjects / sequence / eventId unchanged | **Yes.** Suite: ASSEMBLY, RITE (fighters held), CONSEQUENCE (candidate + rite type held). Sequence does not increment. Second `MarkPopeLost` is idempotent and still not a transition. Reviewer: return value is a copy (mutating state / flag / fighters does not change live). |
| `MarkPopeLost` from QUIET fails; `ClearPopeLost` clears the flag and is not a transition | **Yes.** Cold QUIET: `nil, err`, object unchanged. `ClearPopeLost` unsets the flag, leaves state / sequence / rite / subjects, idempotent when unset. Reviewer: ended QUIET (leftover `eventId`) still refuses `MarkPopeLost`; `ClearPopeLost` from QUIET is inert and does not bump sequence. |
| Snapshot / Restore round-trip `awaitingPope` when set; QUIET Restore drops it | **Yes.** Flag is on Snapshot only when true. Restore keeps it on ASSEMBLY / RITE when `== true`. QUIET Restore with `awaitingPope = true` stays QUIET and drops the flag. Missing / `"yes"` do not set it. Reviewer: CONSEQUENCE + flag round-trips; `1` and `false` do not set it; Snapshot-then-Restore identity holds; `holdSeconds` / `holdTimeout` / narration / attendance still stripped. |
| No `holdSeconds`, no auto-EndEvent, no toast, no second Quiet notice, no congregation takeover / self-promotion | **Yes.** Source has no `holdSeconds` / `C_Timer` / `OnUpdate` / `CreateFrame` / toast / `_WarnVersion` / `Promote` / `TakeOver`. `MarkPopeLost` from RITE leaves RITE + rite type. Public methods are only the Lane A verbs plus `MarkPopeLost` / `ClearPopeLost`. Common `Clock` is loaded by the suite and unused. |
| Isolated suite green (Common + Runtime) | **Yes.** Reviewer rerun: `lua tests/test_runtime.lua` → **648 passed, 0 failed** (Lua 5.1.5). Loads Common + Runtime only. No Ranks / Store / Archive / Recognition / DB / UI / Net / Codec / Snapshot / Sender `dofile`. Lane A cases remain. |
| Writer did not edit TOC / bootstrap / `run.lua` / BeefNet / Codec / Snapshot / Sender / UI / DB | **Yes.** Writer transcript Writes/StrReplace: `tests/test_runtime.lua`, `Core/Runtime.lua`, this lane’s report. Those three only. No commit. |

## Attack results

| Attack | Result |
|---|---|
| Law 4 — `MarkPopeLost` is an auto-transition / auto-EndEvent / auto-declare? | **No.** Flag only. State / rite / subjects / sequence / event id unchanged. RITE stays open. No verdict, winner, outcome, or flavor. |
| Law 4 — a hold timer then force-closes or advances the queue? | **No.** No seconds constant, no `Clock`, no `C_Timer`. §20.4 five/thirty is not coded. Hold duration stays unspecified. |
| Law 4 — Pope verbs while `awaitingPope` are software running the ceremony? | **No this lane.** Brief: those verbs stay Pope-owned and may still run as the Pope client. They increment sequence only on a real transition. They do not clear the flag except `EndEvent` → QUIET. No second writer. |
| Law 4 — `EndEvent` clearing `awaitingPope` is auto-advance? | **No.** Entering QUIET cannot carry Event Mode degraded. That is the Quiet invariant, not a hidden `ClearPopeLost` transition. |
| Law 4 — error strings or comments are Pope-voice narration? | **No.** Engineering refusal (`"awaiting pope from event"`). No flavor generator. |
| Law 5 — `MarkPopeLost` is congregation self-promotion / a second writer? | **No.** It does not change ceremony state, assign a Pope, or add `Promote` / `TakeOver`. One writer remains these APIs. Later Net must not call Pope verbs as a takeover. Do not code `#8`. |
| Law 5 — Restore of `awaitingPope` is a peer authority / invented snapshot schema? | **No.** Same in-memory event object. Flag is resume of degrade, not a new opcode or a sixth `state`. Extra keys still drop. |
| Law 5 / Audit V7 — gossip / Officer+ answer / client takeover on disconnect? | **No.** No Net send. No snapshot-on-GUILD. No Council answer. On Pope disconnect, this file does not let anyone else write the machine. |
| Law 6 — degrade is Quiet Mode / Quiet chrome / a toast / a pip? | **No.** No frames. Not a Quiet surface. `MarkPopeLost` from QUIET fails. QUIET Restore drops the flag. Event Mode is still `state ~= "QUIET"`. |
| Law 6 / §13.4 — a second Quiet notice (“awaiting the Pope” as version-mismatch chrome)? | **No.** No `_WarnVersion`, `WarnVersion`, `Toast`, or `Notify`. Version-mismatch notice stays in BeefNet. This flag is not that notice. |
| §20.2 — `awaitingPope` is a sixth broadcast field? | **No in this file.** Bible-named broadcast fields are unchanged. The flag is persist/resume, not STATE. Lane C `BuildResponse` already copies only those five fields (reviewer: encode still works while degraded; decoded `awaitingPope` is nil). Do not add the flag to the wire later. |
| §20.3 — last state is not held? | **No.** Fields stay put. Reviewer: Gora fighters and Knighting candidate survive `MarkPopeLost`. |
| §20.3 — persist into SV, hold-timeout seconds, or “awaiting the Pope” UI? | **No.** Brief forbids all three this lane. Snapshot / Restore are the in-memory hook. Presentation is leftover. |
| “Awaiting the Pope is a sixth state”? | **No.** `STATES` has four names. Restore of `AWAITING_POPE` (and reviewer aliases) fails. Live `state` never becomes that string. |
| Writer edited TOC / bootstrap / `run.lua` / BeefNet / Codec / Snapshot / Sender / UI / DB, wrote SV, or committed? | **No.** Exclusive Writes only. Suite stubs `CreateFrame` / `COB.Net`: zero calls through a degrade + verb cycle. `ChurchOfBeefDB.sentinel` stays put. |

Refutation of Law 4 (software proposes; Pope ratifies; no auto-advance / auto-declare / narration), Law 5 (one Pope writer; no self-promotion), Law 6 (Quiet contract; degrade is not Quiet chrome), Bible §20.3 (hold last state; Event Mode degraded; no takeover), §13.4 (no second Quiet notice), and “not a sixth state” **fails** for the exclusive files.

## Leftovers (other lanes — expected; not fixed)

### Presentation / Net (do not invent here)

- Congregation theater that reads `awaitingPope` and paints “awaiting the Pope.” This lane is the flag only. That paint is Event Mode degraded — not Quiet chrome, not a toast/pip, not a sixth state.
- Who calls `MarkPopeLost` / `ClearPopeLost` on disconnect / resume. BeefNet version-mismatch Quiet notice is unchanged. Do not add a second notice.
- Later STATE encode must not pass a raw `Runtime:Snapshot()` while the flag is set. Reviewer: `Codec:EncodeState(raw)` returns `"unknown field"`; Lane C `BuildResponse` already strips to Bible fields and stays green (**471 / 0**). Strip, do not put `awaitingPope` on the wire.

### Later / out of scope (do not invent here)

- Persist Snapshot into `ChurchOfBeefDB` so the Pope console resumes after disconnect (§20.3).
- Whisper snapshot request / response. No GUILD fan-out. No Officer+ / Council answer.
- Director Console verbs. Do not invent the console this review.
- Hold duration stays unspecified. §20.4 five / thirty is a chaos-test quality bar, not a timer.
- Registered-Pope list (`#8` — do not code).

### Same leftovers as Lane A (still true)

- These APIs are ungated wherever the file loads.
- `EndEvent` QUIET keeps `eventId`. Event Mode is `state ~= "QUIET"`. `MarkPopeLost` correctly refuses that QUIET.
- Restore can land mid-skeleton. That is §20.3 resume, including a degraded flag.

## Findings

### Critical

None. No one-line Law 4 / 5 / 6, §20.3 / §13.4, or “sixth state” breach in the exclusive files.

### Important

1. **These APIs are ungated.** Same leftover as Lane A / Store. `StartEvent` / `EndEvent` / `Restore` / `MarkPopeLost` will run on any client that loads the file. One writer remains a deployment rule: later Net/UI must call ceremony verbs only on the Pope client, and must not treat `MarkPopeLost` as promotion. Do not add a registered-Pope check this lane (`#8`).

2. **`awaitingPope` is not a §20.2 broadcast field.** Snapshot carries it when set so Restore can resume. Lane C already omits it on the wire. A later Sender that encodes the raw Snapshot during degrade will fail closed (`"unknown field"`). Strip to Bible fields. Do not invent a STATE key for the flag.

3. **Restore can land mid-skeleton with the flag set.** Reviewer: CONSEQUENCE + `awaitingPope = true` succeeds. That is §20.3 resume of Event Mode degraded, not auto-advance. Persist / Apply must not apply a non-Pope or fail-closed payload. Do not add a “Restore only from QUIET” gate.

4. **EndEvent QUIET keeps `eventId`.** Writer inherited this from Lane A. `MarkPopeLost` still fails: ended QUIET is not Event Mode. Do not treat a leftover id as live theater or as “awaiting.”

### Nit

1. **Isolated suite `dofile`s Common; Runtime never calls it.** Same as Lane A. Correctly unused (no Clock hold).

2. **Writer suite does not Restore CONSEQUENCE + flag, or `ClearPopeLost` from ended QUIET.** Reviewer probes pass. Not a miss that reopens Spec.

3. **Lane A report still says Restore drops `awaitingPope` as an extra.** Stale relative to this lane. Lane E updated the extras case so it no longer claims the flag is always stripped. Do not “fix” Lane A by inventing hold seconds.

4. **`math.huge` event id and empty `fighters = {}`.** Coverage gaps carried from Lane A. Honest verbs do not emit them.

## Brief contract

| Requirement | Result |
|---|---|
| Test-first; keep isolated Common + Runtime green; add degrade cases | Met (648 / 0) |
| States named only: QUIET, ASSEMBLY, RITE, CONSEQUENCE — not a sixth state | Met |
| `MarkPopeLost` while not QUIET sets `awaitingPope`; fields unchanged | Met |
| `MarkPopeLost` from QUIET → `nil, err`; object unchanged | Met |
| `ClearPopeLost` clears the flag; not a transition | Met |
| Snapshot / Restore round-trip the flag if set; QUIET Restore drops it | Met |
| No `holdSeconds` / timer; do not invent hold duration | Met |
| No auto-EndEvent, toast, second Quiet notice, congregation takeover | Met |
| Pope verbs stay Pope-owned; no second writer | Met |
| Do not persist into `ChurchOfBeefDB`; no `CreateFrame` | Met |
| Do not edit TOC / bootstrap / `run.lua` / BeefNet / Codec / Snapshot / Sender / UI / DB | Met |
| No commit; do not invent product / OPEN_QUESTIONS answers | Met |

## Sections checked

- `docs/reformation/phase-0/TEN_LAWS.md` Laws 4, 5, 6
- Brief `docs/reformation/phase-3/briefs/P3-E-degrade.md`
- Writer report `docs/reformation/phase-3/reports/P3-E-degrade.md`
- Bible §20.2, §20.3, §13.4
- `.cursor/rules/ceremony-runtime.mdc` (Disconnect); `quiet-event-modes.mdc` (only Quiet notice is §13.4)
- Lane A signed review `docs/reformation/phase-3/reports/P3-A-runtime-review.md`
- `addon/ChurchOfBeef/Core/Runtime.lua`
- `tests/test_runtime.lua` (isolated run: 648 / 0)
- Writer transcript ([Degrade](dbc64275-59b2-4f4f-9b7d-2628f7e12922)) — exclusive Writes only
- `docs/design/OPEN_QUESTIONS.md` (no hold-duration answer invented)
- Reviewer probes: sixth-state aliases; ended-QUIET `MarkPopeLost`; `ClearPopeLost` from QUIET; return-copy mutation; CONSEQUENCE Restore + flag; `awaitingPope = 1` / `false`; Snapshot key omitted when unset; failed verb while degraded; Snapshot/Restore identity; no banned APIs; Lane C `BuildResponse` while degraded still encodes without the flag (`test_net_snapshot.lua` 471 / 0)
