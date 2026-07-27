# Local WoW AddOns install path (machine note)

Resolved for this machine on 2026-07-26. No secrets.

## Destination

```
/Applications/World of Warcraft/_anniversary_/Interface/AddOns
```

Installed addon folder:

```
/Applications/World of Warcraft/_anniversary_/Interface/AddOns/ChurchOfBeef
```

Client: **WoW Classic Anniversary** (`_anniversary_`, Interface `20506`).

## Source (workspace)

```
/Volumes/AI_Design_Drive/Beef_Addon/addon/ChurchOfBeef/
```

Prefer this over an empty `.worktrees/feat-church-of-beef-v1/` checkout when `addon/ChurchOfBeef` exists on the workspace root.

## Re-install

```bash
export WOW_ADDONS_DIR="/Applications/World of Warcraft/_anniversary_/Interface/AddOns"
rsync -a --delete \
  "/Volumes/AI_Design_Drive/Beef_Addon/addon/ChurchOfBeef/" \
  "$WOW_ADDONS_DIR/ChurchOfBeef/"
```

Then in-game: `/console scriptErrors 1` → `/reload` → `/beef`.

**Never** touch `WTF/` or player `ChurchOfBeefDB.lua` unless the user explicitly asks.
