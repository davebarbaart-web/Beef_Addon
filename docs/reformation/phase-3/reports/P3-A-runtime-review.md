# Phase 3 Lane A — Adversarial Review

**Lane:** Ceremony runtime (Core state machine)
**Exclusive files:** `addon/ChurchOfBeef/Core/Runtime.lua`, `tests/test_runtime.lua`
**Lane report:** `docs/reformation/phase-3/reports/P3-A-runtime.md`
**Cited law:** Ten Laws 4, 5, 6; Bible §20.1–20.3, §4.11; brief `docs/reformation/phase-3/briefs/P3-A-runtime.md`; `.cursor/rules/ceremony-runtime.mdc`; Adjudication §5 / Bible §22.2 (no generic builder)
**Writer:** [Runtime](de5570e2-ea2c-4913-bfef-af6400ef7a6d)

**Spec:** PASS
**Quality:** Approved

Pope-owned in-memory machine only. States are exactly **QUIET → ASSEMBLY → RITE (typed) → CONSEQUENCE → ASSEMBLY or QUIET**. Closed rites: Knighting, Gora, Confession, Proclamation. StartEvent is one zero-config action. Illegal transitions return `nil, err` and leave the event object unchanged. No auto-advance, auto-declare, or narration. Event object fields only: `eventId`, `state`, `riteType`, `subjects` (`candidate` / `fighters`), `sequence`. Snapshot / Restore of that object; no `ChurchOfBeefDB` write. No `CreateFrame`, Net, Grant, or hold-timeout seconds. Isolated suite: **492 passed, 0 failed**. Writer stayed inside exclusive files. Integrator listed TOC / `run.lua` after. `OPEN_QUESTIONS.md` unchanged. No commit. This review did not invent a Director Console or an “awaiting the Pope” surface.

## Verdict

Refutation of Laws 4, 5, 6 and Bible §20.1–20.3 / §4.11 **fails** for this lane’s exclusive files.

Law 4 is intact: every transition is a named Pope verb. StartEvent does not open a rite. OpenRite does not close. CloseRite enters CONSEQUENCE and writes no verdict, winner, or flavor. Continue does not open the next rite. EndEvent from RITE is illegal. There is no queue, timer, observer, or announce hook.

Law 5 is intact on the same terms as the Phase 2 store: one writer = these APIs on the Pope’s client. The module does not call UI or Net. Restore is resume of the same object, not a second authority. This lane must not invent a registered-Pope list (`#8`).

Law 6 is intact: this is not a UI feature. Loading the file leaves `event` nil until a verb or Snapshot; cold Snapshot is QUIET. No frames, toasts, feeds, or sound. Event Mode is entered and exited only through this machine. `AWAITING_POPE` / `EVENT` / `HOLD` Restore is refused.

§20.1–20.2 match the skeleton and the Bible-named broadcast fields. §20.3 Snapshot / Restore exist so the Pope can resume; persist into SavedVariables is an integrator / later lane (brief). §4.11 is StartEvent: one action, extra args ignored, no event configuration.

## Confirmations

| Check | Result |
|---|---|
| States QUIET → ASSEMBLY → RITE (typed) → CONSEQUENCE → ASSEMBLY or QUIET only | **Yes.** `STATES` is those four names. Suite walks the happy path and refuses every off-edge (StartEvent from live states; OpenRite from QUIET / RITE / CONSEQUENCE; CloseRite from QUIET / ASSEMBLY / CONSEQUENCE; Continue from QUIET / ASSEMBLY / RITE; EndEvent from RITE / QUIET). Reviewer: CONSEQUENCE → RITE is `"rite opens from assembly"`. No sixth state. |
| Closed rite types: Knighting, Gora, Confession, Proclamation — no free-text / generic builder | **Yes.** `RITE_TYPES` is exactly that set. Suite refuses `knighting` / `KNIGHTING` / `Builder` / `Recognition` / `Custom` / `""` / `1`. Reviewer: `SUMMON`, `Summon`, `Knight This Beef`, `Tournament`, `Confession ` (trailing space). Restore of `riteType = "Builder"` refuses. |
| StartEvent is zero-config; illegal transitions fail and do not change state | **Yes.** `StartEvent()` takes no parameters; leftover `{ name = "Tuesday", setup = true }` is ignored and still enters ASSEMBLY with no rite and no subjects. `refuse()` helper asserts `nil, err` and unchanged `state` / `eventId` / `riteType` / `subjects` / `sequence`. |
| No auto-advance, auto-declare, narration | **Yes.** After each verb the machine stops. CloseRite keeps type and subjects and stores no outcome. Public surface has no `AutoAdvance` / `Narrate` / `Announce` / `Grant`. No `OnTransition`, `Notify`, or `Broadcast`. No `C_Timer` / `OnUpdate`. Reviewer: extra subject keys `winner` / `verdict` / `narration` / `Grant` / `label` / `kind` are dropped. |
| Event object fields only: eventId, state, riteType, subjects, sequence | **Yes.** Snapshot shape assertion rejects any other top-level or subject key. `subjects` is only `candidate` / `fighters` (ids or nil). Restore of extras (`holdTimeout`, `awaitingPope`, `narration`, `attendance`) succeeds and does not keep them. `nextEventId` is module-local, not on the object. |
| Snapshot / Restore of that object; no ChurchOfBeefDB write | **Yes.** Snapshot is a deepcopy. Mutating it (and mutating an OpenRite result) does not change live state. Restore replaces from a Bible-shaped parse. Suite + reviewer: `ChurchOfBeefDB.sentinel` stays put; no `runtime` key. Persist is later. |
| No CreateFrame, no Net, no Grant, no hold-timeout seconds | **Yes.** Source has none of those tokens. Suite stubs `CreateFrame` and `COB.Net.Send` / `Broadcast`: zero calls through a full verb cycle. `Runtime.Grant` / `GrantCeremony` are `nil`. No hold field, no seconds constant. Common `Clock` is loaded by the suite and unused by Runtime. |
| Isolated suite green | **Yes.** Reviewer rerun: `lua tests/test_runtime.lua` → **492 passed, 0 failed** (Lua 5.1.5). Loads Common + Runtime only. No Ranks / Store / Archive / Recognition / DB / UI / Net `dofile`. |
| Writer did not edit TOC / bootstrap / `run.lua` | **Yes.** Writer transcript Writes: `tests/test_runtime.lua` (first), `Core/Runtime.lua`, this lane’s report. Integrator listed `Core\Runtime.lua` after Common and `test_runtime` in `tests/run.lua` — not a writer miss. `ChurchOfBeef.lua` does not call `COB.Runtime`. |

## Attack results

| Attack | Result |
|---|---|
| Law 4 — StartEvent is a configuration wizard / auto-opens a rite? | **No.** Extra args ignored. ASSEMBLY, `riteType == nil`, no subjects. OpenRite is a later Pope verb. |
| Law 4 — CloseRite auto-declares a verdict? | **No.** State becomes CONSEQUENCE. No `verdict` / `winner` / `outcome`. Type and subjects remain for a later Pope beat. Continue / EndEvent are separate clicks. |
| Law 4 — Continue auto-advances a queue? | **No.** There is no queue. Continue only returns to ASSEMBLY and clears type / subjects. The next OpenRite is another verb. |
| Law 4 — EndEvent from RITE (or a timer) force-closes the rite? | **No.** EndEvent from RITE fails; rite stays open. No hold seconds. §20.4 five/thirty is not coded. |
| Law 4 — Restore jump QUIET → RITE is an auto-transition? | **No.** Restore is §20.3 resume, not a verb. After a jump, StartEvent still fails and sequence does not bump. Honest verbs still have to walk the skeleton. |
| Law 4 — error strings or comments are Pope-voice narration? | **No.** Engineering refusals (`"start from quiet"`, `"unknown rite type"`). No flavor generator. |
| Law 5 — ungated verbs on every client are peer authority? | **No as this schema.** Same leftover as Store: one writer = these APIs. Congregation UI/Net are not called. Later layers must not StartEvent / Restore on a congregation client. Do not code `#8`. |
| Law 5 — Restore is a second source of truth? | **No.** Same in-memory event object. Lane B encodes this object; it does not become authority by sitting on the wire. |
| Law 5 / Audit V7 — snapshot schema / gossip invented? | **No.** Snapshot is a copy of the Bible fields. No opcode strings. No Net send. Extra keys stripped. |
| Law 6 — Runtime paints Quiet chrome / toasts / a sixth “awaiting” state? | **No.** No frames. Restore of `AWAITING_POPE` / `EVENT` / `EVENT_MODE` / `HOLD` refuses. Cold state is QUIET. Bootstrap does not start an event. |
| Law 6 — EndEvent QUIET with a leftover `eventId` is still Event Mode? | **No in Core.** State is QUIET. The leftover id is the ended event (writer disclosed). UI/Net must key Event Mode off `state ~= "QUIET"`, not `eventId ~= nil`. Do not invent a Quiet toast for the last id. |
| §20.1 — CONSEQUENCE → RITE, or a free-text / Recognition / SUMMON type? | **No.** OpenRite only from ASSEMBLY. Recognition is the identity rite (other lane), not a Gathering type. SUMMON is stretch-MVP and not a rite. |
| §20.2 — extra broadcast fields (attendance, hold, narration)? | **No.** Five fields only. Subjects are ids; no Store lookup. |
| §20.3 — persist into SV, hold-timeout seconds, or “awaiting the Pope” UI? | **No.** Brief forbids all three this lane. Snapshot / Restore are the in-memory hook. Hold duration stays unspecified. |
| §4.11 — Tuesday start is a four-step wizard? | **No.** StartEvent is one action with zero configuration. OpenRite may omit subjects (Knighting with no candidate, Gora with no fighters). Per-type subject gates were not added. |
| §4.11 / Phase 0 F4 — two Core verbs mean the Tuesday floor failed? | **No this lane.** The brief splits StartEvent and OpenRite. Collapsing them into one product button is a later console binding, not a machine auto-advance. This review does not invent that button. |
| Adjudication §5 / §22.2 — `OpenRite(type, subjects?)` is a generic builder? | **No.** Type is a closed set. Subjects are the Bible-named fields on the shared object, not a rite-kind factory or free-text `kind`. Extra subject keys do not change `riteType`. |
| Writer edited TOC / bootstrap / `run.lua`, wrote SV, or committed? | **No.** Exclusive Writes only. No commit. |

Refutation of Law 4 (software proposes; Pope ratifies; no auto-advance / auto-declare / narration), Law 5 (one Pope writer; no peer authority), Law 6 (Quiet contract; Event Mode only through this machine), and Bible §20.1–20.3 / §4.11 **fails** for the exclusive files.

## Leftovers (other lanes — expected; not fixed)

Writer leftovers are current except the integrator lines (already done).

### Integrator (already landed — writer report is stale)

- `ChurchOfBeef.toc` lists `Core\Runtime.lua` after Common. Writer did not edit it.
- `tests/run.lua` lists `test_runtime`. Writer did not edit it.
- `ChurchOfBeef.lua` does not call `COB.Runtime`. Correct (stays QUIET until a Pope verb).

### Lane B (codec)

- Encode / decode of this event object. This lane does not send or receive.
- Fail closed on unknown TYPE, missing protocol version, free-text rite kinds, Grant / standing / points keys.
- Do not invent opcode strings beyond the closed kind families in the Lane B brief.

### Later / out of scope (do not invent here)

- Persist Snapshot into `ChurchOfBeefDB` so the Pope console resumes after disconnect (§20.3).
- Whisper snapshot request / response. No GUILD fan-out. No Officer+ / Council answer.
- Director Console verbs and congregation theater. Do not invent the console this review.
- “Awaiting the Pope” is Event Mode degraded presentation — not a sixth state, not Quiet chrome, not a toast. Do not invent that surface here. Hold duration stays unspecified.
- Registered-Pope list (`#8` — do not code).
- Decree, Grant, attendance sampling, SUMMON protocol.

### Same-lane quality (not a Spec reopen)

- Crafted `eventId = math.huge` Restore succeeds (`isInt` uses `floor` / `>= 1`). Honest StartEvent emits 1, 2, 3…. Do not invent a max id.
- `fighters = {}` OpenRite succeeds and stores `nil`. Not a free-text kind.

## Findings

### Critical

None. No one-line Law 4 / 5 / 6 or §20.1–20.3 / §4.11 breach in the exclusive files.

### Important

1. **These APIs are ungated.** Same leftover as Store. `StartEvent` / `Restore` will run on any client that loads the file. One writer remains a deployment rule: later Net/UI must call writes only on the Pope client. Do not add a registered-Pope check this lane (`#8`).

2. **Restore can land mid-skeleton.** Reviewer: QUIET → RITE with a Bible-shaped object succeeds; that is §20.3 resume, not auto-advance. Lane B and persist must not apply a non-Pope or fail-closed payload. Do not add a “Restore only from QUIET” gate (that would break disconnect resume).

3. **EndEvent QUIET keeps `eventId`.** Writer disclosed. Cold QUIET is `eventId == nil`; ended QUIET is not. Event Mode is `state ~= "QUIET"`. Do not treat a leftover id as live theater, and do not nil it here as a product rule.

4. **Tuesday one-action vs four verbs.** StartEvent is the zero-config start the brief asked for. A later console may bind one click to StartEvent (and, if product says so, OpenRite). That binding is ratification, not auto-advance. Do not collapse the machine this lane.

### Nit

1. **Writer leftover map is stale** (`P3-A-runtime.md`). TOC and `tests/run.lua` already list Runtime / `test_runtime`. Integrator, not a writer miss.

2. **Sequence does not reset on a new event.** Disclosed. Engineering for “latest Pope sequence,” not a score. Do not invent a per-event reset.

3. **Isolated suite `dofile`s Common; Runtime never calls it.** Brief asked for Common + Runtime. Correctly unused (no Clock hold).

4. **`math.huge` event id and empty `fighters = {}`.** Coverage gaps on crafted input. Honest verbs do not emit them.

5. **Restore accepts ASSEMBLY with `sequence == 0`.** Legal by `isSeq` (`>= 0`). Odd next to cold QUIET. Do not invent a minimum live sequence.

6. **Full harness currently reports `test_net_codec.lua` unlisted** (2081 passed, 1 failed runner). Lane B / integrator. Not a Runtime miss. Isolated Lane A suite is 492 / 0.

## Brief contract

| Requirement | Result |
|---|---|
| Test-first; isolated Common + Runtime; prefer not to call Ranks / Store | Met (492 / 0) |
| States named only: QUIET → ASSEMBLY → RITE (typed) → CONSEQUENCE → ASSEMBLY or QUIET | Met |
| StartEvent: QUIET → ASSEMBLY; zero configuration; one action | Met |
| OpenRite: closed types only; no free-text kind; no generic builder | Met |
| CloseRite / Continue / EndEvent edges; illegal → `nil, err`, state unchanged | Met |
| No auto-declare, auto-advance, narration | Met |
| Event object: event id, state, rite type, subjects (candidate / fighters), sequence | Met |
| Sequence increments only on success | Met |
| Snapshot / Restore of that object; no extra snapshot fields | Met |
| Do not persist into `ChurchOfBeefDB` this lane | Met |
| No hold-timeout seconds, awaiting-the-Pope UI, Net, Director Console, Decree, Grant, attendance | Met |
| No CreateFrame | Met |
| Do not edit TOC / bootstrap / `run.lua` / Store / Archive / Recognition / BeefNet / UI | Met (integrator listed Runtime after) |
| No commit; do not invent product / OPEN_QUESTIONS answers | Met |

## Sections checked

- `docs/reformation/phase-0/TEN_LAWS.md` Laws 4, 5, 6
- Brief `docs/reformation/phase-3/briefs/P3-A-runtime.md`
- Writer report `docs/reformation/phase-3/reports/P3-A-runtime.md`
- Bible §20.1–20.3, §4.11, §22.2; Adjudication §5
- `.cursor/rules/ceremony-runtime.mdc`
- `addon/ChurchOfBeef/Core/Runtime.lua`
- `tests/test_runtime.lua` (isolated run: 492 / 0)
- Writer transcript ([Runtime](de5570e2-ea2c-4913-bfef-af6400ef7a6d)) — exclusive Writes only
- `ChurchOfBeef.toc` / `tests/run.lua` / `ChurchOfBeef.lua` (integrator listings; bootstrap does not call Runtime)
- `docs/design/OPEN_QUESTIONS.md` (unchanged; #8 do not code)
- Reviewer probes: extra subject keys dropped; CloseRite has no outcome; Restore jump + failed StartEvent; sixth-state names; SUMMON / Recognition / Builder types; Knighting/Gora with no subjects; returned-copy mutation; EndEvent leftover eventId; cold Restore; `math.huge` id; empty fighters; no observer hooks; no SV write; CONSEQUENCE → RITE refused; no spontaneous transition
