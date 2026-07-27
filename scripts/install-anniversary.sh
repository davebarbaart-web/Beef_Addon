#!/usr/bin/env bash
# Install Church of Beef into the local TBC Classic Anniversary AddOns folder.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SRC="$ROOT/addon/ChurchOfBeef"
DST_DEFAULT="/Applications/World of Warcraft/_anniversary_/Interface/AddOns/ChurchOfBeef"
DST="${WOW_ADDONS_DIR:-$DST_DEFAULT}"

if [[ ! -f "$SRC/ChurchOfBeef.toc" ]]; then
  echo "error: missing $SRC/ChurchOfBeef.toc" >&2
  exit 1
fi

PARENT="$(dirname "$DST")"
if [[ ! -d "$PARENT" ]]; then
  echo "error: Anniversary AddOns directory not found: $PARENT" >&2
  echo "Set WOW_ADDONS_DIR to the full ChurchOfBeef install path." >&2
  exit 1
fi

rm -rf "$DST"
mkdir -p "$DST"
# Prefer rsync when available (preserves structure cleanly).
if command -v rsync >/dev/null 2>&1; then
  rsync -a --delete "$SRC/" "$DST/"
else
  cp -R "$SRC/." "$DST/"
fi

echo "Installed Church of Beef → $DST"
echo "In-game: /reload then /beef"
echo "Solo smoke (first): docs/phases/solo-smoke.md"
echo "Guild night:       docs/phases/guild-night-playtest.md"
echo "Checklist:         docs/phases/v1-checklist.md"
