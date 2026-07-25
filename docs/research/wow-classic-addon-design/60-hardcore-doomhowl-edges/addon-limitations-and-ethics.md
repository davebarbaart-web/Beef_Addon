# Addon limitations & Hardcore ethics

**Last updated:** 2026-07-25  
**Scope:** What Blizzard allows, what the Lua sandbox cannot do, and what HC culture rejects — mapped to Church of Beef.

---

## 1. Addons are allowed on Hardcore

There is no Blizzard rule forbidding AddOns on official HC. Player confusion is almost always **wrong install folder** (`_classic_era_` / nested zip folders), not a ban ([US forums — “No addons?”](https://us.forums.blizzard.com/en/wow/t/no-addons/1658472)).

Anniversary V1 install path remains track [30](../30-anniversary-vs-era-deltas/) territory. For any future HC/Classic Era Beef build: document `_classic_era_` (or current Era/HC tree), never the Anniversary path.

---

## 2. Hard platform limits (Lua cannot)

Community HC tooling documents the gap between **official** HC and **addon-emulated** HC ([Hardcore Mode on CurseForge](https://www.curseforge.com/wow/addons/hardcore-mode)):

| Desired behavior | Official HC | Addon-only |
|------------------|-------------|------------|
| Force logout / block play after death | Server-enforced | **Cannot** — protected; UI can only nudge (open game menu) |
| Auto-transfer guild leadership on death | Facilitated in ghost logistics | **Cannot** — protected guild APIs |
| Block all illegal trades / AH / mail / group | Ruleset + enforcement | Best-effort hooks; honor system for gaps |
| Realm-wide death broadcast without peers | Server/realm systems | Requires other clients running the addon |

**Beef implication:** Never promise “anti-death,” “auto-GM succession,” or “enforced Self-Found.” Officer judgment remains the anti-cheat ([spec §6.3](../../../superpowers/specs/2026-07-25-church-of-beef-design.md)). BeefNet already accepts that players without the addon are invisible to the mesh — same honesty model as HC social addons.

---

## 3. Ethics pressure (more important than API)

HC discourse focuses on **fairness of information / automation**, not on whether a guild rank UI exists:

| Hot topic | Example | Beef stance |
|-----------|---------|-------------|
| Paid guide “leash” | [RestedXP on HC forums](https://us.forums.blizzard.com/en/wow/t/why-is-addon-like-restedxp-allowed-by-blizzard/2022911?page=6) | Never position Beef as leveling autopilot |
| Spoiler / map reveal | Community purity fights | No quest-rail or danger-radar features |
| Clean UI as survival virtue | [r/wowhardcore clean UI](https://www.reddit.com/r/wowhardcore/comments/1rd6o45/a_clean_ui_can_make_a_difference/) | Edge ladder, low chrome (already V1) |
| Human judgment over automation | Officer culture | Hybrid suggest → Officer+ approve (already locked) |

Track [12](../12-classic-vs-retail-philosophy/) owns the broader Classic vs Retail philosophy; this note only restates the HC-sharpened edge: **information that helps you decide > systems that decide for you.**

---

## 4. UX constraints for HC-adjacent audiences

Even when V1 runs only on Anniversary, stream and brand audiences include Doomhowl HC veterans:

1. **Minimal chrome** — no center HUD theater in V1 (spec already defers ceremonial dashboard).
2. **No “risk meter” / death prediction** — out of brand and ethics.
3. **Quiet defaults** — avoid raid-warning spam culture for social events (track [49](../49-officer-notifications/)).
4. **Plain language** — “record Gora result,” not combat helper jargon.
5. **Opt-in spectacle** — guild-chat promotion lines already officer-sent; keep death memorials officer-authored if ever added.

---

## 5. Competitor adjacency (do not absorb)

| Product | Job | Beef relation |
|---------|-----|---------------|
| Official HC realm systems | Permadeath, ghost, FCM | Environment Beef may someday *observe* |
| [Hardcore Mode](https://www.curseforge.com/wow/addons/hardcore-mode) (addon) | Emulate HC on non-HC; death ledgers | Adjacent; do not merge death-leaderboard into Beef |
| [Guild Roster Manager](http://guildrostermanager.com/) | Officer ops; Classic & HC support | Complementary (track [52](../52-competitor-market-map/)) |

Beef’s white space remains **institutional comedy ranks**, not survival tracking.
