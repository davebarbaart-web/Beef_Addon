# Addon Roster — Visual DNA

**Last updated:** 2026-07-25  
**Clients:** Classic Era / TBC Classic Anniversary (primary for Beef V1). Retail notes only for contrast.

---

## At a glance

| Addon | Role | Default visual feel | Pole |
|-------|------|---------------------|------|
| **ElvUI** | Full UI replacement | Flat dark panels, hairline borders, unified fonts/statusbars; profile ecosystem | Clean modern Classic |
| **Bartender4** | Action bar suite | Blizzard button art unless Masque; layout/fade/alpha control | Either (chrome inherited) |
| **Dominos** | Action bar suite | Movable bar parts; Masque per-bar; opacity/combat show | Either (chrome inherited) |
| **Plater** | Nameplates + scripts | Slim bars, class/threat color, debuff icons; profile-driven | Clean modern (usually) |
| **WeakAuras** | Custom overlays | Utilitarian defaults; community packs = retail HUD energy | Author-defined / often modern |
| **Details!** | Combat meter | Dense dark tables, color rows, multi-window | Utilitarian modern |
| **Questie** | Quest helper + map pins | Classic fantasy pins/tooltips; sidebar tracker | Classic-native readability |
| **AtlasLoot Classic** | Loot browser | Tabbed tool window, item-quality grid | Classic tool-window |
| **Auctionator** | AH helper | Tabbed lists, shopping/selling panes, quality chips | Classic tool-window |
| **Cell / VuhDo** (similar) | Raid/party frames | Compact grids, debuff icons | Clean modern combat |
| **DialogueUI / Leatrix** (similar) | QoL chrome | DialogueUI leans storybook; Leatrix often “less is more” | Mixed |

Community “must install” lists for TBC Anniversary consistently group ElvUI + Bartender/Dominos as interface, Plater + Details + WA as combat HUD, Questie / AtlasLoot / Auctionator as world/economy tools — e.g. [Overgear TBC Anniversary guide](https://overgear.com/guides/wow-classic/tbc-anniversary-top-addons/).

---

## ElvUI (Tukui)

- **Sources:** [tukui.org/elvui](https://tukui.org/elvui), [github.com/tukui-org/ElvUI](https://github.com/tukui-org/ElvUI)
- **What it is:** Full restyle — unit frames, bars, bags, chat, nameplates, datatexts — one settings language.
- **Visual DNA:** Dark flat fills; thin/thick border modes; plugin looks (BenikUI, Merathilis, Luckyone) shown on Tukui; **ClassicTheme** tank/healer screenshots; changelog notes **Anniversary layout** in installer and Classic Anniversary dual-spec / role-icon work.
- **Love / hate:** One importable style; “everything looks like ElvUI”; setup overwhelm.
- **Beef relevance:** Many guildies will run it. Coexist — unique frame name, saved position, minimap-button-collector friendly. Do **not** try to match ElvUI’s flat grey as brand identity; Beef wants institution pageantry later, not another Toxi profile.

## Bartender4

- **Source:** [CurseForge — Bartender4](https://www.curseforge.com/wow/addons/bartender4)
- **What it is:** Full action-bar replacement; scale/alpha/fade; macro condition show/hide; optional hide of Blizzard artwork; **Masque** support.
- **Visual DNA:** Feels Classic when default button art remains; feels modern when borderless icon strips + Masque skins.
- **Beef relevance:** Combat-bar patterns are out of scope. Steal only the idea of **opacity/fade for non-critical chrome** (later) — never for the ladder’s primary text.

## Dominos

- **Source:** [CurseForge — Dominos](https://www.curseforge.com/wow/addons/dominos) (Tuller / tullamods; *not* a Bartender predecessor named “Domino”)
- **What it is:** Main-bar replacement as movable parts; spacing, vertical bars, opacity, combat-only visibility; Masque per bar; LibKeyBound.
- **Visual DNA:** Same chrome-inheritance story as Bartender; gallery culture often pairs with ButtonFacade/Masque for “pretty buttons.”
- **Beef relevance:** Same as Bartender — layout philosophy only. Config-mode drag is familiar UX for “move my `/beef` window.”

## Plater Nameplates

- **Source:** [CurseForge — Plater](https://www.curseforge.com/wow/addons/plater-nameplates)
- **Tagline:** Highly customizable nameplates with scripts and animations.
- **Visual DNA:** Information-dense plates; out-of-combat size reduction; script/animation culture parallel to WeakAuras; shared profiles.
- **Beef relevance:** **Reject** nameplate density for social UI. **Steal** only: short-lived scripted spotlight for rank-up theater (V2+), then clear the screen.

## WeakAuras

- **Sources:** [CurseForge — WeakAuras 2](https://www.curseforge.com/wow/addons/weakauras-2), [wago.io/weakauras](https://wago.io/weakauras), [GitHub](https://github.com/WeakAuras/WeakAuras2)
- **What it is:** Authorable graphics (icons, bars, text, models) + import culture.
- **Visual DNA:** Defaults utilitarian; popular packs create constant center-screen motion — the “retail raid HUD” feel even on Classic.
- **Beef relevance:** Do not become a WA pack. **Steal:** one-shot ceremony toast choreography (enter → hold → fade). Prefer guild-chat announcement for V1 spectacle (spec §10).

## Details! Damage Meter

- **Source:** [CurseForge — Details!](https://www.curseforge.com/wow/addons/details)
- **Tagline:** Complete combat analysis (damage, healing, etc.).
- **Visual DNA:** Dense tables, dark rows, bookmarks, multi-window; skinable but fundamentally a **meter**.
- **Beef relevance:** Officer standing breakdown = **simple event list**, not a DPS meter. Never fake health bars for “standing.”

## Questie

- **Source:** [CurseForge — Questie](https://www.curseforge.com/wow/addons/questie) (“The Classic Quest Helper”)
- **Visual DNA:** Map/minimap pins, tooltips, journey/history UI, config window — fantasy readability over flat SaaS.
- **Beef relevance:** Clarity of icons/pins > ornament for functional UI. Map overlays for “holy sites” are out of V1; pin clarity is the lesson.

## AtlasLoot Classic

- **Source:** [CurseForge — AtlasLootClassic](https://www.curseforge.com/wow/addons/atlaslootclassic)
- **Visual DNA:** Instance/boss tabs, item-quality-colored rows/buttons, favourites, minimap entry — encyclopedic **tool window**.
- **Beef relevance:** Ladder + officer queue ≈ lightweight tabbed tool window. Rank rows can borrow “item card” scanning (icon + colored name + short meta), not loot-spreadsheet density.

## Auctionator

- **Source:** [CurseForge — Auctionator](https://www.curseforge.com/wow/addons/auctionator)
- **Visual DNA:** Shopping / selling / cancelling tabs; Classic screenshots show Blizzard-adjacent AH chrome with denser lists and quality-aware tooltips.
- **Beef relevance:** Tab + list + action buttons pattern for Officer approve/reject. Avoid spreadsheet column overload on My Standing.

## Similar companions (brief)

| Addon | Visual note | Beef take |
|-------|-------------|-----------|
| **Cell / VuhDo** | Compact healer grids | Do not make ladder look like raid frames |
| **DialogueUI** | Immersive dialogue presentation | Tone reference for ceremony copy later; not V1 chrome |
| **Leatrix Plus / Maps** | QoL, often reduces clutter | “Less chrome in the world, more clarity” |
| **Masque** | Button skin engine used by bars | Optional later for any icon buttons; never a V1 dependency |
| **DBM / BigWigs** | Timers/alerts, not full skins | Toast timing discipline: short, loud, gone |

---

## Pattern across the roster

Successful Classic addons either:

1. **Inherit Blizzard chrome** and add data (Questie, AtlasLoot, Auctionator, bar movers), or  
2. **Replace chrome with a unified flat system** (ElvUI, many Plater/WA packs).

Church of Beef should do **(1) in V1**, then a **branded variant of (1)** later — not (2). Absurd religion needs heraldry, not another grey panel skin.
