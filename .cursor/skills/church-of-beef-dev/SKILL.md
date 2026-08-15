---
name: church-of-beef-dev
description: >-
  Install, reload, offline-test, and run the UI polish loop for Church of Beef.
  Use when developing or verifying the addon, running lua tests/run.lua, copying
  into Interface/AddOns, /reload smoke, polish/juice/spectacle/critique,
  toasts/announce feel, empty states, “make UI nicer,” or when the user mentions
  install, AddOns path, /beef, WOW_ADDONS_DIR, or offline Core tests. Before any
  UI CreateFrame / visual work, read Bible §19.3 and
  `.cursor/rules/ui-juice-standards.mdc`, then follow § Polish loop.
  Product law is `docs/design/`, not archived briefs or specs.
  Do not install a second polish skill — this skill § is enough.
---

# Church of Beef — install / reload / test

Operational loop after code changes. Policy stays in `.cursor/rules/`; map/links in `AGENTS.md`; tooling backlog in `OPTIMIZATIONS.md`.

## 0. Resolve addon checkout (`ADDON_ROOT`)

Workspace root has rules/skill. Addon + tests may be on `main` or only in a feature worktree.

```bash
# Prefer cwd if it already has the harness
test -f tests/run.lua && ADDON_ROOT="$PWD"

# Else common local worktree (see .gitignore: .worktrees/)
test -z "${ADDON_ROOT:-}" && test -f .worktrees/feat-church-of-beef-v1/tests/run.lua \
  && ADDON_ROOT="$PWD/.worktrees/feat-church-of-beef-v1"

# Else first shallow match
test -z "${ADDON_ROOT:-}" && ADDON_ROOT="$(
  find .worktrees -maxdepth 2 -name run.lua -path '*/tests/run.lua' 2>/dev/null \
    | head -1 | xargs dirname | xargs dirname
)"
```

All following commands: `cd "$ADDON_ROOT"` (parent of `addon/` and `tests/`).

**Failure:** nothing found → stop; tell the user the addon checkout is missing (worktree not created, or opened wrong folder).

## 1. Offline tests (every Core/Data/harness change)

From the Beef_Addon workspace root you can also run `./scripts/run-tests.sh` (resolves the worktree). GHA runs the same path when `tests/run.lua` is on the branch.

```bash
cd "$ADDON_ROOT"
lua -v                 # 5.1 preferred; 5.4 OK for pure logic
lua tests/run.lua      # exit 0 required
```

| Symptom | Likely cause | Fix |
|---------|--------------|-----|
| `lua: command not found` | No Lua on PATH | Install Lua 5.1 (or 5.4 for pure-logic) |
| `cannot open tests/run.lua` | Wrong cwd / missing checkout | Re-run step 0 |
| Non-zero exit / `N failed` | Logic or fixture bug | Fix code/tests; do not skip |
| Suite listed but skipped | Module not created yet | OK until that task lands |

Green harness ≠ MVP done (Bible §22.3). UI / net / ceremony need the client.

## 2. Install into the client (agents own this)

After UI / Net / SV / slash changes that need in-game smoke, **reinstall** the addon into the player's Anniversary AddOns folder — do not leave install to the user. Prefer `_anniversary_` over Retail / `_retail_`. **Never** touch `WTF/` or player `ChurchOfBeefDB.lua`.

Folder name must match the `.toc` basename (`ChurchOfBeef`). Known-good path for this machine: `docs/research/agent-polish-vision/00-INSTALL-PATH.md`.

```bash
# Prefer env if set; else known-good Anniversary AddOns (see 00-INSTALL-PATH.md)
: "${WOW_ADDONS_DIR:=/Applications/World of Warcraft/_anniversary_/Interface/AddOns}"

# Source: workspace addon/ when present, else ADDON_ROOT checkout
SRC="$ADDON_ROOT/addon/ChurchOfBeef"
test -d "/Volumes/AI_Design_Drive/Beef_Addon/addon/ChurchOfBeef" \
  && SRC="/Volumes/AI_Design_Drive/Beef_Addon/addon/ChurchOfBeef"

test -d "$SRC" || { echo "Missing $SRC"; exit 1; }

rsync -a --delete "$SRC/" "$WOW_ADDONS_DIR/ChurchOfBeef/"
# or: cp -R "$SRC" "$WOW_ADDONS_DIR/ChurchOfBeef"
```

| Symptom | Likely cause | Fix |
|---------|--------------|-----|
| Addon missing in client | Wrong client / wrong folder name | Confirm `_anniversary_` AddOns; basename `ChurchOfBeef` |
| Stale files after delete | Used `cp` without replace | Prefer `rsync -a --delete` |
| Edits not visible in-game | Installed from empty/stale checkout | Prefer workspace `addon/ChurchOfBeef/` per 00-INSTALL-PATH.md |

## 3. In-game reload smoke

After install (or any UI/Net/SV/slash change):

1. Enable **Church of Beef** in the AddOns list (correct client).
2. `/console scriptErrors 1` (prefer BugGrabber + BugSack for stacks).
3. `/reload`
4. `/beef` — expect versioned stub or UI; Lua errors = fail.
5. BeefNet / guild-net changes → two clients (Pope writer + congregation display).

**Do not** delete player `WTF/**/ChurchOfBeefDB.lua` unless the user explicitly asks.

| Symptom | Likely cause | Fix |
|---------|--------------|-----|
| Addon not listed | Install path / TOC Interface mismatch | Re-check `WOW_ADDONS_DIR` and `## Interface: 20506` |
| Silent failure | `scriptErrors` off | Enable console errors or BugSack |
| `/beef` unknown | Bootstrap/slash not loaded | Check TOC file list + load errors |
| Expected surface missing | Roster / runtime not ready | Wait for `GUILD_ROSTER_UPDATE`; confirm the client role |

## 4. Quick zip (optional hand-out)

```bash
cd "$ADDON_ROOT/addon" && zip -r ../ChurchOfBeef.zip ChurchOfBeef
```

Zip root must be `ChurchOfBeef/`, not the monorepo root. No packager upload without approval.

## Checklist (copy and tick)

```
- [ ] ADDON_ROOT resolved (tests/run.lua present)
- [ ] lua tests/run.lua → 0 failed
- [ ] TOC lists only existing files; Interface 20506 unless intentionally bumping
- [ ] Reinstalled to Anniversary AddOns/ChurchOfBeef (see 00-INSTALL-PATH.md; never WTF/)
- [ ] /reload + /beef smoke (and two-client if Net / Pope↔congregation)
- [ ] No gameplay automation / Retail-only APIs introduced
```

## 5. UI / art work (agent-executed)

UI and art direction are implemented by coding agents. Before scaffolding frames
or Media:

1. Read Bible §19.3 (hybrid visual law) and `.cursor/rules/ui-juice-standards.mdc`.
2. Follow Law 10: functional surfaces stay stock-template pragmatic; theatrical surfaces get the ecclesiastical identity. The UI never tells jokes.
3. Custom media is permitted only on theatrical surfaces; missing media must not fail load.
4. Do **not** treat `docs/archive/pre-reformation/` UI briefs or specs as product law.

Green harness still does not prove UI polish — complete step 3 (in-game smoke) for UI changes.

## Polish loop (UI / toast / announce / empty states)

Use for juice/critique asks after the functional path exists. Product law is Bible §19 and `ui-juice-standards.mdc` only. Research links below are **process** (goal size, stop conditions). If a research page cites the archived design spec, V1 ladder, officer `/g` spectacle, or the archived UI brief as law — **ignore those product claims.**

1. **Goal** — name the surface, acceptance evidence, max **2** critique→revise rounds (research [30](docs/research/agent-polish-vision/30-writing-effective-agent-goals.md)). Refuse “make it nicer” without a Goal.
2. **One slice** — named surface only ([42](docs/research/agent-polish-vision/42-v1-vs-v2-juice-scope.md)). Refuse WA center pulses, StatusBar meters, and a juice OS. Theatrical media follows Law 10 / Bible §19.3; Quiet Mode stays silent.
3. **Hard verify** — this skill §§1–3 (harness if Core/Data; TOC; install → `/reload` → path).
4. **Separate critique** — against Bible §19.3 / `ui-juice-standards.mdc` (hybrid law, Quiet vs Event, UI never jokes). Gates + rule anti-patterns first; [25](docs/research/agent-polish-vision/25-ui-polish-critique-rubric.md) optional depth only — never paste composite score math. Fix P0/P1 only.
5. **Stop** — clean / plateau / max rounds / reopen-locked ([31](docs/research/agent-polish-vision/31-loop-stop-conditions.md), [49](docs/research/agent-polish-vision/49-adversarial-overengineering.md)). Role budget: **1** implementer + **0–1** critic; no UI swarm.
6. **Claim `POLISH:CANDIDATE` only** — human signs `POLISH:PASS`; never claim MVP complete from harness or taste (Bible §22.3).
7. **No** WoW process control, pixel CI, or overnight unattended UI Ralph.

Visual law: Bible §19.3 and `.cursor/rules/ui-juice-standards.mdc`. Do not open `00-SYNTHESIS.md` for product decisions.

## Do not duplicate

Canon numbers, layer rules, and packaging constraints stay in `.cursor/rules/`.
Further tooling ideas (pre-commit hooks, packager tokens, MCP) live in `OPTIMIZATIONS.md` — need human approval.
