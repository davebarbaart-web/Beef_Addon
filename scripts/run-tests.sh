#!/usr/bin/env bash
# Resolve the Church of Beef addon checkout and run the desktop Lua harness.
# Prefer a checkout that already has tests/run.lua (feature branch or worktree).
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

resolve_checkout() {
  if [[ -f "$ROOT/tests/run.lua" ]]; then
    printf '%s\n' "$ROOT"
    return 0
  fi
  local wt="$ROOT/.worktrees/feat-church-of-beef-v1"
  if [[ -f "$wt/tests/run.lua" ]]; then
    printf '%s\n' "$wt"
    return 0
  fi
  return 1
}

if ! CHECKOUT="$(resolve_checkout)"; then
  echo "run-tests: no tests/run.lua found."
  echo "  On main this usually means addon/tests live only on feat/church-of-beef-v1"
  echo "  (or under .worktrees/feat-church-of-beef-v1 locally). Skipping."
  if [[ "${REQUIRE_TESTS:-0}" == "1" ]]; then
    exit 1
  fi
  exit 0
fi

if ! command -v lua >/dev/null 2>&1; then
  echo "run-tests: lua not found on PATH (prefer Lua 5.1; 5.4 OK for pure Core/Data)." >&2
  exit 1
fi

echo "run-tests: using checkout $CHECKOUT"
echo "run-tests: $(lua -v 2>&1)"
cd "$CHECKOUT"
exec lua tests/run.lua
