# Privacy-relevant CVars matrix

**Track:** [61-streamer-mode-privacy](README.md)  
**Last updated:** 2026-07-25  

What Blizzard’s client can hide or filter without any “Streamer Mode” product surface. Values/scopes from [Wowpedia — Console variables](https://wowpedia.fandom.com/wiki/Console_variables), [Warcraft Wiki — Console variables](https://warcraft.wiki.gg/wiki/Console_variables), [CVar BlockTrades](https://warcraft.wiki.gg/wiki/CVar_BlockTrades), and [AdvancedInterfaceOptions `cvars.lua`](https://github.com/Stanzilla/AdvancedInterfaceOptions/blob/master/cvars.lua).

---

## How streamers actually flip these

| Path | What it controls |
|------|------------------|
| Esc → Interface → **Names** | Floating unit names (`UnitName*` family); enemy/friendly/NPC toggles ([CyberPost Names walkthrough](https://cyberpost.co/how-do-you-get-rid-of-floating-names-in-wow)) |
| Esc → Interface → **Nameplates** (+ V / Shift-V) | Plate visibility; many `nameplateShow*` CVars are **secure** (shield icon in wiki tables) |
| Esc → Interface → **Social** / chat options | Mature language (`profanityFilter`), spam filter (`spamFilter`), chat bubbles |
| Friends → **Ignore** | Suppresses chat **including guild** from listed characters ([Ignore](https://wowpedia.fandom.com/wiki/Ignore)) |
| `/console` / `SetCVar` / AdvancedInterfaceOptions | Power-user browse + diff from defaults |

Account vs character scope matters for streamer alts: e.g. `chatBubbles` and `profanityFilter` are **account**-scoped on the wiki list; many nameplate toggles are **character**-scoped ([Console variables — scope notes](https://wowpedia.fandom.com/wiki/Console_variables)).

---

## Names / world identity (not Beef UI)

These change what floats over heads in the 3D world. They do **not** rewrite Beef ladder frames or `SendChatMessage` payloads.

| CVar / family | Default (wiki) | Stream privacy effect | Beef note |
|---------------|----------------|----------------------|-----------|
| `UnitNameOwn` (+ related `UnitName*` toggles exposed in AIO) | varies | Hide own / friendly / enemy / NPC floating names | Ceremony screenshots look “cleaner”; ladder still shows names |
| `UnitNameGuildTitle` | listed in AIO secure set | Guild title over heads | Flavor only for Church titles if Blizzard titles shown |
| `nameplateShowFriends` | `0` | Friendly plates off by default | Reduces accidental doxx of nearby guildies on stream |
| `nameplateShowEnemies` | `1` | Enemy plates on | Open-world PvP stream snipers use enemy plates + names |
| `nameplateShowFriendlyNPCs` | `1` (7.1+) | Friendly NPC clutter | Common “why green bars everywhere” CVar ([Blizzard forum](https://us.forums.blizzard.com/en/wow/t/removing-friendly-trivial-npc-names/559440)) |
| `nameplateShowSelf` | `1` | Personal resource / self plate | Low privacy relevance |
| `nameplateShowAll` | `0` | Always-show plates | More names on screen when on |
| `nameplateShowOnlyNames` | `0` (Retail history; removed/changed in 10.0.5 — [forum](https://us.forums.blizzard.com/en/wow/t/why-was-nameplateshowonlynames-removed/1499143)) | Names-only plates | Do not rely on for Classic Anniversary |

Secure (`🛡`) nameplate CVars cannot be set in combat via normal addon paths ([Console variables](https://wowpedia.fandom.com/wiki/Console_variables)). Beef should never fight the player’s plate profile mid-raid.

---

## Chat / social filters

| CVar | Default | Scope | Effect on Beef spectacle |
|------|---------|-------|--------------------------|
| `profanityFilter` | `1` | Account | Mature-language filter on chat display ([Wowpedia list](https://wowpedia.fandom.com/wiki/Console_variables); [WoWI thread](https://wowinterface.com/forums/showthread.php?t=53263)) — can asterisk liturgy / comedy |
| `spamFilter` | (Social option; AIO maps `OPTION_TOOLTIP_SPAM_FILTER`) | — | Blizzard spam heuristics; usually spares guild/friends but not guaranteed for odd announce cadence |
| `chatBubbles` | `1` | Account | World bubbles show spoken text; guild announce is chat-frame, not bubble — low direct impact |
| `blockTrades` / `BlockTrades` | `0` | Character | Blocks trade spam while streaming open world ([CVar BlockTrades](https://warcraft.wiki.gg/wiki/CVar_BlockTrades)) — privacy-adjacent, not name privacy |

---

## Ignore (not a CVar, still client privacy)

| Mechanism | Limit | Affects guild announce? |
|-----------|-------|-------------------------|
| Blizzard Ignore list | **50** characters ([Ignore](https://wowpedia.fandom.com/wiki/Ignore); patch 3.3.0 raised cap) | **Yes** — ignored sender’s `/guild` lines are suppressed for that client |
| Addon expanders (GIL / IgnoreMore) | Soft-expand; not all behaviors equal ([Global Ignore List](https://www.curseforge.com/wow/addons/global-ignore-list)) | Often **exempt** party/guild by option — still a footgun if misconfigured |

---

## What CVars cannot do

| Desire | Reality |
|--------|---------|
| Hide streamer’s name from **other players** | Impossible via CVar — server still sends real identity |
| Redact names inside **addon frames** Beef draws | Must be Beef (or another addon) logic |
| One toggle “Streamer Mode” that Blizzard exposes to addons | Not found for Classic; use SV preset ([name-hiding-ecosystem.md](name-hiding-ecosystem.md)) |
| Make guild announce invisible to stream snipers watching Twitch | Only if the **captured** client redacts chat; snipers can still watch other guildies’ streams or join the guild |

---

## Steal for design docs

- Document a **recommended streamer CVar checklist** (Names off for self/friends; plates as preferred; mature filter off for ceremony night) as *player ops*, not as something Beef sets automatically.
- Never call `SetCVar` on secure nameplate keys from Beef without an explicit power-user panel — wrong product layer, combat lockdown risk.
