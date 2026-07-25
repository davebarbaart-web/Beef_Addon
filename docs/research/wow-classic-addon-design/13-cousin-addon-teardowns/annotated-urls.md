# Annotated URLs — cousin-addon tear-downs

Curated for this track only. Prefer these over listicle roundups when citing Attune / Gargul / RP directory behavior.

---

## Attune

| URL | Annotation |
|-----|------------|
| https://www.curseforge.com/wow/addons/attune | **Primary product page.** Features, flavors (Classic / Classic TBC), survey instructions, guild summary / raid planner marketing, Discord. Start here. |
| https://arcaneintellect.com/attune-world-of-warcraft-wow-tbc-addon-spotlight/ | **Best UX walkthrough (2021).** Personal tree, Survey → Results, Raid Planner, role profiles, options (auto-survey, chat on complete). |
| https://us.forums.blizzard.com/en/wow/t/attune-addon-track-your-attunement-progress/883832 | Author intro + community reaction (raid leads like readiness). Links sample screenshot. |
| https://github.com/r-o-b-o-t-o/Attune-3.3.5/blob/master/Attune/README.md | Forked README clarifying survey + export-to-website path (legacy upload mental model). |
| https://overgear.com/guides/wow-classic/tbc-anniversary-top-addons | Anniversary roundup that keeps Attune in the “must discuss” set for TBC gates. |
| https://boostmatch.gg/blog/wow-anniversary/articles/wow-tbc-anniversary-addons-guide | Secondary Anniversary guide; useful only as corroboration. |

---

## Gargul

| URL | Annotation |
|-----|------------|
| https://www.curseforge.com/wow/addons/gargul | **Primary product page.** Feature table, BCC Classic files, gallery captions (announce, rolls, trades, widgets). |
| https://addons.wago.io/addons/gargul | Clean duplicate of feature/command table; “ML only required” pitch. |
| https://github.com/papa-smurf/Gargul | Source repo landing. |
| https://github.com/papa-smurf/Gargul/wiki | **Wiki index** — announce, rolling, awarding, SoftRes, version check, settings. |
| https://github.com/papa-smurf/Gargul/wiki/Announcing-Loot-in-Chat | Announce defaults, quality gates, SoftRes inclusion toggles, raid warning on RollOff. |
| https://github.com/papa-smurf/Gargul/wiki/Rolling-Items | **Officer queue anatomy** — RollOff window, raider widget, duplicate rolls, ML-only install note. |
| https://github.com/papa-smurf/Gargul/wiki/Awarding-Items | Award UI + **confirm dialogue** + slash award. |
| https://github.com/papa-smurf/Gargul/wiki/Importing-Soft-Reserves | Import + **Broadcast** (ML-gated) — cousin of RANK_COMMIT fanout. |
| https://github.com/papa-smurf/Gargul/wiki/Version-Check | `/gl version` capability discovery — cousin of HELLO. |
| https://www.reddit.com/r/classicwow/comments/servxp/gargul_a_battletested_autoloot_and_loot | Author launch thread; ease-of-use vs RCLC; optional raid install; auto-trade stories. |
| https://medium.com/@rengo_wow_world_of_warcraft/rclootcouncil-vs-gargul-which-wow-loot-addon-should-you-use-f99ac760e944 | 2026 comparison: Gargul = speed/SR; RCLC = voting council. Clarifies why Beef should copy Gargul’s authority shape, not RCLC’s. |

---

## RP directory (TRP3 / MRP / MSP)

| URL | Annotation |
|-----|------------|
| https://github.com/Total-RP/Total-RP-3 | **Feature manifesto:** directory, map scan, target frame, chat, MSP interop, modularity. |
| https://www.wowinterface.com/downloads/info24113-TotalRP3.html | Distribution page; Classic & TBC compatibility claim; MSP mentioned; changelog noise about chat/UI conflicts (cautionary). |
| https://www.curseforge.com/wow/addons/total-rp-3 | CurseForge listing (Retail-primary; verify Classic flavor files when installing). |
| https://github.com/Total-RP/Total-RP-3/wiki/Mary-Sue-Protocol | MSP field notes + link to protocol home; interop list. |
| https://moonshyne.org/msp/ | **Mary Sue Protocol** home — standardized RP profile exchange. |
| https://legacy-wow.com/classic-addons/myroleplay-classic/ | MRP Classic features + FAQ (cross-realm limits, WTF backup, tooltip conflicts). |
| https://blizzardwatch.com/2019/08/26/roleplaying-in-wow-classic-guide | Classic launch RP addon landscape; CHANNEL policy risk note. |
| https://us.forums.blizzard.com/en/wow/t/rp-profile-addon-for-classic-popular-here/273469 | Player reports: MRP vs TRP3; cross-reading profiles. |

---

## Spec / library cross-links (repo-local)

| Path | Annotation |
|------|------------|
| [`docs/superpowers/specs/2026-07-25-church-of-beef-design.md`](../../../superpowers/specs/2026-07-25-church-of-beef-design.md) | Product truth for ladder, BeefNet, officer gate, announces. |
| [`../00-church-of-beef-implications.md`](../00-church-of-beef-implications.md) | Called for this teardown track; high-level Attune/Gargul mentions. |
| [`../01-ux-patterns/quest-helpers.md`](../01-ux-patterns/quest-helpers.md) | Shallow Attune pointer — superseded in depth by this track. |
| [`../01-ux-patterns/loot.md`](../01-ux-patterns/loot.md) | Shallow Gargul pointer — superseded in depth by this track. |

---

## Provenance

Search/extract JSON for this track: [`.raw/`](.raw/).  
Claims in tear-down docs should stay traceable to URLs in this file.
