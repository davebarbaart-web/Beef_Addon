---
name: church-of-beef-dev
description: >-
  Install, reload, and offline-test the Church of Beef WoW addon. Use when
  developing or verifying the addon, running lua tests/run.lua, copying into
  Interface/AddOns, /reload smoke checks, or when the user mentions install,
  AddOns path, /beef, WOW_ADDONS_DIR, or offline Core tests.
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

## 2. Install into the client

Folder name must match the `.toc` basename (`ChurchOfBeef`).

```bash
# Set once per machine (do not commit real paths with usernames if sensitive)
# export WOW_ADDONS_DIR="/path/to/TBC Anniversary/Interface/AddOns"

test -n "${WOW_ADDONS_DIR:-}" || {
  echo "Set WOW_ADDONS_DIR to .../Interface/AddOns and re-run"
  exit 1
}

test -d "$ADDON_ROOT/addon/ChurchOfBeef" || {
  echo "Missing $ADDON_ROOT/addon/ChurchOfBeef"
  exit 1
}

rsync -a --delete "$ADDON_ROOT/addon/ChurchOfBeef/" "$WOW_ADDONS_DIR/ChurchOfBeef/"
# or: cp -R "$ADDON_ROOT/addon/ChurchOfBeef" "$WOW_ADDONS_DIR/ChurchOfBeef"
```

| Symptom | Likely cause | Fix |
|---------|--------------|-----|
| `WOW_ADDONS_DIR` unset | Env not configured | Ask user for Anniversary `Interface/AddOns` path; export it |
| Addon missing in client | Wrong client / wrong folder name | Confirm Anniversary AddOns dir; basename must be `ChurchOfBeef` |
| Stale files after delete | Used `cp` without replace | Prefer `rsync -a --delete` |

Never invent a specific `_classic_*/` client folder — Anniversary layout varies.

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
- [ ] WOW_ADDONS_DIR set; installed to Interface/AddOns/ChurchOfBeef
- [ ] /reload + /beef smoke (and two-client if Net/officer)
- [ ] No gameplay automation / Retail-only APIs introduced
```

## Do not duplicate

Canon numbers, layer rules, and packaging constraints stay in `.cursor/rules/`.
Further tooling ideas (pre-commit hooks, packager tokens, MCP) live in `OPTIMIZATIONS.md` — need human approval.
