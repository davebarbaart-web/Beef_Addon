# Church of Beef brand tokens

**Last updated:** 2026-07-25  
**Purpose:** Propose a Classic-native, Scarlet-gothic, colorblind-aware brand palette and token naming for V1→V2.  
**Status:** Design research — hex values are proposals; lock after Anniversary screenshot pass.  
**Brand source:** Spec §3.3 — comedic holy institution; gothic cathedral / Scarlet Crusade imagery; steaks / cows / pageantry; not generic UI art ([design spec](../../../superpowers/specs/2026-07-25-church-of-beef-design.md)).

---

## 1. Brand axes (what color must say)

| Axis | Feeling | Avoid |
|------|---------|-------|
| Sacred absurd | Cathedral light, tabard zeal, holy heat | Generic purple-glow “AI fantasy UI” |
| Classic-native | Warm metals, parchment, deep panels | Flat neon ElvUI dashboard |
| Comedy institution | Readable, slightly over-earnest heraldry | Horror gore red / edgy black-only |
| Dual-realm | Same church on Alliance + Horde | Stormwind-blue OR Orgrimmar-red as the whole skin |

Gothic stained-glass tradition leans **ruby red + deep blue + gold light** as sacred language ([Wikipedia — French Gothic stained glass](https://en.wikipedia.org/wiki/French_Gothic_stained_glass_windows); cathedral light/color notes in [Gallerix Gothic stained glass overview](https://gallerix.org/pnews/202506/goticheskoe-vitrazhnoe-iskusstvo-svet-i-cvet-v-soborax)). Scarlet Crusade fantasy in-game is tabard crimson / monastery white-gold pageantry ([Wowpedia — Scarlet Monastery](https://wowpedia.fandom.com/wiki/Scarlet_Monastery)). Beef twists that toward **holy steak** without leaving Classic readability.

---

## 2. Core brand palette (proposed)

Use **token names** in code/docs; hex is the default light. Provide a dark-panel pair for overlays.

### 2.1 Foundations

| Token | Hex | Role |
|-------|-----|------|
| `cob.brand.scarlet` | `#9B1B2E` | Primary brand — tabard crimson (deeper than Hostile `(1,0,0)` and distinct from DK `#C41E3A`) |
| `cob.brand.scarlet.bright` | `#C42B3F` | Hover / toast accent / selected tab underline |
| `cob.brand.gold` | `#D4AF37` | Holy trim, titles, Prophet gleam (not Legendary orange `#FF8000`) |
| `cob.brand.gold.dim` | `#A88B2E` | Inactive gold, borders on dark panels |
| `cob.brand.parchment` | `#E8DCC4` | Primary text on dark panels; light fills |
| `cob.brand.ink` | `#1A1410` | Near-black brown — panel fill / text on parchment |
| `cob.brand.iron` | `#2C2420` | Secondary panel / toast scrim |
| `cob.brand.ash` | `#6E6258` | Muted labels, disabled |
| `cob.brand.cream` | `#F5F0E6` | Large title text on iron/scarlet |

### 2.2 Flavor accents (use sparingly)

| Token | Hex | Role |
|-------|-----|------|
| `cob.flavor.beef` | `#6B3A2A` | Umber “steak” — progress fills, secondary charts |
| `cob.flavor.suet` | `#C4A574` | Warm tan — warrior-adjacent but brand-owned |
| `cob.flavor.holyglow` | `#F0E6A8` | Soft highlight behind Prophet / ceremony toast (low saturation) |
| `cob.flavor.stained.blue` | `#1F3A5F` | Optional gothic cold accent — **not** Alliance chip; use for decorative dividers only |

### 2.3 Why these vs collisions

| Collision risk | Mitigation |
|----------------|------------|
| Hostile red nameplates | Scarlet is darker/brown-crimson; demotion uses semantic rose + text |
| DK / blood red | TBC has no DK; still keep brand off `#C41E3A` |
| Legendary orange | Brand gold is yellow-metal, not `#FF8000` |
| Paladin pink “holy” | Reject pink as brand; gold + parchment carry holy |
| Epic purple UI | Avoid purple as primary Church color (reads loot/epic, not Scarlet) |
| Alliance blue UI | Faction chip only; panels stay iron/parchment/scarlet |

---

## 3. Semantic tokens (state, not paint)

Map UI meaning → color + **required dual encode** (icon/word). Color alone is forbidden for state ([Datawrapper — colorblind viz](https://www.datawrapper.de/blog/colorblindness-part2); Blizzard UI Colorblind Mode text labels).

| Token | Default hex | Dual encode | Used for |
|-------|-------------|-------------|----------|
| `cob.state.pending` | `#E0B85A` (amber) | Hourglass / “Pending” | Officer queue awaiting approve |
| `cob.state.approved` | `#3D8B6E` (teal-green) | Check / “Recognized” | Rank commit success toast |
| `cob.state.rejected` | `#8A4F5C` (dusty rose) | X / “Rejected” | Officer reject |
| `cob.state.demoted` | `#7A3038` (deep rose) | Broken seal / “Excommunicated” | Demotion announce |
| `cob.state.info` | `#C4B59A` | “i” / neutral | Soft tips, scripture footer |
| `cob.state.localYou` | `cob.brand.gold` underline | “You” label | Ladder self highlight |
| `cob.state.officer` | `cob.brand.scarlet.bright` pip | Shield / “Officer” | Officer tab affordance |

**Approved green is teal, not Uncommon `#1EFF00`.** Neon loot-green fights brand and is brutal for deuteranopia next to scarlet. Teal + checkmark stays readable when red/green cones are weak ([Visme — color blind friendly palettes](https://visme.co/blog/color-blind-friendly-palette); IBM-safe categorical set includes blue/orange/magenta rather than pure R/G — [IBM color-blind safe palette listing](https://www.color-hex.com/color-palette/1044488)).

---

## 4. Rank ladder color progression (proposed)

Ranks are social hierarchy, not classes. Use a **warm ascent** from ash → beef → gold → scarlet highlight at the top — not quality-color rainbow for all seven rows.

| Rank | Title | Token hint | Hex |
|------|-------|------------|-----|
| 1 | Fresh Beef | `cob.rank.1` | `#8A8076` ash |
| 2 | Cooked Beef | `cob.rank.2` | `#6B3A2A` beef |
| 3 | Beef Knight | `cob.rank.3` | `#A88B2E` dim gold |
| 4 | Beef Lord | `cob.rank.4` | `#D4AF37` gold |
| 5 | Beef Butcher | `cob.rank.5` | `#C42B3F` bright scarlet |
| 6 | Beef Council | `cob.rank.6` | `#9B1B2E` scarlet + gold pip |
| 7 | Beef Prophet | `cob.rank.7` | `#F0E6A8` holyglow text on iron + gold border |

**Rules:**

- Occupant **names** may still take class color chips.
- Rank **title** uses `cob.rank.N`.
- Council/Prophet scarcity (spec §4.1) = gold pip / unique border, not epic purple spam.
- Optional ceremony toast may flash quality Rare/Epic/Legendary **once** as parody loot — then return to brand tokens.

---

## 5. Token layers (how to organize in addon later)

Conceptual only (no code in this track):

```
cob.brand.*     → identity paint (scarlet, gold, parchment, iron)
cob.flavor.*    → rare garnish (beef umber, holyglow)
cob.state.*     → pending/approved/rejected/demoted/info
cob.rank.1..7   → ladder title colors
cob.sys.*       → aliases to Blizzard runtime (class, quality, faction)
cob.overlay.*   → scrim, toast fill, outline for stream readability
```

V1 may implement only `brand` + `state` + `rank` as a flat table; `sys` remains “call the API.”

---

## 6. Colorblind-safe brand rules

Okabe–Ito / blue–orange thinking: prefer **blue vs orange** pairs for categorical contrast; vary **lightness**; never rely on red vs green alone ([Datawrapper](https://www.datawrapper.de/blog/colorblindness-part2)).

Applied to Beef:

1. **Scarlet + gold + parchment** already spans dark/mid/light — good.
2. **Pending amber** vs **approved teal** vs **rejected dusty rose** differ in lightness and hue; still require icons.
3. Do not put Uncommon green next to brand scarlet as the only approve/reject cue.
4. Prophet holyglow is light-on-dark; verify ≥4.5:1 on `cob.brand.iron` ([MDN contrast](https://developer.mozilla.org/en-US/docs/Web/Accessibility/Guides/Understanding_WCAG/Perceivable/Color_contrast)).
5. Optional: document a “high contrast” preset that pushes parchment to `#FFF8EC` and iron to `#0E0B09` for streamers — still brand-shaped, not ElvUI neon.

### Quick CVD simulation checklist (manual)

When locking hex, screenshot `/beef` and toast under Blizzard colorblind filters (protanopia / deuteranopia / tritanopia + strength slider) if the Anniversary client exposes them ([Blizzard Watch — 6.1 colorblind UI](https://blizzardwatch.com/2015/02/17/patch-6-1-adds-new-colorblind-support-ui); [Blizzard blog](http://worldofwarcraft.blizzard.com/en-us/news/17964863/new-colorblind-support-in-patch-61)). Confirm: pending ≠ approved ≠ demoted without reading hue.

---

## 7. Classic-native feel (color only)

Track 02 owns borders/fonts/chrome. Color contribution to “feels Classic”:

| Classic-native | Retail-modern trap |
|----------------|--------------------|
| Warm parchment + deep brown iron | Cool gray `#1E1E1E` + cyan accents |
| Scarlet/gold heraldry | Purple→indigo gradient brand |
| Sparse Legendary-orange jokes | Permanent neon class rainbow |
| Muted ash labels | High-saturation chips everywhere |

Spec V1: plain frames. These tokens still apply to **FontString colors** and toast fills before any texture pack.

---

## 8. Faction coexistence

| Guild | Realm | Brand panels | Optional chip |
|-------|-------|--------------|---------------|
| Church (Alliance) | Dreamscythe | Scarlet / gold / iron | `GetFactionColor("Alliance")` |
| Church (Horde) | Doomhowl | **Same** brand tokens | `GetFactionColor("Horde")` |

No “Horde Church skin” that swaps scarlet for forest green — that splits the meme. Rivalry lives in Gora / chat, not in forking the brand.
