# Patterns: Belonging, Rituals, Status & Shared Identity

**Last updated:** 2026-07-25  
**Sources:** Parallel deep research ([`.raw/guild-social-deep.md`](.raw/guild-social-deep.md)), primary addon pages cited below.

---

## Unifying principle

Across successful Classic guild/social tools, **belonging comes from making the invisible visible**: join dates, alts, attendance, loot/standing, promotions, and tenure. A cult/community-themed addon should treat meaningful member actions as **publishable events in a shared ledger**, then give those events a **voice** (templated shoutouts) and a **rhythm** (calendar / recurring ceremonies).

---

## Pattern catalog

### 1. Enriched Guild Tab (persistent identity)

**Mechanism:** Augment Blizzard’s roster with biography fields — alt/main, join date, promotion history, custom notes, change log.  
**Exemplar:** [Guild Roster Manager](https://addons.wago.io/addons/guild-roster-manager) — “Alt/main management, join dates, promo histories. Log of changes in the guild…”  
**Belonging effect:** Members feel like people with history, not disposable toons.  
**Status effect:** Promotion history is something you can “show off.”  
**Church of Beef:** Ladder rows + titles + standing breakdown are the V1 biography. Defer GRM-scale CRM (birthdays, ban lists, exports).

### 2. Threshold rites of passage

**Mechanism:** Rules or suggestions fire when a numeric or qualitative threshold is crossed; advancement is framed as initiation, not a silent DB write.  
**Exemplars:** Guild management automation ([CurseForge guild-management-system](https://www.curseforge.com/wow/addons/guild-management-system)); DKP/EPGP threshold cultures ([EPGP wiki](https://wowwiki-archive.fandom.com/wiki/EPGP)).  
**Belonging effect:** “I earned my place” + “the clergy recognized me.”  
**Church of Beef:** Already specified — point-driven ranks 1–5 suggest; Council/Prophet are appointed/bestowed (scarcity = prestige). Officer approval is the rite.

### 3. Ritual cadence (calendar + signup)

**Mechanism:** Recurring events with accept/decline and countable signups.  
**Exemplars:** [Group Calendar](https://www.warcrafttavern.com/wow-classic/addons/groupcalendar/), [GuildEventManager](https://www.curseforge.com/wow/addons/guild-event-manager), [Guilds of WoW RSVP sync](https://guildsofwow.com/).  
**Belonging effect:** The community has a heartbeat (raid night, ceremony night).  
**Church of Beef:** Ceremony start/close + instance co-play drip create cadence without a full calendar in V1. Later: recurring “Eternal Grazing” / confession nights.

### 4. Obligation made legible (attendance)

**Mechanism:** Signup list × presence × credit ledger. Rarely a standalone addon.  
**Exemplars:** WebDKP attendance ([webdkp.com/addon](https://webdkp.com/addon)); GEM signup-vs-show; GoW Discord attendance automation ([help.guildsofwow.com](https://help.guildsofwow.com/Home)).  
**Status effect:** Streaks and % become soft reputation.  
**Church of Beef:** Shared-instance buckets + ceremony marks are the devotion log. Keep anti-AFK so “devotion” isn’t parking at the stone.

### 5. Scarce-resource ritual (council vote + history)

**Mechanism:** Session UI → candidate responses → council votes → award → immutable history.  
**Exemplar:** [RCLootCouncil](https://github.com/evil-morfar/RCLootCouncil2/wiki) — Loot Frame / Voting Frame / Session Frame; Observe mode for transparency.  
**Status effect:** Fairness theater — drama dies when the log is public-enough.  
**Church of Beef:** Replace loot with **rank commits**. Officer tab = council chamber. Revisioned `RANK_COMMIT` history = the audit trail.

### 6. Contribution vs consumption (EP/GP split)

**Mechanism:** Earn from showing up; spend (or separate) when receiving scarce rewards.  
**Exemplar:** EPGP ([wiki](https://wowwiki-archive.fandom.com/wiki/EPGP)).  
**Identity effect:** Status isn’t “loot goblin”; it’s “reliable flock member.”  
**Church of Beef:** Standing rises from Gora/ceremony/instances; top seats are not purchasable with grind. Optional future “Lent” reset ≈ seasonal EP decay.

### 7. Peer survey sync (shared progress without soft-lock)

**Mechanism:** Addon users answer a survey/sync; non-users are simply invisible to that layer.  
**Exemplar:** [Attune](https://www.curseforge.com/wow/addons/attune) guild survey ([forum description](https://us.forums.blizzard.com/en/wow/t/attune-addon-track-your-attunement-progress/883832)).  
**Belonging effect:** “We’re climbing the same path together.”  
**Church of Beef:** BeefNet HELLO / SYNC_* already encode this. Never require the addon for dungeon night.

### 8. Recognition shoutouts (triggered vernacular)

**Mechanism:** On milestone → short delay → templated guild-chat line.  
**Exemplars:** [Guild Achieve Congratulator](https://www.curseforge.com/wow/addons/guild-achieves) (funny delayed grats); [GuildGreet Extended](https://legacy-wow.com/wotlk-addons/guildgreet-extended) (greet/level-up prompts).  
**Identity effect:** Shared language becomes the cult’s voice.  
**Church of Beef:** Spec already mandates throttled promotion/demotion announcements in guild chat from the approving officer. Template voice = scripture tone (“The Church recognizes…”).

### 9. Bicameral community (Discord hall / game pulpit)

**Mechanism:** Bot + optional in-game addon; RSVPs, reminders, logs mirror both ways.  
**Exemplar:** [Guilds of WoW](https://guildsofwow.com/) — Discord bot and in-game addon sync calendar RSVPs.  
**Belonging effect:** Community exists when nobody is logged in.  
**Church of Beef:** Conceptual for V1 (hard in-game rule). Design shoutouts and ceremony names so they *copy-paste* into Discord/stream titles without a bridge.

### 10. Collective memory

**Mechanism:** Roster history + calendar history + standing/loot history.  
**Exemplars:** GRM log + RCLC history + bank ledgers ([Guild Bank Ledger](https://www.curseforge.com/wow/addons/guild-bank-ledger)).  
**Identity effect:** The guild has a past you can retell on stream.  
**Church of Beef:** V2 ceremonial dashboard / scripture is the spectacle layer on top of V1’s revisioned ladder state.

---

## Pattern → emotion map (for cult theme)

| Desired feeling | Pattern to lean on | V1 surface |
|-----------------|--------------------|------------|
| “I’m part of the flock” | Enriched identity, greetings | Ladder highlight, title, My Standing |
| “Tonight matters” | Ritual cadence | Ceremony start/close, Gora |
| “Showing up is holy” | Attendance → standing | Instance drip + caps |
| “Judgment is fair” | Council + audit | Officer approve/reject + revisions |
| “Prestige is scarce” | Appointed top seats | Beef Council / Prophet |
| “Everyone heard it” | Shoutout vernacular | Guild-chat promotion line |
| “We remember” | Collective memory | Cached ladder + event log (thin) |

---

## Anti-patterns (social)

| Anti-pattern | Why it kills belonging | Seen in / risk |
|--------------|------------------------|----------------|
| Silent rank changes | No spectacle → no identity | Spec calls this a V1 failure mode |
| Full autopilot promote/kick | Feels bureaucratic, not sacred | Guild Manager-style automation |
| Spreadsheet-only standing | Invisible in-game | Pure WebDKP without in-game voice |
| Requiring every member install | Soft-locks social nights | Contrast Attune/Gargul graceful degrade |
| High-frequency chat spam | Ritual becomes noise | Unthrottled congratulator bots |
| Combat-HUD placement | Social tool fights for center screen | Wrong gravity vs chat/minimap tools |
