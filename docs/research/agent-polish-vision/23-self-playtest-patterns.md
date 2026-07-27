# 23 — Self-playtest patterns for AI coding agents (Church of Beef)

**Status:** Research guidance (not product law)  
**Audience:** Coding agents polishing V1 UI / Core after Task 7+  
**Date:** 2026-07-26  
**Authority order:** Spec §10/§15 → glossary 74–81 → `ui-polished-direction-for-agents.md` → this note  
**Ops loop:** `.cursor/skills/church-of-beef-dev/SKILL.md` · verification: `.cursor/rules/verification.mdc`

---

## 1. Problem

Web/desktop AI agents can close a **code → run → observe → fix** loop with Playwright, DOM dumps, and headless browsers. Church of Beef runs inside **WoW TBC Classic Anniversary** (`Interface: 20506`). The client is not a DOM app: there is no reliable agent-driven click automation, no CI-hosted Anniversary instance, and ToS/safety rules forbid bots, injection, and protected-action bypass.

Green `lua tests/run.lua` proves Core/Data policy. It does **not** prove frames, BeefNet, SavedVariables, or spectacle. Agents still need a **self-playtest** discipline that fits those limits.

---

## 2. Industry patterns (steal the shape, not the stack)

| Pattern | What it is | Web/desktop default | Beef adaptation |
|---------|------------|---------------------|-----------------|
| **Offline oracle** | Fast, deterministic asserts before any human/client step | Unit/integration tests, REPL checks ([Replit Agent 3](https://replit.com/blog/automated-self-testing)) | Existing `tests/run.lua` harness (track [73](../wow-classic-addon-design/73-desktop-lua-testing/)) |
| **Interaction script** | Rerunnable steps that exercise UI and capture evidence | Playwright/Webwright scripts ([Hücki playtester](https://huecki.com/en/blog/ai-built-ui-needs-a-playtester/)) | **Human-executed slash + click scripts** with fixed scenario IDs (not OS-level input injection) |
| **Screenshot / visual observer** | Capture frames after actions; VLM or second agent judges “silent failures” | PlayCoder VisualObserver ([arXiv:2604.19742](https://arxiv.org/html/2604.19742)); CUA-as-judge ([arXiv:2511.15567](https://arxiv.org/html/2511.15567v1)) | Player/`Screenshot()` PNGs → agent **reads image files** against a rubric |
| **Scenario checklist** | Coverage-driven paths when there is no single “win” state | PlayCoder coverage-driven non-game testing; Reflexion verbal memory ([arXiv:2303.11366](https://arxiv.org/abs/2303.11366)) | Named smoke scenarios + track [19](../wow-classic-addon-design/19-testing-debugging-qa/) QA checklist |
| **Separate playtester role** | Builder agent ≠ judge agent (self-grading is weak) | PlayCoder PlayTester / PlayRefiner | Same chat OK if **rubric + evidence** are external; prefer a critique pass that only sees screenshots + checklist |
| **Ralph / iteration loops** | Fresh context, persistent artifacts, stop on completion promise | Ralph Wiggum loops in Cursor | Loop on harness + critique notes written to disk — never on “I think `/beef` works” |

**Key steal:** evidence beats vibes. Persist (1) harness exit code, (2) ticked scenario rows, (3) screenshot paths + critique bullets. Do not claim UI polish from code review alone.

---

## 3. WoW-specific limits (hard)

### 3.1 Cannot easily automate the client

| Wanted capability | Reality on Anniversary |
|-------------------|------------------------|
| Headless CI “open `/beef`” | No first-class Anniversary headless client for Beef V1 |
| Agent clicks tabs / drags frame | No approved OS automation of the live client (ToS + `verification.mdc` / skill: no bots, no external process control) |
| DOM / accessibility tree | FrameXML widgets — not web ARIA |
| Full FrameXML emulator in CI | Optional ecosystem tools ([wowless](https://github.com/lua-wow-tools/wowless), [wow-ui-sim](https://github.com/Osso/wow-ui-sim)) are Retail-skewed / heavy; track [73] explicitly **non-goals** headless screenshot UI tests for V1 |
| In-addon `Screenshot()` gallery | Possible later (cousin pattern: deterministic shot manifests). Still needs a human (or hardware event) in the client; not a substitute for two-client BeefNet |

### 3.2 Safety non-negotiables (from verification + skill)

- No combat automation, injection, protected-action bypass, or gameplay bots  
- Do not scrape chat/combat logs for “support dumps”  
- Do not delete/overwrite `WTF/**/ChurchOfBeefDB.lua` without explicit user ask  
- Do not call `ResetForTests` outside the harness (`ChurchOfBeef._IN_TEST`)  
- Guild/net proof needs **two clients** (Officer+ and Member)  
- Research guidance ≠ green harness or client smoke

### 3.3 What *does* work for agents

1. **Desktop Lua** — mutate Core/Data, run harness, read failures  
2. **Install sync** — `rsync`/`cp` into `WOW_ADDONS_DIR` per skill  
3. **Structured human smoke** — agent writes the script; human (or operator) executes; results come back as ticks + BugSack text + PNGs  
4. **Vision on files** — Cursor agents can **Read** screenshot images and critique against UI doctrine  
5. **Static UI audit** — TOC truth, template inheritance, layer rules, copy IDs vs glossary — no client required

---

## 4. Hybrid protocol (normative recommendation)

Three layers. Agents must not skip Layer A for Core/Data edits, or Layer B for UI/Net/SV/slash edits. Layer C is required before claiming visual polish or brand-hex readiness.

```text
┌─────────────────────────────────────────────────────────────┐
│  A. Offline harness     lua tests/run.lua → exit 0          │
│     (policy / pure transitions)                             │
├─────────────────────────────────────────────────────────────┤
│  B. Structured in-game smoke   install → scriptErrors →     │
│     /reload → scenario script → ticks + BugSack             │
├─────────────────────────────────────────────────────────────┤
│  C. Visual critique     screenshots → VLM/agent rubric      │
│     (silent layout failures the harness cannot see)         │
└─────────────────────────────────────────────────────────────┘
```

### Layer A — Offline harness

**When:** Every Core / Data / harness change (and keep green on UI PRs).  
**How:** Skill §0–1 / `./scripts/run-tests.sh`.  
**Proves:** Ranks, ladder, scoring, officer injection, net **validate** (as suites exist).  
**Does not prove:** Frames, CTL, SV round-trip, guild chat spectacle.

Exit gate: `Tests finished: N passed, 0 failed`.

### Layer B — Structured in-game smoke scripts

**When:** Any UI / Net / SV / slash change; always before “UI done.”  
**How:** Agent prepares a **scenario card** (below); operator runs it in Anniversary; returns evidence.

**Install (agent-runnable):**

```bash
# ADDON_ROOT from church-of-beef-dev skill §0
rsync -a --delete "$ADDON_ROOT/addon/ChurchOfBeef/" "$WOW_ADDONS_DIR/ChurchOfBeef/"
```

**Client preamble (every session):**

1. Correct Anniversary AddOns folder; Church of Beef enabled  
2. `/console scriptErrors 1` (+ BugGrabber/BugSack preferred)  
3. `/reload`  
4. Confirm no Beef-attributed BugSack errors  

**Scenario cards (agent emits these; human ticks):**

| ID | Role | Steps | Pass criteria |
|----|------|-------|---------------|
| `S0-load` | Any | `/reload` → `/beef` | Frame opens; no Lua error |
| `S1-tabs` | Member | Open Ladder, My Standing; confirm Officer hidden | Three-tab IA; officer gate holds |
| `S2-officer` | Officer+ | Officer tab visible; open pending/empty states | No error; dual-encoded states readable |
| `S3-move-sv` | Any | Drag frame → `/reload` → `/beef` | Position persisted |
| `S4-combat` | Any | Enter combat → `/beef` open/tabs/minimap | No taint/BugSack from Beef insecure frames |
| `S5-net` | Officer+ **and** Member | Commit/suggest path per change under test | Peer ladder update; two clients |
| `S6-spectacle` | Officer+ + guild | Promote announce path | Throttled `/g` line; private toast; **product** reaction is guild-night only |

Deeper coverage: [church-of-beef-qa-checklist.md](../wow-classic-addon-design/19-testing-debugging-qa/church-of-beef-qa-checklist.md). Guild pacing/spectacle: [`docs/phases/guild-night-playtest.md`](../../phases/guild-night-playtest.md).

**Interaction script format (copy into chat or a scratch note):**

```markdown
## Smoke: <change summary>
- Build: <sha or date> · Interface 20506
- Clients: [ ] Officer+  [ ] Member  [ ] (optional) no-addon witness

### Run
1. [ ] Install synced to ChurchOfBeef/
2. [ ] scriptErrors 1 · BugSack clear
3. [ ] /reload · /beef → S0
4. [ ] …scenario IDs…

### Evidence back to agent
- BugSack: none | paste stack
- Ticks: S0… 
- Screenshots: path list (see Layer C)
```

Agents **write and grade** the script from returned ticks; they do not drive the mouse in-client.

### Layer C — Visual critique of screenshots

**When:** After Layer B for any visual/layout/copy change; required for brand-hex / chrome lock discussions (glossary rows 78, 81).  
**Capture (human):**

| Shot ID | Content | Notes |
|---------|---------|-------|
| `V-ladder` | Ladder tab, player highlight | Opaque panel; GameFont*; class color on **names** only |
| `V-standing` | My Standing | Text thresholds only — no hero StatusBar |
| `V-officer` | Officer+ queue / empty | Dual-encode pending/approve/reject |
| `V-toast` | Private edge toast (if triggered) | No center-screen WA pulse |
| `V-minimap` | Minimap button + open frame | Guest on player `uiScale` |
| `V-chat` | Guild promote line (spectacle) | Words-as-brand |

Drop PNGs into a local folder the agent can read (e.g. workspace `tmp/playtest-shots/` — do not commit player-identifying clutter; see track [65](../wow-classic-addon-design/65-debug-dumps-privacy/)).

**Critique rubric (agent reads each image):**

1. **Shell doctrine:** Classic Blizzard template chrome, not ElvUI-flat brand, not gothic commission art in V1  
2. **Contrast:** Opaque high-contrast panels; text readable at stream distance  
3. **Hierarchy:** One primary job per tab; no Details!-dense meter dashboard  
4. **Bans:** WA center pulses · item-quality rainbow ranks · glass/low-alpha · tip jars · SecureActionButton chrome  
5. **Copy:** Titles/thresholds match `Data/Ranks.lua` — never invent numbers  
6. **Scale:** No accidental full-UI scale change; frame clamped on screen  
7. **Silent failures:** Truncation, overlapping FontStrings, empty black panels, cut-off buttons, tab misalignment  

**Output shape (agent → human):**

```markdown
## Visual critique <date>
| Shot | Verdict | Issues |
|------|---------|--------|
| V-ladder | pass/fail | … |

Fixes (ordered): …
Re-smoke: S0 + affected scenarios
```

Optional second-pass: a **playtester** subagent that only receives screenshots + rubric (not the Lua it wrote) — mirrors industry “don’t grade your own homework.”

---

## 5. Agent loop (end-to-end)

```text
1. Edit Lua (respect UI→Core→Data; no Core CreateFrame)
2. Layer A: lua tests/run.lua          → fix until 0 failed
3. TOC truth: listed files exist; Interface 20506
4. Install to WOW_ADDONS_DIR
5. Emit Layer B scenario card for the change
6. Operator runs card → returns ticks + BugSack + PNGs
7. Layer C: Read screenshots → critique vs rubric + ui brief
8. If fail: patch → goto 2 (narrow scenarios)
9. Stop only when A green ∧ B ticked ∧ C pass
   Never claim V1 complete without docs/phases/v1-checklist.md walk
```

**Completion promise (Ralph-style):** useful for polish loops —

`PLAYTEST_PASS: harness0 + S0..Sn ticked + visual critique pass`

Do not treat a lone `/beef` open as done for officer/net work.

---

## 6. What belongs where

| Artifact | Location |
|----------|----------|
| Policy / safety | `.cursor/rules/verification.mdc` |
| Install / reload ops | `.cursor/skills/church-of-beef-dev/SKILL.md` |
| Offline harness how-to | `.cursor/rules/testing.mdc` · track [73](../wow-classic-addon-design/73-desktop-lua-testing/) |
| Full in-game QA | track [19 checklist](../wow-classic-addon-design/19-testing-debugging-qa/church-of-beef-qa-checklist.md) |
| Guild-night product gates | [`docs/phases/guild-night-playtest.md`](../../phases/guild-night-playtest.md) |
| UI doctrine for CreateFrame | [`docs/superpowers/ui-polished-direction-for-agents.md`](../../superpowers/ui-polished-direction-for-agents.md) |
| This hybrid self-playtest protocol | **this file** |
| Future tooling (wow-ui-sim, hooks, shot manifests) | [`OPTIMIZATIONS.md`](../../../OPTIMIZATIONS.md) — needs human approval |

---

## 7. Explicit non-goals (V1)

- OS-level WoW window click bots or pixel-bot “playtesters”  
- Claiming Playwright-class automation against the live client  
- Replacing two-client BeefNet labs with mocks  
- Headless screenshot CI as a V1 ship gate  
- Auto-deleting WTF or scraping chat for dumps  
- Treating Layer C pass as brand-hex **law** without an intentional Anniversary screenshot lock (spec §10 / glossary 78)

---

## 8. Sources (annotated)

| Source | Use |
|--------|-----|
| [PlayCoder](https://arxiv.org/html/2604.19742) | Screenshot observer + interaction loop; silent UI failures |
| [CUA as UI judges](https://arxiv.org/html/2511.15567v1) | Separate navigator/judge; compact visual dashboards |
| [Hücki — playtester not screenshot-only](https://huecki.com/en/blog/ai-built-ui-needs-a-playtester/) | Rerunnable scripts + evidence-backed bugs |
| [Replit Agent 3 self-test](https://replit.com/blog/automated-self-testing) | Hybrid code execution + browser verification (shape only) |
| [Reflexion](https://arxiv.org/abs/2303.11366) | Verbal memory of failures across iterations |
| Ralph / Cursor loops | Fresh context; completion promises; artifacts on disk |
| [wowless](https://github.com/lua-wow-tools/wowless) / [wow-ui-sim](https://github.com/Osso/wow-ui-sim) | Future optional headless FrameXML — not V1 dependency |
| Church of Beef skill + verification + tracks 19/73 | Local law for what agents may automate |

---

## 9. One-page protocol (copy)

**Path:** `docs/research/agent-polish-vision/23-self-playtest-patterns.md`

**Protocol:**

1. **A — Offline:** `lua tests/run.lua` → `0 failed` (Core/Data/harness).  
2. **Install:** sync `addon/ChurchOfBeef/` → `Interface/AddOns/ChurchOfBeef/`.  
3. **B — Smoke script:** `scriptErrors 1` → `/reload` → `/beef` → tick scenario IDs `S0`… for the change (two clients if Net/officer).  
4. **C — Screenshots:** capture `V-*` shots → agent Read + critique against UI brief / bans.  
5. **Fix loop:** patch → A → B → C until harness green, scenarios ticked, critique pass.  
6. **Never:** automate the live client; skip B for UI; claim spectacle from unit tests alone.
