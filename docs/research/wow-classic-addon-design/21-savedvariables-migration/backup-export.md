# Backup and export

**Track:** [21 README](README.md)  
**Primary sources:** [SavedVariables](https://warcraft.wiki.gg/wiki/SavedVariables), [WTF Folder Backup Guide](https://xscarlife-gaming.com/wtf-folder/), [ElvUI export wiki](https://github.com/tukui-org/ElvUI/wiki/export), [WoWUIBugs #241](https://github.com/Stanzilla/WoWUIBugs/issues/241), WoWInterface restore threads

---

## 1. Layers of “backup”

| Layer | What it protects | Who owns it | CoB V1 stance |
|-------|------------------|-------------|-----------------|
| Client auto `.bak` | Previous session’s SV file next to `.lua` | Blizzard client | Unreliable sole plan (see corruption note) |
| Manual WTF copy | All addon settings for that client tree | Player / guild IT | Document in install README |
| In-game UI export string | Portable prefs / layout | Addon author feature | Optional later; UI only |
| BeefNet peer cache | Official ladder revisions | Guild peers + officers | **Primary** recovery for church data |
| Officer “source of truth” habit | Freshest commits | Human process | Spec §8.3 — officers are freshest in practice |

---

## 2. Manual WTF backup (guild installer playbook)

Community backup guides converge on the same ritual ([xScarlife WTF guide](https://xscarlife-gaming.com/wtf-folder/); ElvUI update guides):

1. **Fully exit** WoW (and preferably Battle.net) before copying — SV write on dirty shutdown is a known corruption contributor ([WoWUIBugs #241](https://github.com/Stanzilla/WoWUIBugs/issues/241)).
2. From the Battle.net gear menu → “Show in Explorer/Finder”, open the **correct** client folder (Anniversary / TBC Classic tree, not Era/Retail).
3. Copy the entire `WTF` folder (and optionally `Interface` for a full UI snapshot) to a dated backup name.
4. For CoB-only triage, the per-character file is enough:  
   `WTF/Account/<account>/<realm>/<character>/SavedVariables/ChurchOfBeef.lua`  
   (filename follows **addon folder name**, not the global — wiki storage section).
5. Restore only while the game is closed; login once to verify.

**Rename instead of delete** when troubleshooting (`WTF` → `WTF_old`) so recovery is a folder rename away ([WTF guide](https://xscarlife-gaming.com/wtf-folder/)).

---

## 3. Client `.lua.bak` behavior (know the limits)

- On write, the client typically keeps a `.bak` sibling of the addon SV file (forum + WeakAuras reports).
- Failure mode documented by WeakAuras authors: corrupt/empty/NUL-padded `.lua` loads as “missing data”; next logout can **promote the corrupt file into `.bak`**, destroying the last good backup ([WoWUIBugs #241](https://github.com/Stanzilla/WoWUIBugs/issues/241)).
- Blizzard later added flush precautions for SV writes (same issue thread); residual risk remains — treat `.bak` as best-effort, not archival.

**Player recovery tip (document for officers):** if settings vanish after a crash, **quit without logging in a second time** if possible, and restore from an external WTF copy or an older `.bak` copied aside *before* another clean logout overwrites it. In practice, users often log in twice — hence external dated backups matter.

---

## 4. In-game export / import strings

UI-pack culture (ElvUI, WeakAuras, etc.) uses copy/paste strings:

- ElvUI: Profiles panel → Export Profile / Import Profile; can distinguish Profiles vs Private (character-specific) vs Global subsets ([ElvUI export wiki](https://github.com/tukui-org/ElvUI/wiki/export)).
- Purpose: share layouts, try streamer packs, backup prefs without shipping the whole WTF tree.
- Update hygiene: export important profiles **and** keep a WTF copy before major patches ([ElvUI update guides citing WTF](https://www.elvui.org/) / community mirrors).

**CoB adapt rules:**

- **Allow** export of `ui` subtree (position, mute announces, toast density) if/when settings grow.
- **Do not** market “export ladder” as a trust mechanism — a pasteable ladder string is forgeable theater and fights the officer-commit model (spec §6.3).
- If an officer wants disaster recovery offline, prefer “ask three online peers to stay logged in” + sync over “paste this RANK dump from Discord.”

---

## 5. Copying SV between characters / realms

WoWInterface and forum lore: copying a PerCharacter `.lua` onto another character’s SavedVariables path while the game is closed can transfer settings ([WoWInterface thread](https://www.wowinterface.com/forums/showthread.php?t=44721)). Caveats:

- Addon may key internal data on character name / GUID — blind copy can look “restored” but point at the wrong identity.
- CoB ladder cache keyed by other players’ names is relatively portable; **local standing** claiming to be “this character” must be re-validated or cleared on identity mismatch.
- Cross-client-tree copies (Era → Anniversary) are unsupported; separate WTF roots ([WTF guide](https://xscarlife-gaming.com/wtf-folder/)).

---

## 6. What CoB should tell guild members (short)

1. Normal rank recovery = log in with addon → wait for sync (not “edit my lua”).
2. Before big patches / PC moves: copy the Anniversary `WTF` folder.
3. After a crash + missing CoB data: restore WTF from backup **or** accept empty local standing and re-sync ladder; do not chase `.bak` as the only hope.
4. Alts do not share standing (V1 doctrine) — backing up one character’s file does not populate another.
