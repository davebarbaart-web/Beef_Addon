# Competitive addon case studies — social / progression / UI juice

**Track:** `agent-polish-vision` · **Doc:** `10-competitive-addon-case-studies`  
**Date:** 2026-07-26  
**Audience:** Agents polishing Church of Beef Ladder / My Standing / Officer Commit UX  
**Status:** Research guidance — **not** product law. Spec §10 / §15 + glossary 74–81 + [`ui-polished-direction-for-agents.md`](../../superpowers/ui-polished-direction-for-agents.md) win on conflict.

---

## 1. Purpose

Pull transferable UX lessons from WoW addons that already win at:

- **Progression juice** — “what’s next / why am I here / I just earned something”
- **Social / guild gravity** — belonging, biography, officer ritual, spectacle
- **Collection / achievement clarity** — glanceable status without spreadsheet death
- **Classic UI overhaul coexistence** — readable beside ElvUI / default Anniversary chrome

Church of Beef V1 is a **social ladder institution**, not a combat HUD. This doc maps cousin juice onto:

| Beef surface | Job |
|--------------|-----|
| **Ladder** | Macro flock order — seven titles + occupants + “you are here” |
| **My Standing** | Micro progress — title, standing, next threshold, short story lines |
| **Officer Commit** | Authority ritual — evidence → Approve/Reject → confirm when destructive |
| **Toasts + `/g` line** | Spectacle without WA fovea |

---

## 2. Method & provenance

| Source class | Used for |
|--------------|----------|
| In-repo tracks `09`, `13`, `26`, `70`, `01`, `02` | Cousin tear-downs already mapped to Beef |
| CurseForge / Wago / GitHub / author sites | Feature lists & design jobs |
| Parallel web search dumps | Fresh listing snippets (Jul 2026) under [`.raw/`](.raw/) |

**Hard filter:** Steal IA / manners / feedback choreography. Do **not** steal loot automation, combat CLEU density, Retail-only APIs, tip jars, or center-screen WA pulses (already banned in the agent UI brief).

---

## 3. Case-study roster (12)

| # | Addon | Juice category | Closest Beef surface |
|---|-------|----------------|----------------------|
| 1 | AllTheThings | Collection progression | My Standing “what’s next” + micro celebration |
| 2 | Overachiever | Achievement tracking | Standing criteria / tooltips / suggestions |
| 3 | CanIMogIt (+ Rarity cluster) | Glanceable collect status | Rank eligibility chips / row badges |
| 4 | Attune | Shared progress survey | Ladder vs Standing split + BeefNet soft-dep |
| 5 | Gargul | Officer decision speed | Commit queue density + confirm |
| 6 | RCLootCouncil | Transparent judgment ritual | Officer pending list IA (not voting parliament) |
| 7 | Guild Roster Manager | Social biography | Ladder rows as flock biography lite |
| 8 | Immersion | Flavor pacing | Ceremony / toast skip-friendly timing |
| 9 | AtlasLoot Classic + Auctionator | Tabbed tool windows | `/beef` tab IA |
| 10 | WeakAuras (manners only) | One-shot feedback | Private edge toasts |
| 11 | ElvUI | Full UI overhaul coexistence | Chrome rules for V1 plain frames |
| 12 | Details! | Density antipattern | What Standing / Officer must never become |

Composite product Beef should feel like (from track 13):

> **Attune’s guild readiness table** + **Gargul’s officer decision queue** + **TRP3/GRM directory browse** — without loot automation, MSP prose spam, or meter density.

---

## 4. Case studies

### 4.1 AllTheThings — collection completion as dopamine loop

**Links:** [GitHub — AllTheThings](https://github.com/ATTWoWAddon/AllTheThings) · [CurseForge](https://www.curseforge.com/wow/addons/all-the-things)  
**Design job:** Make “what am I missing / what just completed” more presentable than Blizzard’s native collections UI.

**What creates juice**

- Hierarchical **collections window** (movable/resizable) + **auto minilist** for ambient progress ([GitHub features](https://github.com/ATTWoWAddon/AllTheThings)).
- Tooltip enrichment (models, icons, descriptions) so the world itself teaches completion state.
- Optional **fanfare** on learn — celebration as a discrete event, not a permanent HUD.

**Steal for Beef**

| Steal | Apply |
|-------|--------|
| Macro board + micro minilist | Ladder = macro; My Standing = personal micro board |
| “Missing → next action” framing | Next-threshold line (“12 to Beef Knight”) as hero microcopy |
| Celebration on *meaningful* acquire | Toast + `/g` on **rank commit**, not per standing drip |
| Presentable vs Blizzard default | Plain Classic chrome that still reads clearer than chat-only |

**Avoid**

- Database-module sprawl and filter oceans in V1.
- Fanfare / SFX as V1 default (spec: silent; optional post-V1, default off).
- Treating completion % as the brand — Beef brand is **titles**, not completion bars.

---

### 4.2 Overachiever — criteria visibility & contextual suggestions

**Links:** [CurseForge — Overachiever](https://www.curseforge.com/wow/addons/overachiever)  
**Design job:** Make achievement hunting legible — progress in tooltips, suggestions by context, watch lists, related series.

**What creates juice**

- Surfaces **hidden criteria** (“Progress: 5/10”) in tooltips.
- **Suggestions** tab keyed to location / holiday — “what can I do *now*.”
- Series / related browsing so milestones feel like a path, not isolated checkboxes.
- Enhances Blizzard’s frame instead of replacing the whole UI religion.

**Steal for Beef**

| Steal | Apply |
|-------|--------|
| Criteria-in-tooltip energy | Rank / suggestion tooltips: threshold, sources today, pending petition |
| Contextual “Suggestions” | Empty states & Officer queue: teach what earns standing *tonight* |
| Series awareness | Soft “path of titles” language — Fresh → Cooked → Knight… without fake XP bars |
| Watch-list mindset | Officer “pending” is the only watch list that matters in V1 |

**Avoid**

- Auto-tracking spam that fights player intent.
- Achievement-UI chrome wars (Beef owns `/beef`, does not skin Blizzard AchievementFrame).
- Holiday-event complexity in V1.

---

### 4.3 CanIMogIt + Rarity cluster — glanceable status in the wild

**Design job (cluster):** Answer “do I need this?” in one glance while looting / browsing — appearance collected, pet/mount rare drop chase, etc. (CanIMogIt-class tooltip badges; Rarity-class rare-drop trackers.)

**What creates juice**

- Status lives **where attention already is** (tooltip / item), not only in a separate binder.
- Binary or short-state vocabulary (collected / missing / partial) beats paragraphs.
- Chase trackers make rare outcomes feel *noticed* when they finally drop.

**Steal for Beef**

| Steal | Apply |
|-------|--------|
| Short-state chips | Source chips on My Standing (`Instance` / `Ceremony` / `Gora`); pending petition badge |
| World-adjacent feedback | Private toast when suggestion opens or commit lands — still edge, not center WA |
| Rare-event notice | Prophet / Council appoint / demote get heavier confirm + copy than Cooked Beef |

**Avoid**

- Rainbow item-quality coloring for ranks (banned; class color on **names** only).
- Tooltip essays — chips + one line max.
- Persistent “need” overlays on nameplates / world.

---

### 4.4 Attune — personal tree vs guild readiness table

**Links:** [CurseForge — Attune](https://www.curseforge.com/wow/addons/attune) · tear-down [`13/attune.md`](../wow-classic-addon-design/13-cousin-addon-teardowns/attune.md)  
**Design job:** Personal attunement progress + optional guild/party/raid **survey** of who is stuck where.

**What creates juice**

- Clean split: **my progress** vs **group readiness** vs (later) action tools.
- Soft dependency — non-installers do not soft-lock the raid.
- Celebrate completion with optional chat announce; survey is episodic pull, not constant spam.

**Steal for Beef**

| Steal | Apply |
|-------|--------|
| My progress ≠ group board | My Standing vs Ladder tabs (already locked) |
| Self-reported = advisory | Standing = testimony; Officer Commit = truth |
| Soft dependency | Guild night works without 100% COB install; `/g` line is the public layer |
| Survey / pull sync spirit | BeefNet login pull — not SCORE spam |

**Avoid**

- Raid planner / invite tools in V1.
- Website export as authority.
- Assuming a survey snapshot is forever-correct without revisions (Beef ranks persist — need revisioned commits).

---

### 4.5 Gargul — single-authority Commit theater

**Links:** [CurseForge — Gargul](https://www.curseforge.com/wow/addons/gargul) · tear-down [`13/gargul.md`](../wow-classic-addon-design/13-cousin-addon-teardowns/gargul.md)  
**Design job:** Fast master-loot decisions with visible rolls, notes, Award + confirm; only ML needs it for most features.

**What creates juice**

- One screen: subject + evidence/list + action + short note + **confirm on Award**.
- Soft dependency — public `/roll` still works for non-installers.
- Announce ownership (who speaks) prevents chat storms.
- Roller widget is brief and hideable — manners without center HUD.

**Steal for Beef**

| Steal | Apply |
|-------|--------|
| Select → evidence → Commit | Officer tab Approve / Reject flow |
| Confirm friction scaled to risk | Demote / Council / Prophet / wipe → StaticPopup; routine Cooked approve can be lighter |
| Single announcer | Officer client sends throttled `/g` promote line |
| Soft dependency | Non-COB members still understand the guild-chat sentence |

**Avoid**

- SoftRes / GDKP / PackMule / autoloot gravity.
- Raid-warning severity for comedy ranks.
- Requiring every member to install for the rite to “count” socially (public chat covers spectacle).

---

### 4.6 RCLootCouncil — transparent judgment (contrast + steal IA)

**Links:** [rclootcouncil.com](https://rclootcouncil.com/) · [CurseForge Classic](https://www.curseforge.com/wow/addons/rclootcouncil-classic)  
**Design job:** Session-based council: candidates respond; council votes; history survives drama.

**What creates juice**

- Pending queue with **who / claim / context / decide**.
- Observe mode — spectators understand the ritual without holding the gavel.
- Logged judgment reduces “officer whim” narratives.

**Steal for Beef**

| Steal | Apply |
|-------|--------|
| Pending-list IA | Officer suggestion rows: player, from→to, breakdown, recent events |
| Judgment + log > autopilot | Hybrid ladder already locked — keep human Commit |
| Session clarity | Rites / suggestions feel live; don’t auto-close offline |

**Avoid**

- Multi-voter parliament UI for V1 ranks (Beef is Gargul-ML shaped, not full RCLC).
- Gear-comparison density.
- Requiring raid-wide install for the ritual to function.

---

### 4.7 Guild Roster Manager — biography as belonging

**Links:** [guildrostermanager.com](https://www.guildrostermanager.com/) · [CurseForge](https://www.curseforge.com/wow/addons/guild-roster-manager) · landscape [`09/addon-landscape.md`](../wow-classic-addon-design/09-guild-social-community/addon-landscape.md)  
**Design job:** Turn the flat roster into biography + audit trail (alts, promo history, joins/leaves, notes, inactivity).

**What creates juice**

- **History** makes membership feel persistent (“who did what and when”).
- Mouseover enrichment — Main/alts/rank history without opening a second app.
- Sync among addon users with rank-gated edit privileges.
- Classic / Anniversary / Hardcore awareness — social tools that respect mode.

**Steal for Beef**

| Steal | Apply |
|-------|--------|
| Biography lite | Ladder occupants + My Standing recent rites as V1 “flock memory” |
| Officer-gated edits | Only Officer+ Commit mutates official ranks |
| Mouseover detail | Tooltip on ladder name: title, standing band, pending? |
| Change log energy | Revision / last bless footer — not full CRM |

**Avoid**

- Full alt CRM / ban lists / mass kick tools in V1.
- Autopilot promote/kick (Guild Manager pattern) — kills sacred theater.
- Competing with GRM for roster real estate; coexist.

---

### 4.8 Immersion — skip-friendly flavor pacing

**Links:** [WoWInterface — Immersion Classic](https://www.wowinterface.com/downloads/info24931-ImmersionClassic.html)  
**Design job:** Replace wall-of-text quest/gossip with talking-head pacing; skip/advance without blocking progress.

**What creates juice**

- Flavor is **optional theater** — one button / click advances.
- Inspired by Blizzard talking-head, not a new combat language.
- Does not require reading the novel to accept the quest.

**Steal for Beef**

| Steal | Apply |
|-------|--------|
| Skip-friendly liturgy | Ceremony stubs finish in seconds; no modal novel on Commit |
| Talking-head manners for flavor | Post-V1 pageantry can be ornate **and** dismissible |
| Progress never hostage to prose | Officers can Commit without watching a cutscene |

**Avoid**

- Hijacking gossip/quest frames for Beef ranks.
- Center-screen Immersion-style dialogue for every +standing tick.
- Immersion as a hard dependency.

---

### 4.9 AtlasLoot Classic + Auctionator — tabbed tool-window grammar

**Design job:** Dense reference (loot tables) and frequent utility (AH) that still feel like **Classic tool windows** — tabs, lists, summary panes — not installers or combat HUDs.

**What creates juice**

- Predictable IA: open → tab → scan → act.
- Auctionator-like **summary + recent lines** for “what just happened.”
- Item-quality color used sparingly as hierarchy — not rainbow noise everywhere.

**Steal for Beef**

| Steal | Apply |
|-------|--------|
| Tabbed tool window | Ladder / My Standing / Officer+ |
| Summary + recent lines | My Standing layout (track 70 recommendation) |
| Soft hierarchy accents | Later heraldic left-rule / title weight — not neon |

**Avoid**

- Auction-spreadsheet column counts on standing history.
- AtlasLoot-depth loot matrices for comedy ranks.
- Treating Beef as an “installer” wizard (ElvUI first-run anti-pattern for this product).

---

### 4.10 WeakAuras — manners, not real estate

**Design job (as culture):** Scriptable, high-signal combat overlays. **For Beef:** only the feedback manners matter.

**What creates juice (stealable)**

- Brief → hold → clear choreography.
- Progressive disclosure — important then gone.
- Players already trust “something happened” from a short flash.

**Steal for Beef**

| Steal | Apply |
|-------|--------|
| One-shot timing | Private edge toast on suggestion / commit / credit |
| Cap visible noise | One toast; no stack storms |
| High contrast | Opaque toast; stream-readable |

**Avoid**

- Center-screen pulses, screen flash, persistent proc icons (explicit V1 ban).
- WeakAuras dependency or “import this pack” as product.
- Competing with DBM/WA for the fovea during combat.

---

### 4.11 ElvUI — coexistence & polish pole (not brand)

**Links:** [tukui.org/elvui](https://tukui.org/elvui)  
**Design job:** Full UI replacement; dominant “modern Classic” look.

**What creates juice**

- Unified tokens, movable everything, clean density — players feel *in control* of layout.
- Media registration patterns (embed + optional SharedMedia).

**Steal for Beef**

| Steal | Apply |
|-------|--------|
| Unique frames + saved position + clamp | `/beef` movable; guest on player `uiScale` |
| Coexist, don’t skin the world | No global Blizzard skinning; LibDBIcon-friendly minimap |
| Optional media later | V1 plain FrameXML; post-V1 `Media/` with fallbacks |

**Avoid**

- Matching ElvUI grey as “brand.”
- Hard dependency on ElvUI / Masque / SharedMedia.
- Fighting bag/chat modules.

**Mantra (from track 02):** *Framed like a Classic tool window; dressed later like a ridiculous cathedral.*

---

### 4.12 Details! — density antipattern (study to reject)

**Design job:** Combat metering — maximum analytic density for performance debate.

**Why it feels “juicy” to some players**

- Sparklines, breakdowns, multi-window layouts, endless drill-down.
- Social status via parse — toxic cousin of a ladder.

**For Beef — reject the shape**

| Reject | Why |
|--------|-----|
| Meter windows / sparklines for standing | Turns comedy church into parse culture |
| Multi-monitor officer dashboards | Officer tab is a liturgy roster, not Details! |
| Standing-as-HP / castbar skins | Fights ElvUI; looks like combat UI |
| “Why N” as a pie chart essay | Short event list + source chips only (track 70) |

Use Details! as the **review checklist red flag**: if a Standing or Officer mock looks like a meter, redraw it.

---

## 5. Cross-case pattern matrix

| Pattern | Best exemplars | Beef V1 default |
|---------|----------------|-----------------|
| Macro board + micro progress | ATT, Attune, leaderboard UX research | Ladder + My Standing |
| Advisory data → human commit | Attune, Gargul, RCLC | Standing → suggestion → Officer+ |
| Soft dependency / public layer | Gargul rolls, Attune survey, `/g` announces | BeefNet among users; chat for all |
| Short-state chips | CanIMogIt cluster, Overachiever criteria | Source chips + pending badge |
| Biography / history | GRM | Recent rites + last bless |
| Skip-friendly flavor | Immersion | Thin ceremony; no modal novels |
| Toast manners | WA / BigWigs culture | Edge toast, silent, one-at-a-time |
| Tabbed Classic tool | AtlasLoot, Auctionator | Three tabs |
| Full UI skin | ElvUI | Coexist only |
| Analytic density | Details! | **Reject** |

---

## 6. Top 15 transferable lessons (implementer shortlist)

1. **Split macro flock from micro self** — Ladder shows titles/occupants; My Standing shows *my* next step and story (Attune / ATT / leaderboard UX).
2. **Titles are the juice; numbers are eligibility** — Never let raw standing dominate chrome (track 26 ranking UX).
3. **“You are here” beats unreachable elites** — Local highlight + nearest-band context; don’t hero an all-time points sort.
4. **Advisory → Commit is the social anti-cheat** — Cousins agree: client testimony is not sacred until a human awards (Attune / Gargul / spec §6.3).
5. **Officer UI = select → evidence → act → confirm-on-risk** — Gargul Award density; RCLC pending IA; no voting parliament in V1.
6. **Reject without erasing progress** — Clear the petition; keep standing (spec + cousin honesty).
7. **Soft dependency is a feature** — Non-installers still get the `/g` rite; BeefNet is for addon peers only.
8. **One announcer, throttled plain text** — Spectacle is chat-native; avoid multi-client storms (Gargul announce ownership).
9. **Celebrate commits, not drips** — ATT fanfare / Overachiever ding energy belongs on rank change, not every +2 standing.
10. **Short-state chips > essays** — Source badges and pending flags (CanIMogIt cluster); tooltip one-liners (Overachiever criteria).
11. **Story lines explain “why N”** — ~10 recent rites, not Details! breakdowns (track 70).
12. **Biography lite creates belonging** — GRM history energy as last-bless + event list; not a full CRM.
13. **Flavor must be skippable** — Immersion pacing for any ceremony copy; Commit never waits on liturgy.
14. **Toast manners, edge placement** — WA timing without WA real estate; opaque, brief, singular.
15. **Classic tool window beside ElvUI; never become Details!** — Plain FrameXML tabs; unique frames; no meter/HP metaphors for standing.

---

## 7. Surface checklist (Ladder / Standing / Commit)

| Surface | Do (from cases) | Don’t |
|---------|-----------------|-------|
| **Ladder** | Seven scannable bands; occupants; local highlight; mouseover lite (GRM/Attune) | Raid-frame grid; points spreadsheet; Questie pin spam |
| **My Standing** | Title · standing · next · source chips · ~10 lines (ATT micro + Auctionator summary) | Hero StatusBar-as-castbar; Details! history; silent progress |
| **Officer Commit** | Pending queue + breakdown + Approve/Reject + risk-scaled confirm (Gargul/RCLC) | Autopilot promote; council vote UI; loot-economy modules |
| **Spectacle** | Officer `/g` + private toast (Gargul + WA manners) | Center WA; per-point guild spam; Immersion modal for +standing |

---

## 8. Related in-repo reading

| Doc | Why |
|-----|-----|
| [`13-cousin-addon-teardowns/steal-avoid-for-beef.md`](../wow-classic-addon-design/13-cousin-addon-teardowns/steal-avoid-for-beef.md) | Composite Attune+Gargul+TRP3 map |
| [`09-guild-social-community/implications-for-church-of-beef.md`](../wow-classic-addon-design/09-guild-social-community/implications-for-church-of-beef.md) | Belonging / shoutout / scarcity |
| [`26-ladders-points-gamification/ranking-ux.md`](../wow-classic-addon-design/26-ladders-points-gamification/ranking-ux.md) | Leaderboard psychology |
| [`70-standing-breakdown-ui/beef-v1-recommendation.md`](../wow-classic-addon-design/70-standing-breakdown-ui/beef-v1-recommendation.md) | Standing layout verdict |
| [`02-visual-language/03-steal-adapt-matrix.md`](../wow-classic-addon-design/02-visual-language/03-steal-adapt-matrix.md) | Visual steal/reject matrix |
| [`01-ux-patterns/church-of-beef-synthesis.md`](../wow-classic-addon-design/01-ux-patterns/church-of-beef-synthesis.md) | Edge-social tool doctrine |
| [`ui-polished-direction-for-agents.md`](../../superpowers/ui-polished-direction-for-agents.md) | Locked V1 UI doctrine |

---

## 9. Sources (web)

- [AllTheThings — GitHub](https://github.com/ATTWoWAddon/AllTheThings)
- [ALL THE THINGS — CurseForge](https://www.curseforge.com/wow/addons/all-the-things)
- [Overachiever — CurseForge](https://www.curseforge.com/wow/addons/overachiever)
- [Guild Roster Manager](https://www.guildrostermanager.com/)
- [Guild Roster Manager — CurseForge](https://www.curseforge.com/wow/addons/guild-roster-manager)
- [Immersion Classic — WoWInterface](https://www.wowinterface.com/downloads/info24931-ImmersionClassic.html)
- [Attune — CurseForge](https://www.curseforge.com/wow/addons/attune)
- [Gargul — CurseForge](https://www.curseforge.com/wow/addons/gargul)
- [RCLootCouncil](https://rclootcouncil.com/)
- [ElvUI — Tukui](https://tukui.org/elvui)
- Search dumps: [`.raw/competitive-addons-search.json`](.raw/competitive-addons-search.json), [`.raw/competitive-addons-search-2.json`](.raw/competitive-addons-search-2.json)

---

*End of case studies. When a lesson would change product law, log it in the design spec §15 — do not fork policy only into this research file.*
