# Design Lead Directive — Gate 1 Rulings
## Response to the Cursor Orchestrator's Phase 0/1 Status Report

**From:** Design Lead
**To:** Cursor workspace orchestrator (Grok 4.6)
**Date:** 2026-08-14
**Authority:** Design Bible v1.1.1 → Adjudication → Audit → CURSOR_REWORK_HANDOFF.md → this directive
**File this under:** `docs/reformation/phase-1/` and reference it in the REFORMATION_LOG Gate 1 entry.

---

## 1. Gate 0: Ratified

Gate 0 is confirmed passed. Additionally, the integrator's eight law clarifications are **ratified as canonical interpretations** — record them as settled, not provisional:

- Narrative W/L streaks and honorifics are records of events, not engagement economies; Law 1 bans the latter only. Correct.
- Quiet Mode's ban includes sound; the version-mismatch notice is the sole permitted Quiet notice. Correct.
- Law 7's never-delete governs *Church history*: it does not ban human Council-role changes, nor Fresh Beef guild purges performed by other addons — and note the corollary, which is the important half: **a purged member's Church records persist**. The guild roster forgets; the Church does not.
- `Names.Key` is a spelling key, not durable identity; the Rite of Recognition is the identity mechanism. Correct.
- Curtain hides display only; rank lives on the human; Famous Upsets are Pope-flagged; no pairing scores or auto-sanction; KNIGHT THIS BEEF may call guild promote APIs where permitted; `rankIndex` is display/drift only. All correct.
- On the Audit-§4-vs-Bible-§5 conflict (Butcher): you resolved it correctly and in the correct direction — the Bible outranks the Audit, by the authority order both documents state. This is exactly how conflicts should die.

---

## 2. Answers to Your Three Asks

**Ask 1 — Is the leftover-sweep set the right Gate 1 close, and must the Roster/Officer/BeefNet cuts stay out of Phase 2–4 product?**

**Confirmed on both counts**, with the amendments in §3 below. The sweep lanes as you scoped them are correct: cut what speaks the dead engines, keep sensing and transport, invent nothing. Roster presence may be empty until the display-vs-truth rework; do not invent Church-id mapping. The Officer cut must not become the registered-Pope module; the BeefNet cut must not become v2 codecs; the DB test cut must not become the Pope store. Phase boundaries hold.

One clarification on your Officer concern ("fail-closed forever is also wrong"): **fail-closed is correct for the entire Phase 1 shell, on purpose.** Nothing in a Quiet-Mode-only addon legitimately exercises authority — there are no ritual verbs yet. Stub the authority module to refuse everything, have the rewritten tests assert the stub's shape, and leave a comment pointing at Phase 4. "Always false" only becomes wrong when there is something true to say, and that day is Phase 4's.

**Ask 2 — No commit until David asks?**

**Confirmed.** You do not commit without David's explicit instruction; that authority is his alone. Separately, I am recommending to David (outside this directive) that he authorize **gate commits** — one commit per closed gate — because two phases of uncommitted work on a single working tree is an unacceptable single point of failure for exactly the reasons the Sacred Archive exists. If he authorizes, commit Gate 0 and Gate 1 as two commits with the gate verdicts in the messages. Until he says so: no commits.

**Ask 3 — May the Gate 1 bar be lowered (harness red on Net until Phase 3)?**

**No. The bar stands: remaining tests green.** The red suites are not evidence that the bar is too high; they are evidence the sweep isn't finished — they still `dofile` deleted modules and encode the dead product. The fix is cutting and rewriting those suites to assert what actually ships (transport behavior, stub shapes, current DB defaults), which is precisely what your sweep lanes do. A gate that closes on red "because the red is expected" trains every future phase to negotiate with the gate. Green means green.

---

## 3. Amendments to the Sweep (add these before closing Gate 1)

**3a. UI leftovers lane (small, one agent + reviewer).** Three disclosed items are Phase 1 remainder, not later-phase work: (1) the dead tab registry and `ClassColorCode` walk over `GetLadderView` — cut with the Roster lane; (2) the footer joke **"Eternal Grazing."** — remove now; it is a live Law 10 violation (*the UI never tells jokes*) and costs one line; (3) the orphaned promote/rite toast copy builders — dead code, cut.

**3b. Gora stub containment.** `RecordResult` may remain through Gate 1 as inert code **only if it has zero callers** — no UI path, no slash command, no Net handler reaches it. The conformance grep must verify this. If severing it is trivial, prefer severing. Same rule for Ceremony's session stubs.

**3c. BeefNet: HELLO stays.** Version/presence discovery is transport, supports §21.3 version-skew handling, and survives into v2. Only SUGGESTION and everything standing/threshold-shaped dies.

**3d. TOC per-character SavedVariables: correct call.** It stays until Phase 2, as you ruled. Confirmed — no drive-bys through phase boundaries, even obviously-needed ones.

**3e. Client smoke: required, and it needs a human.** The in-game `/reload` pass cannot be closed by an agent — flag it in the log as **owner: David** (install → `/console scriptErrors 1` → `/reload` → confirm minimap presence and that `/beef` is an empty shell, BugGrabber+BugSack preferred). Gate 1 does not close without it; it is the only Law 6 evidence the harness cannot manufacture.

---

## 4. Design Rulings (removing blockers you correctly refused to invent)

**OPEN_QUESTIONS #9 — "Defense" is now resolved. Canonical definition:**

> **A defense is a victory by a sitting Beef Lord in a sanctioned Beef Gora fought after their elevation.**

It is a **derived statistic, not a system**: computed from the character's Gora record plus the elevation timestamp, displayed as a count on fighter cards and in the Records Book. Consequences: draws and Voids are not defenses; an opponent's Cowardice Recorded is a victory for the Lord and therefore a defense; there is no title-defense schema, no champion obligations, no sit-the-champ mechanics, no title at stake — the Pope may theatrically declare stakes, and that remains narrative, never mechanical. **Phase 2 note:** the Pope store's elevation records must carry a timestamp so this is computable; add that field to the Phase 2 schema.

**OPEN_QUESTIONS #8 — direction only (full spec lands with Phase 4; do not code now):** the registered-Pope character list must be trustworthy *before* any network state exists, so it ships as workspace data (a small data file, the same pattern as `Ranks.lua`), locally overridable. Council designations live in the Pope store and reach clients via Pope-originated state broadcasts. Exact file, edit path, and override UX are Phase 4 spec work. This is direction, not license to build.

---

## 5. Gate 1 Closing Checklist (restated, with amendments folded in)

1. Sweep lanes complete: Roster cut, Officer stub, BeefNet message cut (HELLO retained), DB test cut, UI leftovers lane (§3a).
2. Full harness green — no red suites, no skipped-as-red.
3. Conformance grep on live `addon/` + TOC: zero Criticals on `Grant(`, points faucet, Prophet rank, standing store, activity leaderboard, `threshold`, `suggestion`; zero callers into Gora/Ceremony stubs (§3b). Benign comment hits may be noted and waived explicitly, one by one.
4. Fresh-context reviewer verdict on the merged code (Bible + code only).
5. Human client smoke, owner David (§3e).
6. Gate 1 verdict written to `docs/REFORMATION_LOG.md`. Then, and only then, spawn Phase 2 — as written in the handoff, no rewrites.

The discipline in this report — signed lanes, refused inventions, escalated questions, an honest red harness rather than a massaged green one — is exactly what the Reformation asked for. Close the gate properly and proceed.

*— Design Lead*
