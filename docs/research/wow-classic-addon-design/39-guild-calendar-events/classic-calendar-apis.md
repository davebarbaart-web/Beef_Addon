# Classic calendar / event APIs (Anniversary-relevant)

**Question:** What calendar or scheduled-event APIs can a TBC Classic Anniversary addon actually rely on?  
**Answer short:** Treat full Blizzard calendar UX as **not a V1 dependency**. Core `C_Calendar` may be present on Classic-family clients, but holiday/guild-announcement behavior is incomplete or addon-patched. Beef ceremonies must not require calendar RSVP state.

## History that still shapes Classic

| Fact | Implication for Beef |
|------|----------------------|
| In-game Calendar shipped in **patch 3.0.2** (WotLK pre-patch): realm events + player/guild event creation, Accept/Decline, mass invite by level/rank ([WoWWiki Calendar](https://wowwiki-archive.fandom.com/wiki/Calendar)) | Vanilla/TBC-era fantasy clients never “originally” had this UI |
| Guild Control grants who may create events; deleted events can mail invitees ([same](https://wowwiki-archive.fandom.com/wiki/Calendar)) | Retail/Wrath mental model ≠ Era/Anniversary defaults |
| Classic Era community repeatedly asked for a native calendar; answer in practice was **addons** ([Blizzard forum: Add in-game calendar](https://us.forums.blizzard.com/en/wow/t/add-in-game-calendar/1738784) — players point to Classic Calendar) | Expect Discord-first scheduling culture |

## What Classic Calendar authors reverse-engineered

Primary technical source: [birkholz/ClassicCalendar README](https://github.com/birkholz/ClassicCalendar) (SoD/Era port of Blizzard_Calendar; later unmaintained, then revived/forked).

| Capability | Classic-family reality (per Classic Calendar docs) |
|------------|-----------------------------------------------------|
| `C_Calendar` namespace present | Yes — “core calendar functions present even though the interface isn’t” |
| Player-created events | Worked with little change |
| Raid lockouts on the day grid | Returned correctly |
| Holidays / Darkmoon / Call to Arms | **Not returned** by `GetNumDayEvents` / `GetDayEvent` — addons inject schedules |
| `C_Calendar.GetHolidayInfo` | Exists but acts as if holidays do not exist — descriptions dumped from Wrath and injected |
| Guild Announcements | Unavailable (later WoW only) |
| Community events | Unavailable |
| `CanEditGuildEvent` / guild event permission | Missing on Classic — Classic Calendar removed the check so **anyone** can create guild events (GM kick is the backstop) |
| `CALENDAR_EVENT_ALARM` | Never fires — addon polls every minute for upcoming player events |
| Guild event invites after Classic **1.15.3** | Reported broken on [Classic Calendar – Revived](https://www.curseforge.com/wow/addons/classic-calendar-revived) (left open for Blizzard fix) |

**Retail-shaped APIs (document, do not assume on Anniversary without in-client probe):**

- `C_Calendar.CreatePlayerEvent` / `CreateGuildSignUpEvent` → candidate → `C_Calendar.AddEvent()` finalize ([Wowpedia AddEvent](https://wowpedia.fandom.com/wiki/API_C_Calendar.AddEvent))
- Day queries: `GetNumDayEvents`, `GetDayEvent`
- Older globals (`CalendarGetDate`, etc.) exist in historical docs ([WoWWiki CalendarGetDate](https://wowwiki-archive.fandom.com/wiki/API_CalendarGetDate))

**Beef rule:** if code needs calendar invites to grant standing, it is wrong for V1. Ceremony attendance is an **officer close mark**, not an Accept on a calendar event.

## Anniversary / TBC forks (ecosystem, not Beef scope)

| Project | Claim | Beef stance |
|---------|-------|-------------|
| [Classic Calendar – Revived](https://www.curseforge.com/wow/addons/classic-calendar-revived) | Era `11508` + BCC `20505`; guild events + P2P world-buff sync; officer rank ≥ 2 for some features | Coexist; do not embed |
| [ClassicCalender_TBC](https://www.curseforge.com/wow/addons/classiccalender-tbc) | TBC Anniversary raid/dungeon listings (Kara→Sunwell, heroics) on Classic Calendar UI (`2.5.5`) | Same — guild may install; Beef ignores |
| Group / Guild Calendar (Classic / TBC ports) | Addon-synced calendar; **single-guild only** after Blizzard CHANNEL messaging changes ([WoWI TBC port](https://www.wowinterface.com/downloads/info26073-GroupGuildCalendarforClassicTBC.html); [Continued MoP](https://www.curseforge.com/wow/addons/group-guild-calendar-for-classic-continued)) | Different sync stack than BeefNet; never share prefix traffic patterns casually |

## Practical API matrix for Church of Beef

| Need | Prefer | Avoid |
|------|--------|-------|
| “Was this person at ceremony?” | Officer closes ceremony → attendance mark (spec §7.1) | Calendar Accept status |
| “Is tonight a guild night?” | Social convention + Discord event (out of game) | Parsing `C_Calendar` day events |
| “When did standing move?” | Local SV timestamps + officer commit time | Holiday injection tables |
| “Who may start a ceremony?” | WoW Officer+ rank index (track 16) | Calendar creator crown / event moderator |

## Probe checklist (when someone is in-client)

Not done in this research pass — record answers in `.raw/` later:

1. Does `C_Calendar` exist on Anniversary `Interface 20506`?
2. Does Blizzard ship `Blizzard_Calendar` load-on-demand, or only stubs?
3. Can an officer create a guild signup event without a calendar UI addon?
4. Do `CALENDAR_*` events fire for player events?

Until probed: **assume Discord/officer ritual, not calendar.**

## Related tracks

- [14-addon-messaging-beefnet](../14-addon-messaging-beefnet/) — why Group Calendar’s old multi-guild CHANNEL sync died
- [16-guild-roster-officer-edges](../16-guild-roster-officer-edges/) — Officer+ for ceremony start/close
- [15-instance-completion-events](../15-instance-completion-events/) — co-play scoring signals (not calendar)