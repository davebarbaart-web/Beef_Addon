# Chat

**Surface:** Chat frames, formatting, social text broadcasts  
**Flavors:** All Classic; addon whisper/channel rules differ from retail historically

---

## Dominant patterns

| Pattern | Exemplars | Notes |
|---------|-----------|-------|
| Chat enhancement | [Prat 3.0](https://www.curseforge.com/wow/addons/prat-3-0) | Timestamps, class colors, fonts, copy |
| Edge placement | ElvUI chat, default movers | Chat stays peripheral during combat |
| Plain guild/raid announces | Boss mods, loot addons, guild tools | Text readable **without** the addon |
| Throttle / single-sender | Community norm | Avoid announce storms from every client |

Prat is the usual “interface” chat pick in Anniversary lists ([Overgear](https://overgear.com/guides/wow-classic/tbc-anniversary-top-addons/)).

---

## Version notes

| Flavor | Notes |
|--------|-------|
| **Classic vs Retail** | Addon message `CHANNEL` disabled on Classic; `SAY`/`YELL` addon messages exist on Classic with heavy throttle ([C_ChatInfo.SendAddonMessage` wiki](https://warcraft.wiki.gg/wiki/API_C_ChatInfo.SendAddonMessage)). BeefNet uses `GUILD` — correct choice. |
| **All Classic** | Players without a given addon still see normal chat; social features must degrade gracefully |

---

## Relevance to Church of Beef

- Spec already matches best practice: **one throttled guild-chat line** on promote/demote from the approving officer only, with opt-out ([design spec §10](../../../superpowers/specs/2026-07-25-church-of-beef-design.md)).
- Keep wording plain and stream-readable; avoid color spam / addon escape codes that break copy-paste.
- Do not put ladder state exclusively in chat — chat is the spectacle ping, the frame is the system of record.

## Sources

- [Prat 3.0 — CurseForge](https://www.curseforge.com/wow/addons/prat-3-0)
- [Overgear — TBC Anniversary Top Add-Ons](https://overgear.com/guides/wow-classic/tbc-anniversary-top-addons/)
- [C_ChatInfo.SendAddonMessage — Warcraft Wiki](https://warcraft.wiki.gg/wiki/API_C_ChatInfo.SendAddonMessage)
- Design spec §10
