# CHURCH OF BEEF — MAJOR REWORK HANDOFF
## Orchestration Prompt for the Cursor Workspace

**From:** David Barba (product owner / the Beef Pope) and the Design Lead
**To:** The orchestrating agent in the `/Volumes/AI_Design_Drive/Beef_Addon` Cursor workspace
**Date:** 2026-08-14
**Mission codename:** THE REFORMATION

---

## 0. Read This First

You are the **lead orchestrator** for a major redevelopment phase of the Church of Beef World of Warcraft addon. An independent design program has produced a canonical Design Bible, adjudicated an external peer review, audited this workspace's existing demo build, and concluded: **the demo is a well-engineered implementation of the wrong product.** Your mission is to rework this codebase into the product the Design Bible actually describes.

Your governing documents, committed to this repo, in strict order of authority:

1. **`docs/design/Game_Design_Bible_v1.1.1.md`** — product law. Overrides everything below it.
2. **`docs/design/Peer_Review_Adjudication.md`** — rationale record for why the law says what it says.
3. **`docs/design/Demo_Build_Audit.md`** — component-by-component keep/rework/discard verdicts for the current code, the canon-violation list (V1–V10), and the rework sequence this handoff operationalizes.
4. **This handoff** — orchestration orders.
5. ~~`docs/superpowers/specs/*`, `docs/canon/*`, the current `.cursor/rules/*` domain rules~~ — **RETIRED.** These encode the wrong product. Phase 0 archives them. Until Phase 0 completes, treat them as historical documents only. On any conflict, the Bible wins, always, without exception.

Read the Bible in full before spawning anything. It is the single source of truth for what this addon is.

---

## 1. Resource Directive (from David, verbatim intent)

**David has a vast usage allowance and is explicitly comfortable with heavy consumption.** Use the Grok 4.6 model liberally as the workhorse for subagent tasks. **Spawning many dozens of subagents across this mission is expected and authorized** — dozens of concurrent agents at peak within a phase is acceptable when the lane structure below keeps them from colliding. Do not economize on agents at the cost of quality, verification depth, or adherence checking. When in doubt between "one agent doing five things" and "five agents each owning one thing with a reviewer behind them," choose the latter.

The constraint is not budget. The constraints are: **correctness against the Bible, phase gates, and merge discipline.** Parallelize aggressively *within* phases; never parallelize *across* an ungated phase boundary.

---

## 2. Non-Negotiables (the Ten Laws — every agent carries these)

Every subagent prompt you write must include, or link to, these. A PR that violates one is rejected regardless of quality.

1. **No points, XP, currencies, dailies, streaks, thresholds, or engagement scoring of any kind.** The points economy is not being rebalanced; it is banned. (Bible §4.6, §4.9; Audit V1)
2. **Record events, never behavior.** No tracking of hours, combat minutes, activity levels, or any generalized contribution number. No activity leaderboards, ever. (§4.9, §17)
3. **The Beef Pope holds ceremonial sovereignty.** Knighting, sanctioning Goras, verdicts, elevation, canonization: Pope actions, performed via one-click verbs on the Director Console. Officers/Council support operations; they do not perform rituals. (§6)
4. **Software proposes; the Pope ratifies.** Nothing auto-declares outcomes, auto-advances queues, auto-announces in the Pope's voice, or generates narration/flavor text. The software never narrates. (§4.2, §4.4)
5. **Pope-authoritative star topology.** One writer (the Pope's client); congregation clients are display terminals plus input devices; witnesses report, never rule. No distributed consensus, no peer self-reported authority. (§13.1)
6. **The Quiet Mode contract.** Outside events: at most a minimap presence and the active Decree. No feeds, toasts, pips, or ambient surfaces. Every UI feature declares Quiet Mode or Event Mode. (§4.8, §19.1)
7. **Church history is never deleted.** No pruning, no departed-member sweeps, no record expiry. Account-level identity; rank belongs to the human; Gora records belong to the character. (§12)
8. **Combat is WoW's.** A Beef Gora is an unmodified duel in the world. No ELO/MMR, no rated matchmaking, no combat analytics, no betting. (§10)
9. **Rank structure is exactly:** Fresh Beef, Cooked Beef, Beef Knight, Beef Lord, Beef Butcher (Raiding Team role designation — display-only in this phase), Beef Council. **No thresholds. No "Beef Prophet."** The Pope is not a rank. (§5)
10. **The hybrid visual law:** functional surfaces stock-template pragmatic; theatrical surfaces (proclamations, fighter cards, seals, verdicts, Records Book, Decree) get the full ecclesiastical parchment-and-dark-iron identity. The UI itself never tells jokes. (§19.3)

The existing hard safety rules remain in force verbatim: no gameplay automation, no injection, no protected-action circumvention, Lua/XML only, target `## Interface: 20506` (TBC Anniversary), Classic+ portability via guarded API reads.

---

## 3. Phase Plan and Gates

Phases are **sequential and gated**. Within a phase, fan out as widely as the lane map allows. A phase gate opens only when its exit criteria pass and a conformance review (see §5) signs off.

### Phase 0 — Replace the Workspace Law *(small agent count; highest leverage)*

The current `.cursor/rules` and internal spec are the machine that will otherwise rebuild the wrong product. Nothing else may start until this lands.

- Archive (do not delete) to `docs/archive/pre-reformation/`: the old design spec, plans, `docs/canon/ranks.md`, and the retired domain rules (`ladder-authority.mdc`, `scoring-coplay.mdc`, `canon-data.mdc`, `beefnet-messaging.mdc`). Preserve git history; write a one-page `docs/archive/pre-reformation/WHY.md` explaining the turn, citing the Audit.
- Author new `.cursor/rules` derived from the Bible: an `architecture-overview` (star topology, ceremony runtime, module layers), domain rules for `gora-sanction`, `pope-authority`, `identity-records`, `ceremony-runtime`, `quiet-event-modes`, `records-not-points`, and a `ten-laws` always-on rule containing §2 above. Keep the existing engineering rules (layers, taint, performance, testing, packaging) — they survive with light edits.
- Rewrite `README.md` and `AGENTS.md` to point at `docs/design/` as sole product law.
- **One agent writes each rule; a separate reviewer agent checks each against the Bible; you integrate.** Rules are law — this is the one phase where fewer, more careful agents beat a swarm.

**Gate 0 exit:** new rules merged; old law archived; a fresh agent given only the workspace can correctly answer "what is this product and what is banned?"

### Phase 1 — The Excision *(wide fan-out; destructive; branch-protected)*

Remove the points economy and everything downstream of it, on a dedicated branch.

- Delete: `Core/Scoring.lua`, `Core/Ladder.lua` (standing/suggestion machinery), the Standing tab, grant-driven toast kinds (`suggest`, `credit`, `demote`, `excommunicate`), the minimap grant pip, threshold data in `Data/Ranks.lua`.
- Attic (move to `attic/` or a shelf branch, never shipped): `Core/Instance.lua` and `Core/Quest.lua` — their instance/group *sensing* primitives are a head start on later-phase Expedition witnessing; their scoring wiring dies.
- Replace `Data/Ranks.lua` with the six-rank canon structure (Law 9), no thresholds, plus the guild-rank display-vs-truth mapping stub (§5).
- Delete dead tests with their subjects; keep the harness.
- **Exit criterion:** the addon compiles, loads on `20506`, shows a minimap button and near-nothing else — and that quiet shell is *correct* (Law 6). All remaining tests green.

**Parallel lanes:** one agent per deleted module + its tests; one agent for Ranks replacement; one agent sweeping UI references; one agent on the attic move; adversarial reviewers verifying no scoring tendrils survive (grep for `standing`, `Grant`, `threshold`, `suggestion`).

### Phase 2 — Re-Found the Data Layer

- Account-level SavedVariables (`ChurchOfBeefDB` per account, not per character).
- The Pope-authoritative store schema: player identities, linked characters (human-confirmed linking — the Rite of Recognition flow, §12.2), Church ranks, character Gora records, ceremony log, marked moments, honorifics. **Never-delete rule enforced structurally** (tombstones/inactive flags, no destructive sweeps).
- The Sacred Archive: one-action export/import serialization, restore path, integrity check (§13.5).
- Keep and reuse: `Core/Common.lua` identity law (Names.Key/Display), Clock abstraction, the batch/revision persistence patterns from the old Ladder (the *patterns*, not the module).
- **Test-first on the offline harness** — the store, linking, records, and archive round-trip are pure logic and must have suites before UI exists.

**Parallel lanes:** schema agent, archive agent, linking-flow agent, migration agent (what happens to the old per-character DB on first load: preserve nothing product-side, but don't error), test agents shadowing each, reviewers behind them.

### Phase 3 — Ceremony Runtime + BeefNet v2

The skeleton everything hangs on (Bible §20 in full).

- Event state machine: QUIET → ASSEMBLY → RITE (typed: Knighting / Gora / Confession / Proclamation) → CONSEQUENCE → loop/QUIET. Pope client owns every transition. Zero-setup start for small ceremonies (§4.11 — "the floor is a Tuesday").
- BeefNet v2 on the **kept transport skeleton** (`Net/BeefNet.lua`'s throttling, inbound rate limits, framing, version discards are keepers — Audit §4): new message set = Pope-originated state broadcasts (sequence-numbered), snapshot request/response over whisper (late join, reload), congregation inputs (petition, favor, confession text) routed to the Pope's console only.
- **Registered-Pope sender validation:** theatrical UI renders only from configured Pope character senders (§13.4). Player free text never auto-renders publicly.
- Protocol version field; stale clients degrade to Quiet Mode with a gentle notice.
- Pope-disconnect behavior: clients hold, then degrade to "awaiting the Pope"; his console resumes from persisted event state.
- Offline-testable: state machine and message codecs are pure logic; simulate late join, reload, disconnect, version skew, input floods in the harness.

**Parallel lanes:** state-machine agent, protocol/codec agent, snapshot-sync agent, sender-auth agent, degradation-path agent, plus a dedicated **chaos-test agent** whose only job is adversarial scenarios (spoofed senders, replayed sequences, floods, mid-rite reloads).

### Phase 4 — The Centerpiece: Beef Gora + Director Console + Knighting

The largest phase; widest fan-out. Build to Bible §10 and §18 exactly.

- **Gora flow:** petitions (with hygiene: expiry, present-and-alive filtering, one-tap dismissal, soft re-petition cooldown, optional named-opponent challenges) → matchmaking assistance (level proximity, head-to-head context, class display, **no ratings**) → SANCTION BEEF GORA (with optional one-line stipulation) → mute fighter cards (tale of the tape + head-to-head line) → congregation favor (pick-a-side; split bar; Pope visibility toggle; nothing else) → duel (WoW's) → proposed verdict from duel system messages, Pope ratifies: DECLARE VICTOR / COWARDICE RECORDED / VOID / free ruling → records → elevation beat when earned (§10.4: win a fair sanctioned match, Pope's judgment, attainable milestone).
- **Fight HUD** (§10.7): both fighters, class colors, records, defenses, head-to-head, favor split; live health if Appendix A item 1 validates, defined fallback if not; Event Mode only; top-center, movable.
- **Director Console** (§18): question-oriented desks — Presence, Knighting queue (targeting assist + raid-marker on candidate where API permits, latecomer insertion), Gora desk, MARK THIS MOMENT, Pope's Notebook (private free-text per member). Big targets, one-click verbs, keybinds, movable/collapsible, zero-setup small ceremonies. Stock-template chrome (Law 10) — this is a working tool.
- **Knighting workflow** (§8): KNIGHT THIS BEEF performs the Church record + guild-rank promotion where the API permits + proclamation + queue advance-on-command (never auto).
- **Records & Records Book** (§10.9): character records as stories (W/L, streaks, defenses, head-to-heads, rulings received), player aggregation, and the Records Book as parchment superlatives — Most Sanctioned Victories, Longest Streak, Most Defenses, The Iron Chin, Greatest Rivalry, Famous Upsets, The Undefeated, The Glorious Martyr. **No sortable ranked ladder.** Theatrical surface: full ecclesiastical treatment.
- Reuse: `UI/Toasts.lua` engine (reworked kinds: consequence beats + rare system notices), `UI/MainFrame.lua` frame plumbing (drag/resize/coalescing — not its information architecture), `Core/Roster.lua` roster sensing (rework mapping to display-vs-truth), `Core/Officer.lua` reworked into Pope/Council authority module.

**Parallel lanes:** one agent per flow segment above, each with a shadowing test agent; a UI-theater squad (cards, seals, proclamations — Law 10's identity work); a console squad (one agent per desk); pairwise adversarial reviewers; an integration agent owning the end-to-end "run a full simulated Gora night" harness scenario.

### Phase 5 — Ceremony Completeness + Everyday Layer

- The Decree (§14.1: single active proclamation, login banner, minimap access, hard-bounded — no calendar/RSVP), SUMMON THE FAITHFUL one-button broadcast, Beef Confession queue support (text renders on Pope console only), sound cues (§19.4: sanction bell, verdict, elevation, knighting, cowardice — Event Mode only, Quiet Mode silent), post-show clipboard summary, near-invisible onboarding (§19.5), guild-rank reconciliation (§5 display-vs-truth).

### Phase 6 — Validation, Hardening, Rehearsal Prep

- **Appendix A execution:** every API validation item in the Bible's Appendix A becomes a task with a written result committed to `docs/validation/`. Items 1–4 (HUD health feasibility, duel system message formats, sender integrity + rate limits at 40 clients, roster write permissions) are load-bearing — validate in-game early, not last.
- Rewrite `docs/phases/` checklists against the Bible's §22.3 definition of done; author the **dress-rehearsal script** (late arrival, UI reload, Pope disconnect, no-show petitioner, disputed Gora — all deliberate).
- Polish pass per §21 MVP component list; packaging for CurseForge/Wago dual publish.

**Mission definition of done (from the Bible, verbatim):** *the Church runs one complete, real Gathering — assembly under a Decree, several Knightings, several sanctioned Beef Goras with fight HUD and favor — live on stream, with records persisting afterward, a first-time Twitch viewer able to understand the spectacle, and David never opening Blizzard's guild roster or touching a spreadsheet during the performance.* One deliberately imperfect dress rehearsal gates release.

---

## 4. Orchestration Rules

- **Lane ownership:** every subagent owns one bounded task with named files. No two agents write the same file concurrently. You (orchestrator) are the sole integrator per phase; use worktrees/branches per lane.
- **Every task prompt cites its Bible sections.** An agent that cannot name the sections it implements does not start.
- **Reviewer pairing:** every producing agent gets an independent reviewer agent whose prompt is adversarial: *find the Bible violation, find the Law breach, try to refute conformance.* Reviewer sign-off is recorded in the PR/commit message with the section numbers checked.
- **Conformance squad (standing, all phases):** a rotating set of agents whose only job is auditing merged work against the Ten Laws and grepping for regression tells (`standing`, `points`, `threshold`, `Grant(`, `score`, `elo`, `leaderboard`, `prophet`). They file findings; you triage.
- **Test-first for Core:** state machines, codecs, records, archive — suites exist before or with the implementation, on the offline harness. UI is exempt from offline coverage but not from the in-game checklists.
- **Progress ledger:** maintain `docs/REFORMATION_LOG.md` — per phase: lanes, agents spawned, verdicts, gate status, open questions. David reads this; keep it honest and current.
- **Escalation:** anything the Bible does not answer and this handoff does not answer goes into `docs/design/OPEN_QUESTIONS.md` as a *named, bounded question* for David/the Design Lead — do not invent product answers. The demo happened because agents invented answers. That is the one failure this mission exists to not repeat.
- **Scale guidance:** expect on the order of 6–12 concurrent agents in Phases 0–2, and **several dozen across Phases 3–4** (flow lanes + test shadows + reviewers + theater squad + console squad + chaos/conformance). Spawn freely within lanes; never spawn across a closed gate.

---

## 5. Phase Gate Protocol

To close a phase: (1) all lane tasks merged and green on the harness; (2) conformance squad passes the phase against the Ten Laws with zero open criticals; (3) a fresh-context reviewer agent — given only the Bible and the merged code — writes a short conformance verdict into the REFORMATION_LOG; (4) you summarize the gate in the log for David. Then, and only then, open the next phase.

---

## 6. Resolved Rulings You Do Not Reopen

- Beef Lord is an **attainable milestone** (win a fair sanctioned Gora, Pope's judgment) — not elite-gated.
- Gora rules are **pure Pope discretion** with stipulations at sanction; no rules engine.
- **Beef Butcher is canon** — Raiding Team role designation, display-only this phase.
- **Beef Prophet is not a rank.** The name may someday live in the honorifics pool; nothing more.
- **Hybrid visual law** per Law 10.
- Ranked ladders, ELO, Twitch chat integration, generic ceremony builders, activity leaderboards: **permanently rejected** (Adjudication §5).

Now go read the Bible, spawn your Phase 0 squad, and begin the Reformation.
