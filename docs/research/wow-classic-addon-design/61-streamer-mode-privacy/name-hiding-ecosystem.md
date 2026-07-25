# Name-hiding ecosystem (no first-party Streamer Mode API)

**Track:** [61-streamer-mode-privacy](README.md)  
**Last updated:** 2026-07-25  

## Verdict

WoW Classic / TBC Anniversary has **no confirmed Blizzard “Streamer Mode” that addons can register for**. Privacy is assembled from:

1. Client **Names / nameplate CVars** ([privacy-cvars-matrix.md](privacy-cvars-matrix.md))
2. Social **chat filters + ignore** ([chat-filters-and-spectacle.md](chat-filters-and-spectacle.md))
3. **Third-party** Lua addons that rewrite default UI strings client-side

Track 05 already warned against treating names like `RegisterForStreamerMode` as real Classic APIs ([anti-patterns note](../05-packaging-community-antipatterns/03-anti-patterns-and-complaints.md)). This track confirms: ship Beef’s own SV preset.

---

## What “streamer mode” addons actually do

### StreamerMode (D4KiR) — multi-flavor, actively maintained

[CurseForge — StreamerMode](https://www.curseforge.com/wow/addons/streamermode) (updated Jul 2026; Classic / BCC / MoP / Retail flavors):

| Feature | Coverage |
|---------|----------|
| Hide character name in | Chat, PlayerFrame, Target/Focus (+ ToT), Inspect, Character, Communities, GameTooltip, right-click menu, BG/Arena scoreboards |
| Hide BattleTag | Yes |
| Hide Chat button | Toggle chat visibility for stream |
| Commands | `/sm`, `/streamermode` |
| Stated goal | Make stream-sniping harder; works with **default UI** |

**Implication for Beef:** If a streamer runs StreamerMode, **local chat display** of a Beef guild announce may show a masked self-name while the **server-sent** line still contains the real character name for everyone else. Beef ladder frames are **custom UI** — StreamerMode does not automatically redact them unless it hooks those fonts (it targets Blizzard defaults).

### Streamer Mode (DnB_Junkee) — Classic Era–oriented obfuscator

[CurseForge — Streamer Mode](https://www.curseforge.com/wow/addons/streamer-mode) (Classic flavor; last notable file era ~1.15.0):

- Target / ToT names → **class names**
- Nameplate player names → **class names**
- Mouseover tooltips → **class names**
- Floating names → each letter replaced with **Ω**

Built for open-world PvP sniping (Hydra use case). Smaller install base than D4KiR’s addon; still the clearest Classic “obfuscate everyone” pattern.

### Historical pattern (ReName / StreamGuard)

Community tools historically rewrote Player/Target/Party/Raid frames, tooltips, guild roster, chat, scoreboards — and explicitly noted limits: **world names above heads** and **nameplates/bubbles** often still leak unless CVars/addons cover them ([OwnedCore ReName thread](https://www.ownedcore.com/forums/world-of-warcraft/world-of-warcraft-bots-programs/576599-rename-addon-streamers-video-creators-fake-hide-names-ui.html)). Treat as design history, not a V1 dependency.

---

## Layers of identity leakage (stream capture)

From outer world → Beef surfaces:

| Layer | Controlled by | Leaks character name on stream? |
|-------|---------------|----------------------------------|
| Floating unit names | Interface → Names / `UnitName*` | Yes, if enabled |
| Nameplates | `nameplateShow*` + Plater/BBP | Yes, unless obfuscated / names hidden |
| Blizzard unit frames / tooltips / chat | Default UI or StreamerMode-class addons | Yes without obfuscator |
| Guild chat (Beef announce) | `SendChatMessage` text + local chat filters | **Yes in payload**; local redact only affects capture |
| Beef ladder / toasts / My Standing | **Beef only** | Yes unless Beef ships a privacy preset |
| BeefNet / commits | GUID + server sender name | Not shown on stream unless UI prints them |

`UnitName("unit")` always returns the real unit name to Lua ([UnitName API](https://wowpedia.fandom.com/wiki/API_UnitName)) — obfuscation is **display rewriting**, not API anonymization.

---

## Nameplate addons vs privacy

Plater / BetterBlizzPlates are combat readability tools. BBP documents **name formatting** (hide realm, Arena ID, shorten NPC names) and CVar control panels ([BetterBlizzPlates](https://legacy.curseforge.com/wow/addons/betterblizzplates); [Wago](https://addons.wago.io/addons/betterblizzplates)). That is adjacent to privacy but not a Church-of-Beef concern beyond:

- Streamers often run dense plates → more name pixels in the capture (readability → track 17).
- Beef must **not** mount or fight nameplate engines (track 01 / 08).

---

## Product rule for Church of Beef

| Do | Don’t |
|----|-------|
| Offer a **Streamer / privacy preset** in Beef SV (mask ladder display names; quieter toasts; optional announce copy that prefers title over name for *local* preview if ever shown) | Claim integration with a Blizzard Streamer Mode API |
| Document coexistence: “If you use StreamerMode, open `/beef` once on stream to confirm ladder rows are masked” | Assume StreamerMode hooks Beef frames |
| Keep BeefNet keys as GUID / revision — never use display-mask as identity | Change commit identity when privacy mode toggles |
| Point officers at client Names + mature-filter checklist for ceremony nights | Auto-`SetCVar` secure nameplate keys from Beef |

See [beef-stream-privacy-implications.md](beef-stream-privacy-implications.md) for the V1/V2 recipe.
