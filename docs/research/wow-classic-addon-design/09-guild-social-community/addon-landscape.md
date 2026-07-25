# Classic Guild / Social Addon Landscape

**Last updated:** 2026-07-25  
**Purpose:** Catalog of living (or historically foundational) guild/community/social tools and what design job each one does.

---

## 1. Enriched roster & guild identity

### Guild Roster Manager (GRM)

- **Links:** [Wago](https://addons.wago.io/addons/guild-roster-manager), [CurseForge](https://www.curseforge.com/wow/addons/guild-roster-manager)
- **What it is:** The modern “rich guild tab.” Adds alt/main groupings, join dates, promotion histories, custom notes, ban list, inactivity recommendations, export tools, and a guild change log (joins, leaves, rank changes, note edits, level-ups).
- **Sync model:** Data syncs among GRM users in the guild; edit privileges can be limited to trusted ranks ([Wago feature list](https://addons.wago.io/addons/guild-roster-manager)).
- **Design job:** Turn Blizzard’s flat phone-book roster into a **biography + audit trail**.
- **Beef relevance:** Closest cousin to a “ladder as living flock.” V1 does not need GRM’s full CRM surface, but **mouseover detail, history, and officer-gated sync** are the right mental model for BeefNet + ladder rows.

### Guild Manager / guild management automation

- **Link:** [CurseForge — Guild Management System](https://www.curseforge.com/wow/addons/guild-management-system)
- **What it is:** Configurable (semi) automatic recruitment, kick, ban, promotion, demotion, and announcement rules.
- **Design job:** Codify rank thresholds so advancement feels like a **rite of passage** rather than arbitrary officer whim.
- **Beef relevance:** Church of Beef already chose the healthier hybrid — **suggest → Officer+ approve** — rather than silent auto-promote. Steal the *ritual framing*, not the full autopilot.

---

## 2. Calendar, RSVP, ceremony cadence

### Group Calendar (Classic)

- **Links:** [Warcraft Tavern overview](https://www.warcrafttavern.com/wow-classic/addons/groupcalendar/), [WowInterface download](https://www.wowinterface.com/downloads/download25167-GroupCalendar), [Classic Continued port (CurseForge)](https://www.curseforge.com/wow/addons/group-guild-calendar-for-classic-continued)
- **What it is:** In-game calendar for planning, signing up (accept/decline), managing events; single-guild or multi-guild alliance configs historically; continued ports note Blizzard changes that restrict multi-guild use.
- **Features called out on the Continued port:** attendance-by-category views, invite helpers, trust settings for who may create events, local vs server time, alt schedule viewing, `/calendar` + minimap icon ([CurseForge](https://www.curseforge.com/wow/addons/group-guild-calendar-for-classic-continued)).
- **Design job:** Give rituals a **rhythm** and a shared object members can commit to.
- **Beef relevance:** V1’s thin ceremony start/close is the minimal viable ritual object. Later phases can grow toward calendar-like recurrence without becoming a full GEM/GroupCalendar clone.

### GuildEventManager (GEM)

- **Links:** [WoWInterface — GuildEventManager 2.3](https://www.wowinterface.com/downloads/info11200-GuildEventManager2.3WotLK.html), [CurseForge project](https://www.curseforge.com/wow/addons/guild-event-manager)
- **What it is:** Classic-era guild event scheduler: members say “I’ll be there,” leaders count signups for instances; event leader need not be online for subscriptions ([CurseForge description](https://www.curseforge.com/wow/addons/guild-event-manager)).
- **Design job:** Self-service commitment + countable participation.
- **Beef relevance:** Ceremony attendance marks are the Beef analogue of “signed up and showed.”

---

## 3. Attendance & standing economies

### WebDKP

- **Link:** [webdkp.com/addon](https://webdkp.com/addon)
- **What it is:** Classic DKP stack — raid attendance tracking, automated bidding, timed awards, ZeroSum variants, often paired with a web view.
- **Design job:** Make **participation → currency → priority** legible and exportable.
- **Beef relevance:** Beef’s “standing points” are a comedy-church cousin of DKP/EP — but V1 standing is **advisory testimony** gated by officers, not a loot currency.

### EPGP (conceptual system + RCLC extension)

- **Links:** [WoWWiki archive — EPGP](https://wowwiki-archive.fandom.com/wiki/EPGP), [EPGP Classic — RCLootCouncil Extension](https://www.curseforge.com/wow/addons/epgp-classic-rclootcouncil-extension)
- **What it is:** Effort Points / Gear Points — earn EP for showing up/progress, spend GP when awarded loot; priority ≈ EP/GP.
- **Design job:** Separate **contribution** from **consumption** so status isn’t just “who won the most loot.”
- **Beef relevance:** Maps cleanly to “standing accrues from showing up (instances, ceremonies, Gora); prestige ranks are scarce and appointed.” Council/Prophet seats are the intentional break from pure grind — same cultural need EPGP answers with decay/ratios.

### Implicit attendance pattern

Across Classic guild tooling, attendance is rarely a lone-purpose addon. It **piggybacks** on calendar signup sheets + DKP/loot ledgers ([deep research synthesis](.raw/guild-social-deep.md)). Officers grade “who signed / who showed / who got credited.”

---

## 4. Loot council & distribution theater

### RCLootCouncil Classic

- **Links:** [CurseForge](https://www.curseforge.com/wow/addons/rclootcouncil-classic) (~9.1M downloads; Classic / TBC Classic / MoP Classic flavors), [GitHub wiki](https://github.com/evil-morfar/RCLootCouncil2/wiki), [rclootcouncil.com](https://rclootcouncil.com/)
- **What it is:** Session-based loot council: candidates respond on a Loot Frame; council votes on a Voting Frame; ML awards; history/export; Observe mode for non-council viewers ([wiki](https://github.com/evil-morfar/RCLootCouncil2/wiki)).
- **Roles:** Master Looter / group leader configures buttons, council, usage popup; council members vote; candidates mostly see response UI.
- **Design job:** Turn scarce-resource allocation into a **transparent, logged ritual** that survives drama (“who voted for what”).
- **Beef relevance:** Officer suggestion queue ≈ Voting Frame lite. Steal: pending list, actor, context, approve/reject, history — not gear comparison.

### Gargul

- **Links:** [Wago](https://addons.wago.io/addons/gargul), [CurseForge](https://www.curseforge.com/wow/addons/gargul), community writeup [RCLootCouncil vs Gargul (Medium, 2026)](https://medium.com/@rengo_wow_world_of_warcraft/rclootcouncil-vs-gargul-which-wow-loot-addon-should-you-use-f99ac760e944)
- **What it is:** Speed-first master-loot toolkit: SoftRes / TMB / GDKP integrations, roll tracking, trade timers, packmule auto-loot; **only ML needs it for most features** ([Wago](https://addons.wago.io/addons/gargul)).
- **Design job:** Reduce loot friction; optional external sheets (softres.it, thatsmybis).
- **Contrast:** RCLC = deliberative council; Gargul = fast SR/rolls. Church of Beef’s officer gate is philosophically closer to RCLC (judgment + log) than Gargul (speed).

### External soft-reserve sheet (conceptual companion)

- **Link:** [softres.it](https://softres.it/)
- **Pattern:** Out-of-game commitment list imported into the raid tool — same “declare intent before the ritual” energy as ceremony RSVPs.

---

## 5. Shared progress / guild survey

### Attune

- **Links:** [CurseForge](https://www.curseforge.com/wow/addons/attune), [GitHub](https://github.com/hippuli/Attune), [Wago](https://addons.wago.io/addons/attune), [author forum post](https://us.forums.blizzard.com/en/wow/t/attune-addon-track-your-attunement-progress/883832)
- **What it is:** Tracks attunement/key progress; **surveys guild/party/raid** so peers with the addon share where they are on chains.
- **Design job:** Shared status without requiring 100% install — graceful degradation when peers lack the addon.
- **Beef relevance:** Direct analogue to BeefNet: peers with the addon sync; players without it must not soft-lock guild play (already in V1 spec).

---

## 6. Recognition, greetings, fun

### Guild Achieve Congratulator (pattern exemplar; Retail-skewed)

- **Link:** [CurseForge — Guild Achieves](https://www.curseforge.com/wow/addons/guild-achieves)
- **What it is:** On guild achievements, wait 1–3 seconds (to seem human), then post a random funny congratulations line to guild chat.
- **Design job:** Automated **shoutout ritual** with personality and throttle.
- **Beef relevance:** V1’s officer-sent promotion line (“The Church recognizes…”) is the same primitive with cult vernacular. Do **not** spam; do **throttle**; do keep readable without the addon.

### GuildGreet Extended (legacy pattern)

- **Link:** [Legacy-WoW listing](https://legacy-wow.com/wotlk-addons/guildgreet-extended)
- **What it is:** Tracks mains/alts; reminds officers to greet and congratulate level-ups.
- **Design job:** Proactive **hospitality ritual** — the guild notices you.
- **Beef relevance:** Fresh Beef onboarding moments; later “confessions / spotlight” phases.

### Prat 3.0 Classic (chat surface, not guild CRM)

- **Links:** [CurseForge](https://www.curseforge.com/wow/addons/prat-3-0-classic), [Warcraft Tavern](https://www.warcrafttavern.com/wow-classic/addons/prat-3-0/)
- **What it is:** Modular chat enhancement (30+ modules).
- **Beef relevance:** Indirect — Beef’s spectacle lives in **plain guild chat** that Prat users (and non-users) both see. Prefer plain text over custom chat frames.

---

## 7. Platforms outside the client (inspirational)

| Platform | Role | Link |
|----------|------|------|
| Guilds of WoW | Web + Discord bot + in-game addon; bidirectional calendar RSVP | [guildsofwow.com](https://guildsofwow.com/), [help center](https://help.guildsofwow.com/Home) |
| Guild Manager app | Calendar, activity points, Discord, applications | [guildmanager.app/games/wow](https://guildmanager.app/games/wow) |
| CoGM (Classic page) | Roster/events/attendance/DKP-style feature set (platform) | [cogm.app/games/wow-classic](https://cogm.app/games/wow-classic) |

These prove that modern guilds treat **Discord as the meeting hall** and the game as the event floor. Church of Beef V1 stays in-game; the pattern still informs channel naming and future stream tooling.

---

## 8. Quick “who wins which job?” matrix

| Job | Best exemplars | Steal for Beef? |
|-----|----------------|-----------------|
| Member biography | GRM | Yes — history, alts note (later), mouseover density |
| Ritual cadence | Group Calendar, GEM, GoW | Thin ceremony now; calendar later |
| Standing ledger | WebDKP, EPGP | Yes — standing + thresholds; no loot currency |
| Officer judgment UI | RCLootCouncil | Yes — queue, context, vote/approve, log |
| Fast coordination | Gargul | No — wrong philosophy for rank theater |
| Peer survey sync | Attune | Yes — BeefNet graceful degrade |
| Shoutouts | Guild Achieves, GuildGreet | Yes — throttled cult-voice guild chat |
| Out-of-game hall | Guilds of WoW | Conceptual only in V1 |
