# Annotated URLs — standing breakdown & My Standing UI

**Track:** 70 · Curated primary references. Prefer these over `.raw/` dumps when citing.  
**Legend:** **Steal** = use directly · **Adapt** = reshape for Beef · **Avoid** = anti-pattern · **Context** = background only.

Do **not** treat this list as a second copy of [26/annotated-urls](../26-ladders-points-gamification/annotated-urls.md) (ladders/seasons/toxicity). Overlap is intentional only where personal progress is the lesson.

---

## Classic cousins — personal progress & attribution

| URL | Annotation |
|-----|------------|
| [https://arcaneintellect.com/attune-world-of-warcraft-wow-tbc-addon-spotlight/](https://arcaneintellect.com/attune-world-of-warcraft-wow-tbc-addon-spotlight/) | **Steal:** personal tree = where / next / tooltip evidence; survey table stays separate. **Adapt:** flatten to My Standing summary + event list. |
| [https://us.forums.blizzard.com/en/wow/t/attune-addon-track-your-attunement-progress/883832](https://us.forums.blizzard.com/en/wow/t/attune-addon-track-your-attunement-progress/883832) | **Context:** Author framing — visual chain, next steps, guild readiness as a different surface. |
| [https://www.curseforge.com/wow/addons/attune](https://www.curseforge.com/wow/addons/attune) | **Context:** Listing/gallery for Attune; soft-dep survey model. Full tear-down in track 13. |
| [https://github.com/kakysha/HonorSpy](https://github.com/kakysha/HonorSpy) | **Steal:** personal progress estimate + glance path; **Avoid:** defaulting My Standing to full standings table. |
| [https://www.curseforge.com/wow/addons/cepgp-standings-tracker](https://www.curseforge.com/wow/addons/cepgp-standings-tracker) | **Steal:** date-ordered personal change log. **Avoid:** requiring CEPGP matrix underneath. |
| [https://www.wowinterface.com/downloads/info25051-CEPGP.html](https://www.wowinterface.com/downloads/info25051-CEPGP.html) | **Avoid as template:** GUI standings for loot EPGP — density warning for My Standing. |
| [https://www.curseforge.com/wow/addons/cepgp](https://www.curseforge.com/wow/addons/cepgp) | **Avoid:** loot-distribution UI as comedy standing chrome. |
| [https://wowpedia.fandom.com/wiki/EPGP](https://wowpedia.fandom.com/wiki/EPGP) | **Adapt:** transparent effort channels. **Avoid:** EP/GP/PR columns in Beef UI. |
| [https://www.curseforge.com/wow/addons/duelbook](https://www.curseforge.com/wow/addons/duelbook) | **Adapt:** personal rivalry lines for Gora history (opponent + outcome). |

---

## Blizzard reputation / progress chrome

| URL | Annotation |
|-----|------------|
| [https://warcraft.wiki.gg/wiki/Reputation](https://warcraft.wiki.gg/wiki/Reputation) | **Steal:** named standing tiers + points-to-next-level mental model. Vocabulary stay “standing,” not “rep.” |
| [https://warcraft.wiki.gg/wiki/API_GetWatchedFactionInfo](https://warcraft.wiki.gg/wiki/API_GetWatchedFactionInfo) | **Steal idea:** determinate min/max/value inside current band → remaining-to-next title. |
| [https://us.forums.blizzard.com/en/wow/t/progress-bar-for-pvp/1656898](https://us.forums.blizzard.com/en/wow/t/progress-bar-for-pvp/1656898) | **Context:** Players expect visible progress; weekly gates confuse — keep Beef’s next-threshold always readable. |

---

## Progress / chip UX (general)

| URL | Annotation |
|-----|------------|
| [https://www.nngroup.com/articles/progress-indicators/](https://www.nngroup.com/articles/progress-indicators/) | **Steal:** visibility of system status — standing should move when grants apply. |
| [https://userpilot.com/blog/progress-bar-ui-ux-saas/](https://userpilot.com/blog/progress-bar-ui-ux-saas/) | **Adapt:** honest pacing; avoid theatrical bars that stall. Text-first progress is safer in Classic. |
| [https://smart-interface-design-patterns.com/articles/badges-chips-tags-pills/](https://smart-interface-design-patterns.com/articles/badges-chips-tags-pills/) | **Steal:** badges = static source labels; chips = interactive filters (defer filters). |
| [https://m2.material.io/components/chips](https://m2.material.io/components/chips) | **Context:** filter-chip semantics; Classic V1 uses FontString badges, not Material widgets. |
| [https://www.setproduct.com/blog/chip-ui-design](https://www.setproduct.com/blog/chip-ui-design) | **Context:** chips vs tags vs badges — keep source markers non-CTA. |

---

## In-library cross-links (not primary web sources)

| Path | Why |
|------|-----|
| [../26-ladders-points-gamification/](../26-ladders-points-gamification/) | Macro ladder / seasons / anti-farm — cite, don’t duplicate |
| [../13-cousin-addon-teardowns/steal-avoid-for-beef.md](../13-cousin-addon-teardowns/steal-avoid-for-beef.md) | Attune personal progress → My Standing |
| [../02-visual-language/03-steal-adapt-matrix.md](../02-visual-language/03-steal-adapt-matrix.md) | Summary + recent lines; no fake XP castbar |
| [../53-beef-lore-ui-bible/string-do-dont.md](../53-beef-lore-ui-bible/string-do-dont.md) | Standing vocabulary; no points-to-Prophet |
| [../57-scrollframe-list-rows/beef-ladder-officer-lists.md](../57-scrollframe-list-rows/beef-ladder-officer-lists.md) | History list widget choice |
| [../40-officer-moderation-audit/beef-product-patterns.md](../40-officer-moderation-audit/beef-product-patterns.md) | Officer reuses short breakdown |
| [../41-empty-states-degraded-ux/beef-copy-ux-map.md](../41-empty-states-degraded-ux/beef-copy-ux-map.md) | Empty My Standing copy |

---

## Spec / plan anchors

| URL / path | Annotation |
|------------|------------|
| [../../../superpowers/specs/2026-07-25-church-of-beef-design.md](../../../superpowers/specs/2026-07-25-church-of-beef-design.md) | **Canon:** §7 sources/caps/suggestions; §10 My Standing fields |
| [../../../superpowers/plans/2026-07-25-church-of-beef-v1.md](../../../superpowers/plans/2026-07-25-church-of-beef-v1.md) | **Canon:** Task 8 StandingTab — threshold line + ~10 history lines |
