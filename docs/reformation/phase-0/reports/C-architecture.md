# Phase 0 Lane C — Architecture overview report

**Status:** DONE

**Cited:** Bible §3 (platform, §3.2 portability), §4.10 (witnesses report), §13.1 (Pope-authoritative star), §13.4 (message trust), §20 (runtime states + Pope-owned transitions), §22.1 (surfaces that hang on the skeleton); Audit §4 keepers (BeefNet, Common, Roster, DB, UI shell, module layering, hard safety); Handoff product-law order (Bible → Adjudication → Audit → handoff); Lane C brief.

**OPEN_QUESTIONS appended:** none.

## Files written

- `.cursor/rules/architecture-overview.mdc` (rewrite)
- `docs/reformation/phase-0/reports/C-architecture.md` (this file)

## Removed from the old overview

- Product one-liner as a social guild **ladder**; “V1” AceAddon note as product framing
- “UI never awards points” (replaced with official-outcomes / verdicts / Pope-store line)
- Repo map rooted on `.worktrees/feat-church-of-beef-v1/` and “docs-only main”
- Core described as Ladder / scoring / officer gate; Net as BeefNet **+ Sync**
- UI described as tabs / toasts / minimap as the spine
- Authority table: `Data/Ranks.lua` thresholds/seats; `docs/superpowers/specs/*` and plans as product law; `docs/canon/` numeric-threshold rule
- `COB.Sync:OnLogin()` as a login authority path
- Per-character `ChurchOfBeefDB` / SavedVariablesPerCharacter
- Edit preference to extend `Core/Ladder.lua` and to prefer `docs/superpowers/` + `Data/Ranks.lua`
- Polish / juice OS paragraph (UI brief, skill § Polish loop, four-rule pack)

## Concerns

- Current `ChurchOfBeef.toc` still declares `SavedVariablesPerCharacter`; this rule states Bible direction only. Packaging TOC law is Lane J.
- `ceremony-runtime.mdc` is named as the detail home and does not exist until Lane G.
- Demo Lua still has Ladder / Scoring / suggestion fanout; this rule describes the Bible product, not the current bootstrap spine.
- Bible §13.1 says “per-client SavedVariables”; account-level `ChurchOfBeefDB` is the brief’s stated Bible direction (Audit §6.3, Handoff Phase 2). Not opened as a question.
- No commit made.
