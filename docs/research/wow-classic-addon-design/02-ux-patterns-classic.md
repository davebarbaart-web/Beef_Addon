# Dominant UX Patterns in Contemporary Classic Addons

**Last updated:** 2026-07-25  
**Sources:** TBC Anniversary addon roundups ([Overgear](https://overgear.com/guides/wow-classic/tbc-anniversary-top-addons/), [Warperia](https://warperia.com/tbc-addons/)), UI philosophy writeups (2026), Tukui/ElvUI, community “clean UI” discussions.

---

## 1. Mental model: information gravity

A recurring modern Classic/retail UI rule (community guides, 2026):

> Critical combat/self info sits **near the character** (center-lower). Chat, meters, minimap, and social tools go to **edges**.

Church of Beef is **social theater**, not combat assistance — so it should behave like chat/minimap/guild tools: edge-accessible, not center-screen combat HUD.

---

## 2. Patterns by surface

### Action bars

| Pattern | Exemplars | Classic-native feel |
|---------|-----------|---------------------|
| Movable multi-bar layouts | Bartender4, Dominos, ElvUI bars | Compact bars, optional art hide, keybind-centric |
| Numeric CDs on buttons | OmniCC | Numbers over Blizzard swipe — widely expected |
| Proc highlights | ClassicSpellActivations, WeakAuras | Glow/overlay near bars |

**Steal for Beef:** Nothing combat-bar related. Do steal **movable + clamped + saved position** conventions.

### Unit frames / raid frames

| Pattern | Exemplars | Notes |
|---------|-----------|-------|
| Full replacement | ElvUI UF, Cell, VuhDo, Grid2 | Flat bars, class colors, thin borders |
| Healer click-cast | Clique + raid frames | Mouseover casting |
| Blizzard Edit Mode | Built-in | Growing; 2026 Classic got more raid/nameplate options |

**Steal for Beef:** Class/guild-rank **color accents** sparingly; avoid looking like a heal frame. Ladder rows ≈ simple list/roster, not health bars.

### Nameplates

| Pattern | Exemplars |
|---------|-----------|
| Scriptable plates | Plater |
| Class-colored plates | Default CVars + Plater |

Irrelevant to Beef V1. Note only: default Classic plates are drifting modern (Jul 2026 Blizzard updates).

### Bags / inventory

| Pattern | Exemplars |
|---------|-----------|
| All-in-one bag | Bagnon, ElvUI bags |
| Gear sets | ItemRack Classic |

Irrelevant to V1.

### Minimap

| Pattern | Exemplars | Notes |
|---------|-----------|-------|
| Square / skinned minimap | ElvUI, Leatrix | Aesthetic |
| **Addon button on minimap** | LibDBIcon + Broker display | De facto standard for “open my addon” |
| Button collectors | MBB, MinimapButtonCollector | Players hate button sprawl |

**Steal for Beef:** LibDBIcon-style minimap button (or equivalent) that toggles `/beef`; respect collector addons; provide hide option later.

### WeakAuras-style overlays

Custom anchors, icon groups, text warnings for procs/boss cues. High skill ceiling; profile-import culture (Wago).

**Steal for Beef (later phases):** Toast/ceremony moments can learn from WA’s “brief centered spectacle then clear” — but V1 toasts should stay lightweight and non-combat.

### Chat

| Pattern | Exemplars |
|---------|-----------|
| Chat enhancement | Prat 3.0 |
| Copy/links/timestamps | Various |

**Steal for Beef:** Guild-chat promotion lines (already in spec) should be **one throttled plain-text line**, readable without the addon — same pattern as other “social broadcast” addons.

### Loot

Gargul (raid loot), AtlasLoot Classic (drop lookup). Coordination UIs with officer controls.

**Steal for Beef:** Officer queue UX (approve/reject lists) resembles loot council / attunement survey patterns (e.g. Attune’s guild survey) — clear pending list, actor, action buttons.

### Auction / economy

Auctionator, TradeSkillMaster, Auctioneer — dense tables, undercut workflows.

Not relevant except as anti-pattern: do not ship spreadsheet density for a comedy ladder.

### Quest helpers

Questie (map/minimap objectives), DialogueUI (modernized gossip), RestedXP (route overlay), Attune (progress trees + guild survey).

**Steal for Beef:** Attune’s **guild progress visibility** is the closest social-coordination cousin: shared status, survey when peers have the addon, graceful degradation when they don’t (matches BeefNet “players without addon must not soft-lock”).

---

## 3. Entry-point conventions

Successful Classic addons almost always offer:

1. **Slash command** (`/beef`) — primary, scriptable, streamer-friendly to say aloud  
2. **Minimap / compartment button** — discoverability for non-power users  
3. **Keybindable toggle** (optional) via Bindings.xml or settings  

Options live in:

- AceConfig dialog / Blizzard Interface Options add-on category, **or**
- In-window tabs (ElvUI-style) for complex UIs

Beef V1: slash + minimap + in-frame tabs (Ladder / My Standing / Officer) matches guild-tool norms better than a 200-option Ace tree.

---

## 4. “Start small” packaging of UX

Anniversary guides repeatedly advise: install a **small essential set**, then expand. Implications for Beef:

- First open should show **ladder + your standing** immediately.
- Officer tools hidden unless Officer+.
- Thin Gora/ceremony stubs must not dominate chrome.
- Deferred ceremonial dashboard belongs in V2+ (spec §3.2).

---

## 5. Social / guild addon niche (underserved)

Most “must have” Classic lists are combat, questing, economy, full UI replacements. **Guild culture / ceremony / theatrical rank** addons are rare. Closest patterns:

- Attune (guild readiness)
- Gargul (officer-led decisions)
- RP profile / directory addons (social identity — caution: logged addon messages for user content)

Church of Beef can own a niche: **guild spectacle layer** that sits beside, not on top of, combat HUD stacks.

---

## Sources

- [Overgear — TBC Anniversary Top Add-Ons](https://overgear.com/guides/wow-classic/tbc-anniversary-top-addons/)
- [Warperia — TBC Addons](https://warperia.com/tbc-addons/)
- [Medium — Best UI Setup 2026 (philosophy; retail-skewed)](https://medium.com/@debonikawow/best-ui-for-wow-complete-guide-for-a-perfect-interface-in-2026-7c03bc12dce7)
- [Tukui ElvUI](https://tukui.org/elvui)
