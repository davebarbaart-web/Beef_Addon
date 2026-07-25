# Button collector addons (Classic / Anniversary)

**Last updated:** 2026-07-25  
**Role:** Player-side tools that collapse many addon minimap icons into one control. Authors do not depend on them; authors **design so they work**.

---

## Why collectors matter for Beef

Minimap button sprawl is a long-standing Classic complaint ([Blizzard Classic forums](https://us.forums.blizzard.com/en/wow/t/minimap-cluttered-addon-help/304044), [r/classicwow](https://www.reddit.com/r/classicwow/comments/ffa99x/any_idea_of_an_addon_i_can_use_to_sort_out_the/)). Guild/utility addons that always plant an icon get collected or disabled. Beef must remain reachable via `/beef` when collected or hidden.

---

## Active / recommended collectors (2026)

| Addon | Classic / TBC Anniv | Role | Notes |
|-------|---------------------|------|-------|
| **[HidingBar](https://www.curseforge.com/wow/addons/hidingbar)** | Classic + Classic TBC flavors; Jul 2026 releases | Primary modern collector | Grabs **DataBroker** buttons and minimap buttons; MBB-like mode; ElvUI/Tukui + Masque notes; `/hidingbar`. Explicitly named as MBB’s successor on MBB project pages. |
| **[MinimapButtonButton](https://www.curseforge.com/wow/addons/minimapbuttonbutton)** | Classic + Classic TBC (+ Retail, MoP, Titan Reforged) | Single-button collector | High download history (“a single button that collects your minimap buttons”); still shipping Jul 2026 across Classic flavors. |
| **[MinimapButtonCollector](https://addons.wago.io/addons/minimapbuttoncollector)** | **TBC Classic Anniversary** (Interface `20505`) | Anniv-specific niche | Wago/GitHub project: one trigger fans buttons onto the minimap. Low downloads; validates Anniv demand for collectors. |
| **[MBB - Classic](https://www.curseforge.com/wow/addons/mbb-classic)** | Classic + Classic TBC listed | Legacy | Last meaningful Curse activity ~2021; page points authors/users to **HidingBar**. Still in old guides ([Arcane Intellect MBB spotlight](https://arcaneintellect.com/minimap-button-bag-mbb-world-of-warcraft-wow-addon-spotlight)). |
| **MBB (retail project)** | Retail-oriented | Legacy | Same “use HidingBar” banner ([CurseForge MBB](https://www.curseforge.com/wow/addons/mbb)). |

Historical / discontinued names players still search: MiniMap Button Bag, Minimap Button Frame (MBF). Treat as genealogy, not recommendations.

---

## How collectors behave (author implications)

Pattern shared across MBB-family tools ([Arcane Intellect](https://arcaneintellect.com/minimap-button-bag-mbb-world-of-warcraft-wow-addon-spotlight), [HidingBar description](https://www.curseforge.com/wow/addons/hidingbar)):

1. Scan for addon minimap buttons (and often LDB icons).
2. Reparent / hide them under one trigger or bar.
3. Expand on click (or hover for slidebar-style).
4. Offer ignore/exclude lists and detach hotkeys (MBB: Ctrl+Right-click).

**Author duties:**

- Use a **standard LibDBIcon** button (or a well-named, parented minimap button collectors already know how to find).
- Do not fight reparenting with aggressive `SetParent(Minimap)` every frame.
- Keep **slash** and optionally an LDB object so “collected but not broken” is true.
- Ship **hide icon** so clean-UI players never need a collector for Beef alone.

HidingBar’s dual support (DataBroker **and** minimap grab) is why shipping LDB+LibDBIcon is strictly better than a bare `CreateFrame` on the minimap.

---

## LDB display bars (related, not collectors)

These are not bag-style collectors; they **host** LDB objects on a bar and often reduce minimap need:

| Display | Classic flavors (observed) | Steal for Beef |
|---------|----------------------------|----------------|
| [Bazooka](https://www.curseforge.com/wow/addons/bazooka) | Classic + Classic TBC | LDB launcher appears in bar |
| Arcana (ex-ChocolateBar) | Listed on WowAce Data Broker/Titan plugin indexes | Same |
| Titan Panel | Long Classic history / built-ins for Era | Same |

If Beef registers a proper LDB launcher, these users may hide the LibDBIcon entirely and still launch from the bar.

---

## Anniversary-specific note

Separate client trees mean separate SavedVariables and collector layouts ([01 minimap.md](../01-ux-patterns/minimap.md) Anniv note). Collector choice on Anniv tracks **Classic TBC** Curse flavors (HidingBar / MinimapButtonButton) plus Anniv-tagged tools like MinimapButtonCollector — not Retail-only bags.

---

## Sources

- [HidingBar — CurseForge](https://www.curseforge.com/wow/addons/hidingbar)
- [MinimapButtonButton — CurseForge](https://www.curseforge.com/wow/addons/minimapbuttonbutton)
- [MBB - Classic — CurseForge](https://www.curseforge.com/wow/addons/mbb-classic)
- [MBBClassic README (HidingBar successor) — GitHub](https://github.com/vallantv/MBBClassic)
- [MinimapButtonCollector — Wago](https://addons.wago.io/addons/minimapbuttoncollector)
- [Minimap Button Bag spotlight — Arcane Intellect](https://arcaneintellect.com/minimap-button-bag-mbb-world-of-warcraft-wow-addon-spotlight)
- [Bazooka — CurseForge](https://www.curseforge.com/wow/addons/bazooka)
