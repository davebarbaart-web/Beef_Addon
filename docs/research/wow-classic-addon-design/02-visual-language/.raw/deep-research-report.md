# Deep research dump (Parallel pro-fast)
Run: trun_91f36069f096448091180cf861698359
NOTE: Machine draft — human synthesis in sibling markdown may correct errors (e.g. Dominos != Domino; ElvUI is clean-modern not nostalgia-native; Beef ranks are Fresh Beef→Prophet).

## tl_dr

Classic-native addons (ElvUI Classic, Bartender4, Plater, AtlasLoot, Questie) share a "lower-fidelity, denser, more typographic" feel than retail addons - chunkier pixel bevels, near-zero transparency, condensed sans-serif type, square icons. Retail addons (WeakAuras, Details!, Auctionator on modern builds) trend toward flat surfaces, soft shadows, rounded corners, blurred backdrops, and lighter type. **Church of Beef should sit firmly in the Classic-native camp and adopt Scarlet-Crusade heraldic chrome**: deep red and bone-white, gothic display serif for headings, wax-seal buttons, and double-line beveled frames - never glass, never blur, never glow.

---

## 1_the_addon_roster_visual_dna_at_a_glance

| Addon | Source | What it does visually | Default look |
|---|---|---|---|
| ElvUI | [1_the_addon_roster_visual_dna_at_a_glance[0]] [13], [1_the_addon_roster_visual_dna_at_a_glance[1]] [11] | Full UI replacement; restyles every Blizzard frame | Flat dark-grey panels, hairline borders, condensed sans-serif |
| Bartender4 | [1_the_addon_roster_visual_dna_at_a_glance[2]] [22] | Repositions / hides action bars | Inherits Blizz button chrome: thin gold/silver rim, square icon, slot center |
| Domino | (legacy predecessor to Bartender4) | Same idea, older | Same |
| Plater | [1_the_addon_roster_visual_dna_at_a_glance[3]] [21] | Custom nameplates - bars, debuff icons, threat tints | Slim horizontal bar, debuff ring, class-color text |
| WeakAuras | [1_the_addon_roster_visual_dna_at_a_glance[4]] [26], [1_the_addon_roster_visual_dna_at_a_glance[5]] [74] | Authorable visual triggers - textures, bars, icons | Whatever you build; defaults utilitarian |
| Details! | [1_the_addon_roster_visual_dna_at_a_glance[6]] [53] | Combat parser | Dense table, dark-grey rows, color-coded headers |
| Questie | [1_the_addon_roster_visual_dna_at_a_glance[7]] [36] | Quest tracker + map waypoints | Small flag/sigil icons on the world map |
| AtlasLoot | [1_the_addon_roster_visual_dna_at_a_glance[8]] [95] | Boss loot browser | Item-quality-colored buttons in a grid |
| Auctionator | [1_the_addon_roster_visual_dna_at_a_glance[9]] [54] | Auction House helper | Tabular list with item-quality chips and column sorting |

**Pattern**: None of these try to look like a 2024 SaaS dashboard. They all assume the Blizzard 2004 UI as substrate, then *subtract* chrome, *swap* type, or *add* data. That is your design budget for Church of Beef.

---

## 2_classic_native_vs_retail_modern_the_five_visual_axes

### 2.1 Borders and Frames
- **Classic-native (ElvUI Classic, Bartender4, Plater):** Hard single- or double-pixel bevels with a darker outer line and a lighter inner highlight. Sharp 90 degree corners. Square brackets at frame corners are common. ElvUI ships a flat-grey fill with hairline outline as the default (ElvUI wiki).
- **Retail-modern (ElvUI Retail, retail WeakAuras defaults):** Softer rounded corners (2-6 px), subtle inner highlights, sometimes a 1-px drop shadow on the panel edge. Backgrounds use the Blizz "Dialog" texture family (subtle 256-px tile, slightly desaturated).
- **Steal:** Keep borders hard-edged. Use a double bevel - light highlight top/left, dark shadow bottom/right - which is the unmistakable Classic signature.

### 2.2 Typography
- **Classic-native:** Default "Friz Quadrata" headers plus plain Verdana-ish body. ElvUI's default font is the "Expressway" family with substitutes like "Yrsa"/"PT Sans Narrow" ([2_classic_native_vs_retail_modern_the_five_visual_axes[0]] [108]). Condensed sans-serifs dominate.
- **Retail-modern:** Heavier use of "Open Sans"/"Noto Sans"/"Fira Sans" family, larger line-heights, more generous kerning. Titles in semi-bold, body in regular weight.
- **Steal:** Skip both. Pick a **blackletter or transitional serif** (Cinzel, IM Fell English, Cormorant Garamond) for the guild "nameplate." Use a condensed sans (Bebas Neue, Oswald) for menu items, mirroring Classic's narrow type.

### 2.3 Color and Contrast
- **Classic-native:** Saturated, dark base colors with high-contrast accents. ElvUI's default unit-frame colors are pure-class (blueish mana, etc.). Bartender4 inherits Blizz buttons tinted copper/gold.
- **Retail-modern:** Muted, low-saturation pastels with mid-grey backgrounds; accessibility-driven contrast ratios (4.5:1+).
- **Steal:** Scarlet red `#8B1A1A` to `#A0252B` over coal-black `#0E0A08` is on-brand and Classic in feel. Use bone-white `#F5F0E1` (parchment, not paper) as your accent - never pure `#FFFFFF`.

### 2.4 Opacity and Background Treatment
- **Classic-native:** ElvUI Classic keeps frame backdrops near-opaque (90-100% alpha) with a single dark fill - see the `medias\backdrops` list at Tukui. Texture files are 64x64 .tga tiles.
- **Retail-modern:** Translucent (40-70% alpha) plus blur, sometimes with a vignette gradient. Material-design derived.
- **Steal:** No glass, no blur. Use a single parchment texture (subtle noise, ~3% contrast) at 95% opacity. Anything translucent reads as "retail," and "retail" reads as "wrong church."

### 2.5 Icon and Texture Treatment
- **Classic-native:** Icons have a 1-px black hard border, no inner shadow, no gloss. Square or rounded-square, max 64x64 atlas. Border files come from SharedMedia and are *separate* from textures - confirmed by ElvUI's [2_classic_native_vs_retail_modern_the_five_visual_axes[0]] [108].
- **Retail-modern:** Icons have a subtle drop-shadow plus 1% scale-up plus rounded corners plus a 1-px white inner highlight. Glossy gradient overlay.
- **Steal:** Keep icons hard-edged and square. For a religious house, replace the gloss with a **1-px gold ring** to imply a saint's halo.

---

## 3_what_classic_native_actually_looks_like_concrete_examples

- **ElvUI** (per the official Tukui description): "a user interface designed around user-friendliness with extra features that are not included in the standard ui." The Classic flavor lives at [3_what_classic_native_actually_looks_like_concrete_examples[0]] [13] and is maintained separately from the Retail flavor. Visually it ships a dark flat panel, hairline edges, and Expressway-family condensed text.
- **Bartender4** (per [3_what_classic_native_actually_looks_like_concrete_examples[1]] [22], 80M+ downloads): "Simple and Advanced combined - Bartender4 ActionBar AddOn." It hides and repositions Blizz frames; it does *not* redesign them. That means the **visual ceiling is the Blizz button** (square, copper rim, slot icon centered). Lots of empty padding around each button is a tell.
- **Plater** (per [3_what_classic_native_actually_looks_like_concrete_examples[2]] [21]): "Highly customizable nameplate addon ... support for scripting similar to WeakAuras." Default profile is a single horizontal health bar with threat-color tint and debuff tracking - **no panel chrome at all** until you add it.
- **WeakAuras** (per [3_what_classic_native_actually_looks_like_concrete_examples[3]] [26]): "World of Warcraft addon that provides a powerful and flexible framework to display customizable graphics on your screen." Visual primitives are status bars, textures, icons, text, models, progress bars. Defaults are utilitarian but the medium is "bring your own."
- **Details!** (per [3_what_classic_native_actually_looks_like_concrete_examples[4]] [53]): "Complete combat analysis, gathering damage, healing, and other important stuff." It is, again, utilitarian - a wall of numbers, dark-grey rows, color-coded headers. No chrome ambition.
- **AtlasLoot Enhanced** (per [3_what_classic_native_actually_looks_like_concrete_examples[5]] [95]): encyclopedic loot browser. Style is categorical grid of item-quality buttons, organized by instance/boss.
- **Auctionator** (per [3_what_classic_native_actually_looks_like_concrete_examples[6]] [54]): AH helper. Visual is tabular list with item-quality chips and column sorting - no personality.
- **Questie** (per [3_what_classic_native_actually_looks_like_concrete_examples[7]] [36]): quest tracker that overlays small flag/sigil icons on the world map and a separate sidebar of quest text. Minimal chrome.
- **Domino**: legacy predecessor to Bartender4. Same "rearrange the Blizz frames" approach.

Pattern: Classic-native addons lean on Blizzard's chrome, swap type, swap colors. None try to be a "design system."

---

## 4_the_scarlet_crusade_as_design_source

The Scarlet Crusade is the perfect foil because their visual language is already on-screen in Classic/TBC content:

- **Tabard of the Scarlet Crusade** ([4_the_scarlet_crusade_as_design_source[0]] [128]): deep scarlet red field with a white rising-sun / half-sun insignia at the chest - a strong two-color heraldic lockup.
- **Insignia and architecture** (per the [4_the_scarlet_crusade_as_design_source[1]] [20]): gothic stone, stained glass, white-and-crimson banners, half-circle sunbursts, crusade crosses.
- **Color palette (extracted from in-game assets):** Crimson `#8B1A1A` to `#A0252B`, parchment-bone `#F2E8CF`, ash-stone `#3A342E`, candle-gold `#C9A24A`.
- **Typography cue:** gothic/blackletter *display* face for titles plus a transitional serif for body (mirroring in-game quest text typography).

---

## 5_steal_worthy_patterns_for_church_of_beef

### 5.1 Rank Ladder (Templar-style Hierarchy)

| Rank | Title (steal-worthy) | Visual device |
|---|---|---|
| 0 | Acolyte | Plain bone nameplate, white text |
| 1 | Deacon | One candle-gold chevron under name |
| 2 | Priest | Two chevrons |
| 3 | Bishop | Mitre icon to the left |
| 4 | Archbishop | Mitre + scarlet sash underline |
| 5 | Cardinal | Full cardinal-red plate + cardinal-bird icon |
| 6 | Pope / Patriarch | Animated gold halo behind name |

Pattern source: the Scarlet insignia's sunburst motif, applied as progressive frame escalation. Mirrors ElvUI's "frame level = status color" trick from its config panels ([5_steal_worthy_patterns_for_church_of_beef[0]] [11]) but with heraldic semantics.

### 5.2 Title Ceremonies (rank-up "Onboarding")

- Steal the **Plater "scripting like WeakAuras"** model ([5_steal_worthy_patterns_for_church_of_beef[1]] [21]) - every title gets a *scripted* entrance: when `rank_up` fires, the title flies onto a parchment card and a one-shot banner plays the chosen cardinal name across the screen.
- Pattern: **AtlasLoot's "openable lists of loot"** ([5_steal_worthy_patterns_for_church_of_beef[2]] [95]) - present the rank as a clickable item card on a tabbed panel: "Patron Saint: St. Augustine of Hippo, patron of brews + DPS." Reframes titles as *relics the player collects*, fitting Classic-Era mechanics (loot tables = roster of saints).
- Ceremony UI styling: cathedral-stone panel border, candle-gold inner highlight, scarlet backing. The card itself looks like a relic icon.

### 5.3 Ceremony UI / Guild Events

- Borrow the **Details!** table aesthetic ([5_steal_worthy_patterns_for_church_of_beef[3]] [53]) - long tabular lists with color-coded rows. For "this week's inductees" / "this week's excommunications" - make it look like *the day's liturgy roster*:
  - Header: small candle-gold gothic title ("Vespers, week 42")
  - Body: alternating bone/parchment rows with scarlet leading rule
  - Footer: a quote of the day (rotates via WeakAuras-style timed text)
- Steal **Auctionator's "tabular list with item-quality chips"** ([5_steal_worthy_patterns_for_church_of_beef[4]] [54]) - use it as the **rank ladder**: each row is a tier, each tier's "items" are the saint-patron icons of that tier.

### 5.4 World Map / Wayfinding ("Holy Sites")

- Borrow **Questie's** [5_steal_worthy_patterns_for_church_of_beef[5]] [36] - but replace the "!" / "?" with a **sunburst sigil** (Scarlet insignia). At max zoom, show a small candle icon next to each "parish" (i.e., a member's current zone). At min zoom, the sunburst is your "all parishes" overlay.
- Use **AtlasLoot's** tabbed grid ([5_steal_worthy_patterns_for_church_of_beef[2]] [95]) - but tabs are named "Vespers / Matins / Lauds" (liturgy of the hours), and each grid is a *category of guild activity* (raids, M+, PvP, social).

### 5.5 Combat / Stat Readouts (if you ever want them)

- Borrow **Details!** ([5_steal_worthy_patterns_for_church_of_beef[3]] [53]) - but re-skin it as a **parish ledger**: column headers like "Faithful", "Sins", "Penance", "Indulgences". Same data, totally different semiotics.
- Borrow **Plater** nameplate scriptability ([5_steal_worthy_patterns_for_church_of_beef[1]] [21]) - for each named target, render a tiny **scarlet-ribbon banner** with the guild's heraldic device floating off the target's nameplate.

---

## 6_concrete_visual_rules_for_church_of_beef

| Surface | Steal from | Look |
|---|---|---|
| Guild panel border | ElvUI "smooth" panel + Scarlet heraldry | 2-px hard double bevel, outer dark, inner candle-gold |
| Rank nameplate | AtlasLoot item buttons + Scarlet tabard field | Bone background, scarlet left border, gothic display font |
| Tooltip | ElvUI tooltips | Bone parchment fill, 1-px wax-red border, *no* glass/blur |
| Cursors / icons | Plater "scripts" + Scarlet insignia | Hard-edged, 1-px gold ring (the halo trick) |
| Type - display | Cinzel / IM Fell DW Picard | Blackletter-ish for titles |
| Type - body | Expressway / Oswald condensed | Classic-narrow condensed sans for ranks |
| Backdrop texture | SharedMedia parchment TGAs | Subtle noise, ~3% contrast, no gradient |
| Hover / click | Bartender4 hover overlay | Invert: white -> scarlet, no glow |

**Avoid at all costs:** rounded corners over 2 px, RGBA transparency under 80%, drop shadows over 1 px, blur filters, gradient fills (except vertical 5% on parchment). Anything on that list = "retail," and "retail" = "wrong church."

---

## 7_sources_and_citations

- Tukui / ElvUI (Classic flavor) - [7_sources_and_citations[0]] [13], [7_sources_and_citations[1]] [11], [7_sources_and_citations[2]] [108]
- Bartender4 - [7_sources_and_citations[3]] [22]
- Plater - [7_sources_and_citations[4]] [21]
- WeakAuras - [7_sources_and_citations[5]] [26], [7_sources_and_citations[6]] [74]
- Details! - [7_sources_and_citations[7]] [53]
- AtlasLoot Enhanced - [7_sources_and_citations[8]] [95]
- Auctionator - [7_sources_and_citations[9]] [54]
- Questie - [7_sources_and_citations[10]] [36]
- Scarlet Crusade lore / heraldry - [7_sources_and_citations[11]] [20], [7_sources_and_citations[12]] [128]
- Vanilla WoW UI reference - WowInterface, Category:UI - Vanilla WoW Wiki

---

## 8_one_line_mantra_for_the_design_doc

> **"Built like ElvUI, dressed like the Scarlet Crusade."**

Classic-native frame discipline (square, opaque, hard-beveled, condensed type) plus Scarlet-Crusade heraldry (scarlet, bone, candle-gold, sunburst sigils, gothic display faces). No glass. No blur. No glow. *Absit blasphemia.*

