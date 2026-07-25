# Annotated URLs — multi-toon / realm / transfer edges

**Track:** 25 · **Last updated:** 2026-07-25  
Only URLs consulted via this track’s research dumps (see [`.raw/`](.raw/)).

| URL | What it establishes | Steal / adapt for Beef |
|-----|---------------------|------------------------|
| [UnitName — Warcraft Wiki](https://warcraft.wiki.gg/wiki/API_UnitName) | `name, realm` returns; realm is normalized; `UnitFullName("player")` always includes realm; same-realm `UnitName("player")` realm is nil | Always qualify ladder keys; do not assume bare name is enough forever |
| [Ambiguate — Warcraft Wiki](https://warcraft.wiki.gg/wiki/API_Ambiguate) | Context table for when `-Realm` is stripped (`guild`, `mail`, `none`, …); same-guild cross-realm collision detail | Use for **display** and announces only; never as sole storage key |
| [UnitGUID — Warcraft Wiki](https://warcraft.wiki.gg/wiki/API_UnitGUID) | GUID string form; `Player-serverId-playerId` parse example; added 2.4.0 | Optional secondary identity for rename migrate later |
| [GetGuildRosterInfo — Warcraft Wiki](https://warcraft.wiki.gg/wiki/API_GetGuildRosterInfo) | Roster `name` may be `Name-Realm`; final return `guid` | Normalize roster names into canonical keys; GUID available when roster loaded (timing = track 16) |
| [GetGuildInfo — Warcraft Wiki](https://warcraft.wiki.gg/wiki/API_GetGuildInfo) | Guild name / rank index / guild realm; **nil at load** even if guilded; wait on guild events | Do not select guild-scoped ladder bucket until `guildName` known |
| [TOC format — Saved variables](https://warcraft.wiki.gg/wiki/TOC_format) | Account SV vs per-character path `WTF/.../[server]/[character]/SavedVariables` | Confirms rename/transfer orphans per-char folders |
| [GetRealmName — Wowpedia](https://wowpedia.fandom.com/wiki/API_GetRealmName) | Pairs `GetRealmName()` with `GetNormalizedRealmName()` | Document both forms; pick normalized for compact keys |
| [AceDB-3.0 Tutorial — WowAce](https://www.wowace.com/projects/ace3/pages/ace-db-3-0-tutorial) | `char` / `realm` / `factionrealm` / `global` / `profile` meanings | Vocabulary for future alt/UI prefs without adopting Ace yet |
| [AceDB-3.0.lua charKey construction](https://github.com/Vicious-wow/XIV_Databar/blob/master/Libs/AceDB-3.0/AceDB-3.0.lua) | `charKey = UnitName("player") .. " - " .. GetRealmName()` | Explains ecosystem `"Name - Realm"` (spaced) vs roster `Name-Realm` forks |
| [AceDB-3.0 API page — WowAce](https://www.wowace.com/projects/ace3/pages/api/ace-db-3-0) | Same data-type list + profile management | If account SV arrives, keep Church data out of cosmetic profiles |
| [Changing Addon Character Name/Realm — Blizzard forums](https://us.forums.blizzard.com/en/wow/t/changing-addon-character-namerealm/989443) | Manual WTF copy + find/replace after rename/transfer; Ace global SV pain | Officer/member runbook; Beef cannot automate filesystem repair |
| [Anyone know how Saved Variables work? — Blizzard forums](https://us.forums.blizzard.com/en/wow/t/anyone-know-how-saved-variables-work/1388757) | Account vs character SV locations; account copy shares configs | Supports “alts don’t share per-char ladder” explanation |
| [SavedVariables — WoWWiki archive](https://wowwiki-archive.fandom.com/wiki/SavedVariables) | Classic path sketch `Account/REALM/CHAR/SavedVariables` | Historical confirmation of folder layout |
| [GetUnitName — AddOn Studio](https://addonstudio.org/wiki/WoW:API_GetUnitName) | Combined name formatting; space/`-` inconsistency examples | Reinforces need for one normalizer |
| [WoW lua get GUID from character name — Stack Overflow](https://stackoverflow.com/questions/50392681/wow-lua-get-guid-from-character-name) | `UnitGUID` needs UnitId; arbitrary names are not UnitIds | Cannot resolve offline guildmate GUID without roster |
| [[Classic] What Happens on Character Transfer? — Warcraft Logs forums](https://forums.combatlogforums.com/t/classic-what-happens-on-character-transfer/11243) | External systems also struggle with transfer/name reuse | Expect social/DB identity pain; officers are migrate authority |
| [Church of Beef V1 design spec](../../../superpowers/specs/2026-07-25-church-of-beef-design.md) | Product law: per-char SV, dual-realm independent ladders, leave/hide/restore, alt doctrine | Source of truth this track must not contradict |
| [05-persistence-and-profiles.md](../05-persistence-and-profiles.md) | Library persistence mapping already aligned with V1 | Sibling context for account vs char split |

## Intentionally not duplicated

Track [16-guild-roster-officer-edges](../16-guild-roster-officer-edges/) owns `GUILD_ROSTER_UPDATE` races, offline member visibility, and Officer+ rank-index gates. This track only uses guild APIs for **membership identity** and **name/GUID key material**.
