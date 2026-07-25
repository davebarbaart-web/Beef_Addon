# WoW system colors (Classic-relevant)

**Last updated:** 2026-07-25  
**Purpose:** Document player-learned Blizzard color grammar so Church of Beef can borrow it without inventing conflicting hues.  
**Not covered here:** Brand scarlet palette (see [church-of-beef-brand-tokens.md](church-of-beef-brand-tokens.md)); chrome/borders (track 02).

---

## 1. Principle: runtime over hardcoded hex

Wiki tables round and drift across patches. Prefer client APIs / FrameXML globals when painting UI:

| Need | Prefer |
|------|--------|
| Class tint | `GetClassColor(englishClass)` → `r, g, b, colorStr` ([Warcraft Wiki — GetClassColor](https://warcraft.wiki.gg/wiki/API_GetClassColor)); table `RAID_CLASS_COLORS` |
| Item quality | `GetItemQualityColor(quality)` ([Wowpedia archive — GetItemQualityColor](https://wowwiki-archive.fandom.com/wiki/API_GetItemQualityColor)) |
| Faction brand chip | `GetFactionColor(factionGroupTag)` → uses `PLAYER_FACTION_COLORS` ([FrameXML ColorUtil.lua excerpt](https://github.com/Nevcairiel/wow-ui-source-1/blob/live/SharedXML/ColorUtil.lua)) |
| Unit reaction (hostile/friendly) | `UnitSelectionColor(unit)` / historical `UnitReactionColor` table ([WoWInterface reaction thread](https://www.wowinterface.com/forums/showthread.php?t=18459)) |

Hardcoded hex below is for **design docs, mockups, and contrast math** — not a substitute for runtime lookup on Anniversary.

---

## 2. Class colors (TBC Anniversary set)

Canonical modern wiki table ([Warcraft Wiki — Class colors](https://warcraft.wiki.gg/wiki/Class_colors)):

| Class | Hex (wiki “fixed”) | Notes for Beef |
|-------|--------------------|----------------|
| Warrior | `#C69B6D` | Tan — safe as name tint |
| Paladin | `#F48CBA` | Pink — do not use as “holy brand” (conflicts with Scarlet gold/cream) |
| Hunter | `#AAD372` | Green |
| Rogue | `#FFF468` | Yellow — poor on parchment; needs dark outline/shadow |
| Priest | `#FFFFFF` | White — needs dark panel behind |
| Shaman | `#0070DD` | Blue (post-BC identity) |
| Mage | `#3FC7EB` | Light blue (Legion+ wiki value) |
| Warlock | `#8788EE` | Purple (Legion+ wiki value) |
| Druid | `#FF7C0A` | Orange |

**TBC-relevant history** (same wiki + [Chase Christian — history of class colors](https://chasechristian.com/blog/2015/08/the-history-of-wow-class-colors/)):

- Pre-BC: Shaman shared Paladin pink (`#F58CBA`) because factions could not play both.
- BC 2.0.1: Shaman → `#2459FF` (distinct blue).
- WotLK 3.2.2: Shaman → `#0070DE` (close to modern `#0070DD`).
- Legion 7.0.3: Mage `#69CCF0` → `#40C7EB`-family; Warlock `#9482C9` → `#8787ED`-family.

**Anniversary implication:** Dump `RAID_CLASS_COLORS` once on the live `Interface: 20506` client. Fan SCSS lists often still ship pre-Legion Mage/Warlock hexes ([GitHub gist — wow-class-colors.scss](https://gist.github.com/davidcraig/72a4d979bdbaa61652706e8379c3872f)) — treat those as historical, not authoritative for Anniversary.

**Classes not in TBC:** Death Knight, Monk, Demon Hunter, Evoker — ignore for V1 name chips; do not reserve brand tokens that collide with DK red if you later port.

### Beef usage rules for class color

| Do | Don’t |
|----|-------|
| Tint character names on ladder / standing | Paint entire ladder rows in class color |
| Optional small class icon + tint | Use Paladin pink or Priest white as Church “holy” brand |
| Respect player-learned identity | Recolor classes for comedy (breaks muscle memory) |

---

## 3. Item quality colors

From documented `GetItemQualityColor` output ([Wowpedia archive](https://wowwiki-archive.fandom.com/wiki/API_GetItemQualityColor)):

| Index | Quality | Hex (RGB portion) | Player meaning |
|------:|---------|-------------------|----------------|
| 0 | Poor | `#9D9D9D` | Trash / grey |
| 1 | Common | `#FFFFFF` | White |
| 2 | Uncommon | `#1EFF00` | Green |
| 3 | Rare | `#0070DD` | Blue |
| 4 | Epic | `#A335EE` | Purple |
| 5 | Legendary | `#FF8000` | Orange |
| 6 | Artifact | `#E6CC80` | Light gold |
| 7 | Heirloom | `#E6CC80` | Same gold family (when present) |

Community “rarity palette” summaries match the common→legendary set ([color-hex Item Rarity](https://www.color-hex.com/color-palette/38466)).

### Beef usage rules for quality color

Quality colors are **prestige metaphors**, not church doctrine:

| Metaphor | Quality cue | Prefer for |
|----------|-------------|------------|
| Everyday flock | White / green | Fresh–Cooked standing chrome accents (subtle) |
| Recognized knight | Blue (Rare) | Beef Knight highlight optional |
| High clergy theater | Purple / orange | Council / Prophet **ceremony moments only** — sparse |

Do **not** paint the whole ladder like an loot table. One quality-tinted title word at toast time beats seven purple rows.

Blizzard’s colorblind UI adds the words “Rare” / “Epic” beside color ([Blizzard — New Colorblind Support in Patch 6.1](http://worldofwarcraft.blizzard.com/en-us/news/17964863/new-colorblind-support-in-patch-61)). If Beef ever shows a quality-colored rank title, also print the rank name in plain text (already required by product).

---

## 4. Faction colors vs reaction colors

These are **different systems**. Mixing them confuses PvP-trained eyes.

### 4.1 Faction brand (Alliance / Horde)

- FrameXML exposes `PLAYER_FACTION_COLORS` via `GetFactionColor` ([ColorUtil.lua](https://github.com/Nevcairiel/wow-ui-source-1/blob/live/SharedXML/ColorUtil.lua)).
- Marketing / room-paint hexes are unofficial and vary; one forum claim pairs Alliance `#162C57` / Horde `#8C1616` ([Blizzard forums — Alliance blue](https://us.forums.blizzard.com/en/wow/t/is-there-an-official-alliance-blue-color-i-need-the-right-shade-for-my-gaming-room/506287)). Use as **mood reference only**.
- Official WoW **logo** palette (navy/cyan/yellow/orange) is product branding, not in-game faction UI ([Brand Palettes — WoW color codes](https://brandpalettes.com/world-of-warcraft-color-codes/)).

**Beef implication:** Dreamscythe (Alliance) and Doomhowl (Horde) each run their own ladder. Optional footer chip “Alliance realm” / “Horde realm” may use `GetFactionColor`. Church panels themselves stay Scarlet-holy, not Stormwind blue or Orgrimmar red.

### 4.2 Reaction / selection colors

Classic-era `UnitReactionColor` pattern (hostile red → orange → yellow → friendly green) from default TargetFrame ([WoWInterface](https://www.wowinterface.com/forums/showthread.php?t=18459)):

| Band | Approx RGB | Meaning |
|------|------------|---------|
| Hostile | `(1, 0, 0)` | Enemy |
| Unfriendly | `(1, 0.5, 0)` | Caution |
| Neutral | `(1, 1, 0)` | Neutral |
| Friendly | `(0, 1, 0)` | Friend / same faction PvE |

**Beef implication:** Reserve pure hostile red for true “danger / reject / excommunicate” semantic states if you must — or better, use brand scarlet for ceremony and a **desaturated rose + icon** for demotion so you do not look like a nameplate threat addon. Never use friendly green as “points gained” without also saying “+standing” in text (green already means friendly unit).

---

## 5. Escape sequences (chat / fontstrings)

Colored text in WoW uses `|cAARRGGBB…|r` ([escape-sequence skill summary citing FrameXML patterns](https://skillsmp.com/creators/jburlison/wowaddonapiagents/github-skills-wow-api-escape-sequences)). Prefer wrapping via ColorMixin helpers when available (`WrapTextInColorCode`) so alpha/`colorStr` stay consistent with `RAID_CLASS_COLORS`.

Guild-chat spectacle lines (spec §10) should stay **mostly plain** for members without the addon — color codes in public chat are optional garnish, not the message.

---

## 6. Quick do / don’t for system colors

| Do | Don’t |
|----|-------|
| Runtime class/quality APIs | Hardcode retail-only class list |
| Small name chips | Full-row class neon |
| Quality color for rare ceremony peaks | Ladder-as-loot-table |
| Faction chip per realm guild | One UI that implies cross-faction shared state |
| Dual-encode with text/icons | Color-only pending/approve |
