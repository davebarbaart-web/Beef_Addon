# Phase 0 Lane G — Adversarial review (ceremony-runtime)

**Lane:** G — Ceremony runtime + BeefNet v2  
**Artifacts:** `.cursor/rules/ceremony-runtime.mdc`, `docs/reformation/phase-0/reports/G-ceremony-runtime.md`, brief `docs/reformation/phase-0/briefs/G-ceremony-runtime.md`  
**Law:** Bible §20.1–20.4, §13.1, §13.4, §4.11, §7, §18.2, §22.1–22.2; Ten Laws 4–5; Audit V5, V7, §4 BeefNet; Adjudication §5  
**Rule edited:** no (no Critical Bible contradiction)

| Axis | Verdict |
|------|---------|
| **Spec** | **PASS** |
| **Quality** | **Changes required** |

The §20 machine, Pope-owned transitions, one-way broadcast, whisper snapshot-to-Pope, input-never-theater, registered-Pope theater, disconnect-without-self-promotion, closed rite set, transport keepers, and the explicit “do not invent opcodes / hold seconds / snapshot schema” line are present and Bible-aligned. The seven assigned attacks do not refute conformance. Residual holes would still let a later Net agent rebuild Audit V7 under other names.

---

## Attacks (assigned)

### A1 — Peer `SYNC_STATE` authority — does not land (Critical)

Non-negotiables ban rebuilding `SYNC_STATE` / `SYNC_REQUEST` (or any peer reply) as a source of truth (Audit V7, Law 5, §13.1). Broadcasts are Pope → congregation, one-way, sequence-numbered. Snapshots are answered by the Pope's client over whisper. Congregation clients are display + input only. Do-not-rebuild repeats the peer-sync ban.

The Bible's snapshot (§20.3) is not peer authority: one writer answers catch-up. The rule's kind table matches that.

**Residual (Quality, not Spec):** Transport keepers restates the ban as “Do not keep **as authority**.” Sequence reconcile is not tied to a Net/Core Pope-sender discard. Snapshot request is not forbidden as a GUILD fan-out. See F1–F3.

### A2 — Auto-advance — does not land (Critical)

Law 4 / §18.2 / §20.2 are restated: Pope client owns every transition; nothing auto-advances the queue, auto-declares outcomes, auto-announces in the Pope's voice, or generates narration. Start / open / close / end are Pope console actions. Net does not invent transitions.

Tuesday zero-setup (§4.11, §20.2) is a Pope verb, not a timer. Chaos-test five/thirty is not wired as a CONSEQUENCE or queue timeout (A7).

**Residual (Quality):** “single Pope action” and “one click each” are split across sections without the Bible parenthetical that they are the same sentence. See F4.

### A3 — Invented opcodes / hold seconds / snapshot schema — does not land

Opening law: do not invent opcode strings, hold-timeout seconds, or a snapshot schema. Hold duration is unspecified; §20.4 is not a hold timer. Snapshot schema is unspecified. Congregation-input channel is unspecified.

Broadcast *fields* (event id, state, rite type, active subjects, sequence) are Bible-named in §20.2. Kind labels (state broadcast, snapshot request/response, congregation input) are Bible-named *kinds*, not `STATE_BROADCAST`-style opcodes. Demo names (`SYNC_STATE`, `RANK_COMMIT`, `GrantCeremony`) are discard tells, not new protocol.

Lane report records the omissions and does not append `OPEN_QUESTIONS.md` (brief: omit *or* OPEN_QUESTIONS; exclusive-file rule forbids other edits). Correct.

### A4 — Generic ceremony builder — does not land

Closed rite set is exactly §20.1: Knighting / Gora / Confession / Proclamation. No rite-kind factory, free-text “kind,” or officer-invented types (Adjudication §5; Bible §22.2). Shared skeleton + typed RITE is the Bible machine, not a ceremony engine for inventing rites.

This is the discard of demo `Core/Ceremony.lua` `Kinds.Rite` + free-text `label`. The ban is abstract; the demo tell is not named. Residual only.

### A5 — Client self-promotion on Pope disconnect — does not land (Critical)

§20.3 is copied: hold last state briefly, then quiet-leaning “awaiting the Pope”; **no client promotes itself**; Pope console resumes from the persisted event object in SavedVariables. “No other client writes ceremony state.”

**Residual (Quality):** “awaiting the Pope” is not labeled as Event Mode degraded presentation (not a sixth state, not Quiet Mode chrome). Snapshot answering by Council / any online officer during disconnect is not named as self-promotion. See F3, F5.

### A6 — Attendance timesheet — does not land

Audit V5 is named: no attendance timesheet, no start/close group sampling, no ceremony points, no officer-close credit ledger. Knighting writes a Church record only as a Pope verb in this runtime (Audit §4 `Ceremony.lua` salvage). Do-not-rebuild adds RSVP / timesheet sampling as ceremony. Decree attendance tracking is out of this rule (Lane H / §14.1).

Presence-desk “who is here” (§18.1) is not smuggled in. ASSEMBLY “congregation gathering” is Bible §20.1 wording, not a `liveRoster()` sampler.

### A7 — §20.4 five/thirty as a coded timeout — does not land

Chaos test section: a confused client is acceptable for five seconds and embarrassing for thirty — **quality bar, not a timeout constant to code.** Disconnect section repeats that five/thirty is not a hold timer. No seconds are invented.

---

## Findings

### Critical

None. Rule not edited.

### Important

1. **“Do not keep as authority” lets peer `SYNC_STATE` survive as gossip.** (Law 5; Bible §13.1; Audit V7; rule “Transport keepers,” “Non-negotiables,” “Do not rebuild”)
   - Primary ban is correct. Transport keepers weakens it to “Do not keep as authority” (and “suggestion fanout **as product**”).
   - Current `Net/BeefNet.lua` already treats `SYNC_STATE` / `SYNC_REQUEST` as retired types and its file comment forbids state replication (“standing is local testimony”). “Rework messages; do not throw away the wire” can be read as: keep those types (or the no-replication manifesto) so long as the Pope store “wins.”
   - Congregation theater *is* the local source of truth. Peer `SYNC_STATE` applied “as display only” is V7.
   - **Required change:** do not keep `SYNC_STATE` / `SYNC_REQUEST` / `RANK_COMMIT` on the product wire at all (quiet discard of old clients is transport, not a live kind). No peer ceremony-state exchange. Keep throttle / framing / version-discard only. The BeefNet header’s “no state replication” line is V7 — do not keep it as law. Pope one-way broadcast is required (§13.1).

2. **Sequence reconcile is not a Net/Core Pope-sender discard.** (Bible §13.1, §13.4; Law 5; rule “Broadcast and catch-up”)
   - “Clients reconcile to the latest sequence” is adjacent to the kind table. Registered-Pope is stated as **theatrical UI** renders only from a registered Pope sender.
   - A congregation Core that stores a high-sequence body from a non-Pope sender, then paints later, rebuilds peer authority under a UI-layer fig leaf. §13.4 is message trust, not a paint filter.
   - **Required change:** discard — do not store, do not reconcile — state broadcasts whose server-provided sender is not a registered Pope character. Sequence reconcile applies only among accepted Pope broadcasts.

3. **Snapshot request can be GUILD fan-out / Officer+ spray.** (Bible §20.3, §13.1; Audit V7; rule “Broadcast and catch-up,” “Disconnect”)
   - Bible: the client requests current state **from the Pope's client** (whisper) and receives a snapshot.
   - Rule: same table row. It never says the request must not go to the guild channel, to Officer+, or to “any Council client,” and never says no non-Pope client may answer.
   - That is `SYNC_REQUEST` with a new kind name — including the disconnect path (“I’m not the writer; I’m only answering catch-up”). OPEN_QUESTIONS #8 (who is registered Pope) does not license discovery-by-spray. Do not invent the Pope list here.
   - **Required change:** snapshot request is whisper to the registered Pope character only. No other client answers. While the Pope is disconnected, requests go unanswered and presentation stays “awaiting the Pope.”

4. **Tuesday one-action and “one click each” are split.** (Bible §20.2, §4.11; Law 4; rule “Non-negotiables,” “States”)
   - Bible §20.2 is one sentence: start / open / close / end are Pope console actions (one click each; **starting a small ceremony is a single action** with zero configuration).
   - Rule puts “single Pope action / no event configuration” in Non-negotiables and “one click each” under States. An agent can ship a four-step event-configuration wizard and claim “one click each,” failing the Tuesday floor. The inverse error is treating QUIET→ASSEMBLY→RITE collapse as banned auto-advance.
   - **Required change:** restore the parenthetical. Four verbs remain Pope clicks. A small ceremony may be one Pope action that starts the event and opens the rite. That is ratification, not auto-advance. No event-configuration wizard.

5. **“Awaiting the Pope” is unlabeled.** (Bible §20.3, §4.8, §19.1; Law 6; rule “Disconnect,” “States”)
   - Bible authorizes a quiet-leaning presentation during an in-progress event, not a sixth §20.1 state and not a return to Quiet Mode (event object persists; console resumes).
   - Unlabeled, Lane H’s Quiet contract (minimap + Decree only) can hide it, or a Quiet toast can show it. Adding `AWAITING` to the machine invents a state.
   - **Required change:** “awaiting the Pope” is Event Mode degraded presentation only — not a §20.1 state, not Quiet Mode chrome, not a toast kind. Lane H owns Quiet surfaces; this rule owns the machine.

### Minor

6. **“Or any peer reply” is over-broad against the Pope snapshot.** (Bible §20.3; rule “Non-negotiables”)
   - On the wire the Pope is a peer. Read strictly, the clause bans the snapshot response the kind table requires.
   - **Required change:** peer = non-Pope sender. Pope snapshot response is the catch-up writer, not a peer reply.

7. **One “congregation input” kind vs three Bible inputs.** (Bible §13.1; Adjudication §5; rule “Broadcast and catch-up”)
   - Petition, favor, and confession text are named. Grouping them as one kind invites a single free-form opcode (generic builder on the wire).
   - **Required change:** keep three Bible-named input kinds. Still do not invent opcode strings or the input channel.

8. **Lane report does not record F1–F5.**
   - `G-ceremony-runtime.md` correctly confirms the bans and the §20.4 reading. It does not note the “as authority” softener, UI-only sender check, or snapshot fan-out. Frontmatter/globs match the brief. Citations §18.2, §21.3, §22.1–22.2 are supporting, not invention.

---

## What holds (attacks failed)

| Contract | Rule |
|----------|------|
| States QUIET → ASSEMBLY → RITE (four types) → CONSEQUENCE → ASSEMBLY or QUIET | States (§20.1) |
| Pope owns every transition; zero-setup; no event config to begin | Non-negotiables; States; §4.11, §20.2 |
| One-way sequence-numbered broadcast; snapshot whisper; inputs to console only | Broadcast and catch-up; §13.1, §20.2–20.3 |
| Theater only from registered Pope; protocol version; stale → Quiet + gentle notice | Broadcast; §13.4, §21.3 |
| Disconnect: hold, awaiting the Pope, no self-promote, persist event | Disconnect; §20.3 |
| Inputs re-sendable; dedupe by character | Disconnect; §20.3 |
| No generic ceremony builder | Non-negotiables; Adjudication §5; §22.2 |
| BeefNet keepers; custom CHANNEL forbidden | Transport keepers; Audit §4 |
| No invented opcodes / hold seconds / snapshot schema | Opening law; Disconnect; report |
| §20.4 is a quality bar, not a coded timeout | Chaos test; Disconnect |
| V5 timesheet / V7 peer-sync named as the failures to stop | Non-negotiables; Do not rebuild |
| SUMMON is one button, later phase; no summon protocol | Transport keepers; §7, §22.1 |
| Frontmatter | `alwaysApply: false`; Core + Net globs |

No Critical Bible contradiction. Rule not edited. No commit.

---

## Verdict

**Spec PASS. Quality: Changes required.**

Close F1–F3 (peer ceremony-state must die at the wire and in Core apply, not only at UI paint) and F4 (Tuesday collapse is one Pope verb) before treating Lane G as gate-clean. F5–F8 are wording/report nits. The assigned attacks do not justify Spec FAIL.
