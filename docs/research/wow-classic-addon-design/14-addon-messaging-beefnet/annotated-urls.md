# Annotated URLs — addon messaging / BeefNet

Primary sources for track 14. Prefer these over “top addons” listicles when deciding protocol constraints.

## API and events

| URL | Why it matters for Beef |
|-----|-------------------------|
| https://warcraft.wiki.gg/wiki/API_C_ChatInfo.SendAddonMessage | Canonical send API: 16-char prefix, 255-char message, channel matrix, per-prefix throttle (10 / 1/sec defaults), Classic patch notes (`CHANNEL` removal, severe throttle). |
| https://warcraft.wiki.gg/wiki/API_C_ChatInfo.RegisterAddonMessagePrefix | Must register `COB` before peers can deliver into `CHAT_MSG_ADDON`. |
| https://warcraft.wiki.gg/wiki/CHAT_MSG_ADDON | Receive path: `prefix, text, channel, sender, …` — filter GUILD + COB. |
| https://wowpedia.fandom.com/wiki/API_C_ChatInfo.SendAddonMessage | Mirror / historical wording; useful if wiki.gg is blocked. |
| https://wowpedia.fandom.com/wiki/CHAT_MSG_ADDON | Mirror of event payload docs. |
| https://wowwiki-archive.fandom.com/wiki/API_SendAddonMessage | Pre-`C_ChatInfo` history; WHISPER addition era; reminder that addon comms are old and hard-throttled. |

## Classic policy and throttle culture

| URL | Why it matters for Beef |
|-----|-------------------------|
| https://www.wowhead.com/classic/news/wow-classic-patch-1-13-3-lua-api-change-disabling-addons-from-communicating-in-299371 | Official summary: no custom CHANNEL addon comms; PARTY/RAID/GUILD/WHISPER remain — validates BeefNet `GUILD`. |
| https://us.forums.blizzard.com/en/wow/t/wow-classic-patch-1133-lua-api-change/384543 | Kaivax primary: social-dynamics rationale for CHANNEL ban. |
| https://eu.forums.blizzard.com/en/wow/t/classic-patch-1-13-3-lua-api-change/111998 | EU mirror of the same blue post. |
| https://us.forums.blizzard.com/en/wow/t/classic-sendaddonmessage-problems/620054 | Loot-addon author: AceComm+CTL still see silent drops on multi-KB GUILD sync; “send less data.” |
| https://us.forums.blizzard.com/en/wow/t/classic-changes-to-cchatinfosendaddonmessage/544278 | Burst GUILD loops only partially delivered; intermittent / realm-dependent. |
| https://stackoverflow.com/questions/62723031/wow-classic-api-event-for-addon-messages | Cold login `SendAddonMessage` fails; works after `/reload` — delay SYNC until settle. |

## Throttle libraries

| URL | Why it matters for Beef |
|-----|-------------------------|
| https://warcraft.wiki.gg/wiki/ChatThrottleLib | CTL algorithms, priorities (BULK/NORMAL/ALERT), CPS/burst, post-login clamp. |
| https://wowpedia.fandom.com/wiki/ChatThrottleLib | Long-form CTL docs / changelog mirror. |
| https://www.wowace.com/projects/chatthrottlelib | Distribution / project home for embedding. |
| https://www.curseforge.com/wow/addons/chatthrottlelib | Alternate package page. |
| https://www.wowace.com/projects/ace3/pages/api/ace-comm-3-0 | AceComm: unlimited-length framing + CTL; optional BeefNet polish. |
| https://github.com/WoWUIDev/Ace3/blob/master/AceComm-3.0/AceComm-3.0.lua | Implementation reference for chunking behavior (read-only research). |
| https://github.com/WoWAddonMirrors/ChatThrottleLib | Source mirror if needed for API archaeology. |

## Retail contrast (do not copy into Anniversary V1)

| URL | Why it matters for Beef |
|-----|-------------------------|
| https://github.com/Plaitrix/WoW-Midnight-Addon-Template/blob/main/docs-site/docs/midnight.md | Encounter-time messaging restrictions + same 10/1 throttle story — portability watch only. |

## Product truth (repo)

| Path | Why |
|------|-----|
| [`docs/superpowers/specs/2026-07-25-church-of-beef-design.md`](../../../superpowers/specs/2026-07-25-church-of-beef-design.md) §8–§9, §11 | Locked BeefNet types, `COB`/`GUILD`, revisioned sync, error table. |
| [`docs/research/wow-classic-addon-design/00-church-of-beef-implications.md`](../00-church-of-beef-implications.md) §8 | Synthesis lane implications (do not duplicate wholesale; this track deepens messaging). |
| [`docs/research/wow-classic-addon-design/06-annotated-master-reference-list.md`](../06-annotated-master-reference-list.md) | Curated master list; messaging rows overlap intentionally. |

## Provenance dumps

| File | Contents |
|------|----------|
| [`.raw/search-addon-messaging.json`](.raw/search-addon-messaging.json) | Parallel search: SendAddonMessage / CTL / Classic throttle |
| [`.raw/search-events-sync.json`](.raw/search-events-sync.json) | Parallel search: CHAT_MSG_ADDON / AceComm / sync |
