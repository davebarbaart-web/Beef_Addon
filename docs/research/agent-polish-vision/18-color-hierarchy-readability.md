# 18 — Color hierarchy & readability (WoW UI → Church of Beef)

**Last updated:** 2026-07-26  
**Audience:** Agents polishing V1 UI / later art tokens.  
**Status:** Research synthesis — **not** product law. Spec §10 / §15, glossary rows 78–81, and [`ui-polished-direction-for-agents.md`](../../superpowers/ui-polished-direction-for-agents.md) win on conflict.  
**Depth tracks:** [`23-color-brand-tokens`](../wow-classic-addon-design/23-color-brand-tokens/) · [`02-visual-language`](../wow-classic-addon-design/02-visual-language/) · [`05` a11y notes](../wow-classic-addon-design/05-packaging-community-antipatterns/02-accessibility-density-clean-ui.md)

---

## 1. Verdict (one screen)

WoW players already speak four color languages: **class identity**, **item quality prestige**, **reaction/faction threat**, and **panel chrome (dark + parchment)**. Church of Beef must **borrow the first for names**, **almost never paint ranks with the second**, **never confuse the third with church scarlet**, and **obey the fourth for readability**. Colorblind-safe UI means **labels + icons first**; hue is garnish ([Blizzard — Colorblind Support in Patch 6.1](http://worldofwarcraft.blizzard.com/en-us/news/17964863/new-colorblind-support-in-patch-61)).

**V1 agent lock (from UI direction + glossary):** opaque high-contrast Classic panels · `GameFont*` · class color on **names only** · dual-encode pending/approve/reject · **no** item-quality rainbow for ranks · provisional brand hex is **not law** until Anniversary screenshot pass.

---

## 2. Alignment with UI polished direction

From [`docs/superpowers/ui-polished-direction-for-agents.md`](../../superpowers/ui-polished-direction-for-agents.md):

| Direction rule | Color implication |
|----------------|-------------------|
| Classic Blizzard shell for process UI | Use template-native fills/borders; do not invent cool-gray glass skins |
| Opaque high-contrast panels | α ≈ 1.0 iron/dark fills; reject glass/low-alpha |
| `GameFont*` | Prefer default font colors unless a state/name token applies |
| Class color on **names** only | Ladder/officer identity chips; never full-row neon |
| Dual-encode pending/approve/reject | Color + word + icon — never color alone |
| Anti-pattern: item-quality rainbow for ranks | Rank titles use warm heraldic ascent (or plain GameFont), not loot purple/orange spam |
| Anti-pattern: ElvUI-flat as brand | Avoid flat `#1E1E1E` + cyan; stay warm brown/gold when customizing later |
| Brand hex waits on screenshot lock | Task 7 may tint names + dual-encoded states; do not flood FontStrings with research scarlet |

---

## 3. WoW color hierarchy (player-learned)

Think of these as **layers**. Higher layers are more “sacred grammar”; misuse causes misreads.

```
┌─────────────────────────────────────────────┐
│ 4. Semantic state (pending / ok / reject)   │  ← addon-owned; dual-encode
├─────────────────────────────────────────────┤
│ 3. Class colors (identity of a person)      │  ← names only
├─────────────────────────────────────────────┤
│ 2. Item quality (loot prestige)             │  ← ceremony joke flash OK; not ladder paint
├─────────────────────────────────────────────┤
│ 1. Panel chrome (opaque dark + readable FG) │  ← Classic-native floor
└─────────────────────────────────────────────┘
```

### 3.1 Layer 1 — Dark panel conventions

Classic-native UI reads as **near-opaque** brown/stone panels with high-contrast body text; translucent “glass” and cool flat greys read Retail/ElvUI ([track 02 — Classic-native vs Retail](../wow-classic-addon-design/02-visual-language/01-classic-native-vs-retail.md)).

| Convention | Do | Don’t |
|------------|----|-------|
| Opacity | Opaque / α ≥ 0.92 scrims (prefer 1.0 for V1 toasts) | Mid-alpha panels over the world |
| Temperature | Warm iron / parchment / gold trim (post-hex-lock) | Cool SaaS grey + cyan |
| Text | Cream/parchment on iron; ink on parchment | Gold on parchment; Rogue yellow on parchment without outline |
| Contrast floor | Body ≥ **4.5:1**; large titles ≥ **3:1** ([W3C WCAG 1.4.3](https://www.w3.org/WAI/WCAG22/Understanding/contrast-minimum.html); [Recite Me — 4.5:1](https://reciteme.com/us/news/wcag-contrast-ratio-4-5-1)) | Grey-on-grey “mood” |

Game UI is not a website, but stream capture and living-room TVs behave like low-end displays — treat AA as the floor for toast/panel copy.

### 3.2 Layer 2 — Item quality (prestige grammar)

Players learn loot rarity as a fixed rainbow via `GetItemQualityColor` ([WoWWiki archive — GetItemQualityColor](https://wowwiki-archive.fandom.com/wiki/API_GetItemQualityColor)):

| Index | Quality | Hex (RGB) | Player meaning |
|------:|---------|-----------|----------------|
| 0 | Poor | `#9D9D9D` | Trash |
| 1 | Common | `#FFFFFF` | White |
| 2 | Uncommon | `#1EFF00` | Green |
| 3 | Rare | `#0070DD` | Blue |
| 4 | Epic | `#A335EE` | Purple |
| 5 | Legendary | `#FF8000` | Orange |
| 6–7 | Artifact / Heirloom (era-dependent) | `#E6CC80` family | Gold prestige |

**Beef rule:** quality colors are **prestige metaphors**, not church doctrine. Optional one-shot ceremony flash as parody loot is fine; painting the whole ladder like an AH loot table is an anti-pattern (UI direction + track 10/23).

Blizzard’s own colorblind mode adds the words “Rare” / “Epic” beside hue ([Blizzard 6.1 colorblind blog](http://worldofwarcraft.blizzard.com/en-us/news/17964863/new-colorblind-support-in-patch-61)) — if Beef ever shows a quality-tinted title, the rank name must remain plain text.

### 3.3 Layer 3 — Class colors (identity)

Canonical wiki table (runtime via `RAID_CLASS_COLORS` / `GetClassColor`) ([Warcraft Wiki — Class colors](https://warcraft.wiki.gg/wiki/Class_colors)):

| Class (TBC set) | Hex (wiki fixed) | Readability note |
|-----------------|------------------|------------------|
| Warrior | `#C69B6D` | Safe on dark |
| Paladin | `#F48CBA` | Not “holy brand” |
| Hunter | `#AAD372` | OK |
| Rogue | `#FFF468` | Needs dark behind / outline |
| Priest | `#FFFFFF` | Needs dark panel |
| Shaman | `#0070DD` | Post-BC blue (not pink) |
| Mage | `#3FC7EB` | Legion-era wiki value — dump client |
| Warlock | `#8788EE` | Legion-era wiki value — dump client |
| Druid | `#FF7C0A` | OK |

**Prefer runtime APIs over hardcoded hex** on Anniversary `20506` — wiki/SCSS tables drift ([GetClassColor](https://warcraft.wiki.gg/wiki/API_GetClassColor)). Shaman was pink with Paladin until BC 2.0.1; do not hardcode pre-BC pink for Anniversary.

**Beef rule:** tint **character names** only. Do not recolor classes for comedy. Ignore DK/Monk/DH/Evoker for TBC V1 name chips.

### 3.4 Layer 4 — Semantic state (addon-owned)

Reaction colors (hostile red → friendly green) are a **different system** from faction brand and from church scarlet. Community colorblind feedback still stresses: **do not use color as the primary encoding** ([Blizzard forums — For the Colorblind](https://us.forums.blizzard.com/en/wow/t/for-the-colorblind/1068542)).

| State | Color role | Required non-color |
|-------|------------|--------------------|
| Pending | Amber | “Pending” + hourglass/pip |
| Approved | Teal (not neon Uncommon green) | “Recognized” + check |
| Rejected | Dusty rose | “Rejected” + X |
| Demoted | Deep rose | “Demoted” / “Excommunicated” + seal break |
| Self on ladder | Gold underline | “You” / row marker |
| Officer affordance | Scarlet pip (post-lock) | Tab structure > color |

Never: green row vs red row with no text.

---

## 4. Colorblind model (citizen behavior)

Patch 6.1 taught two tools ([Blizzard blog](http://worldofwarcraft.blizzard.com/en-us/news/17964863/new-colorblind-support-in-patch-61); [PC Gamer summary](https://www.pcgamer.com/colorblind-support-is-coming-to-world-of-warcraft/)):

1. **UI Colorblind Mode** — injects words where color alone carried meaning (Rare/Epic, hostile/friendly hints).
2. **Filters** — protanopia / deuteranopia / tritanopia + strength slider.

Beef does **not** reimplement client shaders. Beef **does**:

- Dual-encode every stateful control
- Prefer **blue/orange/amber** categorical separations + **lightness** steps over pure red/green ([Datawrapper — colorblind viz](https://www.datawrapper.de/blog/colorblindness-part2); strategy also in track 23)
- QA under in-game filters after Anniversary screenshot pass
- Keep guild-chat announce **mostly plain** so non-addon members and chat addons are not garbled by `|c` spam

---

## 5. Token recommendations

### 5.1 V1 ship set (Task 7–10) — implement now

These are the only color behaviors agents should wire before hex lock (glossary **81**):

| Token / behavior | Value / source | Where |
|------------------|----------------|-------|
| `cob.sys.class.*` | Runtime `GetClassColor` / `RAID_CLASS_COLORS` | Ladder / officer **names** only |
| `cob.sys.quality.*` | Runtime `GetItemQualityColor` | **Do not** map ranks; optional future ceremony flash |
| `cob.sys.font.default` | `GameFontNormal` / Highlight / Disable | Body chrome |
| `cob.panel.fill` | Template-native Blizzard backdrop | Main `/beef` frame |
| `cob.state.pending` | Amber + “Pending” + icon | Officer queue |
| `cob.state.approved` | Teal + “Recognized” + check | Toast / recent action |
| `cob.state.rejected` | Dusty rose + “Rejected” + X | Officer reject |
| `cob.state.localYou` | Underline / “You” marker (gold optional) | Ladder self row |

**Provisional state hex** (research only — verify contrast in client):

| Token | Hex | Dual encode |
|-------|-----|-------------|
| `cob.state.pending` | `#E0B85A` | Hourglass + word |
| `cob.state.approved` | `#3D8B6E` | Check + word |
| `cob.state.rejected` | `#8A4F5C` | X + word |
| `cob.state.demoted` | `#7A3038` | Broken seal + word |

### 5.2 Post–screenshot-lock brand set (do not flood Task 7)

From track 23 brand proposals — **lock after Anniversary screenshot**, then apply sparsely:

| Token | Hex | Role |
|-------|-----|------|
| `cob.brand.scarlet` | `#9B1B2E` | Primary brand (deeper than Hostile `(1,0,0)`) |
| `cob.brand.scarlet.bright` | `#C42B3F` | Hover / tab underline |
| `cob.brand.gold` | `#D4AF37` | Titles / Prophet gleam (≠ Legendary `#FF8000`) |
| `cob.brand.gold.dim` | `#A88B2E` | Inactive gold / borders |
| `cob.brand.parchment` | `#E8DCC4` | Body on dark |
| `cob.brand.cream` | `#F5F0E6` | Large titles on iron/scarlet |
| `cob.brand.ink` | `#1A1410` | Text on parchment / near-black fill |
| `cob.brand.iron` | `#2C2420` | Panel / toast scrim |
| `cob.brand.ash` | `#6E6258` | Muted labels / disabled |

**Proven pairs (target ≥4.5:1 body / ≥3:1 large):**

| FG | BG | Use |
|----|----|-----|
| parchment `#E8DCC4` | iron `#2C2420` | Default panel/toast body |
| cream `#F5F0E6` | scarlet `#9B1B2E` | Ceremony banner title |
| ink `#1A1410` | parchment `#E8DCC4` | Light tooltip / light mode |
| gold `#D4AF37` | iron `#2C2420` | Titles — thicken stroke if <3:1 |

### 5.3 Overlay tokens

| Token | Value | Role |
|-------|-------|------|
| `cob.overlay.scrim` | `#2C2420` @ **1.0** | Toast / modal fill (V1) |
| `cob.overlay.scrim.soft` | `#1A1410` @ 0.85 | Avoid unless forced |
| `cob.overlay.outline` | `#0A0806` | 1px title shadow for Rogue/Priest names |
| `cob.overlay.flash.holy` | `#F0E6A8` @ 0.15 | 200–400ms ceremony flash — then settle |

### 5.4 Rank title tokens (later; not loot rainbow)

Warm ascent — **not** quality indices 0–5:

| Rank | Title | Token | Hex hint |
|-----:|-------|-------|----------|
| 1 | Fresh Beef | `cob.rank.1` | `#8A8076` ash |
| 2 | Cooked Beef | `cob.rank.2` | `#6B3A2A` beef |
| 3 | Beef Knight | `cob.rank.3` | `#A88B2E` dim gold |
| 4 | Beef Lord | `cob.rank.4` | `#D4AF37` gold |
| 5 | Beef Butcher | `cob.rank.5` | `#C42B3F` bright scarlet |
| 6 | Beef Council | `cob.rank.6` | `#9B1B2E` + gold pip |
| 7 | Beef Prophet | `cob.rank.7` | `#F0E6A8` on iron + gold border |

V1 may ship rank titles in default GameFont until hex lock — **thresholds/titles still come from `Data/Ranks.lua`**, never from color docs.

### 5.5 Namespace sketch

```
cob.brand.*     identity (post-lock)
cob.flavor.*    rare garnish (beef umber, holyglow)
cob.state.*     pending / approved / rejected / demoted
cob.rank.1..7   ladder title colors (post-lock)
cob.sys.*       runtime Blizzard (class, quality, faction)
cob.overlay.*   scrim / outline / flash
```

---

## 6. Collision bans (reject in review)

| Ban | Why |
|-----|-----|
| Full-row class-color neon | Breaks hierarchy; looks like Details!/Plater |
| Item-quality colors as rank IDs | Loot grammar ≠ social doctrine |
| Pure Hostile `(1,0,0)` as brand | Reads as threat/nameplate |
| Paladin pink / Priest white as “holy brand” | Collides with class identity |
| Epic purple as primary Church chrome | Reads loot, not Scarlet |
| Alliance-blue / Horde-red panel skins | One church brand across Dreamscythe + Doomhowl |
| Approve = Uncommon `#1EFF00` vs Reject = pure red | CVD failure + loot-green clash |
| Glass / low-alpha panels | Stream + Classic-native fail |
| Color-only pending/approve/reject | Violates UI direction + Blizzard a11y model |
| Hardcoded retail class list (DK/DH/…) | Wrong for TBC Anniversary V1 |

---

## 7. Agent checklist (before claiming color polish done)

1. Names class-tinted via **runtime** API; rows themselves stay panel-neutral.  
2. Every pending/approve/reject/demote control has **word + icon** (and optional hue).  
3. Main frame is **opaque**; toast scrim α = 1.0 in V1.  
4. No rank row painted Rare/Epic/Legendary purple/orange as identity.  
5. No research scarlet sprayed across every FontString before screenshot lock.  
6. Guild announce line stays readable without relying on `|c` codes.  
7. After hex lock: contrast-check parchment/iron and cream/scarlet; toggle client colorblind filters.

---

## 8. Sources

- [Warcraft Wiki — Class colors](https://warcraft.wiki.gg/wiki/Class_colors) (Sep 2024 wiki revision in search corpus)
- [Warcraft Wiki — GetClassColor](https://warcraft.wiki.gg/wiki/API_GetClassColor)
- [WoWWiki archive — GetItemQualityColor](https://wowwiki-archive.fandom.com/wiki/API_GetItemQualityColor) (example hex dump)
- [Blizzard — New Colorblind Support in Patch 6.1](http://worldofwarcraft.blizzard.com/en-us/news/17964863/new-colorblind-support-in-patch-61) (Feb 2015)
- [PC Gamer — Colorblind support coming to WoW](https://www.pcgamer.com/colorblind-support-is-coming-to-world-of-warcraft/) (Feb 2015)
- [Blizzard forums — For the Colorblind](https://us.forums.blizzard.com/en/wow/t/for-the-colorblind/1068542) (Aug 2021) — color-as-primary encoding caution
- [W3C — WCAG 1.4.3 Contrast (Minimum)](https://www.w3.org/WAI/WCAG22/Understanding/contrast-minimum.html)
- [Recite Me — WCAG contrast ratio 4.5:1](https://reciteme.com/us/news/wcag-contrast-ratio-4-5-1) (Jul 2026)
- [Datawrapper — Visualizing for colorblind readers](https://www.datawrapper.de/blog/colorblindness-part2)
- In-repo: [`ui-polished-direction-for-agents.md`](../../superpowers/ui-polished-direction-for-agents.md) · [`23-color-brand-tokens`](../wow-classic-addon-design/23-color-brand-tokens/) · glossary rows 78–81

**Search dumps (follow-up):**  
`docs/research/agent-polish-vision/_search-color-hierarchy.json`  
`docs/research/agent-polish-vision/_search-quality-contrast.json`
