# Cousin research — cult / guild / ceremonial voice (light)

**Purpose:** Steal *placement* patterns for vernacular and recognition — not combat UX, not Track 32 craft essays.  
**Depth:** Light pass only (web search + sibling tracks 07/09).  
**Raw dumps:** [`.raw/search-cult-guild-addons.json`](.raw/search-cult-guild-addons.json), [`.raw/search-religious-guild-titles.json`](.raw/search-religious-guild-titles.json).

---

## What “analogous” means for Beef

Church of Beef is a **guild institutional ladder** with religious-sports comedy. True “cult addon” products are rare; useful cousins are:

1. **RP identity / document tools** — titles and scripture as content  
2. **Guild recognition shoutouts** — chat as ritual calendar  
3. **Officer fairness queues** — sincere process under the pageantry  
4. **Custom guild rank culture** — funny titles as social identity (outside addon code)

---

## Cousins and lore-UI lessons

### Total RP 3: Extended — campaigns, items, documents

[Total RP 3: Extended (GitHub)](https://github.com/Total-RP/Total-RP-3-Extended) adds authoring for campaigns, items, stashes, and immersive dialogs on top of TRP3 identity.

| Steal for lore-UI bible | Avoid for V1 |
|-------------------------|--------------|
| Scripture/relics/tickets as **authored content**, not HUD chrome | Shipping a parallel TRP creator in V1 |
| Custom titles / about-fields as free ceremony when identity needs a home | Requiring TRP to see Church ranks |

**Beef mapping:** V1 keeps ranks in `/beef` + guild chat. Extended-style documents are a **V2+** home for long Beef Scripture (spec already defers deep lore systems). Sibling note: [07 addon catalog](../07-immersion-roleplay-flavor/addon-catalog.md).

### Religious / ceremonial RP title culture

RP communities treat priestly ranks (cleric, high priest, etc.) as **ordered vocabulary** players argue over for consistency ([r/WoWRolePlay — priest ranks/titles](https://www.reddit.com/r/WoWRolePlay/comments/1etrrti/priest_rp_help_regarding_ranks_and_titles/)). Custom titles historically live in MRP/TRP, not Blizzard title APIs ([MMO-Champion — Roleplay Titles](https://www.mmo-champion.com/threads/1141086-Roleplay-Titles)).

| Steal | Avoid |
|-------|--------|
| Stable ordered title ladder with clear glosses | Synonym soup (“Knight” vs “Blade” vs “Paladin of Beef”) |
| Tooltip/identity placement for long lore | Dumping lore into every toast |

**Beef mapping:** Seven fixed titles *are* the product — protect exact strings like an RP order protects its rank list.

### Guild Achieve Congratulator — shoutout ritualizer

[Guild Achieve Congratulator (CurseForge)](https://www.curseforge.com/wow/addons/guild-achieves) auto-posts funny/sarcastic congratulations to guild chat on achievements, with delay, batching, and huge random pools (Classic/TBC flavors listed on the project page).

| Steal | Avoid |
|-------|--------|
| Milestone → guild chat as shared ritual | 950-line random sarcasm for **rank commits** |
| Humanizing delay / anti-spam batching (craft lives in 32) | Letting comedy drown parseable who/title |

**Beef mapping:** V1 commits should stay **liturgical deadpan** (one stable rite), not Congratulator’s roulette. Optional V2 “flock reaction” packs could learn from its pool idea — separate from officer liturgy.

### Guild recognition & greeting tools (pattern)

Track 09 documents [GuildGreet Extended](https://legacy-wow.com/wotlk-addons/guildgreet-extended)-style proactive greet/level-up reminders and achievement shoutouts as **triggered vernacular** — the template is where cult voice lives ([09 deep research](../09-guild-social-community/.raw/guild-social-deep.md)).

| Steal | Avoid |
|-------|--------|
| “The Order welcomes X to the Inner Circle” template thinking | Greeting spam on every login as V1 scope |

### Officer sincerity cousins (Attune / Gargul / RCLootCouncil)

Not cult-themed, but they prove **process UI stays sincere** while public lines stay factual ([09](../09-guild-social-community/), [32](../32-microcopy-tone-voice/)). Beef’s sacred comedy belongs in titles + liturgy, not in Approve/Reject labels.

### Guild Manager / Roster Manager — ranks as rite of passage

Configurable promote/demote/announce systems and promo histories treat rank change as **biography**, not a checkbox ([Guild Manager](https://www.curseforge.com/wow/addons/guild-management-system), [Guild Roster Manager](https://addons.wago.io/addons/guild-roster-manager) — via track 09).

| Steal | Avoid |
|-------|--------|
| Promotion as recorded rite | Auto-promote rules that bypass Officer+ doctrine |

---

## Synthesis for Church of Beef UI lore

1. **Vernacular lives at milestones** (rank commit lines), not in procedural chrome.  
2. **Title lists want rigidity** — RP orders and Beef share this; synonyms kill brand.  
3. **Long scripture wants documents / footers**, not announce spam (TRP Extended lesson; spec V1 footer).  
4. **Random joke pools are a different product** than institutional liturgy (Congratulator ≠ Church).  
5. **Officer honesty underpins comedy** — without sincere Approve/Reject, sacred announces feel like a scam.

No cousin found that is a full “comedy church ladder” for Classic; Beef is filling a niche by combining guild standing + RP title discipline + stream liturgy.
