# Annotated URLs — slash commands & chat-command UX

**Last updated:** 2026-07-25  
Primary links for this track. Steal/adapt notes are for Church of Beef research, not endorsements.

---

## Registration & mechanics

| URL | Why it matters | Steal / adapt |
|-----|----------------|---------------|
| [Creating a slash command (Wowpedia)](https://wowpedia.fandom.com/wiki/Creating_a_slash_command) | Canonical `SlashCmdList` + `SLASH_*N` howto; arg parse; help-on-else; conflict notes | Copy the syntax-else pattern; keep key `CHURCHOFBEEF` |
| [Creating a slash command (warcraft.wiki.gg)](https://warcraft.wiki.gg/wiki/Creating_a_slash_command) | Same topic on wiki.gg | Prefer if Wowpedia drifts |
| [Creating a slash command (WoWWiki archive)](https://wowwiki-archive.fandom.com/wiki/Creating_a_slash_command) | Full examples including multi-alias and object-method wrapper | Use as secondary if extracts fail |
| [SlashCmdList_AddSlashCommand (Wowpedia)](https://wowpedia.fandom.com/wiki/SlashCmdList_AddSlashCommand) | Helper that sets list + aliases | Optional sugar; not required |
| [SlashCmdList_AddSlashCommand (warcraft.wiki.gg)](https://warcraft.wiki.gg/wiki/SlashCmdList_AddSlashCommand) | wiki.gg mirror | Same |
| [Stack Overflow: WOW Addon commands](https://stackoverflow.com/questions/45264404/wow-addon-commands) | Real footgun: missing `1` on `SLASH_*` | Mentions in QA checklist |
| [Blizzard forum: execute slash from addon](https://us.forums.blizzard.com/en/wow/t/how-to-execute-a-slash-command-from-inside-an-addon/2034102) | `SlashCmdList` / `ACECONSOLE_*` invocation | Avoid ChatEdit hacks for minimap → call Toggle directly |

---

## Ace console / config / tab

| URL | Why it matters | Steal / adapt |
|-----|----------------|---------------|
| [AceConsole-3.0 API](https://www.wowace.com/projects/ace3/pages/api/ace-console-3-0) | `RegisterChatCommand`, `GetArgs`, `Print` | V1 can skip Ace; steal GetArgs semantics later |
| [Ace3 Getting Started — slash section](https://www.wowace.com/projects/ace3/pages/getting-started) | No leading `/` on register; AceConfig slash list | Empty input vs args pattern |
| [AceConfigCmd-3.0 API](https://www.wowace.com/projects/ace3/pages/api/ace-config-cmd-3-0) | `HandleCommand`; CreateChatCommand registers AceTab | Empty → GUI template; don’t dump options on `/beef` |
| [AceTab-3.0 API](https://www.wowace.com/projects/ace3/pages/api/ace-tab-3-0) | Official Tab lib; marked not finalized | Defer for V1 |
| [AceTab-3.0.lua (WoWUIDev/Ace3)](https://github.com/WoWUIDev/Ace3/blob/master/AceTab-3.0/AceTab-3.0.lua) | `RegisterTabCompletion` signature + cycle/usage behavior | Limits notes for tab-completion doc |
| [AceConsole-3.0.lua (WoWUIDev)](https://github.com/WoWUIDev/Ace3/blob/master/AceConsole-3.0/AceConsole-3.0.lua) | Implementation reference | Audit only |

---

## Discovery / built-in Tab / Blizzard slash culture

| URL | Why it matters | Steal / adapt |
|-----|----------------|---------------|
| [WoWInterface: slash Tab discovery](https://wowinterface.com/forums/archive/index.php/t-48783.html) | `/` + Tab cycles registered commands | Keep `/beef` short and unique |
| [Slash commands reference (WoWWiki archive)](https://wowwiki-archive.fandom.com/wiki/Slash_commands) | Built-in `/help`, guild `/g` `/o`, etc. | Officer-restricted verb culture |
| [List of slash commands (old) — AddOn Studio](https://addonstudio.org/wiki/WoW%3AList_of_slash_commands_%28old%29) | Officer guild verbs (`/ginvite`, `/gmotd`, …) | Soft-deny expectations |

---

## Cousin addon slash UX

| URL | Why it matters | Steal / adapt |
|-----|----------------|---------------|
| [Guild Recruiter — CurseForge](https://www.curseforge.com/wow/addons/guild-recruiter) | Documents `/gr` / `/recruiter help`; officer/GM option force | Advertise `help` as discovery verb |
| [Gargul listing (slash blurb)](https://addonswow.com/gargul) | `/gl` GUI; `/gl help`; short subverbs | Shallow verb set + help |
| [Guild Roster Manager — CurseForge](https://www.curseforge.com/wow/addons/guild-roster-manager) | Power actions live in `/grm` UI | Bias commits to Officer tab |

---

## Product sources (repo)

| URL / path | Why it matters | Steal / adapt |
|------------|----------------|---------------|
| [Church of Beef design spec](../../../superpowers/specs/2026-07-25-church-of-beef-design.md) | `/beef` frame; officer gates; error table | Product truth |
| [V1 implementation plan](../../../superpowers/plans/2026-07-25-church-of-beef-v1.md) | `SLASH_CHURCHOFBEEF1`; UI-not-ready line; debug standing | Bootstrap + debug policy |
| [00 implications §10](../00-church-of-beef-implications.md) | Slash + minimap entry pattern | Cross-link only |
| [02 UX patterns — entry points](../02-ux-patterns-classic.md) | Slash / minimap / keybind triad | Don’t duplicate IA here |
| [04 Ace libraries](../04-ace3-and-libraries.md) | AceConsole listed for `/beef` family | V2 options path |

---

## Provenance dumps

Raw search/extract JSON for this track:

- `.raw/search-slash-api.json`
- `.raw/search-officer-help-ux.json`
- `.raw/search-acetab-configcmd.json`
- `.raw/search-cousin-slash-ux.json`
- `.raw/extract-aceconsole.json`
- `.raw/extract-aceconfigcmd.json`
- `.raw/extract-acetab.json`
- `.raw/extract-acetab-source.json`
- `.raw/extract-ace-getting-started.json`
- `.raw/extract-wowpedia-slash.json`
- `.raw/extract-wowinterface-tab.json`
