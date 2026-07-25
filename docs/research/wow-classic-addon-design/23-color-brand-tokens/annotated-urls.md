# Annotated URLs — color, faction, brand tokens

**Last updated:** 2026-07-25  
**How to use:** Prefer ★★★ for implementation-facing claims; ★★ for design context; ★ for mood only.

---

## A. WoW system colors & APIs

| URL | Annotation | Steal / adapt |
|-----|------------|---------------|
| [https://warcraft.wiki.gg/wiki/Class_colors](https://warcraft.wiki.gg/wiki/Class_colors) ★★★ | Canonical class RGB/hex + patch history (Shaman BC split, Legion Mage/Warlock tweaks). | Use as design reference; still prefer runtime `RAID_CLASS_COLORS` on Anniversary. |
| [https://warcraft.wiki.gg/wiki/API_GetClassColor](https://warcraft.wiki.gg/wiki/API_GetClassColor) ★★★ | `GetClassColor(englishClass)` → r,g,b,hex. | Ladder name chips. |
| [https://wowwiki-archive.fandom.com/wiki/API_GetItemQualityColor](https://wowwiki-archive.fandom.com/wiki/API_GetItemQualityColor) ★★★ | Documents quality indices and example hex (`9d9d9d`…`ff8000`). | Ceremony prestige flashes; not full ladder paint. |
| [https://github.com/Nevcairiel/wow-ui-source-1/blob/live/SharedXML/ColorUtil.lua](https://github.com/Nevcairiel/wow-ui-source-1/blob/live/SharedXML/ColorUtil.lua) ★★★ | Shows `RAID_CLASS_COLORS` population + `GetFactionColor` → `PLAYER_FACTION_COLORS`. | Pattern for faction chips; verify Classic Anniversary FrameXML path may differ. |
| [https://chasechristian.com/blog/2015/08/the-history-of-wow-class-colors/](https://chasechristian.com/blog/2015/08/the-history-of-wow-class-colors/) ★★ | Narrative history of Shaman/Paladin color split and later tweaks. | Explains why TBC Shaman must not be pink. |
| [https://www.color-hex.com/color-palette/38466](https://www.color-hex.com/color-palette/38466) ★★ | Fan palette of common→legendary rarity hexes. | Quick mockups; confirm via API. |
| [https://gist.github.com/davidcraig/72a4d979bdbaa61652706e8379c3872f](https://gist.github.com/davidcraig/72a4d979bdbaa61652706e8379c3872f) ★ | SCSS class colours (often pre-Legion Mage/Warlock). | Do not treat as Anniversary truth. |
| [https://skillsmp.com/creators/jburlison/wowaddonapiagents/github-skills-wow-api-escape-sequences](https://skillsmp.com/creators/jburlison/wowaddonapiagents/github-skills-wow-api-escape-sequences) ★★ | `|cAARRGGBB` / named color escape overview. | Chat/fontstring coloring hygiene. |

---

## B. Faction & reaction

| URL | Annotation | Steal / adapt |
|-----|------------|---------------|
| [https://us.forums.blizzard.com/en/wow/t/is-there-an-official-alliance-blue-color-i-need-the-right-shade-for-my-gaming-room/506287](https://us.forums.blizzard.com/en/wow/t/is-there-an-official-alliance-blue-color-i-need-the-right-shade-for-my-gaming-room/506287) ★ | Community Alliance/Horde hex claims (`#162c57` / `#8c1616`). | Mood only; prefer `GetFactionColor`. |
| [https://brandpalettes.com/world-of-warcraft-color-codes/](https://brandpalettes.com/world-of-warcraft-color-codes/) ★ | WoW **logo** marketing colors, not FrameXML faction UI. | Do not skin Beef like the box art logo. |
| [https://www.wowinterface.com/forums/showthread.php?t=18459](https://www.wowinterface.com/forums/showthread.php?t=18459) ★★ | Documents classic `UnitReactionColor` red→green bands; notes `UnitSelectionColor`. | Keep hostile red out of brand panels. |
| [https://www.reddit.com/r/wow/comments/j17gfy/official_color_codes/](https://www.reddit.com/r/wow/comments/j17gfy/official_color_codes/) ★ | Players pointing at wiki class/quality/power color pages. | Confirms “no single official Alliance paint chip” culture. |

---

## C. Colorblind & contrast

| URL | Annotation | Steal / adapt |
|-----|------------|---------------|
| [http://worldofwarcraft.blizzard.com/en-us/news/17964863/new-colorblind-support-in-patch-61](http://worldofwarcraft.blizzard.com/en-us/news/17964863/new-colorblind-support-in-patch-61) ★★★ | Official UI Colorblind Mode (text labels) + protanopia/deuteranopia/tritanopia filters. | Dual-encode rarity/state like Blizzard does. |
| [https://blizzardwatch.com/2015/02/17/patch-6-1-adds-new-colorblind-support-ui](https://blizzardwatch.com/2015/02/17/patch-6-1-adds-new-colorblind-support-ui) ★★ | Plain-language summary of the 6.1 accessibility menu. | QA checklist language. |
| [https://developer.mozilla.org/en-US/docs/Web/Accessibility/Guides/Understanding_WCAG/Perceivable/Color_contrast](https://developer.mozilla.org/en-US/docs/Web/Accessibility/Guides/Understanding_WCAG/Perceivable/Color_contrast) ★★★ | WCAG AA/AAA contrast ratios for text and non-text. | Toast/panel contrast floors. |
| [https://www.wcag.com/blog/content-over-images-how-does-this-ux-ui-trend-impact-accessibility](https://www.wcag.com/blog/content-over-images-how-does-this-ux-ui-trend-impact-accessibility) ★★ | Text-over-image failures; scrims and 4.5:1. | Opaque toast scrim rule. |
| [https://webaim.org/resources/contrastchecker/](https://webaim.org/resources/contrastchecker/) ★★★ | Practical contrast checker. | Lock hex pairs before shipping tokens. |
| [https://www.datawrapper.de/blog/colorblindness-part2](https://www.datawrapper.de/blog/colorblindness-part2) ★★★ | Blue/orange, lightness, symbols/patterns, Okabe–Ito discussion. | State encoding strategy. |
| [https://visme.co/blog/color-blind-friendly-palette](https://visme.co/blog/color-blind-friendly-palette) ★★ | CVD types + “don’t rely on color alone.” | Officer queue UX. |
| [https://carbondesignsystem.com/data-visualization/color-palettes](https://carbondesignsystem.com/data-visualization/color-palettes) ★★ | Accessible categorical/sequential viz thinking. | Future standing charts. |
| [https://www.color-hex.com/color-palette/1044488](https://www.color-hex.com/color-palette/1044488) ★★ | IBM color-blind-safe categorical hex set. | Strategy reference; not Beef brand. |
| [https://studyaround.blog/toast-notification-design-guide](https://studyaround.blog/toast-notification-design-guide) ★★ | Toast contrast 4.5:1 + icon redundancy. | Aligns with Beef one-toast policy. |

---

## D. Brand / Scarlet / gothic mood

| URL | Annotation | Steal / adapt |
|-----|------------|---------------|
| [https://wowpedia.fandom.com/wiki/Scarlet_Monastery](https://wowpedia.fandom.com/wiki/Scarlet_Monastery) ★★ | Scarlet Crusade monastery lore/context for tabard zeal aesthetic. | Mood for crimson/holy pageantry — not undead horror. |
| [https://warcraft.wiki.gg/wiki/Scarlet_Monastery](https://warcraft.wiki.gg/wiki/Scarlet_Monastery) ★★ | Wiki.gg entry for the same zone. | Cross-check lore naming. |
| [https://www.wowhead.com/classic/zone=796/scarlet-monastery](https://www.wowhead.com/classic/zone=796/scarlet-monastery) ★ | Classic zone hub / screenshots entry. | Visual reference hunting. |
| [https://en.wikipedia.org/wiki/French_Gothic_stained_glass_windows](https://en.wikipedia.org/wiki/French_Gothic_stained_glass_windows) ★★ | Ruby red + gold/silver stain sacred glass language. | Justifies scarlet/gold/parchment triad. |
| [https://gallerix.org/pnews/202506/goticheskoe-vitrazhnoe-iskusstvo-svet-i-cvet-v-soborax](https://gallerix.org/pnews/202506/goticheskoe-vitrazhnoe-iskusstvo-svet-i-cvet-v-soborax) ★ | Cathedral light/color theology overview. | Atmosphere only. |
| Design spec §3.3 — [`docs/superpowers/specs/2026-07-25-church-of-beef-design.md`](../../../superpowers/specs/2026-07-25-church-of-beef-design.md) ★★★ | Local canon: gothic/Scarlet, holy steak absurdity, dual-realm separate ladders, plain V1 frames. | Non-negotiable product constraints for tokens. |

---

## E. Related research tracks (do not duplicate)

| Path | Boundary |
|------|----------|
| [../02-visual-language/](../02-visual-language/) / [../03-visual-language-reference.md](../03-visual-language-reference.md) | Chrome, ElvUI coexistence, Classic-native vs modern look — not hex tokens |
| [../10-skinning-masque-sharedmedia/](../10-skinning-masque-sharedmedia/) | Masque / SharedMedia / icon framing |
| [../17-stream-overlay-readability/](../17-stream-overlay-readability/) | Safe zones, toast duration, capture typography sizes |
| [../00-church-of-beef-implications.md](../00-church-of-beef-implications.md) | Product implications synthesis |

---

## F. Provenance dumps

Raw Parallel search/extract JSON/MD under [`.raw/`](.raw/):

- `search-wow-system-colors.json`
- `search-colorblind-contrast.json`
- `search-faction-quality-fonts.json`
- `search-a11y-palettes.json`
- `search-scarlet-brand.json`
- `search-font-reaction-colors.json`
- `search-api-color-constants.json` (if present)
- `extract-class-colors.md`
- `extract-wow-colorblind.md` (and related extracts)
