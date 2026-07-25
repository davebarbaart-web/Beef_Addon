# Annotated URLs — guild calendar, events, night rituals

Primary sources for track 39. Prefer these when deciding whether Beef should touch calendars or only instrument nights.

## Calendar history and API

| URL | Why it matters for Beef |
|-----|-------------------------|
| https://wowwiki-archive.fandom.com/wiki/Calendar | Canonical product history: calendar added in **3.0.2**; Accept/Decline; guild event creation via Guild Control; mass invite; announcements. Baseline for what “real” calendar UX means. |
| https://wowwiki-archive.fandom.com/wiki/API_CalendarGetDate | Historical date API shape (`weekday, month, day, year`). Useful archaeology; prefer `C_Calendar` on modern clients. |
| https://wowpedia.fandom.com/wiki/API_C_Calendar.AddEvent | Retail-shaped finalize step after `CreatePlayerEvent` / `CreateGuildSignUpEvent`. Document for portability — **probe before depending on Anniversary**. |
| https://warcraft.wiki.gg/wiki/World_of_Warcraft_API | Index mentions `C_Calendar.AddEvent()` among API surface — starting point for wiki.gg deep links when extracts succeed. |
| https://us.forums.blizzard.com/en/wow/t/add-in-game-calendar/1738784 | Player request for Era/SoD native calendar; culture expects addons + Discord, not Blizzard priority. |
| https://github.com/birkholz/ClassicCalendar | **Best Classic-family technical primary:** `C_Calendar` present without UI; what works (player events, lockouts) vs injected (holidays); missing guild event permissions; alarm event never fires. |
| https://www.curseforge.com/wow/addons/classic-calendar | Original CurseForge listing (SoD/Era port); known issues: Guild Announcements/Community unavailable; unmaintained note. |
| https://www.wowinterface.com/downloads/info26678-ClassicCalendar.html | WoWI mirror of Classic Calendar + feature/known-issue list. |
| https://www.curseforge.com/wow/addons/classic-calendar-revived | Maintained revival: Era `11508` + BCC `20505`; guild sync; **guild invites broken since 1.15.3**; officer rank requirements. Closest “living” calendar for Classic-family. |
| https://www.curseforge.com/wow/addons/classiccalender-tbc | TBC **Anniversary** fork: Kara→Sunwell + heroic dungeon listings on Classic Calendar UI (`2.5.5`). Proves Anniversary guilds want calendar UX from addons, not from Beef. |

## Group Calendar lineage (addon-message sync)

| URL | Why it matters for Beef |
|-----|-------------------------|
| https://www.warcrafttavern.com/wow-classic/addons/groupcalendar/ | Classic 1.13 Group Calendar overview — signup/Accept culture before Wrath calendar ports. |
| https://www.wowinterface.com/downloads/info26073-GroupGuildCalendarforClassicTBC.html | TBC Classic port; **single-guild only** after Blizzard messaging changes; trust settings for creators. |
| https://www.curseforge.com/wow/addons/group-guild-calendar-for-classic-continued | Continued port (MoP Classic files); attendance categories, alt schedule, invite tools. |
| https://www.curseforge.com/wow/addons/guild-event-manager | Legacy “I’ll be there” / instance headcount pattern — spiritual ancestor of signup bots. |

## Out-of-game guild-night pipes

| URL | Why it matters for Beef |
|-----|-------------------------|
| https://guildsofwow.com/features | Web + Discord RSVP + in-game calendar bidirectional sync via their addon. Shows the “paid RSVP stack” Beef must not reinvent. |
| https://help.guildsofwow.com/Home | Help center wording: Discord bot attendance, native Discord events, calendar. |
| https://www.raidify.app/discord-bot | Classic-oriented Discord raid bot: signup, 24h/2h/1h reminders, confirm-roster. Reminder cadence lesson for *announce timing*, not BeefNet. |
| https://guildmanager.app/games/wow | Raid calendar + activity points + Discord — competitor category for “guild OS,” not for comedy ladder. |
| https://top.gg/bot/760511701236973610 | Guilds of WoW Discord bot listing (recurring events, RSVP, scheduled events). |

## Attendance / season metaphors (adjacent)

| URL | Why it matters for Beef |
|-----|-------------------------|
| https://www.curseforge.com/wow/addons/guild-raid-attendance | Raid log + attendance editor — credit model contrast to officer ceremony close. |
| https://www.wowinterface.com/downloads/info25254-GuildLaunchCT_RaidTrackerClassic.html | Classic raid tracker → external DKP pipelines. |
| https://wowpedia.fandom.com/wiki/EPGP | EP for on-time/presence + **decay** — contrast continuous tax vs liturgical Lent season (see [ritual-cadence-seasons.md](ritual-cadence-seasons.md)). |
| https://github.com/jpxthu/EPGP-Classic | Classic EPGP implementation pointer (decay/attendance culture). |
| https://wowpedia.fandom.com/wiki/PvP_season | Named seasons with resets/rewards — metaphor for Beef seasons; do not couple standing to Blizzard PvP seasons. |

## Product truth (repo)

| Path | Why |
|------|-----|
| [`docs/superpowers/specs/2026-07-25-church-of-beef-design.md`](../../../superpowers/specs/2026-07-25-church-of-beef-design.md) §3, §7, §13, §16 | Ceremony thin path, social check, Lent open question, threshold playtest. |
| [`docs/research/wow-classic-addon-design/00-church-of-beef-implications.md`](../00-church-of-beef-implications.md) | Synthesis item 8 — guild-night instrumentation. |
| [`docs/research/wow-classic-addon-design/09-guild-social-community/`](../09-guild-social-community/) | Do **not** duplicate: belonging, shoutouts, Discord-as-culture. |
| [`docs/research/wow-classic-addon-design/14-addon-messaging-beefnet/`](../14-addon-messaging-beefnet/) | Why CHANNEL/multi-guild calendar sync died; night traffic budgets. |
| [`docs/research/wow-classic-addon-design/16-guild-roster-officer-edges/`](../16-guild-roster-officer-edges/) | Officer+ for ceremony start/close. |

## Provenance dumps

| File | Contents |
|------|----------|
| [`.raw/search-calendar-apis.json`](.raw/search-calendar-apis.json) | Classic Calendar / Group Calendar / C_Calendar search |
| [`.raw/search-calendar-history.json`](.raw/search-calendar-history.json) | 3.0.2 history, Era calendar requests, AddEvent |
| [`.raw/search-anniversary-calendar.json`](.raw/search-anniversary-calendar.json) | TBC Anniversary calendar forks |
| [`.raw/search-guild-night-tooling.json`](.raw/search-guild-night-tooling.json) | GoW / Raidify / attendance tools |
| [`.raw/search-ritual-cadence.json`](.raw/search-ritual-cadence.json) | Season/ritual cadence search |
| [`.raw/extract-calendar-primary.json`](.raw/extract-calendar-primary.json) | ClassicCalendar GitHub + CurseForge Revived + WoWWiki Calendar |
| [`.raw/extract-calendar-apis-more.json`](.raw/extract-calendar-apis-more.json) | Partial API extracts (wiki.gg/fandom often blocked) |