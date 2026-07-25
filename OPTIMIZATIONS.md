# Agent / DevEx optimizations

## Done (shipped locally — use freely)

| Item | Path | Notes |
|------|------|-------|
| Project skill — install / reload / test loop | `.cursor/skills/church-of-beef-dev/SKILL.md` | Resolves worktree vs main; `WOW_ADDONS_DIR`; failure modes |
| Cursor/VS Code Lua defaults | `.vscode/settings.json`, `extensions.json` | Lua 5.1 diagnostics + WoW/test globals; hide scrape noise |
| Cursor rules (consolidated + polished) | `.cursor/rules/*.mdc` | **2** always-on (`architecture-overview`, `verification`) + file-scoped domain/style rules; YAML-list `globs:` |
| Agent map | `AGENTS.md` | Short index; workspace-root + worktree guidance |
| Index hygiene | `.cursorignore` | Excludes `.firecrawl/`, `**/.raw/`, bulky media |

Do **not** treat research scrapes or inventing CI as “done” — those remain backlog below.

---

## Backlog (needs human approval)

Do **not** implement these until someone opts in — they touch CI secrets, hooks, or global tooling.

### Hooks (Cursor / git) — audit P1

- [ ] **Pre-commit / Cursor hook:** run `lua tests/run.lua` from the addon checkout before commit when `addon/**` or `tests/**` change. Approve command allowlist first.
- [ ] **TOC drift check:** fail if `ChurchOfBeef.toc` lists a missing file or omits a new `addon/ChurchOfBeef/**/*.lua` (except intentional).
- [ ] **Secret scan:** block `CF_API_KEY`, Wago/WoWI tokens, and accidental commit of `.firecrawl/` or research `.raw/`.

### CI / packaging — audit P1

- [ ] **GitHub Actions:** offline `lua tests/run.lua` on PR (Lua 5.1 container or `leafo/gh-actions-lua`).
- [ ] **BigWigs packager@v2** with `-t addon/ChurchOfBeef`; untagged → alpha only. Requires CurseForge/Wago tokens in repo secrets — never in tree.
- [ ] **Release checklist job:** Interface version note + zip artifact; no auto-publish until officers agree.

### Editor / local DX — audit P1

- [ ] **EmmyLua / LuaLS stubs** for Classic Anniversary APIs (small hand-maintained stub library under `tests/` or `tools/wow-api-stubs/`) — approve scope first.
- [ ] **`justfile` or `Makefile`** with `test`, `zip`, `install` (install reads `WOW_ADDONS_DIR`) — nice once the feat branch is default checkout on `main`.
- [ ] **Promote worktree → main layout:** when `feat/church-of-beef-v1` merges, re-point skill defaults away from `.worktrees/...` and ensure `.cursor/` + `.vscode/` land on the default branch.

### MCP / external tools

- [ ] **CurseForge / WowUp MCP or Zapier:** only if maintainers want listing/status from chat; prefer native APIs over duplicate Zapier+native for the same app.
- [ ] **Linear/Notion task sync** for V1 checklist (`docs/phases/v1-checklist.md`) — optional; SDD ledger already exists under `.superpowers/sdd/`.

### Product QA (not tooling, but agent-relevant)

- [ ] Fill `docs/phases/v1-checklist.md` (Task 12) and walk two-client guild night (Task 13).
- [ ] Standardize BugGrabber + BugSack on officer test accounts (see research track `19-testing-debugging-qa`).

---

## Where to put new guidance

| Kind | Put it in |
|------|-----------|
| Always-on policy (rare) | Focused `.mdc` with `alwaysApply: true` — keep ≤2–3 total (currently 2) |
| File/domain policy | `.mdc` with YAML-list `globs:` (one pattern per list item) |
| Operational how-to | `.cursor/skills/church-of-beef-dev/SKILL.md` |
| Future ideas needing approval | Checkboxes in this file |
| Short agent map / links | `AGENTS.md` only — no second full rule copy |
