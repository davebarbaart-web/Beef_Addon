# Classic slash mechanics (discovery & registration)

**Last updated:** 2026-07-25

## How registration works

Addon slash handlers are not a separate “command palette” API. Chat FrameXML looks up:

1. A function in the global `SlashCmdList` table under a unique key.
2. Consecutive globals `SLASH_<KEY>1`, `SLASH_<KEY>2`, … with the typed strings (including leading `/`).

Canonical summary: assign `SlashCmdList[key]` and `SLASH_keyN` globals ([Creating a slash command — Wowpedia](https://wowpedia.fandom.com/wiki/Creating_a_slash_command); archive mirror [WoWWiki](https://wowwiki-archive.fandom.com/wiki/Creating_a_slash_command)).

Plan’s bootstrap shape matches this:

- Key: `CHURCHOFBEEF`
- Alias slot 1: `/beef`

Numbering matters: `SLASH_CHAT` without a trailing `1` fails silently — a common footgun ([Stack Overflow: WOW Addon commands](https://stackoverflow.com/questions/45264404/wow-addon-commands)).

Handler signature: `(msg, editBox)` where `msg` is everything *after* the command token ([Wowpedia](https://wowpedia.fandom.com/wiki/Creating_a_slash_command)).

## AceConsole shorthand

Ace3 embeds the same system:

- `RegisterChatCommand("myslash", func)` — command **without** leading `/` ([Ace3 Getting Started](https://www.wowace.com/projects/ace3/pages/getting-started); [AceConsole-3.0 API](https://www.wowace.com/projects/ace3/pages/api/ace-console-3-0)).
- Ace registration lands in `SlashCmdList` under names like `ACECONSOLE_BT` for `/bt` ([Blizzard forum guidance](https://us.forums.blizzard.com/en/wow/t/how-to-execute-a-slash-command-from-inside-an-addon/2034102)).

Beef V1 plan is plain `SlashCmdList` (no Ace). Ace docs remain the reference for empty-input → GUI and `GetArgs` quoting/itemlink parsing ([AceConsole:GetArgs](https://www.wowace.com/projects/ace3/pages/api/ace-console-3-0)).

## Discovery paths players actually use

| Path | Behavior | Beef implication |
|------|----------|------------------|
| Guild Discord / README | Humans teach `/beef` | Ship `/beef` in README first line of “How to use” |
| Chat Tab after `/` | Cycles registered slash strings ([WoWInterface](https://wowinterface.com/forums/archive/index.php/t-48783.html)) | Short unique name; few aliases |
| `/beef help` or unknown args | Chat prints syntax | Required once subcommands exist |
| Minimap | Non-slash discovery | Spec §10; slash remains enough if button hidden |
| Streamer voice | Saying “slash beef” aloud | Brand-friendly token beats `/churchofbeef` |

## Aliases & collisions

Wiki notes ([Wowpedia](https://wowpedia.fandom.com/wiki/Creating_a_slash_command)):

- Default UI commands often **precede** addon commands.
- Addon-vs-addon conflicts resolve **non-deterministically**.
- Same `SlashCmdList` key: last writer wins.
- Be prudent with aliases; avoid Blizzard emotes (`/hi`, `/hello`).

Helper pattern `SlashCmdList_AddSlashCommand(name, func, ...)` packages the same globals ([Wowpedia helper](https://wowpedia.fandom.com/wiki/SlashCmdList_AddSlashCommand); [warcraft.wiki.gg](https://warcraft.wiki.gg/wiki/SlashCmdList_AddSlashCommand)).

**Beef stance:** ship `/beef` only in V1. Optional later alias `/cob` only if guild asks — not both `/church`, `/beef`, `/cob`, `/cof` on day one.

## Localization note

`SLASH_*` string values can be localized; the `SlashCmdList` key stays stable ([Wowpedia Notes](https://wowpedia.fandom.com/wiki/Creating_a_slash_command)). English-only V1 can hardcode `/beef`; keep the key `CHURCHOFBEEF` forever.

## Built-in guild slash context (not Beef)

Blizzard guild verbs (`/g`, `/o`, `/ginvite`, `/gpromote`, …) train players that **officer-restricted chat commands exist** and fail when you lack privilege ([slash command lists](https://wowwiki-archive.fandom.com/wiki/Slash_commands); [AddOn Studio old list](https://addonstudio.org/wiki/WoW%3AList_of_slash_commands_%28old%29)). Beef should feel like that family: clear deny, not mysterious no-op.
