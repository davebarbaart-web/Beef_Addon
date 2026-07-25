# Annotated URLs — guild-chat announce API & throttling

**Track:** [72-guild-chat-announce-api](README.md)  
**Last updated:** 2026-07-25  

Steal / adapt notes are for **Church of Beef send-path design**. Announce *wording* lives in [32](../32-microcopy-tone-voice/); receive-side filters in [61](../61-streamer-mode-privacy/); BeefNet CPS in [14](../14-addon-messaging-beefnet/).

---

## SendChatMessage / chat types

| URL | Annotation |
|-----|------------|
| https://wowpedia.fandom.com/wiki/API_SendChatMessage | **Primary.** Signature; 255 truncate; HW table — `GUILD`/`OFFICER`/`PARTY`/`RAID` unmarked; `SAY`/`YELL` outdoors + `CHANNEL` always HW. Patch 8.2.5 / Classic 1.13.3 restriction note + DBM reference. Steal: V1 spectacle = `"GUILD"` without MessageQueue. |
| https://warcraft.wiki.gg/wiki/API_C_ChatInfo.SendChatMessage | Modern `C_ChatInfo` mirror; same HW matrix; `HasRestrictions` / Classic-family presence. Prefer when Anniversary dumps show `C_ChatInfo` as the live entry. |
| https://warcraft.wiki.gg/wiki/API_SendChatMessage | Wiki.gg alias (extract sometimes 403) — use Wowpedia / C_ChatInfo if blocked. |
| https://addonstudio.org/wiki/WoW:API_SendChatMessage | Archive detail: 255 max; oversize truncate post-2.4; **10+ messages → high RTT**; malformed item-link disconnect lore; Retail `CLUB_STREAM_SUBSCRIBED` timing note (do not invent for Classic V1). |
| https://twitter.com/deadlybossmods/status/1176685822223011842 | **Authoritative restriction summary:** automation disabled for public CHANNEL + outdoor SAY/YELL; **raid/party/guild permitted**. Steal: citation for “GUILD is OK from addon code.” |
| https://github.com/LenweSaralonde/MessageQueue | HW-event queue for SAY/YELL/CHANNEL; **other chatTypes send instantly**. Steal: proof V1 does **not** need MessageQueue for `/g`. |
| https://www.reddit.com/r/wowaddons/comments/gp9jyu/wow_classic_simple_chat_message_addon_help/ | Classic practitioner: SAY needs HW outdoors; **GUILD works**. Supporting anecdote only. |

---

## Rate limits & ChatThrottleLib

| URL | Annotation |
|-----|------------|
| https://wowpedia.fandom.com/wiki/ChatThrottleLib | **Primary throttle bible.** ~4000-byte burst, ~800 CPS steady, post-login/zone 1/10 for ~5s; `SendChatMessage` + `SendAddonMessage` APIs; v18 refuses chat text &gt; 255. Steal: shared pipe with BeefNet; NORMAL prio for announce. |
| https://warcraft.wiki.gg/wiki/ChatThrottleLib | Wiki.gg mirror of CTL algorithms / priorities. |
| https://www.curseforge.com/wow/addons/chatthrottlelib | Distribution page; “prevent disconnect from outbound rate limit.” Pair with embed guidance in track [14](../14-addon-messaging-beefnet/chatthrottlelib-and-budgets.md). |
| https://www.wowace.com/projects/chatthrottlelib | WowAce project / tech-spec pointer. |
| https://github.com/WoWAddonMirrors/ChatThrottleLib | Source mirror for API archaeology (`SendChatMessage` signature). |

---

## Guild speak / officer permissions

| URL | Annotation |
|-----|------------|
| https://wowpedia.fandom.com/wiki/API_GuildControlGetRankFlags | Returns `guildchat_listen`, `guildchat_speak`, `officerchat_listen`, `officerchat_speak`, … independent flags. Steal: Officer+ index ≠ speak; warn locally if announce no-ops. |
| https://wowwiki-archive.fandom.com/wiki/API_GuildControlGetRankFlags | Classic example: `GuildControlSetRank(playerrank + 1)` then read flags (control APIs **1-based** vs `GetGuildInfo` **0-based`). |
| https://warcraft.wiki.gg/wiki/API_GuildControlGetRankFlags | Wiki.gg mirror (extract may 403). |
| [`../16-guild-roster-officer-edges/api-edges.md`](../16-guild-roster-officer-edges/api-edges.md) | **Internal.** Officer+ threshold vs invite/notes/`IsGuildOfficer` proxies — do not re-derive approve gate here. |
| https://warcraft.wiki.gg/wiki/API_GetGuildInfo | Local `rankIndex` (0 = GM); nil at login race — announce after roster-ready same as approve. |
| https://warcraft.wiki.gg/wiki/API_IsInGuild | Guard before send; pairs with spec §11 not-in-guild empty state. |

---

## Single-announcer cousins

| URL | Annotation |
|-----|------------|
| https://github.com/papa-smurf/Gargul/wiki/Announcing-Loot-in-Chat | **Primary ownership pattern.** ML client posts to raid/party; “Announce loot to chat” opt-out; min quality / SoftRes knobs. Steal: authority client speaks; peers do not echo. |
| https://github.com/papa-smurf/Gargul/wiki/Importing-Soft-Reserves | SoftRes Broadcast restricted to masterlooters — same “one authority broadcasts” idea. |
| https://www.curseforge.com/wow/addons/gargul | Product page: ML-centric; raiders optional for most features; trade announce gallery. |
| https://addons.wago.io/addons/gargul | Wago mirror: “Only the loot master needs Gargul for most features.” |
| https://rclootcouncil.com/wiki/Options | **Primary RCL announce docs.** Award Announcement (default on, ML sends “as if you typed it,” up to two channels); Announce Considerations (header + **one message per item**). Steal: ML ownership. Avoid: consideration fanout. |
| https://www.curseforge.com/wow/addons/rclootcouncil | Project page + Classic flavor pointer. |
| https://rclootcouncil.com/ | Project hub. |
| https://www.curseforge.com/wow/addons/attune | Optional chat announce on attunement **complete** — event-gated celebration, not per-drip. Steal: announce on rank commit only. |
| [`../13-cousin-addon-teardowns/gargul.md`](../13-cousin-addon-teardowns/gargul.md) | Internal announce-ownership synthesis. |
| [`../13-cousin-addon-teardowns/steal-avoid-for-beef.md`](../13-cousin-addon-teardowns/steal-avoid-for-beef.md) | Default-on announce opt-out guidance. |

---

## Filters / ignore (send hygiene pointers — depth in 61)

| URL | Annotation |
|-----|------------|
| https://wowpedia.fandom.com/wiki/Ignore | Ignore suppresses **guild** chat from ignored sender — §13.11 can fail for one client after a correct send. Full matrix → [61](../61-streamer-mode-privacy/chat-filters-and-spectacle.md). |
| [`../61-streamer-mode-privacy/chat-filters-and-spectacle.md`](../61-streamer-mode-privacy/chat-filters-and-spectacle.md) | Receive-side `profanityFilter` / `spamFilter` / GIL — do not duplicate here. |

---

## Product truth (repo)

| Path | Annotation |
|------|------------|
| [`docs/superpowers/specs/2026-07-25-church-of-beef-design.md`](../../../superpowers/specs/2026-07-25-church-of-beef-design.md) §10, §13.11, §8 | Locked: throttled `/g` from approving officer; visible reaction success check; BeefNet commit. |
| [`../14-addon-messaging-beefnet/chatthrottlelib-and-budgets.md`](../14-addon-messaging-beefnet/chatthrottlelib-and-budgets.md) | Shared CTL instance; announce row in budget table. |
| [`../32-microcopy-tone-voice/announce-line-craft.md`](../32-microcopy-tone-voice/announce-line-craft.md) | Words / skim length — **not** this track. |
| [`../49-officer-notifications/README.md`](../49-officer-notifications/README.md) | Local officer breadcrumb ≠ public `/g`. |

---

## Deliberately not used as V1 send-path sources

| URL / class | Why skipped |
|-------------|-------------|
| Retail encounter `Say`/`Yell` block changelogs as Classic blockers | Public-chat only; GUILD remains the spectacle channel |
| AutoHotKey / PixelTrigger MessageQueue helpers | Irrelevant when chatType is `GUILD` |
| Gold-seller / trade-chat spam macro guides | Wrong channel culture |
| Track 32 template banks | Words only — linked, not copied |

---

## Provenance dumps

Search/extract JSON under [`.raw/`](.raw/):

- `search-sendchatmessage-guild.json`
- `search-chat-rate-limits.json`
- `search-single-announcer-gargul.json`
- `search-guild-speak-permissions.json`
- `search-gargul-sendchat.json`
- `extract-api-throttle-gargul.json`
- `extract-guildflags-sendchat.json`
- `search-rcl-isin-guild.json` (follow-up)
