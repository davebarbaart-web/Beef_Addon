# Classic-Native vs Retail-Modern — Visual Axes

**Last updated:** 2026-07-25  
**Scope:** How Classic communities judge “feels right” vs “looks like retail.”

---

## 1. Two poles (not one spectrum of “quality”)

| Pole | Feel | Typical stack |
|------|------|----------------|
| **Classic-native / nostalgia** | Stone/gold Blizzard dialog chrome, parchment, thicker art, Friz Quadrata–adjacent type, low motion | Default UI + Questie + DBM/BigWigs + thin helpers; AtlasLoot/Auctionator as tool windows |
| **Clean modern Classic** | Flat panels, 1px black borders, statusbar textures, condensed/pixel fonts, square minimap, skinned Blizzard art | ElvUI (+ plugins), Plater profiles, WeakAuras HUD packs, Details! skins, Cell/VuhDo grids |

Neither pole is “wrong.” Church of Beef **brand** (gothic cathedral / Scarlet / absurd holy steak — design spec §3.3) leans theatrical **Classic-native chrome**. Church of Beef **V1** (spec §10) ships **plain Classic frames**; dark-iron / cathedral theatrical chrome is a later pass.

**Important correction to common shorthand:** ElvUI on Classic is *not* nostalgia-native. Tukui screenshots show flat dark panels and unified hairline chrome ([ElvUI on Tukui](https://tukui.org/elvui)). It is the flagship of the **clean modern Classic** pole, running *on* Classic clients.

---

## 2. Five visual axes

### 2.1 Borders and frame chrome

| Classic-native | Retail-modern / clean Classic |
|----------------|-------------------------------|
| Blizzard dialog edges, stone/metal trim, corner art | 1px black or grey outline; “thin border” modes; optional soft shadow |
| Sharp 90° corners | Rounded corners (2–6px) common on retail skins |
| Opaque panel fills | Glass / low-alpha fills more acceptable on retail |

**Steal for Beef:** hard corners, high opacity, readable silhouette against world content. Double-bevel or dialog-style edge reads “institution,” not “SaaS card.”

### 2.2 Typography

| Classic-native | Clean modern / retail |
|----------------|------------------------|
| Friz Quadrata–family headers; default UI body | Expressway / pixel / condensed sans via LibSharedMedia |
| Dense, slightly cramped labels | Larger line-height, more padding |

**Steal for Beef V1:** default fonts only (spec: missing media must fall back).  
**Later:** one display face for rank titles / “Church” wordmark; never require LSM for core load.

### 2.3 Color and contrast

| Classic-native | Clean modern / retail |
|----------------|------------------------|
| Brown/gold/parchment UI; faction accents; class color used sparingly | Class colors everywhere; neon threat/cast tints; flat greys |
| Item-quality colors as sacred grammar (AtlasLoot, AH tooltips) | Same grammar survives — do not invent neon alternatives |

**Steal for Beef:** item-quality grammar for nothing combat-related; for ranks, use a **short heraldic ladder** (bone → gold → scarlet escalation), not class-color spam. Spec brand palette cues: scarlet / bone / candle-gold / ash-stone (see Scarlet references in [04-annotated-references.md](04-annotated-references.md)).

### 2.4 Opacity and depth

| Classic-native | Retail-modern |
|----------------|---------------|
| Near-opaque panels; little blur | Translucent panels, blur, vignettes |
| Tooltips as solid cards | “Floating glass” tooltips |

**Steal for Beef:** no glass, no blur. Stream readability (spec §1 streamer-event adjacency) hates grey-on-grey translucency.

### 2.5 Icons, motion, and density

| Classic-native | Clean modern / retail HUD |
|----------------|---------------------------|
| Square icons, hard 1px borders, little gloss | Rounded icon masks, gloss, drop shadows |
| Rare motion (quest bangs, toasts) | Constant WeakAuras pulses, Plater animations |
| Tool windows (AtlasLoot, Auctionator): dense but framed | Screen-as-dashboard: meters + plates + WA packs |

**Steal for Beef:** hard-edged icons; **one** toast at a time; ladder density like a short roster, not a Details! window.

---

## 3. Blizzard’s own Classic drift (2026)

Blizzard has been modernizing Classic Era / TBC Anniversary UI pieces that share retail code (nameplates, raid frames, Edit Mode options). Coverage: [Blizzard Watch — Jul 22, 2026](https://blizzardwatch.com/2026/07/22/blizzard-modernized-parts-wow-classic-era-tbc-classic-anniversary-realms-user-interface/).

**Implication for Beef:** players already argue about “Classic look.” Do not depend on retail Edit Mode APIs for core UX. Do not chase Midnight-style plate aesthetics. Coexist with whatever Blizzard ships; own a **distinct guild window**, not a global skin.

---

## 4. Stream / spectacle readability

From clean-UI culture (useful even when rejecting its aesthetics):

- High-contrast text for Twitch ~720p
- Rank/title type large enough to read on stream overlays
- Prefer **one** center-weighted toast over stacked combat-style alerts
- Guild-chat promotion line remains the cheapest spectacle (spec §10)

---

## Sources

- [ElvUI — Tukui](https://tukui.org/elvui) (ClassicTheme screenshots; Anniversary installer layout notes in changelog)
- [Blizzard Watch — Classic UI modernization](https://blizzardwatch.com/2026/07/22/blizzard-modernized-parts-wow-classic-era-tbc-classic-anniversary-realms-user-interface/)
- [Overgear — TBC Anniversary top addons](https://overgear.com/guides/wow-classic/tbc-anniversary-top-addons/)
- Design spec §3.3 brand, §10 V1 UI
