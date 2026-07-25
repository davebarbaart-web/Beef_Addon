# Common guild-night tooling (stack Beef should coexist with)

**Question:** How do Classic / Anniversary guilds actually run a scheduled night?  
**Answer short:** **Discord owns RSVP + reminders**; optional in-game calendar addons mirror or ignore that; loot/attendance trackers sit beside raid night; Beef should sit in the **ritual/points** slot, not the signup slot.

## Layer model

```
[Discord / web RSVP]  →  who said they'd come
[In-game calendar addon] → optional mirror / invite / holiday UI
[Raid invite + instance] → who actually showed
[Attendance / DKP-EPGP / Beef] → who gets credit in *that system's* ledger
```

Track 09 covers Discord as *community*. This note only maps Discord/web as **event pipes**.

## In-game scheduling addons

| Tool | Role | Notes for Beef |
|------|------|----------------|
| [Group Calendar](https://www.warcrafttavern.com/wow-classic/addons/groupcalendar/) lineage | Signup calendar, Accept/Decline, invite helpers, trust who can create | Classic ports often **single-guild only** after addon CHANNEL bans |
| [Group / Guild Calendar for Classic Continued](https://www.curseforge.com/wow/addons/group-guild-calendar-for-classic-continued) | MoP Classic continuation of same idea | Attendance categories + alt schedule view |
| [Classic Calendar](https://www.curseforge.com/wow/addons/classic-calendar) / [Revived](https://www.curseforge.com/wow/addons/classic-calendar-revived) | Blizzard_Calendar UI on Era/BCC; holidays injected | Guild may use for raids/holidays; Beef still uses officer ceremony close |
| [ClassicCalender_TBC](https://www.curseforge.com/wow/addons/classiccalender-tbc) | Anniversary TBC raid/dungeon listings | Scheduling UX cousin, not a points system |
| Guild Event Manager (legacy) | “I’ll be there” counts for instances ([CurseForge](https://www.curseforge.com/wow/addons/guild-event-manager)) | Pattern ancestor; do not revive as Beef feature |

## Out-of-game scheduling (usually primary)

| Tool | Role | Steal for Beef? |
|------|------|-----------------|
| [Guilds of WoW](https://guildsofwow.com/features) | Web events + Discord bot RSVP + **bidirectional in-game calendar RSVP** via their addon | Steal *nothing* for V1 sync; note that serious guilds already paid for RSVP |
| [Raidify Discord bot](https://www.raidify.app/discord-bot) | Classic-friendly raid signup, 24h/2h/1h reminders, role roster, confirm-roster | Cadence of reminders is a UX lesson for ceremony *announce* timing — not for BeefNet spam |
| [Guild Manager](https://guildmanager.app/games/wow) | Raid calendar, activity points, Discord | Reminder that “activity points” products exist — Beef is *spectacle ranks*, not another AP ledger |
| Generic EventBot / RemindMe-class bots | Polls, RSVP reactions, reminders | Good enough for many casual guilds; Beef must work when this is the only scheduler |

## Attendance / raid-night cousins (adjacent, not calendar)

| Tool | Role | Boundary |
|------|------|----------|
| [Guild Raid Attendance](https://www.curseforge.com/wow/addons/guild-raid-attendance) | Manual/auto raid logs, attendance editor | Credit for *raids*; Beef ceremony is officer-marked |
| CT_RaidTracker / GuildLaunch Classic ports | Boss/loot/attendance export into DKP sites | Loot economy — track 26 / 09, not night ritual design |
| EPGP Classic | EP for on-time / presence + decay | Season/decay analogy only → [ritual-cadence-seasons.md](ritual-cadence-seasons.md) |

## What guilds optimize for on a night

Observed product surfaces (from tool marketing + Classic calendar docs):

1. **Before:** recurring event + reminders + role signup  
2. **At invite:** mass-invite from signup list or calendar attendees  
3. **During:** loot + encounters (out of Beef scope)  
4. **After:** attendance locked, points/EP awarded, logs uploaded  

Beef V1 maps cleanly to **(4) ritual credit + ladder spectacle**, with thin ceremony UI at **(2)–(3)**. It should not invent another (1).

## Coexistence rules for Church of Beef

| Rule | Why |
|------|-----|
| No Blizzard/Discord calendar sync | Spec: fully in-game, no external process; also ToS/complexity |
| No competing `/calendar` UI | Guild may already run Classic Calendar or Group Calendar |
| Ceremony title may be free text (“Friday Grazing”) | Officers can match Discord event names by convention |
| Standing from **presence + officer close**, not RSVP | RSVP liars and no-shows are Discord’s problem; officers see who is in the instance/ceremony |
| One guild-chat announce per promotion (throttled) | Spec social check — do not also spam signup reminders |

## Related

- [09-guild-social-community](../09-guild-social-community/) — belonging / Discord culture (broader)
- [14-addon-messaging-beefnet](../14-addon-messaging-beefnet/) — idle guild night ≈ 0 addon msgs until commits
- [26-ladders-points-gamification](../26-ladders-points-gamification/) — points toxicity & EPGP mechanics depth