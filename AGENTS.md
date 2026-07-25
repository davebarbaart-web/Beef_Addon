# AGENTS.md — Church of Beef (Beef_Addon)

Short map for coding agents. Policy lives in `.cursor/rules/`; the operational loop lives in the skill. Do not fork either here.

## What this is

**Church of Beef** — social guild / streamer-event add-on for **WoW TBC Classic Anniversary** (`## Interface: 20506`). Rank ladder, standing, officer **Commit**, guild spectacle. Not combat/raid tooling.

Stack (V1): Lua 5.1, plain global `ChurchOfBeef` / `COB`, no AceAddon. Installable unit: `addon/ChurchOfBeef/` → `Interface/AddOns/ChurchOfBeef`.

## Workspace root (important)

Open **`/Volumes/AI_Design_Drive/Beef_Addon`** (this repo / `main`) as the Cursor workspace so `.cursor/rules`, `.cursor/skills`, and `.vscode` apply.

Do **not** open `.worktrees/feat-church-of-beef-v1` as a separate workspace — it has no `.cursor/` copy. Edit addon Lua under that worktree path from the parent workspace.

## Where to look

| Need | Path |
|------|------|
| Product decisions | `docs/superpowers/specs/2026-07-25-church-of-beef-design.md` |
| Task / file layout | `docs/superpowers/plans/2026-07-25-church-of-beef-v1.md` |
| **UI / art direction (agents)** | [`docs/superpowers/ui-polished-direction-for-agents.md`](docs/superpowers/ui-polished-direction-for-agents.md) — **read before any UI `CreateFrame`** |
| Machine canon (ranks/thresholds) | `addon/ChurchOfBeef/Data/Ranks.lua` (on feature checkout) |
| Lore prose (no numbers) | `docs/canon/` |
| Cursor rules | [`.cursor/rules/`](.cursor/rules/) |
| Install / reload / test | [`.cursor/skills/church-of-beef-dev/SKILL.md`](.cursor/skills/church-of-beef-dev/SKILL.md) |
| Editor defaults (Lua 5.1) | [`.vscode/`](.vscode/) |
| DevEx backlog (needs approval) | [`OPTIMIZATIONS.md`](OPTIMIZATIONS.md) |
| Research library | `docs/research/wow-classic-addon-design/` |

### UI work is agent-executed

V1 UI and later art direction are expected to be implemented by **coding agents**, not hand-designed in Figma. Orientation canvases (north star, build prep, commission brief) may live in the Cursor project `canvases/` folder; the **in-repo briefing** above is the durable entry point. Spec §15 / glossary win over canvases if they ever diverge.

### Checkout layout

On **`main`**, this tree is mostly docs + research. Active addon code and offline tests live in a **local git worktree** (gitignored at parent):

```
.worktrees/feat-church-of-beef-v1/
  addon/ChurchOfBeef/
  tests/
  README.md
```

Plan paths (`addon/…`, `tests/…`) are relative to that checkout root.

## How to run

```bash
./scripts/run-tests.sh                 # from workspace root (resolves worktree if needed)
# or:
cd .worktrees/feat-church-of-beef-v1   # addon checkout
lua tests/run.lua                      # exit 0 required for Core/Data changes
```

In-game: set `WOW_ADDONS_DIR`, install `addon/ChurchOfBeef/` → `Interface/AddOns/ChurchOfBeef/`, `/reload`, `/beef`. Details: the skill above.

CI: `.github/workflows/lua-tests.yml` runs the harness when `tests/run.lua` is on the branch; on `main` (docs-only) it skips with a clear log. Remaining tooling ideas: `OPTIMIZATIONS.md`.
## Rules at a glance

| Mode | Files |
|------|--------|
| Always on | `architecture-overview.mdc`, `verification.mdc` |
| Layers / style | `addon-module-layers`, `lua-cob-modules`, `toc-lifecycle` |
| Canon / packaging | `canon-data`, `build-packaging`, `packaging-assets` |
| Domain | `ladder-authority`, `scoring-coplay`, `officer-guild-roster`, `beefnet-messaging` |
| Client | `wow-ui-taint-lockdown`, `wow-performance`, `testing` |

Trust the rule picker. When research changes a product decision, update the **design spec decisions log** — do not silently fork policy into research tracks.

## Key don'ts

- No bots, injection, protected-action bypass, or gameplay automation
- No Retail / Dragonflight-only APIs; V1 is Anniversary `20506` only
- Do not fork rank numbers into `docs/canon/` — edit `Data/Ranks.lua`
- UI must not award points; Net must not invent ranks; Core must not `CreateFrame`
- Do not list missing files in the `.toc`
- Research scrapes (`.firecrawl/`, `**/.raw/`) are not product truth
