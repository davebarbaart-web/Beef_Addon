# Phase 0 Lane L — Maps report

**Status:** DONE

**Cited:** Bible §1 (executive vision — not another game inside WoW); Bible §5 (six relationship ranks; Pope is not a rank; no thresholds); Bible §22.3 (Gathering definition of done); Law 6 / §4.8 (Quiet Mode = minimap + Decree); Law 9 (rank list; Butcher display-only; no Prophet); Law 1 / §4.6 / §4.9 (no points/XP; no activity leaderboards); Law 8 / §10 (no ELO); Lane C layer line (UI never records official outcomes or invents ranks; Net never invents ranks or verdicts; Pope Core store is authoritative); Handoff Phase 0 maps (`CURSOR_REWORK_HANDOFF.md` §3); brief `docs/reformation/phase-0/briefs/L-maps.md`.

**No commit. `.cursor/rules` not edited.**

## Files written

- Rewrite: `README.md`
- Rewrite: `AGENTS.md`
- Pointer-only: `.cursor/skills/church-of-beef-dev/SKILL.md`
- Report: `docs/reformation/phase-0/reports/L-maps.md` (this file)

## Wrong-product sentences removed

### README.md

- Seven-title rank ladder; standing points from playing together; officer-approved promotions; guild-chat spectacle on elevate or excommunicate
- Rank table with standing-threshold → officer-approval rows, including Beef Prophet (unique, bestowed by decree)
- Addon *suggests* promotions from standing; Officer+ *approve or reject*; standings as advisory testimony; officer approval as the real gate
- “No custom Media” / stock Blizzard textures and fonts only
- `/beef` “has no subcommands” (false; existing `/beef minimap` kept, not invented)
- Tabs: Ladder (all seven ranks), My Standing (points and testimony), Officer (Officer+ only)
- Officer-tab guild-chat announce opt-out as product UX
- Per-character `ChurchOfBeefDB`; alts start fresh
- `docs/canon/` as “never duplicate the numbers”; `docs/superpowers/` as design spec / plan
- `Data/Ranks.lua` as sole machine canon for ids, titles, thresholds, and seats
- Walk `docs/phases/v1-checklist.md` and `guild-night-playtest.md`; “if a promotion passes unnoticed in guild chat, V1 has failed”
- Design-spec link to `docs/superpowers/specs/2026-07-25-church-of-beef-design.md`
- Workspace identity as “the directory that contains `.worktrees/`”

### AGENTS.md

- “Roster-backed rank ladder, standing suggestions, officer Dismiss / standing correction; officers promote in the Blizzard guild UI”
- Product-law pointers to the old design spec, V1 plan, and `ui-polished-direction-for-agents.md`
- “Machine canon (ranks/thresholds)” at `Data/Ranks.lua` on feature checkout
- “On conflict, design spec / glossary / `Data/Ranks.lua` / UI brief win”
- “Spec §15 / glossary win over canvases”
- “On `main` this tree is mostly docs + research; addon lives only in `.worktrees/feat-church-of-beef-v1`”
- Run-tests path that `cd`s into that worktree as the addon checkout
- “On `main` (docs-only) CI skips”
- Always-on set without `ten-laws`; domain set `ladder-authority`, `scoring-coplay`, `officer-guild-roster`, `beefnet-messaging`; packaging row that listed `canon-data`
- “Update the design spec decisions log”
- “Do not fork rank numbers into `docs/canon/` — edit `Data/Ranks.lua`”
- “UI must not award points; Net must not invent ranks; Core must not `CreateFrame`” (replaced with the Lane C layer line)

### Skill (pointers only; loop kept)

- `docs/superpowers/ui-polished-direction-for-agents.md` as the CreateFrame prerequisite and polish authority
- “Follow design spec §10 / §15 and glossary rows…”
- Cursor canvas `cob-v1-ui-build-prep` as the day-to-day checklist
- “Do not add custom Media/ or SFX in V1 Tasks 7–10”; polish-loop “Refuse Media/SFX” (V1-silent)
- “Product law stays in the UI brief + design spec”
- Critique against UI-brief T0/T1 / four old critique questions
- Two-client model as Officer+ and Member; “Officer tab missing” symptom
- “Never claim V1 complete from harness or taste”

## Concerns

- Maps describe the Bible product. The live `addon/ChurchOfBeef/` tree is still the retired points-ladder; agents must not treat the current UI as law.
- AGENTS names Phase 0 rule files (`ten-laws`, domain rules) that sibling lanes are writing; they may be absent until the gate closes.
- `officer-guild-roster` is omitted from the AGENTS domain table per brief (Lane E owns that file).
- `Data/Ranks.lua` still encodes the old ladder; maps correctly defer machine ids to Phase 1.
- Skill §0 still resolves an optional worktree checkout (operational keep, not product law).
