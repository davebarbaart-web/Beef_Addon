# Icon Framing Conventions (Classic)

**Last updated:** 2026-07-25  
**Primary sources:** [warcraft.wiki.gg ItemQuality](https://warcraft.wiki.gg/wiki/ItemQuality), [API TYPE ItemQuality](https://warcraft.wiki.gg/wiki/API_TYPE_ItemQuality), Masque Border region practice ([Masque](https://www.wowace.com/projects/masque)), community border discussions ([r/WowUI](https://www.reddit.com/r/WowUI/comments/zcpsvs/help_how_do_i_apply_default_actionbar_borders_to/), [WeakAuras border request](https://github.com/WeakAuras/WeakAuras2/issues/2243)).

---

## 1. The shared language: item quality colors

Players read icon importance through **quality colors**. Classic/TBC-relevant tiers ([ItemQuality](https://warcraft.wiki.gg/wiki/ItemQuality)):

| Quality | Familiar color | Classic-era use |
|---------|----------------|-----------------|
| Poor | Gray | Junk |
| Common | White | Baseline |
| Uncommon | Green | Solid upgrades |
| Rare | Blue | Notable |
| Epic | Purple | Best-in-slot tier feel |
| Legendary | Orange | Extreme prestige |

Later Artifact / Heirloom colors exist in the API taxonomy but are not the Classic TBC loot vernacular. Runtime tinting commonly uses `GetItemQualityColor` / `SetItemButtonQuality`-style APIs ([API TYPE ItemQuality](https://warcraft.wiki.gg/wiki/API_TYPE_ItemQuality)).

**Beef caution:** The seven church ranks (Fresh Beef → Beef Prophet) are a **social ladder**, not item rarities. Mapping ranks 1:1 onto Poor→Legendary trains the wrong metaphor (“my guild rank is an epic drop”). Prefer **brand accent colors / badges** for ranks; reserve quality-color language for actual items if shown.

---

## 2. Button anatomy players expect

Blizzard action/item buttons expose a familiar region set that Masque skins target ([Masque features](https://www.wowace.com/projects/masque); historical Default skin region lists):

| Region | Player meaning |
|--------|----------------|
| **Icon** | The subject |
| **Normal / Pushed / Disabled** | Chrome / press feedback |
| **Border** | Quality or emphasis frame (often vertex-colored) |
| **Cooldown** | Sweep / GCD |
| **Count / HotKey / Name** | Stack, bind, label |
| **Overlays** | Quest bang, lock, upgrade marks (sparse in Classic vs Retail) |

Classic TBC lacks many Retail “shine / corruption / upgrade sparkle” overlays. Community requests still ask for `Interface\Buttons\UI-ActionButton-Border`-style framing on non-action icons ([WeakAuras #2243](https://github.com/WeakAuras/WeakAuras2/issues/2243)).

Clean-icon packs (e.g. [Clean Icons — Mechagnome Edition](https://www.wowinterface.com/downloads/info25064-CleanIcons-MechagnomeEdition.html)) crop or restyle icon mats globally — another reason Beef should not assume default icon padding.

---

## 3. Framing strategies in Classic UI addons

| Strategy | Look | Used by |
|----------|------|---------|
| **Blizzard border texture + quality tint** | Nostalgia / inventory-like | Bags, loot, many Classic-native UIs |
| **Masque Border region** | User-chosen skin chrome | Bartender / Dominos / aura buttons that opt in |
| **1px backdrop border** | ElvUI / clean modern | Full UI replacements ([ElvUI glow/blank media](https://github.com/ElvUI-TBC/ElvUI/blob/master/ElvUI/media/sharedmedia.lua)) |
| **No border, cropped icon** | Dense HUD / WA | WeakAuras icon regions |

Panel borders (dialog / tooltip / wood) are separate from **icon** borders — LSM lists both ([predefined BORDER/BACKGROUND](https://www.wowace.com/projects/libsharedmedia-3-0/pages/api-documentation)). A ladder window can use dialog-style panel chrome while rank icons use a simpler square frame.

---

## 4. Iconography guidance for Church of Beef

| Surface | Framing advice |
|---------|----------------|
| **Rank glyphs / title icons** | Stable square icons with a **brand frame** (Scarlet/cathedral), not item-quality rainbows |
| **Local player highlight** | Distinct row treatment (glow/backdrop), not epic purple border spam |
| **Officer actions** | Prefer labeled buttons over icon-only combat chrome |
| **Toasts** | Large readable title + one icon; high contrast for stream (spec §1, §10) |
| **Minimap button** | LibDBIcon path (see [04-ace3](../04-ace3-and-libraries.md)); unique art, not a generic cog |

V1 can ship with **text titles only** and zero custom icons. Iconography becomes valuable in the post-V1 art pass when brand must survive “remove the nav and still know it’s Beef” (brand test from project design rules).

---

## 5. Sources

- [ItemQuality — warcraft.wiki.gg](https://warcraft.wiki.gg/wiki/ItemQuality)
- [API TYPE ItemQuality](https://warcraft.wiki.gg/wiki/API_TYPE_ItemQuality)
- [Masque — WowAce](https://www.wowace.com/projects/masque)
- [LibSharedMedia predefined borders](https://www.wowace.com/projects/libsharedmedia-3-0/pages/api-documentation)
- [WeakAuras action-button border discussion](https://github.com/WeakAuras/WeakAuras2/issues/2243)
- [Clean Icons — WoWInterface](https://www.wowinterface.com/downloads/info25064-CleanIcons-MechagnomeEdition.html)
- [r/WowUI Masque Blizzard bars](https://www.reddit.com/r/WowUI/comments/zcpsvs/help_how_do_i_apply_default_actionbar_borders_to/)
