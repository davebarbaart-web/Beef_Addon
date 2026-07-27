# 30 — Writing effective agent goals (full-scope polish)

**Lane:** Agent polish vision  
**Audience:** Humans who dispatch Cursor (or similar) agents on Church of Beef polish work; agents that must refuse vague “make it nicer” briefs  
**Status:** Research + templates (not product law)  
**Date:** 2026-07-26  
**Authority reminder:** Spec / glossary / `Data/Ranks.lua` win over this note. This file teaches *how to brief agents*; it does not invent UI, ranks, or Net policy.

---

## 1. Why goals beat task lists

Agents fail polish work in predictable ways:

| Failure | Symptom | Goal fix |
|---------|---------|----------|
| **Done = code edited** | “Implemented toast” with no QA artifact | Force acceptance criteria + evidence |
| **Self-graded homework** | Declares polish complete after one pass | Mandate N critique cycles with a written delta |
| **Scope creep** | Custom gothic art mid–Task 7 | Explicit out-of-scope + stop conditions |
| **Missing client truth** | Green `lua tests/run.lua` treated as V1 UI done | Separate offline / in-game / two-client gates |
| **Silent product forks** | Invents thresholds or Retail APIs | Authority pointers + “do not invent” bans |
| **No handoff** | Stops mid-loop; human has no checklist | Human handoff block with decisions + residual risk |

Research patterns that transfer (adapt, don’t cargo-cult):

- **Reflexion** (Shinn et al.): Actor → Evaluator → verbal reflection → bounded retries. For CoB: implement → critique against rubric → write reflection → fix → stop at max trials or pass.
- **Ralph / fresh-context loops**: Code on disk is memory; vague goals → thrash. Success needs *testable* completion promises and max iterations.
- **CoB verification doctrine** (`.cursor/rules/verification.mdc`, skill `church-of-beef-dev`): offline harness ≠ spectacle; guild/net needs two clients; do not claim V1 complete without `docs/phases/v1-checklist.md`.

**Doctrine for this project:** A polish *goal* is a contract that names the player-visible outcome, the evidence, the critique budget, what to leave on disk, when to stop, and what only a human may decide.

---

## 2. Anatomy of a full-scope polish goal

Every goal should fill these eight blocks. Empty blocks are a red flag — fill or explicitly mark `N/A` with why.

| Block | Purpose | CoB-specific note |
|-------|---------|-------------------|
| **A. Intent** | One sentence: who feels what, when | Social / stream moment, not DPS HUD |
| **B. Scope & authority** | In / out; which docs are law | Spec §10/§15, UI brief, glossary 74–81, `Ranks.lua` |
| **C. Acceptance criteria** | Binary, observable checks | Mix offline + `/reload` + (if needed) two-client |
| **D. Critique cycle** | How many judge→fix loops + rubric | Cap cycles; require written deltas |
| **E. Artifacts** | Files the agent must leave | Diff + QA note + critique log; never wipe WTF |
| **F. Stop conditions** | When to halt without “success” | Max cycles, blocker types, safety trips |
| **G. Human handoff** | What only a human signs off | Spectacle taste, guild-night reaction, publish |
| **H. Non-goals / bans** | Explicit don’ts | No bots, no Retail APIs, no Core→UI, no Media in V1 UI |

---

## 3. Master template (copy-paste)

```markdown
# GOAL: <short slug> — <player-facing outcome>

## A. Intent
In one sentence: when <trigger>, <role> should <feel/see/do X>
so that <guild/stream value>.

## B. Scope & authority
- **In scope:** …
- **Out of scope:** …
- **Law (read in order):**
  1. `docs/superpowers/specs/2026-07-25-church-of-beef-design.md` (§…)
  2. `docs/superpowers/ui-polished-direction-for-agents.md` (if UI)
  3. Glossary / locked decisions (rows …)
  4. `addon/ChurchOfBeef/Data/Ranks.lua` (numbers/titles only)
  5. Plan task(s): …
- **Layers:** UI→Core→Data / Net→Core→Data; UI never awards points;
  Net never invents ranks; Core never CreateFrame.

## C. Acceptance criteria (all must be true)
### Offline
- [ ] `lua tests/run.lua` exits 0 (if Core/Data/harness touched)
- [ ] TOC lists only existing files; Interface remains `20506` unless intentional

### In-game (Anniversary client)
- [ ] `/console scriptErrors 1` → `/reload` → path exercised with 0 Lua errors
- [ ] <specific UI/Net/SV check 1>
- [ ] <specific UI/Net/SV check 2>

### Multi-client (only if Net/officer/sync)
- [ ] Officer+ client A and Member client B both online with addon
- [ ] <sync / commit / forge-ignore check>

### Polish / product
- [ ] Matches doctrine: <Classic shell / brand-in-words / …>
- [ ] Anti-patterns avoided: <list from UI brief>
- [ ] No invented thresholds, titles, or Retail-only APIs

## D. Critique cycle
- **Budget:** <N> full cycles (recommend 2–4 for UI polish; 1–2 for Core-only)
- **Cycle definition:**
  1. Implement or revise against acceptance criteria
  2. Critique using rubric below (self or second-pass persona)
  3. Write a short delta: what failed, what changes next
  4. Fix; do not expand scope
- **Rubric dimensions** (score Pass/Fail each cycle):
  - Correctness (behavior matches spec)
  - Clarity (player can parse in <3s / stream-readable)
  - Hierarchy (prestige / pending / action contrast)
  - Restraint (no WA-center, no art-scope creep)
  - Safety (taint, lockdown, no automation)
  - Evidence (artifact updated this cycle)
- **Early exit:** all acceptance criteria Pass + rubric all Pass → stop even if cycles remain

## E. Artifacts (must exist before claiming done)
- [ ] Code/docs changes in the addon checkout (worktree path OK)
- [ ] `docs/research/agent-polish-vision/artifacts/<slug>-critique.md`
      with per-cycle notes (or append to existing)
- [ ] QA evidence: commands run + results (paste harness summary;
      for in-game: what was clicked / which characters)
- [ ] If blocked: `.../<slug>-handoff.md` with residual risks

## F. Stop conditions (halt and hand off — do not fake green)
Stop immediately when any of:
- Critique budget exhausted with open Fail dimensions
- Spec/glossary conflict or missing product decision
- Needs real guild-night social reaction (criterion §13.11 class)
- Would require bots, injection, protected-action bypass, or WTF wipe
- Would require custom `Media/` / SFX in V1 UI tasks
- Two-client environment unavailable for a Net acceptance criterion
- Offline harness fails and root cause is unclear after one focused fix pass

## G. Human handoff
Ask a human when:
- Taste call: announce copy, toast duration, tab density
- Live guild spectacle validation
- Officer rank-index / guild structure assumptions
- Packaging upload / CurseForge / zip distribution
Deliver in handoff: intent, what passed, what’s blocked, exact next human action,
files touched, recommended follow-up goal slug.

## H. Non-goals / bans
- No combat automation, SecureActionButton-for-panels, tip jars
- No forking rank numbers into `docs/canon/` or UI copy docs
- No AceAddon / Masque / SharedMedia hard deps in V1
- No claiming “V1 complete” — only this goal’s criteria
```

---

## 4. Compact template (chat dispatch)

Use when pasting into an agent turn. Keep under ~40 lines; link the master template for detail.

```markdown
GOAL <slug>: <one-line outcome>

Authority: spec §… · UI brief · glossary … · Ranks.lua · plan Task …
In: … | Out: …

Acceptance:
- Offline: …
- In-game: …
- Two-client (if any): …
- Polish: …

Critique: <N> cycles; rubric = correctness, clarity, hierarchy, restraint, safety, evidence.
Each cycle: fix → critique → write delta in artifacts/<slug>-critique.md → fix.

Stop if: budget exhausted | product ambiguity | needs guild-night | safety ban | Media creep | no 2nd client for Net.

Handoff to human: <taste / live spectacle / publish>.
Done means: all acceptance ✅ + critique log + no open Fail rubric rows.
Bans: no bots/Retail APIs/Core→UI/UI-awards-points/invented thresholds.
```

---

## 5. Critique-cycle sizing guide

| Work type | Suggested cycles | Why |
|-----------|------------------|-----|
| Pure Core/Data + harness | 1–2 | Evaluator ≈ tests; second cycle for edge cases |
| Single UI surface (tab, toast) | 2–3 | First pass structure, second hierarchy/copy, third restraint |
| Officer + announce + toast chain | 3–4 | Multi-surface choreography; easy to over-animate |
| BeefNet / sync | 2 + mandatory two-client | Self-critique cannot prove wire behavior |
| “Full polish pass” across addon | Split into multiple goals | One goal ≠ whole product |

**Rule:** If you need more than 4 cycles, the goal is too big or acceptance criteria are mushy — split or rewrite criteria.

---

## 6. Acceptance criteria patterns (steal these shapes)

**Good (binary, observable):**

- “Officer tab hidden for non-officer after `GUILD_ROSTER_UPDATE`; no Lua error.”
- “Approve on A → B shows new title within one BeefNet commit path; revision increases.”
- “Standing shows text thresholds only; no `StatusBar` for standing.”
- “Announce opt-out silences `/g` line; commit and private toast still occur.”

**Bad (agent will fake-done):**

- “Make the ladder feel prestigious.”
- “Polish the officer UX.”
- “Improve BeefNet reliability.”
- “Match the brand.”

**Upgrade trick:** attach *measure* + *evidence*:

- Feel → “Class color on names only; pending/approve/reject dual-encoded (color ≠ sole signal).”
- Polish → “3s readability: title, standing-to-next, primary action visible without scroll on 1080p default UI scale.”
- Reliability → “Stale client C offline during commit; on login `SYNC_*` path shows committed rank without re-approve.”

---

## 7. Artifact conventions

Suggested path (research lane; not shipped to players):

```
docs/research/agent-polish-vision/artifacts/
  <slug>-critique.md
  <slug>-handoff.md          # only if stopped blocked
```

Minimal critique file:

```markdown
# Critique log — <slug>

## Cycle 1
- Rubric: correctness ✅/❌ · clarity · hierarchy · restraint · safety · evidence
- Failures: …
- Delta for cycle 2: …

## Cycle 2
…

## Final
- Acceptance checklist: all ✅ / blocked at …
- Evidence: `lua tests/run.lua` → … ; in-game: …
```

Never treat screenshots as required (agents often lack them); prefer structured click-paths and BugSack-clean statements. Humans may attach captures later.

---

## 8. Anti-patterns in goal writing

1. **Verb without visitor** — “Refactor OfficerTab” (no player outcome).
2. **Unbounded polish** — no cycle cap → endless micro-tweaks.
3. **Harness-only done** for UI/Net/SV.
4. **Hidden authority** — “use best judgment for ranks” (forbids inventing numbers).
5. **Merged goals** — toast + BeefNet crypto-audit + art pack in one brief.
6. **Success = agent opinion** — must be checklist + critique log.
7. **No stop for missing second client** — agent invents “sync works.”
8. **Asking agent to publish** — packager upload is always human.

---

## 9. Five filled example goals (Church of Beef)

### Example 1 — Ladder tab readability (UI)

```markdown
# GOAL: ladder-tab-readability — Seven titles scannable in one glance

## A. Intent
When a member opens `/beef` → Ladder, they should identify all seven titles,
their own row, and relative prestige within ~3 seconds so the ladder feels like
an institution, not a spreadsheet dump.

## B. Scope & authority
- **In scope:** `UI/LadderTab.lua` (+ MainFrame tab wiring if needed); typography,
  row density, self-highlight, empty/not-in-guild state.
- **Out of scope:** Custom Media, SFX, Streamer Mode, changing thresholds,
  Officer/Standing tabs beyond shared shell consistency.
- **Law:** Spec §10/§15 · `ui-polished-direction-for-agents.md` · glossary 74–81 ·
  `Data/Ranks.lua` · Plan Task 7+
- **Layers:** UI reads Core/Data only; never awards points.

## C. Acceptance criteria
### Offline
- [ ] If any Core/Data touched: `lua tests/run.lua` exits 0
- [ ] TOC truth preserved (`20506`)

### In-game
- [ ] `/beef` → Ladder shows all 7 canon titles in order; numbers match `Ranks.lua`
- [ ] Local player row distinguishable without relying on color alone
- [ ] Not-in-guild: empty/honest state, no Lua errors
- [ ] `/console scriptErrors 1` clean through open/close/reload

### Polish
- [ ] Classic FrameXML shell; opaque high-contrast; GameFont*
- [ ] Class color on **names** only; no item-quality rainbow for ranks
- [ ] No Details!-dense meter chrome; no glass/low-alpha panels

## D. Critique cycle
- **Budget:** 3 cycles
- **Rubric:** correctness, clarity (3s scan), hierarchy (Prophet/Council vs flock),
  restraint, safety, evidence

## E. Artifacts
- [ ] Code in addon checkout
- [ ] `artifacts/ladder-tab-readability-critique.md`
- [ ] QA note: characters used + click path

## F. Stop conditions
Budget exhausted with Fail · product asks for custom seals/art · cannot access Anniversary client

## G. Human handoff
Human: 1080p stream-read glance test; optional capture for north-star canvas.

## H. Bans
No StatusBar prestige meters · no Retail templates · no SecureActionButton
```

---

### Example 2 — My Standing thresholds & breakdown (UI + Core read)

```markdown
# GOAL: standing-tab-thresholds — Text progress without HP-bar metaphor

## A. Intent
When a player opens My Standing, they should see current title, standing total,
and text progress toward the next *point-driven* title — never a fake bar to
Council/Prophet — so advancement rules stay honest.

## B. Scope & authority
- **In scope:** `UI/StandingTab.lua`; read-only use of Ladder/Scoring summaries;
  copy for appointed/bestowed ranks.
- **Out of scope:** Changing score formulas; officer evidence panel density beyond
  what’s already planned; ceremony theater.
- **Law:** Spec §4/§10 · UI brief (Standing: text thresholds only) · track 70 notes ·
  `Ranks.lua`

## C. Acceptance criteria
### Offline
- [ ] Harness green if Core touched
- [ ] Unit/fixture coverage for “next rank nil when Council/Prophet” still holds

### In-game
- [ ] Point-driven ranks show text threshold / remaining (no hero StatusBar)
- [ ] At Beef Butcher eligible for Council path: UI states appointment — no numeric
      “points to Council”
- [ ] Source breakdown readable (Gora / ceremony / co-play) without meter clutter
- [ ] Reload persists displayed standing from SV

### Polish
- [ ] Dual-encode any pending suggestion state on this tab if shown
- [ ] Anti-patterns: standing-as-castbar, tip jars, ElvUI-flat brand takeover

## D. Critique cycle
- **Budget:** 3 cycles
- **Rubric:** correctness (canon), clarity, hierarchy, restraint, safety, evidence

## E. Artifacts
- [ ] `artifacts/standing-tab-thresholds-critique.md` + QA click path

## F. Stop conditions
Ambiguity in breakdown IA → hand off with options (do not invent chips)

## G. Human handoff
Human picks final microcopy tone if agent proposes >1 lawful variant.

## H. Bans
No inventing threshold numbers in docs/UI strings · no auto-promote
```

---

### Example 3 — Officer Commit → guild announce + private toast (spectacle chain)

```markdown
# GOAL: promote-spectacle-chain — Commit feels public without WA pulses

## A. Intent
When an Officer+ commits a promotion, the guild should get one throttled `/g`
line (if announce enabled) and the promotee a private edge toast — so rank
changes are social events, not silent SV mutations.

## B. Scope & authority
- **In scope:** Officer approve path → `UI/Announce.lua` + `UI/Toasts.lua` wiring;
  settings checkbox default ON; throttle/single-announcer behavior per spec.
- **Out of scope:** Custom SFX, center-screen pulses, Streamer Mode, art seals.
- **Law:** Spec §10/§13.11 · UI brief spectacle bullets · glossary announce rows ·
  track 72 · Plan Net/UI tasks
- **Layers:** UI does not commit ranks; calls Core; Net sends after Core success.

## C. Acceptance criteria
### Offline
- [ ] Harness green for any Core/Net encode changes

### In-game (Officer+)
- [ ] Approve suggestion → local ladder updates; toast on promotee path verified
      (same client if promotee = self test OK; else two clients)
- [ ] Guild chat shows exactly one promotion line when announce ON
- [ ] Announce OFF → no `/g` line; commit still applies; toast still allowed
- [ ] No center-screen WA-style pulse; toast is edge/private per spec
- [ ] scriptErrors clean

### Two-client
- [ ] Officer A commits for Member B → B sees rank + toast; A’s announce visible in `/g`

### Polish
- [ ] Copy is brand-in-words (holy/absurd institution), not generic “Player promoted”
- [ ] Throttle: spam-click approve does not flood chat (single commit → single line)

## D. Critique cycle
- **Budget:** 4 cycles (choreography is easy to overbuild)
- **Rubric:** correctness, clarity (stream-readable `/g`), hierarchy (toast ≠ raid alert),
  restraint (no Media/SFX), safety, evidence

## E. Artifacts
- [ ] `artifacts/promote-spectacle-chain-critique.md`
- [ ] Explicit note of announce ON/OFF trials

## F. Stop conditions
Cannot run two clients for B’s toast → stop; hand off with A-only evidence listed
Guild-night “someone reacted” (§13.11) is **human** — agent must not claim that pass

## G. Human handoff
Human: live guild-night social check; final announce string taste.

## H. Bans
No bots to fake guild chat · no combat HUD steal · no custom Media
```

---

### Example 4 — BeefNet login sync repairs stale ladder (Net)

```markdown
# GOAL: beefnet-login-sync — Offline during promote, correct on login

## A. Intent
When a member misses a live `RANK_COMMIT`, logging in later should repair their
ladder via sync so officers never re-click Approve for that revision.

## B. Scope & authority
- **In scope:** `Net/BeefNet.lua`, `Net/Sync.lua` (names per checkout), revision
  rules in Core Ladder apply-remote; anti-reply-storm.
- **Out of scope:** Redesigning score testimony trust model; adding encryption;
  UI chrome.
- **Law:** Spec §8 · verification.mdc guild/net rules · plan Task sync ·
  track 14/27/68 as depth only

## C. Acceptance criteria
### Offline
- [ ] `lua tests/run.lua` exits 0 with sync/revision cases covered
- [ ] Forged / older revision apply rules unit-tested

### Two-client (required — do not skip)
- [ ] A Officer+ commits while C is offline / addon disabled
- [ ] C logs in with addon → ends on committed rank without re-approve
- [ ] Member cannot forge `RANK_COMMIT` that peers apply (spec §13.9 style check)
- [ ] No send storms: observe reasonable quiet after sync settles

### In-game safety
- [ ] Not-in-guild: no BeefNet sends; no errors
- [ ] scriptErrors clean on login path

## D. Critique cycle
- **Budget:** 2 cycles after harness green; plus mandatory two-client evidence
- **Rubric:** correctness (revision), clarity (N/A UI), hierarchy N/A,
  restraint (no chatty SCORE spam), safety, evidence (two-client log)

## E. Artifacts
- [ ] `artifacts/beefnet-login-sync-critique.md` with A/C character names + steps
- [ ] Harness summary paste

## F. Stop conditions
Only one client available → STOP and hand off (never mark sync ✅)
Ambiguous conflict rule vs spec → human decision, no silent fork

## G. Human handoff
Human re-runs §13.7–§13.9 on real guild chars before calling Net done.

## H. Bans
No ResetForTests outside harness · no WTF deletion · no Retail chat APIs
```

---

### Example 5 — Officer tab suggestion queue IA (UI + officer gate)

```markdown
# GOAL: officer-queue-ia — Suggest → Approve/Reject without loot-council chaos

## A. Intent
When an Officer+ opens the Officer tab, they should see pending promotion
suggestions with enough evidence to decide, confirm destructive actions, and
never see Council/Prophet as point-suggestion targets.

## B. Scope & authority
- **In scope:** `UI/OfficerTab.lua`, confirm handoffs, empty states, recent actions
  strip if already planned; gate via `Core/Officer.lua`.
- **Out of scope:** Full ceremonial dashboard; demote/excommunicate copy marathon
  beyond confirm friction; changing `OfficerRankIndexMax`.
- **Law:** Spec §6/§10 · UI brief · glossary · track 69 officer-tab IA ·
  `Ranks.lua` seats/uniqueness

## C. Acceptance criteria
### Offline
- [ ] Harness green for officer gate + suggestion list invariants
- [ ] Council/Prophet never appear as threshold suggestions in tests

### In-game
- [ ] Member: Officer tab hidden / inaccessible; approve no-ops if forced
- [ ] Officer+: pending list shows name, current title, target title, standing snapshot
- [ ] Approve → commit path; Reject → clears suggestion; both leave honest empty state
- [ ] Appoint Council / Bestow Prophet paths (if exposed) enforce seats/uniqueness
      with confirm friction — no accidental click
- [ ] Roster not ready: soft wait / empty, no Lua error spam

### Polish
- [ ] Dual-encode pending vs approved affordances
- [ ] Density below Details!; evidence is a short list, not a meter

## D. Critique cycle
- **Budget:** 3 cycles
- **Rubric:** correctness, clarity (decide in one screen), hierarchy (primary Approve),
  restraint, safety (gate), evidence

## E. Artifacts
- [ ] `artifacts/officer-queue-ia-critique.md`
- [ ] Member vs Officer character matrix in QA notes

## F. Stop conditions
Guild rank index assumptions unclear for this guild → hand off; do not hardcode names
Seat policy dispute → human updates `Ranks.lua` / spec, not UI guesses

## G. Human handoff
Human confirms OfficerRankIndexMax matches real guild structure before raid-night use.

## H. Bans
UI never awards points · Net never invents ranks · no auto-promote on threshold
```

---

## 10. How to dispatch (operator checklist)

1. Pick **one** slug; resist bundling spectacle + sync + art.
2. Fill compact template; link acceptance to spec § / checklist row numbers when possible.
3. Preflight environment: Anniversary AddOns path, `scriptErrors`, second client if Net.
4. Cap critique cycles in the goal text (agents ignore vibes, not integers).
5. Require the critique artifact path by name.
6. On return: verify artifacts + run the same acceptance checks yourself for claims that matter (especially §13.11).

---

## 11. Relationship to other docs

| Doc | Role vs this note |
|-----|-------------------|
| `docs/superpowers/specs/2026-07-25-church-of-beef-design.md` | Product law |
| `docs/superpowers/ui-polished-direction-for-agents.md` | UI doctrine agents must read |
| `docs/phases/v1-checklist.md` | Human walkable V1 completion |
| `.cursor/skills/church-of-beef-dev/SKILL.md` | Install / reload / harness loop |
| `.cursor/rules/verification.mdc` | Done means + agent must-nots |
| This file (`30-…`) | **How to write goals** that drive polish to those bars |

---

## 12. Sources (orienting)

- Reflexion: verbal reinforcement + bounded trials — [arXiv:2303.11366](https://arxiv.org/abs/2303.11366)
- Ralph-style loops: fresh context, persistent code, completion promises — Geoffrey Huntley / Cursor community ports (see `_search-cursor-agent-loops.json` in this folder)
- CoB internal: verification rules, UI brief, V1 checklist, design spec §13 success criteria

Scrapes under `_search-*.json` are orientation only — not product truth.
