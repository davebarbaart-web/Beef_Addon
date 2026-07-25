# Parallel Deep Research — Guild / Social / Community Addon Design
**Run ID:** `trun_91f36069f0964480b9da827881728251`  
**Status:** completed  
**Processor:** pro-fast  

---

## 1 guildroster ux belonging identity onboarding

**Pattern: "Enriched Guild Tab"** — augment Blizzard's flat roster with metadata, alts, dates of joining, promotion history, and audit trails.

| Source | What it does (verbatim) | Design lesson |
|---|---|---|
| **Guild Roster Manager** (Wago, updated 2026) — *"Alt/main management, join dates, promo histories. Log of changes in the guild, and many other…"* — https://addons.wago.io/addons/guild-roster-manager / https://addons.wago.io/addons/guild-roster-manager | Tracks alts vs. mains, join dates, promo history; logs every guild change. | Turns the roster from a phone book into a biography. Promotion logs create "history you can show off." |
| **Guild Manager** (CurseForge) — *"Highly configurable (semi) automatic recruitment, kick, ban, promotion, demotion, and announcement system"* — https://www.curseforge.com/wow/addons/guild-management-system | Auto-recruit/kick/ban/promote/demote based on rules. | Codifies rank thresholds so promotion becomes a **rite of passage**, not an arbitrary decision. |
| **GuildEventManager 2.3** (WoWInterface, original kiki fork) — https://www.wowinterface.com/downloads/info11200-GuildEventManager2.3WotLK.html | In-game calendar with sign-ups, attendance, and event creation. | Events become shared calendar objects that live on the roster. |

**Cult/community applicability:** the "rich roster" treats members as people with history (joined date, alts, ranks) rather than disposable toons. This is the single strongest belonging mechanic in any guild addon.

---

---

## 2 calendar helpers ritual cadence

**Pattern: In-game Guild Calendar with sign-up, attendance-tied eligibility, and reminders.**

- **GuildEventManager (GEM)** — *"the official version from kiki"* — hosts recurring sign-ups inside the Blizzard calendar (https://www.wowinterface.com/downloads/info11200-GuildEventManager2.3WotLK.html). It pairs with roster data so players can self-sign for raids.
- **Guilds of WoW** (guildsofwow.com) — *"RSVPs to sync seamlessly between Discord and the in-game calendar"* — Discord bot + in-game addon pair, so RSVPs flow both directions. Demonstrates the **Discord-as-frontend, game-as-engine** bridge (https://guildsofwow.com/).
- **WoWHead Classic Addon Guide** indexes GEM, GuildCalendar, and Plan B as the canonical calendar helpers (https://www.wowhead.com/classic/guide/best-addons-for-classic-wow-fresh).

**Cult/community applicability:** rituals need a *rhythm*. Recurring calendar entries ("Monday raid sign-up", "Friday alt-night") plus sign-up attribution make participation measurable.

---

---

## 3 attendance trackers status obligation

**Pattern: Implicit attendance logging from roster presence + scheduled events.**

- **WebDKP** — *"track raid attendance"* as a first-class feature alongside DKP awarding (https://webdkp.com/addon).
- **GuildEventManager** logs who signed up vs. who showed; this list is the de-facto attendance sheet for Classic guilds.
- **Guilds of WoW** — *"automate event attendance tracking with the Discord bot"* (https://guildsofwow.com/) — attendance is a top-level KPI on the platform.

**Design pattern:** attendance is rarely a separate addon — it piggybacks on the **calendar (who signed up)** and the **DKP table (who got loot)**. Combined, these give officers a single ledger to grade participation.

**Cult/community applicability:** in a cult-themed guild, attendance can become a public "devotion log" — visible streaks, badges, or recognition at thresholds.

---

---

## 4 loot councils status fairness ritual

**Pattern: In-session voting UI with auto-resolve, manual override, and history audit.**

- **RCLootCouncil** — *"facilitate and speed up the loot council process"* (https://rclootcouncil.com/, https://www.curseforge.com/wow/addons/rclootcouncil). Auto-detects tradable loot above threshold, opens a voting frame to council members, logs every decision. Master Looter workflow is one-click.
- **RCLootCouncil – Classic** flavor and **RCLootCouncil – EPGP Classic** are fork variants that bolt EPGP standings onto the same voting UI (https://www.curseforge.com/wow/addons/rclootcouncil-epgp-classic).
- **WebDKP** addon is the classic *DKP* alternative — *"automated bidding support, timed awards, ZeroSum DKP"* (https://webdkp.com/addon).

**Design pattern:** loot is the highest-status resource in any guild. Whether by council vote (subjective, narrative) or DKP/EPGP (objective, math), the *mechanism must be transparent and logged*. Both RCLootCouncil and WebDKP write an immutable history — that history *is* the ritual.

**Cult/community applicability:** replace "loot" with "tribute" or "ranks" — the same voting/ledger pattern creates a fair-distribution ritual that members trust.

---

---

## 5 discord bridges out of game community layer

**Pattern: Bot + game-addon pair, with bi-directional sync.**

- **Guilds of WoW** — *"Discord bot and in-game addon work together, allowing your RSVPs to sync seamlessly between Discord and the in-game calendar. Integrations"* (https://guildsofwow.com/).
- **Jeeves Bot**, **MythicPlusBot**, and other community bots listed on **top.gg** for WoW (https://top.gg/tag/world-of-warcraft) — typical patterns: roster sync, event reminders, recruitment posting, loot announcements.
- **Cross-Guild Chat** (WoWInterface) — *"allows you to synchronize guild chat across multiple guilds"* — https://www.wowinterface.com/downloads/info18676-CrossGuildChat.html — a precursor pattern: chat bridges as social glue.

**Design pattern:** Discord is the *home*; the game is the *event*. Bridges mirror (a) calendar RSVPs, (b) chat highlights, (c) loot decisions, (d) shoutouts/recognition events. The bridge is typically a bot that posts into Discord channels on triggers fired by the in-game addon (COMBAT_LOG_EVENT, CHAT_MSG_GUILD, etc.).

**Cult/community applicability:** the Discord server *is* the meeting hall; the addon is the pulpit. Configure channels for "tribute," "devotion," "initiations," "shoutouts" — and bind each to an in-game trigger.

---

---

## 6 community reputation and fun systems status inside jokes

**Pattern: Surface-and-react recognition + persistent reputation.**

- **Guild Achieve Congratulator** (CurseForge) — *"Automatically congratulate your guildies on their achievements with hilarious, sarcastic messages! When a guild member earns an achievement, Guild Achieves waits 1-3 seconds (to seem human) and then sends a randomly selected funny congratulation to guild chat."* — https://www.curseforge.com/wow/addons/guild-achieves. This is a *chat-bot ritualizer* — it produces shared humor on every achievement.
- **GuildRepair** / **GuildBankLedger** — meta-meta: *"Persistent guild bank transaction logging with automatic multi-player sync"* (https://www.curseforge.com/wow/addons/guild-bank-ledger). The shared ledger of who-takes-what is a *reputation surface*.
- **GuildEventManager** + **DKP** logs combined = "your standing in the guild" is publicly derivable.

**Design pattern:** reputation in classic-era guild addons is *emergent* — derived from attendance %, loot received, and contribution logs. The addon shouldn't invent reputation; it should **publish it visibly** (leaderboards, /gkp dumps, anniversaries).

**Cult/community applicability:** lean into inside-joke name lists (Guild Achieve Congratulator's snarky messages), titles earned at attendance thresholds, and visible "devotion meters."

---

---

## 7 shoutouts and recognition rituals

**Pattern: Triggered broadcast events tied to milestone events.**

- **Guild Achieve Congratulator** (above) — the canonical "shoutout on event" pattern: listen for ACHIEVEMENT_EARNED, throttle, post to guild chat.
- **GuildEventManager** — broadcasts sign-up status changes (a member committed / dropped from a raid), which is a "shoutout" of participation.
- **Guilds of WoW** "Discord bot + addon" — automated reminders and RSVPs serve as public shoutouts (https://guilds of WoW.com/).
- **GuildGreet Extended** (legacy-wow) — *"keeps track of main and alt characters in your guild and reminds you to greet them and congratulate them on level up"* — https://legacy-wow.com/wotlk-addons/guildgreet-extended — a *proactive greeting ritual* the addon enforces.

**Design pattern:** any time a guild event happens (achievement, level-up, promotion, item won), an addon can broadcast a templated message into guild chat. The list of triggers is the ritual calendar.

**Cult/community applicability:** the shoutout template is where the cult's *vernacular* lives ("The Order welcomes Brother X to the Inner Circle" instead of "Grats on lvl 60!").

---

---

## 8 belonging rituals status shared identity synthesis

The deeper design patterns that emerge across the cited addons:

| Pattern | Mechanism | Cited reference |
|---|---|---|
| **Persistent identity** | Track join date, alts, promotion history | Guild Roster Manager (Wago) |
| **Threshold-based rites of passage** | Auto-promote, auto-demote, auto-invite based on attendance / level | Guild Manager (CurseForge) |
| **Public ledger of contribution** | Show who took what, who attended what | WebDKP, GuildBankLedger |
| **Scheduled ritual cadence** | Calendar-driven events with sign-ups | GuildEventManager, Guilds of WoW |
| **Recognition ritual on milestones** | Auto-announce achievements, level-ups, promotions | Guild Achieve Congratulator, GuildGreet Extended |
| **Status by accumulation** | DKP / EPGP / attendance % as visible score | WebDKP (DKP), WoWWiki EPGP, RCLootCouncil – EPGP |
| **Bicameral community** | Discord channel ↔ in-game channel mirroring | Guilds of WoW bridge pattern |
| **Voting as ritual** | Loot council vote with logged history | RCLootCouncil |
| **Shared inside language** | Templated bot messages with custom flavor text | Guild Achieve Congratulator |
| **Collective memory** | Calendar history + ledger history + roster history | All of the above |

---

---

## notable addons by category with urls

| Category | Addon | URL |
|---|---|---|
| Loot council | RCLootCouncil (Retail / Classic / EPGP Classic) | https://rclootcouncil.com/ · https://www.curseforge.com/wow/addons/rclootcouncil · https://www.curseforge.com/wow/addons/rclootcouncil-classic · https://www.curseforge.com/wow/addons/rclootcouncil-epgp-classic |
| DKP / loot | WebDKP (in-game addon + web sync) | https://webdkp.com/addon |
| EPGP system | WoWWiki EPGP article | https://wowwiki-archive.fandom.com/wiki/EPGP |
| Calendar / events | GuildEventManager 2.3 (kiki) | https://www.wowinterface.com/downloads/info11200-GuildEventManager2.3WotLK.html |
| Roster | Guild Roster Manager | https://addons.wago.io/addons/guild-roster-manager |
| Recruitment automation | Guild Manager | https://www.curseforge.com/wow/addons/guild-management-system |
| Recognition fun | Guild Achieve Congratulator | https://www.curseforge.com/wow/addons/guild-achieves |
| Greeting ritual | GuildGreet Extended | https://legacy-wow.com/wotlk-addons/guildgreet-extended |
| Guild bank history | Guild Bank Ledger | https://www.curseforge.com/wow/addons/guild-bank-ledger |
| Cross-guild chat | Cross Guild Chat | https://www.wowinterface.com/downloads/info18676-CrossGuildChat.html |
| Platform | Guilds of WoW (web + Discord + addon) | https://guildsofwow.com/ |
| Addon index | WoWHead Classic Addon Guide | https://www.wowhead.com/classic/guide/best-addons-for-classic-wow-fresh |

---

---

## cult community themed social addon pattern checklist

If the goal is to design an addon that creates a *cult-like* or tight-knit *community-themed* social guild addon for Classic/TBC Classic, the design should combine these primitives (each is grounded in a real, cited addon above):

1. **Enriched roster** (alts, join dates, rank history, audit log) — *Guild Roster Manager*.
2. **Auto-greetings and milestone shoutouts** (level-up, achievement, promotion, attendance streak) — *Guild Achieve Congratulator*, *GuildGreet Extended*.
3. **Ritual calendar** with sign-ups + reminders (recurring raids, weekly devotions, initiation nights) — *GuildEventManager*, *Guilds of WoW*.
4. **Discord bridge** so the cult lives in chat even when not in-game — *Guilds of WoW*.
5. **Voting ritual** for scarce resources (loot council, officer elections, dispute resolution) — *RCLootCouncil*.
6. **Ledger of contribution** (attendance, loot, currency) for status transparency — *WebDKP / EPGP*.
7. **Public reputation score** (derived from attendance %, contribution, tenured membership) — synthesized from *WebDKP* and *Guild Bank Ledger*.
8. **Shared inside-language** (templated bot messages with customizable flavor text) — *Guild Achieve Congratulator*.
9. **Persistent logs of changes** (who joined/left, who got promoted, who got what) — *Guild Roster Manager*, *Guild Bank Ledger*.
10. **Threshold-triggered ceremonies** (auto-promotion, auto-demotion, initation on promotion) — *Guild Manager*.

The unifying principle: in every cited addon, **belonging** comes from *making the invisible visible* — turns, alts, attendance, loot, tenures. A cult-themed guild addon for Classic should therefore treat **every member action as a publishable event** in a shared ledger, and use calendar + Discord bridges so the ritual cadence is enforced outside the game as well.

---

## Basis confidence notes

- **1_guildroster_ux_belonging_identity_onboarding**: confidence=high
- **2_calendar_helpers_ritual_cadence**: confidence=high
- **3_attendance_trackers_status_obligation**: confidence=medium
- **4_loot_councils_status_fairness_ritual**: confidence=medium
- **5_discord_bridges_out_of_game_community_layer**: confidence=high
- **6_community_reputation_and_fun_systems_status_inside_jokes**: confidence=medium
- **7_shoutouts_and_recognition_rituals**: confidence=high
- **8_belonging_rituals_status_shared_identity_synthesis**: confidence=medium
- **notable_addons_by_category_with_urls**: confidence=medium
- **cult_community_themed_social_addon_pattern_checklist**: confidence=medium
