# Account vs Character SavedVariables

**Track:** [21 README](README.md)  
**Primary sources:** [TOC format — Saved variables](https://warcraft.wiki.gg/wiki/TOC_format#Saved_variables), [Saving variables between game sessions](https://warcraft.wiki.gg/wiki/Saving_variables_between_game_sessions), [SavedVariables](https://warcraft.wiki.gg/wiki/SavedVariables)

---

## 1. TOC directives

| Directive | Scope | Typical path under install |
|-----------|--------|----------------------------|
| `## SavedVariables` | Account-wide (any character on the account loads the same globals) | `WTF/Account/<account>/SavedVariables/<AddOnName>.lua` |
| `## SavedVariablesPerCharacter` | One realm + character | `WTF/Account/<account>/<realm>/<character>/SavedVariables/<AddOnName>.lua` |

Rules from wiki:

- Names listed are **globals** in the shared environment; they must be unique across addons (prefix with addon name).
- Variables are **not available** until after the client loads the SV file and fires `ADDON_LOADED` for that addon ([Saving variables…](https://warcraft.wiki.gg/wiki/Saving_variables_between_game_sessions)).
- Changing which names appear in the TOC requires a **full client restart**; `/reload` alone is not enough for TOC metadata changes (community consensus / common-pitfall lists).

`## LoadSavedVariablesFirst` (load SV before script files) exists on modern TOC docs ([TOC format](https://warcraft.wiki.gg/wiki/TOC_format)) but is a Retail-era addition (noted in TWW patch notes on that page). **Do not depend on it for TBC Anniversary V1** — initialize on `ADDON_LOADED` only.

---

## 2. When data loads and when it writes

**Load order (simplified from wiki):** FrameXML → addon Lua/XML executes → SavedVariables for that addon load → `ADDON_LOADED` with addon name → later login events (`PLAYER_LOGIN`, `PLAYER_ENTERING_WORLD`, etc.).

**Write points:** Client persists SV on logout / exit / `/reload`. `PLAYER_LOGOUT` is the last chance for last-minute mutations before disk write ([Saving variables…](https://warcraft.wiki.gg/wiki/Saving_variables_between_game_sessions)). There is **no continuous flush** during play — crash or hard kill can lose in-session mutations that never reached a write boundary.

Blizzard forum guidance matches wiki: locals are not saved unless copied into the declared global SV space before logout ([Saving Local Variables Between Sessions](https://us.forums.blizzard.com/en/wow/t/saving-local-variables-between-sessions/380081)).

---

## 3. What may be stored

Persisted types: strings, numbers, booleans, tables. **Not** persisted: functions, userdata, frames, coroutines. Circular table references and shared table identity across multiple SV roots are not reliably preserved ([Saving variables…](https://warcraft.wiki.gg/wiki/Saving_variables_between_game_sessions) — common pitfalls).

Implication for Beef: store ladder records as plain nested tables (player key → rank id, standing, revision, timestamps). Never store frame references for “saved position” — store point/relativePoint/x/y numbers only.

---

## 4. Account vs Character — decision matrix (general)

| Data class | Prefer Account SV | Prefer PerCharacter SV |
|------------|-------------------|-------------------------|
| Named UI profiles shared across alts | Yes | — |
| Gold / inventory aggregates across alts | Yes | — |
| Character progress, unlocks, standing | — | Yes |
| Frame layout that differs per role/toon | Sometimes (profile) | Yes (simplest) |
| Guild ladder **cache** | Optional (multi-alt same guild view) | Spec V1: Yes (doctrine) |

Church of Beef V1 locks **PerCharacter** for everything in `ChurchOfBeefDB` (spec §9). Account SV is an open-door only if §16 alt-linking or account UI profiles ship later — and even then, ladder authority should stay character- or officer-scoped, not “whatever profile is active.”

---

## 5. Classic / Anniversary path caveats

- Paths sit under a **game-type folder** (`_classic_`, `_classic_era_`, Anniversary/TBC tree, etc.), not a single shared WTF for all flavors ([SavedVariables](https://warcraft.wiki.gg/wiki/SavedVariables); [WTF Folder Backup Guide](https://xscarlife-gaming.com/wtf-folder/)).
- Account-wide SV is still **per Battle.net account folder inside that client tree**, not “server-side” — confused empty-folder reports on forums are almost always wrong path / wrong client ([Blizzard UI forum thread](https://us.forums.blizzard.com/en/wow/t/saving-local-variables-between-sessions/380081)).
- A misplaced `SavedVariables.lua` outside the account tree can make the client load the wrong file and appear to “forget” settings while still writing the real account file on logout ([SavedVariables](https://warcraft.wiki.gg/wiki/SavedVariables)).

---

## 6. Dual declaration pattern (when needed later)

Some addons declare **both** TOC lines with different global names (e.g. account `MyAddonDB` + per-char `MyAddonCharDB`). Wiki’s HaveWeMet example does exactly this: account met-count + per-character last-seen ([Saving variables…](https://warcraft.wiki.gg/wiki/Saving_variables_between_game_sessions)).

For Beef: V1 needs only one global (`ChurchOfBeefDB` PerCharacter). If V2 adds account UI profiles, introduce a **second** global rather than silently flipping the existing TOC line — flipping scope mid-life orphans the old files and looks like data loss.
