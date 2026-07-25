# Annotated URLs — graceful degradation & missing API resilience

Primary sources for track 55. Prefer these when deciding capability probes, `pcall` policy, flavor gates, and partial-sync behavior.

## Lua / capability APIs

| URL | Why it matters for Beef |
|-----|-------------------------|
| https://warcraft.wiki.gg/wiki/API_pcall | Canonical `pcall` contract: success flag + error text; use for optional/media/parse seams, not to hide core bugs. |
| https://warcraft.wiki.gg/wiki/WOW_PROJECT_ID | Project-id constants for flavor detection (`MAINLINE`, `CLASSIC`, `BURNING_CRUSADE_CLASSIC`, …). |
| https://wowpedia.fandom.com/wiki/WOW_PROJECT_ID | Mirror with value table + example `if WOW_PROJECT_ID == …` branches. |
| https://warcraft.wiki.gg/wiki/TOC_format | Interface numbers, multi-Interface commas, `_TBC` / `_Vanilla` TOC suffixes, `GetBuildInfo` probe. |
| https://warcraft.wiki.gg/wiki/API_C_ChatInfo.RegisterAddonMessagePrefix | Must register before peers receive; failure ⇒ BeefNet degraded mode. |
| https://warcraft.wiki.gg/wiki/API_C_ChatInfo.SendAddonMessage | Channel matrix; Classic `CHANNEL` disabled; success return ≠ delivery. |
| https://wowpedia.fandom.com/wiki/API_C_ChatInfo.SendAddonMessage | Mirror: throttle notes, Classic SAY/YELL, register requirement. |
| https://wowpedia.fandom.com/wiki/Porting_addons_to_Classic | Porting mindset: use `WOW_PROJECT_ID`; expect API gaps vs Retail. |

## Messaging failure modes (partial sync evidence)

| URL | Why it matters for Beef |
|-----|-------------------------|
| https://us.forums.blizzard.com/en/wow/t/classic-sendaddonmessage-problems/620054 | Silent drops with AceComm+CTL; API may return true; “send less data.” |
| https://us.forums.blizzard.com/en/wow/t/classic-changes-to-cchatinfosendaddonmessage/544278 | Partial delivery of burst GUILD loops — designs must be revision-safe. |
| https://us.forums.blizzard.com/en/wow/t/wow-classic-patch-1133-lua-api-change/384543 | Kaivax: custom CHANNEL addon comms removed — never design around it. |
| https://www.wowhead.com/classic/news/wow-classic-patch-1-13-3-lua-api-change-disabling-addons-from-communicating-in-299371 | Summary of allowed channels (PARTY/RAID/GUILD/WHISPER). |
| https://stackoverflow.com/questions/61752395/raid-doesnt-receive-c-chatinfo-sendaddonmessage | Local echo vs peers: register prefix or others never receive. |
| https://stackoverflow.com/questions/62723031/wow-classic-api-event-for-addon-messages | Cold-login send failures; settle before SYNC. |
| https://us.forums.blizzard.com/en/wow/t/chat-msg-addon-how/190982 | Community wiring of `CHAT_MSG_ADDON` + register timing. |

## Packaging / multi-flavor

| URL | Why it matters for Beef |
|-----|-------------------------|
| https://support.curseforge.com/support/solutions/articles/9000209856-multi-toc-for-world-of-warcraft-addons | How managers resolve multi-TOC; V1 still prefers Anniversary-only artifact. |
| https://github.com/Stanzilla/WoWUIBugs/issues/68 | Historical multi-interface / TOC suffix support discussion. |

## Cousin / social degradation patterns

| URL | Why it matters for Beef |
|-----|-------------------------|
| Track-local: [../13-cousin-addon-teardowns/attune.md](../13-cousin-addon-teardowns/attune.md) | Soft dependency: peers without addon simply absent; play continues. |
| https://eu.forums.blizzard.com/en/wow/t/feedback-guild-note-apis-guildrostersetpublicnote-cguildinfosetnote-and-secret-values/615202 | Retail note-write blocks — warning not to base Beef ladder on guild-note APIs. |

## Product truth (repo)

| Path | Why |
|------|-----|
| [`docs/superpowers/specs/2026-07-25-church-of-beef-design.md`](../../../superpowers/specs/2026-07-25-church-of-beef-design.md) §8.2–§8.3, §10–§13 | Soft-lock ban, sync, media fallback, edge table, success criteria. |
| [`../14-addon-messaging-beefnet/`](../14-addon-messaging-beefnet/) | Transport budgets; silent-drop culture; settle order. |
| [`../27-desync-conflict-resolution/`](../27-desync-conflict-resolution/) | Revision merge when partial sync heals. |
| [`../00-church-of-beef-implications.md`](../00-church-of-beef-implications.md) | Synthesis: non-addon peers + graceful ladder degradation. |

## Provenance dumps

| File | Contents |
|------|----------|
| [`.raw/search-feature-detection-pcall.json`](.raw/search-feature-detection-pcall.json) | `pcall`, prefix register, hooking notes |
| [`.raw/search-flavor-mismatch.json`](.raw/search-flavor-mismatch.json) | TOC / Interface / multi-TOC |
| [`.raw/search-partial-sync.json`](.raw/search-partial-sync.json) | Classic silent drops / SendAddonMessage |
| [`.raw/search-project-id-roster.json`](.raw/search-project-id-roster.json) | `WOW_PROJECT_ID`, roster/note API context |
| [`.raw/extract-wowpedia-core.json`](.raw/extract-wowpedia-core.json) | Extracted Wowpedia `WOW_PROJECT_ID` |
