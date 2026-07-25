# Track 39 — Guild calendar, scheduled events, night rituals

**Track id:** `39-guild-calendar-events`  
**Last updated:** 2026-07-25  
**Sole focus:** Classic/Anniversary **calendar & event APIs** (what exists vs gaps), the **guild-night tooling stack** guilds already use, **ritual cadence** for points seasons, and **Beef playtest instrumentation** for one real guild night.  
**Out of scope:** Belonging/identity/shoutout UX, Discord-as-community-layer patterns, loot-council fairness theater, officer-queue chrome — those belong in [09-guild-social-community](../09-guild-social-community/). No addon implementation in this folder.

## Product truth (from V1 spec)

| Locked / open | Value |
|---------------|-------|
| V1 ceremony model | Thin: officer-run event + attendance mark (not a calendar product) |
| Social acceptance | One real guild night with visible guild-chat reaction to a promotion |
| Thresholds | Placeholders until one guild night of data (§4.2 / §16.6) |
| Standing decay / Lent reset | Open question — on-brand seasonal option, not V1 |
| Calendar / RSVP ownership | **Not V1** — Discord + existing calendar addons own scheduling |

Source: [`docs/superpowers/specs/2026-07-25-church-of-beef-design.md`](../../../superpowers/specs/2026-07-25-church-of-beef-design.md) §3.1–3.2, §7.1, §13, §16.3 / §16.6; synthesis [00](../00-church-of-beef-implications.md) item 8.

## Index

| Note | Covers |
|------|--------|
| [classic-calendar-apis.md](classic-calendar-apis.md) | WotLK calendar history, `C_Calendar` on Classic-family clients, what works / what is stubbed, Anniversary forks |
| [guild-night-tooling.md](guild-night-tooling.md) | In-game calendars, Discord RSVP bots, web guild platforms — who owns which layer |
| [ritual-cadence-seasons.md](ritual-cadence-seasons.md) | Night → week → season cadence for Beef points; Lent/reset design without duplicating track 26 toxicity notes |
| [beef-guild-night-instrumentation.md](beef-guild-night-instrumentation.md) | What to log on one guild night to replace §4.2 placeholders |
| [annotated-urls.md](annotated-urls.md) | Primary URLs with steal/adapt notes |

## Boundary vs track 09 (do not duplicate)

| 09 (guild social / community) | 39 (this track) |
|-------------------------------|-----------------|
| Belonging, onboarding identity, shoutouts | Calendar/event **API facts** on Classic/Anniversary |
| Discord as community fabric (roles, vibes) | Discord/web tools as **scheduling/RSVP pipes** only |
| Loot-council / status fairness rituals | Ritual **cadence** tied to points seasons + Lent option |
| Cousin social-addon pattern checklist | Beef **instrumentation** for threshold playtests |

If a sentence is about “how the flock feels,” put it in 09. If it is about “when the night starts, what fires, what we measure,” put it here.

## Top insights for Beef (read this first)

1. **Do not build a guild calendar in V1.** Classic Era never shipped the Blizzard calendar UI; TBC Anniversary guilds already schedule via Discord + optional calendar addons. Beef owns **ceremony credit + ladder spectacle**, not RSVPs.

2. **`C_Calendar` can exist without a usable Blizzard UI.** Classic Calendar authors document that core calendar functions are present on Classic clients even when the interface is missing; player events and raid lockouts work, holidays often need injected data, and Guild Announcements / Community events are unavailable.

3. **Two calendar lineages, different sync stories.** *Group Calendar* ports use addon-message sync (single-guild after Classic CHANNEL bans). *Classic Calendar* lineage re-hosts Blizzard_Calendar atop `C_Calendar`. Beef should **read** neither for V1 scoring — officer ceremony close is the attendance gate.

4. **Guild night is the atomic ritual unit; season is the points epoch.** Weekly night = ceremony + co-play + optional Gora. Season (e.g. “Lent”) is the only honest answer if the ladder saturates — decay/reset is a **calendar ritual**, not a continuous grind tax (contrast EPGP decay in track 26).

5. **Instrumentation beats more features.** Spec §16.6 and synthesis item 8 are explicit: one instrumented guild night replaces placeholder thresholds. Log standing deltas, suggestion→approve latency, announce reaction, officer online set, BeefNet sync health — not RSVP counts.

6. **Coexist, don’t compete.** If the guild runs Classic Calendar / Guilds of WoW / Raidify, Beef should stay out of their UI. Optional later: soft-link a ceremony to “tonight’s Discord event title” as free text — never bidirectional calendar sync in V1.

## Provenance

Search/extract dumps under [`.raw/`](.raw/). Prefer Classic Calendar GitHub README + CurseForge Anniversary forks over listicles for API claims.