# Classic / Anniversary messaging realities

**Client focus:** TBC Classic Anniversary (`Interface` 20506 per plan) inherits the Classic messaging policy line, not Retail Midnight encounter locks.

## Policy history that still shapes V1

| Date / patch | Change | Lasting effect on Beef |
|--------------|--------|------------------------|
| Classic **1.13.3** (2019-12) | `CHANNEL` addon messages disabled; `SAY`/`YELL` tested | BeefNet on `GUILD` is policy-correct; never design custom-channel mesh |
| Classic **1.13.4** era + **May 2020 hotfix** | Addon comms more severely rate-throttled (threat-meter traffic) | Multi-KB GUILD dumps fail intermittently; “send less data” is the industry answer |
| Classic **1.13.5** | Native Threat API | Threat meters stopped needing huge sync — throttle stayed |

Primary announcements:

- [Wowhead — 1.13.3 CHANNEL ban](https://www.wowhead.com/classic/news/wow-classic-patch-1-13-3-lua-api-change-disabling-addons-from-communicating-in-299371)
- [Blizzard Kaivax — Patch 1.13.3 Lua API Change](https://us.forums.blizzard.com/en/wow/t/wow-classic-patch-1133-lua-api-change/384543)
- Wiki Classic notes on [SendAddonMessage patch history](https://warcraft.wiki.gg/wiki/API_C_ChatInfo.SendAddonMessage)

## Silent drops vs documented throttle

Developers of Classic loot/sync addons reported (Aug 2020):

- Even with AceComm + ChatThrottleLib, messages can be **silently ignored** when paced “too fast.”
- API may still report success while delivery fails partially or wholly.
- Behavior is **intermittent** and **realm-dependent**.
- Community mitigation: shrink payloads; do not rely on large GUILD config blasts.

Sources: [Classic SendAddonMessage problems](https://us.forums.blizzard.com/en/wow/t/classic-sendaddonmessage-problems/620054) · [Changes to SendAddonMessage?](https://us.forums.blizzard.com/en/wow/t/classic-changes-to-cchatinfosendaddonmessage/544278)

**Anniversary implication:** Treat documented 10/sec-style limits as a **floor**, not a guarantee. Design BeefNet for lossy links: revisions, diffs, retries with backoff.

## Anniversary vs Era vs Retail

| Flavor | Messaging notes for Beef |
|--------|--------------------------|
| **TBC Anniversary (V1)** | Same Classic family: `CHANNEL` banned; GUILD OK; expect Classic throttle culture |
| Classic Era / HC / SoD | Same family; API drift possible — keep BeefNet behind a thin Net module |
| Cataclysm / MoP Classic | Different Interface; messaging patterns similar enough for portability |
| **Retail / Midnight** | Encounter-time addon messaging restrictions for combat-data anti-cheat ([Midnight template notes](https://github.com/Plaitrix/WoW-Midnight-Addon-Template/blob/main/docs-site/docs/midnight.md)) — **out of V1 scope**. Mental model only: queue during restricted windows if a future Classic+ ever copies the idea |

Do **not** pull Retail `C_EncodingUtil` / Midnight encounter gates into Anniversary V1 unless confirmed present on 20506.

## Social dynamics Blizzard optimized for

Kaivax: invisible addon messages to large arbitrary groups across Azeroth risked Classic social dynamics. Guild / party / raid / whisper remain because they map to existing social containers.

Church of Beef is a **guild institution** — `GUILD` is the natural container. Using `SAY`/`YELL` for ladder sync would be wrong (range-limited, heavily throttled, wrong audience).

## Practical Anniversary guild-night checklist

1. Register `COB` before any send/receive expectations.
2. Never send BeefNet on custom channels.
3. After login: delay → HELLO → SYNC_REQUEST (not in the first second).
4. One peer answers SYNC with BULK chunks; others suppress.
5. Officer commits stay tiny; celebrate in **one** guild-chat line.
6. Assume some packets vanish; next login heals via revisions.
7. Soft-warn on BeefNet major version mismatch; refuse incompatible commits.

## Open measurement (still recommended)

Spec synthesis already flagged: measure practical GUILD + CTL throughput on Anniversary before the ladder grows large. Until measured, assume:

- Comfortable: single-digit frames per commit / sync answer.
- Risky: tens of frames per login with many responders.
- Forbidden: continuous SCORE_EVENT streams.
