# Phase 0 Lane L — Rewrite README.md and AGENTS.md

Read first: `docs/reformation/phase-0/TEN_LAWS.md`, Bible §1, §5, §22.3, current `README.md` and `AGENTS.md`.

## Mission

Point humans and agents at `docs/design/` as sole product law. Remove the seven-rank points-ladder pitch.

## Exclusive files

- Rewrite: `README.md`
- Rewrite: `AGENTS.md`
- Light pointer fix only if needed: `.cursor/skills/church-of-beef-dev/SKILL.md` — stop sending agents to archived UI brief / old spec as product law. Keep install/reload/test loop. Do not rewrite the whole skill.
- Report: `docs/reformation/phase-0/reports/L-maps.md`

## README.md must

- Describe the Bible product in a short paragraph (ceremony, Gora, Pope, memory — not another game inside WoW).
- Rank table: the six ranks from Law 9 / §5 with *relationship* one-liners (no point thresholds). Note the Pope is not a rank.
- State bans briefly: no points/XP, no activity leaderboards, no ELO.
- Keep install path, `/beef`, hard safety, tests, Interface 20506.
- Remove: standing tabs, officer approve/reject, per-character alts-start-fresh, “no custom Media,” excommunication spectacle, design-spec link to `docs/superpowers/specs/…`.
- Design law links: Bible, Adjudication, Audit. Archived law: `docs/archive/pre-reformation/`.
- Definition of done: quote or tightly paraphrase Bible §22.3 (human/stream Gathering). Do not claim the demo is done.
- Quiet Mode: minimap + Decree (Decree is forthcoming; do not pretend it ships today).

## AGENTS.md must

- Workspace root still `Beef_Addon` so `.cursor/rules` apply.
- Product: Bible product, not roster-backed standing ladder.
- Where to look table: `docs/design/Game_Design_Bible_v1.1.1.md` first; Adjudication; Audit; `docs/REFORMATION_LOG.md`; archive is historical.
- Rules at a glance: always-on `ten-laws`, `architecture-overview`, `verification`; domain `gora-sanction`, `pope-authority`, `identity-records`, `ceremony-runtime`, `quiet-event-modes`, `records-not-points`; engineering keepers; `ui-juice-standards` for UI.
- Key don'ts: Ten Laws + hard safety. Replace “UI must not award points” with the updated layer line. Replace “do not fork rank numbers into docs/canon” with “rank structure is Bible §5 / Data/Ranks.lua after Phase 1; do not invent Prophet or thresholds.”
- Addon code currently lives at `addon/ChurchOfBeef/` on this workspace (the old “docs-only main / only worktree” sentence is stale). Mention `.worktrees/` only as optional isolation.
- Do not send agents to archived specs as winners on conflict.

## Do not

- `git commit`
- Touch `.cursor/rules` (other lanes)
- Invent install UX or slash subcommands

## Report contract

Status, sections cited, list of wrong-product sentences removed.
