# Annotated URLs — Officer tab IA

Primary sources for track 69. Prefer these when reviewing Officer-tab composition. Annotations emphasize **information architecture** steal/avoid — not protocol or FrameXML depth.

---

## Spec & plan (repo-local)

| URL / path | Annotation |
|------------|------------|
| [`docs/superpowers/specs/2026-07-25-church-of-beef-design.md`](../../../superpowers/specs/2026-07-25-church-of-beef-design.md) §7.3, §10 | **Product truth:** pending evidence fields; Officer tab verb list; Approve/Reject semantics. |
| [`docs/superpowers/plans/2026-07-25-church-of-beef-v1.md`](../../../superpowers/plans/2026-07-25-church-of-beef-v1.md) Task 9 | `UI/OfficerTab.lua` implementation target — consume this track’s zone map. |

---

## RCLootCouncil — selection / detail / history IA

| URL | Annotation |
|-----|------------|
| https://rclootcouncil.com/wiki/Voting-Frame | **Primary IA steal:** session → candidate table → selection highlight → More Info side detail; Award paths. **Avoid for Beef:** vote columns, gear/ilvl/Diff, session icon rail, Disenchant, multi-voter status. |
| https://rclootcouncil.com/wiki/Loot-History | **Recent Actions cousin:** one row per decision, reason, filters/export. Steal row mindset; defer filters/export. |
| https://rclootcouncil.com/ | Product home — council workflow context (Beef is *not* a voting council in V1). |
| https://www.curseforge.com/wow/addons/rclootcouncil-classic | Classic distribution pointer; confirms Voting Frame culture exists on Classic family. |
| https://github.com/evil-morfar/RCLootCouncil2/wiki/Synchronizer | **Out of IA scope** (sync consent) — cited so implementers don’t confuse Synchronizer chrome with Officer tab layout; policy → [67](../67-offline-officer-suggestion-sync/). |
| https://medium.com/@rengo_wow_world_of_warcraft/rclootcouncil-vs-gargul-which-wow-loot-addon-should-you-use-f99ac760e944 | Authority contrast: RCLC = parliament; Gargul = speed/ML — Beef copies Gargul authority + RCLC master–detail. |

---

## Gargul — officer decision queue IA

| URL | Annotation |
|-----|------------|
| https://github.com/papa-smurf/Gargul/wiki/Rolling-Items | **Primary IA steal:** RollOff anatomy — list, select, Award; note field; duplicate flags. Map list→pending, Award→Approve, note→evidence. Avoid Start/Stop/Timer theater. |
| https://github.com/papa-smurf/Gargul/wiki/Awarding-Items | **Confirm handoff steal:** Award → confirm dialogue before commit. Use for demote/Prophet/wipe, not every Approve. |
| https://github.com/papa-smurf/Gargul/wiki | Wiki index — announce, SoftRes, version check (peripheral to tab IA). |
| https://www.curseforge.com/wow/addons/gargul | Product page; ML-centric soft-dependency pitch aligns with Officer+ commits. |
| https://addons.wago.io/addons/gargul | Clean command/feature table; `/gl start` empty/teaching culture. |
| https://www.reddit.com/r/classicwow/comments/servxp/gargul_a_battletested_autoloot_and_loot | Community framing: ease vs RCLC; optional raid install — soft-dependency lesson for Beef. |

---

## Sibling research tracks (do not duplicate)

| Path | Annotation |
|------|------------|
| [`../13-cousin-addon-teardowns/`](../13-cousin-addon-teardowns/) | Full Attune/Gargul/RP tear-downs; this track only lifts Officer-tab IA. |
| [`../13-cousin-addon-teardowns/steal-avoid-for-beef.md`](../13-cousin-addon-teardowns/steal-avoid-for-beef.md) | Screen composition table — Officer row is the seed for 69. |
| [`../40-officer-moderation-audit/`](../40-officer-moderation-audit/) | Audit schema, undo, transparency — feeds Recent Actions *meaning*. |
| [`../40-officer-moderation-audit/beef-product-patterns.md`](../40-officer-moderation-audit/beef-product-patterns.md) | V1 decision row + Recent Actions product bullets. |
| [`../57-scrollframe-list-rows/beef-ladder-officer-lists.md`](../57-scrollframe-list-rows/beef-ladder-officer-lists.md) | Pool size 8–12; rites outside scroll — construction constraint on zones A/C. |
| [`../58-staticpopup-confirms/beef-demote-prophet-confirms.md`](../58-staticpopup-confirms/beef-demote-prophet-confirms.md) | Risk ladder + Approve/Reject non-modal rule — handoff target. |
| [`../41-empty-states-degraded-ux/`](../41-empty-states-degraded-ux/) | Empty-queue copy and scenario matrix — 69 maps slots only. |
| [`../01-ux-patterns/church-of-beef-synthesis.md`](../01-ux-patterns/church-of-beef-synthesis.md) | “Officer tab ≈ loot council, not Gargul density.” |
| [`../01-ux-patterns/loot.md`](../01-ux-patterns/loot.md) | Shallow cousin pointer superseded in depth by 13 + this track. |
| [`../35-xml-vs-lua-ui/beef-officer-ladder-ui.md`](../35-xml-vs-lua-ui/beef-officer-ladder-ui.md) | Construction module sketch for OfficerTab. |
| [`../67-offline-officer-suggestion-sync/`](../67-offline-officer-suggestion-sync/) | Whether offline officers share A — not layout. |
| [`../49-officer-notifications/`](../49-officer-notifications/) | How officers *notice* A; opening tab = acknowledge. |

---

## Empty-state / UX theory (light touch)

| URL | Annotation |
|-----|------------|
| https://www.eleken.co/blog-posts/empty-state-ux | Celebratory vs error empties — supports quiet empty queue in zone A. |
| https://www.nngroup.com/articles/empty-state-interface-design/ | Pathway empties — 41 owns copy; 69 keeps C visible as pathway to rites. |

---

## Provenance

IA claims should trace to Voting Frame / Rolling Items / Awarding Items / Loot History above, plus locked spec §7.3–§10. No new `.raw/` scrape for this track; cousin extracts already live under [13](../13-cousin-addon-teardowns/.raw/) and [40](../40-officer-moderation-audit/.raw/).
