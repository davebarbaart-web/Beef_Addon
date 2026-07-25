# Annotated URLs — streamer mode & privacy CVars

**Track:** [61-streamer-mode-privacy](README.md)  
**Last updated:** 2026-07-25  

Steal / adapt notes are for **Church of Beef design**. Capture readability URLs live in [track 17](../17-stream-overlay-readability/annotated-references.md) — do not duplicate here.

---

## Console variables & client options

| URL | Annotation |
|-----|------------|
| https://warcraft.wiki.gg/wiki/Console_variables | **Primary.** CVar list, account vs character scope (`chatBubbles`, nameplates), secure CVar note, `SetCVar` / `cvar_default`. Steal: scope table for streamer-alt checklists. |
| https://wowpedia.fandom.com/wiki/Console_variables | Mirror with dated complete-list excerpt (`profanityFilter` default `1` account; `nameplateShowFriends` default `0`; etc.). |
| https://warcraft.wiki.gg/wiki/CVar_BlockTrades | `BlockTrades` 0/1 — trade-block while streaming open world. Privacy-adjacent, not name privacy. |
| https://github.com/Stanzilla/AdvancedInterfaceOptions/blob/master/cvars.lua | **Practical browser source.** Maps `spamFilter`, `profanityFilter`, `blockTrades`, `chatBubbles`, `UnitName*`, `nameplateShow*` to Blizzard option tooltips. Steal: which CVars are “real Social options.” |
| https://us.forums.blizzard.com/en/wow/t/removing-friendly-trivial-npc-names/559440 | Community fix: `SetCVar("nameplateShowFriendlyNPCs", 0)`. Steal: streamers inherit plate CVars from other machines. |
| https://us.forums.blizzard.com/en/wow/t/why-was-nameplateshowonlynames-removed/1499143 | Retail 10.0.5 removed `nameplateShowOnlyNames` behavior — do not design Classic Anniversary features on it. |
| https://cyberpost.co/how-do-you-get-rid-of-floating-names-in-wow | Player-facing path: Esc → Interface → Names. Steal: ops checklist wording (not technical depth). |
| https://wowinterface.com/forums/showthread.php?t=53263 | Confirms `profanityFilter` CVar still drives mature-language filtering; manipulate via `SetCVar`. |

---

## Chat filters & ignore

| URL | Annotation |
|-----|------------|
| https://wowpedia.fandom.com/wiki/Ignore | **Critical for §13.11.** Ignore suppresses guild/party/trade chat; 50-name cap; character-not-account. Steal: “ignored the officer → no promote line” failure mode. |
| https://us.forums.blizzard.com/en/wow/t/chat-filters-unlimited-ignore-lists/261792 | Classic-era culture: BadBoy + GIL as default spam stack. Steal: assume streamer guilds run filters; design announces to stay guild-safe. |
| https://www.curseforge.com/wow/addons/global-ignore-list | GIL tags/`[chname=guild]` + “never filter guild/party” options. Steal: recommend those options in Beef ops notes. |
| https://www.wowinterface.com/downloads/info19125-ChatFilter.html | Classic pattern: keyword spam filter; **friends/guild/raid/party exempt**. Steal: exemption norm Beef should rely on, not fight. |

---

## Name-hiding / streamer addons

| URL | Annotation |
|-----|------------|
| https://www.curseforge.com/wow/addons/streamermode | **Primary ecosystem exemplar (2026).** Hides name + BattleTag across default UI + chat; Classic/BCC flavors; `/sm`. Steal: coexistence warning — does not mask Beef frames. |
| https://www.curseforge.com/wow/addons/streamer-mode | Classic Era obfuscator (class names / Ω floating names). Steal: pattern library for Beef’s display mask (title/class metaphors). |
| https://legacy.curseforge.com/wow/addons/betterblizzplates | Name formatting + CVar panel; streamer user list. Steal: plates are combat privacy-adjacent only — out of Beef scope. |
| https://addons.wago.io/addons/betterblizzplates | Wago mirror of BBP feature list. |
| https://wowpedia.fandom.com/wiki/API_UnitName | `UnitName` / `UnitFullName` / `UnitNameUnmodified` — Lua always sees real names; obfuscation is display-only. |
| https://www.ownedcore.com/forums/world-of-warcraft/world-of-warcraft-bots-programs/576599-rename-addon-streamers-video-creators-fake-hide-names-ui.html | Historical ReName/StreamGuard surface list + explicit leaks (heads/plates). Context only; not a CurseForge dependency. |

---

## Product / sibling research (internal)

| URL / path | Annotation |
|------------|------------|
| [../17-stream-overlay-readability/README.md](../17-stream-overlay-readability/README.md) | Capture readability — **do not duplicate**; privacy ≠ contrast. |
| [../05-packaging-community-antipatterns/03-anti-patterns-and-complaints.md](../05-packaging-community-antipatterns/03-anti-patterns-and-complaints.md) | “Streamer quiet” as addon setting until API verified. |
| [../05-packaging-community-antipatterns/05-implications-for-church-of-beef.md](../05-packaging-community-antipatterns/05-implications-for-church-of-beef.md) | Checklist item: streamer quiet setting. |
| [../../../superpowers/specs/2026-07-25-church-of-beef-design.md](../../../superpowers/specs/2026-07-25-church-of-beef-design.md) | Spec §1 / §10 / §13.11 product truth. |

---

## Deliberately not used as WoW Classic sources

Unrelated games’ “streamer mode” pages (Overwatch hide-name gates, Sea of Thieves filters, STALZONE support, etc.) appeared in search noise — ignore for Beef CVar design.

---

## Provenance dumps

| File | Contents |
|------|----------|
| [.raw/search-streamer-mode.json](.raw/search-streamer-mode.json) | StreamerMode / BBP / privacy search |
| [.raw/search-cvars-privacy.json](.raw/search-cvars-privacy.json) | Ignore / GIL / chat filter search |
| [.raw/search-native-cvars.json](.raw/search-native-cvars.json) | Nameplate + profanityFilter + AIO |
| [.raw/search-name-anonymize.json](.raw/search-name-anonymize.json) | Obfuscator ecosystem |
| [.raw/search-wiki-filters.json](.raw/search-wiki-filters.json) | Wiki filter follow-up |
| [.raw/search-unitname-cvars.json](.raw/search-unitname-cvars.json) | Names panel / UnitName |
| [.raw/extract-wiki-cvars-privacy.json](.raw/extract-wiki-cvars-privacy.json) | warcraft.wiki.gg Console variables excerpts |
| [.raw/extract-aio-cvars.json](.raw/extract-aio-cvars.json) | AIO cvars.lua excerpts |
| [.raw/extract-ignore.json](.raw/extract-ignore.json) | Ignore wiki |
| [.raw/extract-streamermode-addon.json](.raw/extract-streamermode-addon.json) | D4KiR StreamerMode |
| [.raw/extract-streamer-mode-classic.json](.raw/extract-streamer-mode-classic.json) | DnB_Junkee Classic Streamer Mode |
