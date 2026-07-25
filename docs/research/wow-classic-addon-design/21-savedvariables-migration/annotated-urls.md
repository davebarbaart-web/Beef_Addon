# Annotated URLs — SavedVariables / migration / backup

**Track:** [21 README](README.md)  
**Last updated:** 2026-07-25  

Prefer these over listicles when making persistence claims. Steal/adapt notes are CoB-specific.

---

## A. Primary wiki / API

| Source | URL | Use for | Steal / adapt for Beef |
|--------|-----|---------|------------------------|
| TOC format — Saved variables | https://warcraft.wiki.gg/wiki/TOC_format#Saved_variables | `SavedVariables` vs `SavedVariablesPerCharacter`; `LoadSavedVariablesFirst` | V1: PerCharacter `ChurchOfBeefDB` only; ignore LoadSavedVariablesFirst for Anniversary |
| Saving variables between game sessions | https://warcraft.wiki.gg/wiki/Saving_variables_between_game_sessions | Load order, `ADDON_LOADED`, `PLAYER_LOGOUT`, types, pitfalls, HaveWeMet dual-scope example | Init/migrate on ADDON_LOADED; plain tables only; dual global pattern if account UI arrives later |
| SavedVariables overview | https://warcraft.wiki.gg/wiki/SavedVariables | WTF path layout; misplaced file gotcha | Document correct Anniversary client path for guild IT |
| TOC format (Wowpedia mirror) | https://wowpedia.fandom.com/wiki/TOC_format | Same directives; sometimes different nav | Cross-check only; prefer wiki.gg |
| AddOn Studio TOC notes | https://addonstudio.org/wiki/WoW:TOC_format | Concise SV availability rule | Reinforce “nil until ADDON_LOADED” |

---

## B. Corruption, `.bak`, write durability

| Source | URL | Use for | Steal / adapt for Beef |
|--------|-----|---------|------------------------|
| WoWUIBugs #241 — SV writing | https://github.com/Stanzilla/WoWUIBugs/issues/241 | Empty/NUL writes; `.bak` clobber; flush fix notes; overflow edge cases | Keep SV small; external WTF backups; wipe-safe ladder via sync |
| WeakAuras corrupt save report (linked from #241) | https://github.com/WeakAuras/WeakAuras2/issues/4695 | Recurrence after “fix” | Don’t assume rarity = never |

---

## C. Backup / restore culture

| Source | URL | Use for | Steal / adapt for Beef |
|--------|-----|---------|------------------------|
| WTF Folder Backup Guide | https://xscarlife-gaming.com/wtf-folder/ | Close game, copy WTF+Interface, per-client trees, rename-not-delete | Guild install/README backup section |
| ElvUI export wiki | https://github.com/tukui-org/ElvUI/wiki/export | In-game profile string export/import; Profiles vs Private vs Global | UI-prefs export only; never as ladder authority |
| WoWInterface — restoring SV files | https://www.wowinterface.com/forums/showthread.php?t=44721 | Copy SV while game closed; `/reload` nuances | Character-to-character copy caveats for CoB identity |
| Blizzard — Saving local variables | https://us.forums.blizzard.com/en/wow/t/saving-local-variables-between-sessions/380081 | Globals only; write on session end; path correction | Naming uniqueness; path troubleshooting |
| Blizzard — How SV work (general) | https://us.forums.blizzard.com/en/wow/t/anyone-know-how-saved-variables-work/1388757 | Account vs character mental model for players | Alt / profile explanations |
| EU forum — Classic SV folder missing | https://eu.forums.blizzard.com/en/wow/t/wotlk-classic-savedvariables-folder-just-gone/393027 | Crash/force-close path oddities | “Exit cleanly” installer advice |

---

## D. Schema / defaults / Ace boundary

| Source | URL | Use for | Steal / adapt for Beef |
|--------|-----|---------|------------------------|
| Ace3 Getting Started — AceDB | https://www.wowace.com/projects/ace3/pages/getting-started | Init after SV load; namespaces; profiles | Optional later; keep ladder out of `profile`; see track 03 for depth |
| Master list (library) | ../06-annotated-master-reference-list.md | TOC + Ace pointers already curated | Persistence rows there; this track deepens wipe/migration |

---

## E. Product spec (repo)

| Source | URL / path | Use for | Steal / adapt for Beef |
|--------|------------|---------|------------------------|
| CoB V1 design spec | ../../../superpowers/specs/2026-07-25-church-of-beef-design.md | §9 persistence, §8.3 sync, §6.3 anti-cheat, §16 opens | Normative product truth |
| Superseded persistence sketch | ../05-persistence-and-profiles.md | Early AceDB mapping notes | Prefer this track for migration/backup/wipe; avoid duplicating Ace tutorial |

---

## Provenance dumps

| File | Contents |
|------|----------|
| `.raw/search-savedvariables-core.json` | TOC / SV / schema search |
| `.raw/search-backup-corruption-wipe.json` | Backup, `.bak`, wipe |
| `.raw/search-wtf-paths-write-timing.json` | Paths, Classic folder anecdotes |
| `.raw/search-export-import.json` | ElvUI export / update backup culture |
| `.raw/extract-wiki-sv.json` | Wiki extracts |
| `.raw/extract-bak-acedb.json` | WoWUIBugs #241 + AceDB getting started |
