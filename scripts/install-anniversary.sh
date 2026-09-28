#!/usr/bin/env bash
# Install Church of Beef into the local TBC Classic Anniversary AddOns folder.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SRC="$ROOT/addon/ChurchOfBeef"
ADDONS_DEFAULT="/Applications/World of Warcraft/_anniversary_/Interface/AddOns"
DST_DEFAULT="$ADDONS_DEFAULT/ChurchOfBeef"

# Accept either the AddOns parent (skill / 00-INSTALL-PATH) or the full
# ChurchOfBeef destination. Never treat the AddOns folder itself as DST.
if [[ -n "${WOW_ADDONS_DIR:-}" ]]; then
  case "${WOW_ADDONS_DIR%/}" in
    */ChurchOfBeef) DST="${WOW_ADDONS_DIR%/}" ;;
    *) DST="${WOW_ADDONS_DIR%/}/ChurchOfBeef" ;;
  esac
else
  DST="$DST_DEFAULT"
fi

if [[ ! -f "$SRC/ChurchOfBeef.toc" ]]; then
  echo "error: missing $SRC/ChurchOfBeef.toc" >&2
  exit 1
fi

if [[ "$(basename "$DST")" != "ChurchOfBeef" ]]; then
  echo "error: refusing to install outside ChurchOfBeef/ (got $DST)" >&2
  exit 1
fi

PARENT="$(dirname "$DST")"
if [[ ! -d "$PARENT" ]]; then
  echo "error: Anniversary AddOns directory not found: $PARENT" >&2
  echo "Set WOW_ADDONS_DIR to AddOns or the full ChurchOfBeef install path." >&2
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
