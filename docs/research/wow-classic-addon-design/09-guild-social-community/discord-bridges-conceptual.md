# Discord Bridges — Conceptual Patterns (Not V1 Scope)

**Last updated:** 2026-07-25  
**Status:** Research / future inspiration only. Church of Beef V1 is **fully in-game** with no external process controlling gameplay ([design spec](../../../superpowers/specs/2026-07-25-church-of-beef-design.md)).

---

## 1. What “bridge” means in the Classic guild ecosystem

Modern guild ops split into two rooms:

| Room | Role | Typical tools |
|------|------|----------------|
| **Discord (meeting hall)** | Always-on community, RSVPs, reminders, recruitment, vibes | Bots, scheduled events, role engines |
| **WoW client (event floor)** | Raids, ceremonies, loot, in-the-moment spectacle | Calendar addons, loot addons, guild chat |

A bridge **mirrors state** between rooms: RSVPs, attendance, announcements, sometimes roster/audit data.

---

## 2. Reference: Guilds of WoW

[Guilds of WoW](https://guildsofwow.com/) markets:

- In-game addon for event management and **bidirectional RSVP** with Discord
- Discord bot for event attendance, native Discord events, role engine
- Web roster, recruitment, audits, Battle.net sync ([help center](https://help.guildsofwow.com/Home))

**Pattern name:** Discord-as-frontend, game-as-engine (or the reverse for calendar authority — the product claim is seamless RSVP sync either way).

**Bot listing (secondary):** [top.gg — Guilds of WoW bot](https://top.gg/bot/760511701236973610) describes recurring events, RSVPs, reminders, guild logs, progress.

---

## 3. Other platform patterns (for contrast)

| Platform | Bridge emphasis | Link |
|----------|-----------------|------|
| Guild Manager | Discord notifications, roles, activity points | [guildmanager.app](https://guildmanager.app/games/wow) |
| CoGM (Classic page) | Discord voice attendance, DKP-style economy, announcements | [cogm.app/games/wow-classic](https://cogm.app/games/wow-classic) |
| softres.it | Out-of-game soft-reserve sheet → imported by Gargul | [softres.it](https://softres.it/) |

Loot soft-reserve sites are a **narrow bridge**: commitment happens on the web; the raid tool imports a snapshot. No continuous bot required.

---

## 4. Design lessons usable without building a bridge

Even with V1 locked to in-game operation, Discord-native guild culture still shapes Beef:

1. **Name channels after rituals** the addon already produces: promotions, ceremonies, Gora results, Prophet anointments. Stream overlays and Discord can quote the same lines.
2. **One memorable sentence per event.** GoW-style bots succeed when a single RSVP/reminder is scannable; Beef’s guild-chat promotion line should be equally pasteable.
3. **RSVP before presence.** Ceremony credit on officer close mirrors “signed up then showed.” Officers can still take Discord headcounts manually.
4. **Do not invent a second ladder on Discord.** Dual standing systems split the flock; Discord should echo officer-committed titles, not invent competing ranks.
5. **Cross-guild chat precursors** (e.g. [Cross Guild Chat on WoWInterface](https://www.wowinterface.com/downloads/info18676-CrossGuildChat.html)) show demand for multi-community glue — relevant to Dreamscythe vs Doomhowl as **separate churches**, not one bridged ladder (per V1: no cross-realm shared state).

---

## 5. If a future phase ever bridges (spec caution)

Any future Discord integration must stay outside “control gameplay”:

- **Allowed conceptually:** announce promotions, post ceremony schedules, mirror public ladder snapshots, stream alerts.
- **Never:** bots that move characters, automate combat, inject input, or act as hidden officers.
- Prefer **officer-initiated exports** or read-only public feeds over always-on privileged control.

Until the design spec revises the hard rules, treat this document as **brand/ops inspiration**, not an implementation backlog item.
