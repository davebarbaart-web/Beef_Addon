# Rename and realm-transfer fallout

**Track:** 25 · **Last updated:** 2026-07-25

## 1. What Blizzard moves vs what addons must fix

Per-character addon data lives under `WTF/Account/<account>/<realm>/<character>/SavedVariables/` ([TOC format](https://warcraft.wiki.gg/wiki/TOC_format)). Community recovery after rename/transfer is **manual folder copy + string replace**, not an automatic Blizzard migrate for third-party SV ([Changing Addon Character Name/Realm](https://us.forums.blizzard.com/en/wow/t/changing-addon-character-namerealm/989443)):

1. Log in once under the **new** name/realm so empty folders exist.
2. Exit completely.
3. Copy old `<realm>/<oldName>/…` contents into `<realm>/<newName>/…` (or across realm folders on transfer).
4. Find/replace old name (and carefully old realm) inside account-level `SavedVariables` for Ace-style addons that key `"Name - Realm"`.

Author notes the guide is Retail-validated; Classic folder layout is the same WTF pattern, but always backup first.

**Beef V1 uses SavedVariablesPerCharacter** — rename/transfer primarily orphans the **character folder**. Account-level Ace keys are less relevant until Beef adds account SV for prefs/alt links.

## 2. Character rename — ladder and points

| Store | Effect of rename (no manual migrate) |
|-------|--------------------------------------|
| Per-char SV folder | New empty `ChurchOfBeefDB`; old folder orphaned under old name |
| Local standing / My Standing | Appears reset (Fresh Beef / zero) unless player copies WTF |
| Cached official ladder (other players) | Intact — peers still hold `OldName` rows |
| This character’s official row | Peers still show **OldName** as occupant; **NewName** looks like a new Fresh Beef until officer commit / sync |
| Guild-chat history / spectacle lines | Past announces refer to old name (fine) |
| Name recycled by another player | Worst case: new unrelated character inherits social confusion if peers never tombstone OldName |

### GUID angle

Roster exposes `guid` ([GetGuildRosterInfo](https://warcraft.wiki.gg/wiki/API_GetGuildRosterInfo)); `UnitGUID` yields `Player-…` ([UnitGUID](https://warcraft.wiki.gg/wiki/API_UnitGUID)). A later migrate tool can match “same GUID, new name” and rewrite keys. V1 name-keyed commits still work if officers:

1. Demote/hide or tombstone `OldName` (or leave hidden after leave — but rename usually stays in guild).
2. Issue a fresh `RANK_COMMIT` for `NewName` with intended rank/standing/revision.

Without that, the ladder shows a ghost title on a name nobody has.

## 3. Realm transfer — ladder and points

| Layer | Effect |
|-------|--------|
| WTF path | Realm segment changes; copy needed for local SV recovery ([forum guide](https://us.forums.blizzard.com/en/wow/t/changing-addon-character-namerealm/989443)) |
| BeefNet | Old guild mesh unreachable; new realm needs new guild membership |
| Dreamscythe → elsewhere | Leaves Alliance church ladder instance entirely |
| Doomhowl → elsewhere | Leaves Horde church ladder instance entirely |
| Transfer + forced rename | Compound of both edges |
| External sites (e.g. log DBs) | Often treat transfer as new identity — same class of pain ([Warcraft Logs Classic transfer thread](https://forums.combatlogforums.com/t/classic-what-happens-on-character-transfer/11243)) |

**Product rule:** realm transfer out of a Church realm is **not** a ladder migrate. Treat as leave. If they transfer *into* Dreamscythe/Doomhowl and join the guild, they are a new (or returning) member under guild-scope rules — officers may manually restore rank as theater.

## 4. Faction change / name conflict edges

- Faction change implies new realm/guild topology for Beef’s dual-church setup — do not auto-carry Alliance Prophet to Horde ladder.
- If `OldName` is taken by another character on the old realm after transfer, peer caches that still key by name can **mis-attribute** history. Prefer tombstone-by-GUID or officer purge when available.

## 5. Points vs official rank after rename/transfer

Remember the anti-cheat stance: **local points are advisory; officer commit is truth** ([§6.3](../../../superpowers/specs/2026-07-25-church-of-beef-design.md)).

| Recovered via WTF copy? | Local points | Official rank on peers |
|-------------------------|--------------|------------------------|
| Yes | Can restore My Standing UI | Still need officer re-commit under new key if name/realm changed |
| No | Starts fresh | Ghost old key until cleaned |

Do not treat a successful WTF copy as “already official” on other clients — revisioned sync still needs a commit under the new player key (or a dedicated migrate message in a future protocol version).

## 6. Officer runbook (docs-only checklist)

When a member renames (same guild/realm):

1. Confirm new name on roster (and GUID if tooling exists).
2. Tombstone / hide old ladder key (manual demote or hide).
3. `RANK_COMMIT` new key at intended rank + standing; bump revision.
4. Optional: one guild-chat line acknowledging the rename (spectacle).
5. Member may copy their own WTF folder for UI prefs / local log — optional, not required for official rank.

When a member transfers off Dreamscythe/Doomhowl:

1. Treat as leave — hide record.
2. Do not attempt cross-realm sync.
3. If they return later to the same church guild, restore per §11.

## 7. Out of scope here

- Exact Classic paid-transfer availability by season — product policy above holds regardless.
- Automated WTF rewriting inside the addon (would require filesystem access the addon does not have).
