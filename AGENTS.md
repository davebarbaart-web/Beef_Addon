# AGENTS.md — Church of Beef (Beef_Addon)

Short map for coding agents. Policy lives in `.cursor/rules/`; the operational loop lives in the skill. Do not fork either here.

## What this is

**Church of Beef** — social ceremony, Gora, and memory layer for **WoW TBC Classic Anniversary** (`## Interface: 20506`). The add-on formalizes ritual, sanctioned duels, Pope-facing direction, and Church records. It is **not** a roster-backed standing ladder and not combat/raid tooling.

Stack: Lua 5.1, plain global `ChurchOfBeef` / `COB`, no AceAddon. Installable unit: `addon/ChurchOfBeef/` → `Interface/AddOns/ChurchOfBeef`.

## Workspace root (important)

Open **`/Volumes/AI_Design_Drive/Beef_Addon`** (this repo) as the Cursor workspace so `.cursor/rules`, `.cursor/skills`, and `.vscode` apply.

Addon code currently lives at `addon/ChurchOfBeef/` on this workspace. `.worktrees/` is optional isolation only — do not open a worktree as a separate workspace (it has no `.cursor/` copy).

## Where to look

| Need | Path |
|------|------|
| **Product law** | [`docs/design/Game_Design_Bible_v1.1.1.md`](docs/design/Game_Design_Bible_v1.1.1.md) |
| Adjudication | [`docs/design/Peer_Review_Adjudication.md`](docs/design/Peer_Review_Adjudication.md) |
| Demo audit | [`docs/design/Demo_Build_Audit.md`](docs/design/Demo_Build_Audit.md) |
| Reformation log | [`docs/REFORMATION_LOG.md`](docs/REFORMATION_LOG.md) |
| Open questions | [`docs/design/OPEN_QUESTIONS.md`](docs/design/OPEN_QUESTIONS.md) |
| Ten Laws (Phase 0) | [`docs/reformation/phase-0/TEN_LAWS.md`](docs/reformation/phase-0/TEN_LAWS.md) |
| Archived law (historical) | [`docs/archive/pre-reformation/`](docs/archive/pre-reformation/) |
| Cursor rules | [`.cursor/rules/`](.cursor/rules/) |
| Install / reload / test | [`.cursor/skills/church-of-beef-dev/SKILL.md`](.cursor/skills/church-of-beef-dev/SKILL.md) |
| Editor defaults (Lua 5.1) | [`.vscode/`](.vscode/) |
| DevEx backlog (needs approval) | [`OPTIMIZATIONS.md`](OPTIMIZATIONS.md) |
| Research library (≠ law) | `docs/research/` |

Research guidance is not product law. On conflict, the Bible wins, then Adjudication, then the Audit. Archived specs, plans, and UI briefs in `docs/archive/pre-reformation/` are historical — they must not win.

### UI work is agent-executed

UI is implemented by coding agents. Visual law is Bible §19.3 / Law 10 and `.cursor/rules/ui-juice-standards.mdc`. Operational polish loop: the skill § Polish loop. Do not treat archived UI briefs as law.

## How to run

```bash
./scripts/run-tests.sh                 # from workspace root
# or:
lua tests/run.lua                      # exit 0 required for Core/Data changes
```

In-game: reinstall `addon/ChurchOfBeef/` → Anniversary `Interface/AddOns/ChurchOfBeef/` (or `$WOW_ADDONS_DIR`); `/reload`, `/beef`. Details: the skill above.

CI: `.github/workflows/lua-tests.yml` runs the harness when `tests/run.lua` is on the branch.

## Rules at a glance

| Mode | Files |
|------|--------|
| Always on | `ten-laws`, `architecture-overview`, `verification` |
| Layers / style | `addon-module-layers`, `lua-cob-modules`, `toc-lifecycle` |
| Packaging | `build-packaging`, `packaging-assets` |
| Domain | `gora-sanction`, `pope-authority`, `identity-records`, `ceremony-runtime`, `quiet-event-modes`, `records-not-points` |
| Client | `wow-ui-taint-lockdown`, `wow-performance`, `testing` |
| UI juice (glob) | `ui-juice-standards` — hybrid visual law when editing `UI/**` |

Trust the rule picker. When research would change a product decision, append a named item to `docs/design/OPEN_QUESTIONS.md` — do not silently fork policy into research tracks or archived specs.

## Key don'ts

- Ten Laws: no points/XP/currencies/dailies/streaks; record events never behavior; no activity leaderboards; no ELO; Pope holds ceremonial sovereignty (officers/Council do not perform rituals); software proposes, Pope ratifies; Pope-authoritative star; Quiet Mode is minimap + Decree only; Church history is never deleted (account-level: rank on the human, Gora records on the character); combat is WoW's; six ranks, no Prophet, Pope is not a rank; hybrid visual law, UI never tells jokes
- No bots, injection, protected-action bypass, or gameplay automation
- No Retail / Dragonflight-only APIs; target is Anniversary `20506`
- Rank structure is Bible §5 / `Data/Ranks.lua` after Phase 1; do not invent Prophet or thresholds
- UI never records official outcomes or invents ranks; Net never invents ranks or verdicts; only the Pope's Core store is authoritative. Core never `CreateFrame`. Data never reads SV
- Do not list missing files in the `.toc`
- Research scrapes (`.firecrawl/`, `**/.raw/`) are not product truth
- Do not follow archived specs as winners on conflict
