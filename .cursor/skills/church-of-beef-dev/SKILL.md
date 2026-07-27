---
name: church-of-beef-dev
description: >-
  Install, reload, offline-test, and run the UI polish loop for Church of Beef.
  Use when developing or verifying the addon, running lua tests/run.lua, copying
  into Interface/AddOns, /reload smoke, polish/juice/spectacle/critique,
  toasts/announce feel, empty states, “make UI nicer,” or when the user mentions
  install, AddOns path, /beef, WOW_ADDONS_DIR, or offline Core tests. Before any
  UI CreateFrame / visual work, read
  docs/superpowers/ui-polished-direction-for-agents.md and follow § Polish loop.
  Do not install a second polish skill — this skill § is enough (ADR-0002).
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

Green harness ≠ V1 done (UI / BeefNet / spectacle need the client).

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
5. BeefNet / officer / sync changes → two clients (Officer+ and Member).

**Do not** delete player `WTF/**/ChurchOfBeefDB.lua` unless the user explicitly asks.

| Symptom | Likely cause | Fix |
|---------|--------------|-----|
| Addon not listed | Install path / TOC Interface mismatch | Re-check `WOW_ADDONS_DIR` and `## Interface: 20506` |
| Silent failure | `scriptErrors` off | Enable console errors or BugSack |
| `/beef` unknown | Bootstrap/slash not loaded | Check TOC file list + load errors |
| Officer tab missing | Roster not ready / not Officer+ | Wait for `GUILD_ROSTER_UPDATE`; confirm rank index |

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
- [ ] /reload + /beef smoke (and two-client if Net/officer)
- [ ] No gameplay automation / Retail-only APIs introduced
```

## 5. UI / art work (agent-executed)

UI and art direction are implemented by coding agents. Before scaffolding frames
or Media:

1. Read `docs/superpowers/ui-polished-direction-for-agents.md` (authority order + V1 bans + juice vocabulary).
2. Follow design spec §10 / §15 and glossary rows 68–71, 74–81.
3. Prefer Cursor canvas `cob-v1-ui-build-prep` as the day-to-day checklist when available.
4. Do **not** add custom `Media/` or SFX in V1 Tasks 7–10.

Green harness still does not prove UI polish — complete step 3 (in-game smoke) for UI changes.

## Polish loop (UI / toast / announce / empty states)

Use for juice/critique asks after the functional path exists. Pointer-heavy; product law stays in the UI brief + design spec.

1. **Goal** — name the surface, acceptance evidence, max **2** critique→revise rounds (research [30](docs/research/agent-polish-vision/30-writing-effective-agent-goals.md)). Refuse “make it nicer” without a Goal.
2. **One V1-IN slice** — shell/tabs/toasts/announce craft/minimap/empty honesty/short fades only ([42](docs/research/agent-polish-vision/42-v1-vs-v2-juice-scope.md)). Refuse Media/SFX/WA center/StatusBar/juice OS.
3. **Hard verify** — this skill §§1–3 (harness if Core/Data; TOC; install → `/reload` → path).
4. **Separate critique** — against UI brief (hierarchy, T0/T1, ToS corridor, 4 critique questions). Gates + brief anti-patterns first; [25](docs/research/agent-polish-vision/25-ui-polish-critique-rubric.md) optional depth only — never paste composite score math. Fix P0/P1 only.
5. **Stop** — clean / plateau / max rounds / reopen-locked ([31](docs/research/agent-polish-vision/31-loop-stop-conditions.md), [49](docs/research/agent-polish-vision/49-adversarial-overengineering.md)). Role budget: **1** implementer + **0–1** critic; no UI swarm.
6. **Claim `POLISH:CANDIDATE` only** — human signs `POLISH:PASS`; never claim V1 complete from harness or taste.
7. **No** WoW process control, pixel CI, or overnight unattended UI Ralph.

Brief after Step 2 promote: `docs/superpowers/ui-polished-direction-for-agents.md`. Synthesis: `docs/research/agent-polish-vision/00-SYNTHESIS.md`.

## Do not duplicate

Canon numbers, layer rules, and packaging constraints stay in `.cursor/rules/`.
Further tooling ideas (pre-commit hooks, packager tokens, MCP) live in `OPTIMIZATIONS.md` — need human approval.
