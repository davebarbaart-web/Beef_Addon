# agent-polish-vision — research pack

**Lane:** `docs/research/agent-polish-vision/`  
**Date:** 2026-07-26  
**Status:** Research guidance — **not** product law  

Church of Beef polish / juice / Cursor-loop research for **TBC Classic Anniversary** (`## Interface: 20506`). Use this pack to brief agents and humans before wiring standards into AGENTS, the UI brief, skills, or rules.

---

## Research ≠ product law

| Wins on conflict | Does not invent policy |
|------------------|------------------------|
| Design spec · glossary · `Data/Ranks.lua` | Numbered briefs `01`–`56` |
| UI agent briefing (`docs/superpowers/ui-polished-direction-for-agents.md`) | Digests `00b` / `01b` / `11b` / `21b` / `22b` |
| Always-on `.cursor/rules/` + Anniversary APIs | `00-SYNTHESIS.md` until ADRs are Accepted + landed |

Scrapes (`_search-*.json`, `_deep-*`, `.raw*`, `.firecrawl/`) are provenance only — never treat them as briefing surfaces.

Do **not** claim V1 complete from research alone. Prefer thin promote ([49-adversarial-overengineering.md](49-adversarial-overengineering.md)).

---

## Entry order (start here)

```text
1. 00-INDEX.md              → inventory + what each file is for
2. 00-SYNTHESIS.md          → unified standards (UI/juice · loops · V1 scope · DoD)
3. 00-PROMOTE-CHECKLIST.md  → ordered wiring steps after human Accepts ADRs
```

Optional before promote:

- [00-SYNTHESIS-ADVERSARIAL.md](00-SYNTHESIS-ADVERSARIAL.md) — hostile review of the SYNTHESIS pack  
- [00-ADR-log.md](00-ADR-log.md) — binding recommendations (**Proposed** until human Accept/Reject)  
- [00-thoroughness-audit.md](00-thoroughness-audit.md) — which briefs are thin / deepen-worthy  

Full inventory of briefs `01`–`56`: [00-INDEX.md](00-INDEX.md).

---

## Digests (annotated primaries)

Read these when you need **sources**, not doctrine:

| Digest | Use when |
|--------|----------|
| [00b-community-threads-digest.md](00b-community-threads-digest.md) | Toast / minimap / guild-chat / Cursor community complaints & praise |
| [01b-classic-ui-web-digest.md](01b-classic-ui-web-digest.md) | Classic FrameXML / CreateFrame / taint / templates web primaries |
| [11b-juice-sources-digest.md](11b-juice-sources-digest.md) | Game juice / feel / motion / celebration primaries → Classic map |
| [21b-cursor-loops-source-digest.md](21b-cursor-loops-source-digest.md) | Cursor / Ralph / hooks / autonomy loop sources |
| [22b-agentic-critique-sources.md](22b-agentic-critique-sources.md) | Critique-loop / evaluator-optimizer sources |

---

## How to use (by job)

| Job | Path |
|-----|------|
| Implement UI / juice on Anniversary | UI brief (law) → SYNTHESIS §A → craft briefs `01`–`20`, `42`–`47`, `56` → digests `01b` / `11b` / `00b` |
| Run a polish agent loop | SYNTHESIS §B–C → [30](30-writing-effective-agent-goals.md) · [29](29-superpowers-loop-patterns.md) · [31](31-loop-stop-conditions.md) · digests `21b` / `22b` |
| Critique / DoD a candidate | [24](24-definition-of-done-polish.md) · [25](25-ui-polish-critique-rubric.md) · human PASS for spectacle |
| Promote into AGENTS / skills / UI brief | Human Accepts ADRs → follow [00-PROMOTE-CHECKLIST.md](00-PROMOTE-CHECKLIST.md) only |
| Stay out of overbuild | [49](49-adversarial-overengineering.md) kill-list · [42](42-v1-vs-v2-juice-scope.md) IN/OUT · [50](50-adversarial-tos-safety.md) / [51](51-adversarial-performance-vs-juice.md) bans |

---

## Related lanes (outside this folder)

| Need | Path |
|------|------|
| Product decisions | `docs/superpowers/specs/2026-07-25-church-of-beef-design.md` |
| UI briefing for agents | `docs/superpowers/ui-polished-direction-for-agents.md` |
| Classic addon design research | `docs/research/wow-classic-addon-design/` |
| Install / reload / offline tests | `.cursor/skills/church-of-beef-dev/SKILL.md` |

---

## Intentionally out of scope here

- Editing product law files from a research wave (promote checklist owns that)  
- Combat / raid tooling patterns  
- Retail-only / Dragonflight-only APIs  
- Packager upload or WTF/SV wipes
