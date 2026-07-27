# 00-CURSOR-WIRING-AUDIT — Polish-vision → Cursor primitives

**Lane:** `docs/research/agent-polish-vision/`  
**Date:** 2026-07-26  
**Auditor:** wiring pass after user Accepted ADRs 0001–0010  
**Reviewed against:** [`00-SYNTHESIS.md`](00-SYNTHESIS.md) · [`00-ADR-log.md`](00-ADR-log.md) · [`00-PROMOTE-STATUS.md`](00-PROMOTE-STATUS.md) · [`00-PROMOTE-CHECKLIST.md`](00-PROMOTE-CHECKLIST.md) · [`00-SYNTHESIS-ADVERSARIAL.md`](00-SYNTHESIS-ADVERSARIAL.md) · [34](34-cursor-rules-polish-proposal.md) · [36](36-cob-rules-skills-gap-audit.md) · [37](37-skill-draft-polish-loop.md) · [49](49-adversarial-overengineering.md)  
**Live surfaces:** `AGENTS.md` · `.cursor/rules/*.mdc` · `.cursor/skills/church-of-beef-dev/SKILL.md` · `docs/superpowers/ui-polished-direction-for-agents.md`

> Research ≠ product law. This audit does **not** claim V1 complete or `POLISH:PASS`.

---

## Verdict

**Thin spine is landed and sufficient.** AGENTS → UI brief → skill § Polish loop → `verification.mdc` CANDIDATE language matches Accepted ADRs 0001–0005 / 0008 / 0010. One ADR-0001 follow-up already exists: glob rule `ui-juice-standards.mdc` (not the four-rule factory from [34]).

**Do not install** a second polish skill from [37], nor always-on `major-leaps` / `agent-self-critique` / picker `agent-polish-loop` — adversarial + ADR-0001/0002 deferred those for good reason; skill § is still ~15 lines (well under the ~80-line extract trigger).

---

## What’s wired (live)

| Target | Status | Notes |
|--------|--------|-------|
| **AGENTS.md** index + polish pointer | **OK** | Row for `agent-polish-vision/` (SYNTHESIS, adversarial, ADR, status); Rules-at-a-glance polish one-liner; “major UI polish = brief + skill §” |
| **UI brief** juice / T0–T1 / motion / ToS / critique / Done | **OK** | Matches SYNTHESIS §A + ADR-0010: hierarchy, tiers + scarce=T1-only, announce corridor, settings budget, motion/perf, 4 critique Qs, stop caps, CANDIDATE/PASS/V1 labels, ADR-0006 watch |
| **`church-of-beef-dev` § Polish loop** | **OK** | BIR: Goal → V1-IN slice → hard verify → separate critique → stop → CANDIDATE only; install path via §§1–3 + `00-INSTALL-PATH.md`; description triggers polish/juice/UI |
| **`verification.mdc` bullet 7** | **OK** | `POLISH:CANDIDATE` only; human PASS / V1 complete; no vibe “polished” without `/reload`; points at brief + skill § + SYNTHESIS |
| **`architecture-overview.mdc`** | **OK** | Edit prefs: major UI polish → brief + skill §; not a rule factory |
| **`ui-juice-standards.mdc`** | **OK (was under-documented)** | Glob on `UI/**` + bootstrap; T0/T1, announce bans, motion, anti-patterns, 4 critique Qs. PROMOTE-STATUS previously listed Step 7 rules as fully deferred — **incorrect** for this file |
| **Plan Tasks 7–10 / 13** | **OK** | Global Constraints + Task notes cite brief / skill § / CANDIDATE / [49] |
| **Phases checklist / guild-night** | **OK** | Polish ≠ V1 complete; optional polish-evidence check; H3/H4 → [32] |
| **Kill-list compliance** | **OK** | No Media/SFX unlock, no juice OS, no UI swarm rules, no pixel CI, no overnight Ralph, no V1-complete claim from wiring |

---

## Gaps vs Accepted ADRs (before this audit pass)

| ADR | Intent | Gap found | Disposition |
|-----|--------|-----------|-------------|
| **0001** | Thin spine first; optional later ≤2 thin rules / glob juice | `ui-juice-standards.mdc` already present; AGENTS Rules table omitted it; [34] other three rules correctly absent | **Close:** index the glob in AGENTS; do **not** add major-leaps / self-critique / polish-loop rules |
| **0002** | Polish loop in `church-of-beef-dev`; [37] later if § > ~80 lines | § present and thin; no second skill | **Document:** skill § is enough — do not install [37] |
| **0003** | ≤2 critique rounds; 1+0–1 roles | Present in skill § + UI brief | No change |
| **0004** | T0/T1 in UI brief | Present | No change |
| **0005** | Gates + brief first; [25] depth; no composite math in product docs | Skill says Gates/brief first; [25] optional depth | No change |
| **0006** | Main-spec Commit→`/g` law; Draft watched | UI brief constitution watch present | Intentional open (human §15) |
| **0007** | Process out of design-spec algorithms | Process in brief/skill — OK | Intentional defer of §15 process one-liners |
| **0008** | Kill-list non-promotes | Honored | Keep |
| **0009** | [53] sequencing not completion law | Not promoted into phases as law | Keep |
| **0010** | UI brief absorbs juice vocabulary | Landed completely vs SYNTHESIS absorb list | No change |

---

## MUST / SHOULD checklist (this pass)

| # | Item | Result |
|---|------|--------|
| 1 | AGENTS index + polish loop pointer | **Verified** — present; Rules table updated to list `ui-juice-standards` |
| 2 | UI brief completeness vs SYNTHESIS | **Verified** — complete |
| 3 | Skill § Polish loop + install path | **Verified** — present; description already trigger-rich |
| 4 | `verification.mdc` CANDIDATE vs human PASS | **Verified** — present |
| 5 | `ui-juice-standards.mdc` accurate | **Verified + thin tighten** — Classic/dual-encode + skill pointer; richer description triggers |
| 6 | `architecture-overview` pointer | **Verified** — present; one-line mention of juice glob |
| 7 | ONE always-on / picker for polish-loop / major-leaps | **Skipped (intentional)** — adversarial Step 7 + ADR-0001: defer until thin spine fails; prefer skill §; glob juice already exists |
| 8 | Install [37] polish skill | **Skipped** — ADR-0002; skill § ≪ 80 lines → **skill § is enough** |
| 9 | Skill/rule descriptions trigger on polish/juice/UI | **Tightened** — juice rule description; AGENTS index; skill already OK |
| 10 | Update `00-PROMOTE-STATUS.md` | **Done** — points at this audit |

---

## Over-engineering risks (watch / refuse)

| Risk | Why it matters | Mitigation in force |
|------|----------------|---------------------|
| Install all four [34] rules | Always-on bloat; process factory | ADR-0001; only juice glob allowed |
| Second skill from [37] while § is short | Duplicate loop surfaces; discovery thrash | ADR-0002; this audit documents “§ enough” |
| Paste SYNTHESIS / [25] / [54] into always-on | Token starvation; ignored rules | Kill-list / §G; brief stays pointer-heavy |
| Unlock Media / SFX / center WA / StatusBar | Schedule theft vs social ladder | ADR-0008 + juice rule bans |
| Treat CERQual “high” or agent taste as PASS | False ship | CANDIDATE vs human PASS in verification + brief |
| Accept roster Draft via polish convenience | Constitution fork (C-07) | ADR-0006 watch in UI brief |
| Score-factory `/40` or [31] composite as ship gate | Agents invent numeric law | ADR-0005; skill: Gates + brief first |
| Soft overshoot / tween bus creep | Juice OS nose (adversarial M7) | Brief + juice rule forbid juice OS |

---

## Intentional deferrals (do not promote from this audit)

1. Separate skill [37] `church-of-beef-polish-loop`  
2. Always-on `major-leaps-per-prompt.mdc` / `agent-self-critique.mdc`  
3. Picker `agent-polish-loop.mdc`  
4. Glossary rows locking T0/T1 as product law  
5. Design spec §13.1 / §15 process one-liners (ADR-0007)  
6. [53] M0–M8 names as completion law (ADR-0009)  
7. Toast mute / dwell → glossary (post playtest)  
8. Roster-backed Draft as law (ADR-0006 — human §15 only)  
9. Hooks / Cloud `environment.json` (`OPTIMIZATIONS.md`)  
10. Patches to `wow-ui-taint-lockdown` / `wow-performance` from [34] §5.3–5.4 (nice-to-have; juice glob + existing OnUpdate bans cover the floor)

---

## Skill § vs dedicated [37] skill

| Criterion | Finding |
|-----------|---------|
| ADR-0002 | Section-first; extract if § exceeds ~80 lines |
| Current § length | ~15 lines, pointer-heavy |
| Overlap with [37] | [37] duplicates install/smoke + adds long rubric templates already in UI brief |
| Decision | **Skill § is enough.** Keep [37] as research draft only. |

---

## Smoke expectations (no Lua changed this pass)

| Change class | Smoke |
|--------------|-------|
| Docs / rules / AGENTS / skill text only | New chat discovers SYNTHESIS + skill § on “polish toasts”; UI file edit attaches `ui-juice-standards` |
| Addon Lua | N/A this pass — **skip** Anniversary reinstall |

---

## Related

- Promote status: [`00-PROMOTE-STATUS.md`](00-PROMOTE-STATUS.md)  
- Checklist: [`00-PROMOTE-CHECKLIST.md`](00-PROMOTE-CHECKLIST.md)  
- Adversarial governor: [`00-SYNTHESIS-ADVERSARIAL.md`](00-SYNTHESIS-ADVERSARIAL.md) · [49](49-adversarial-overengineering.md)
