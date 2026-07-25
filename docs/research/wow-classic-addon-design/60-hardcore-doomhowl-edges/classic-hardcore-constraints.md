# Classic Hardcore constraints (scoring surface)

**Last updated:** 2026-07-25  
**Scope:** Official Hardcore ruleset facts that change what “guild play” looks like — and therefore what Beef scoring can honestly reward. Not a full HC player guide.

Primary source: [Rules of Engagement: Classic Hardcore](https://worldofwarcraft.blizzard.com/en-us/news/23973734/rules-of-engagement-classic-hardcore-is-coming-to-world-of-warcraft) (Blizzard, Aug 2023). Secondary explainers: [Dot Esports rules summary](https://dotesports.com/wow/news/official-wow-classic-hardcore-rules-explained-deaths-pvp-dungeons-and-more), [Icy Veins Hardcore rules](https://www.icy-veins.com/wow-classic/classic-hardcore-rules), [Warcraft Tavern rules explained](https://www.warcrafttavern.com/wow-classic/news/official-hardcore-rules-explained/).

---

## 1. Permadeath (the pillar)

| Rule | Detail |
|------|--------|
| Death on Hardcore is permanent **on that realm** | No corpse run, no player resurrect, no Soulstone / Reincarnation second wind ([Blizzard](https://worldofwarcraft.blizzard.com/en-us/news/23973734/rules-of-engagement-classic-hardcore-is-coming-to-world-of-warcraft)) |
| Ghost continues | Dead characters remain as ghosts for communication and logistics (guild leadership handoff, etc.) |
| Character not deleted by Blizzard | Free Character Move to a **non-Hardcore** destination lets the character resurrect there; return to HC is closed |

**Beef implication:** Standing and ranks are per-character. On HC, death ends the *playable* character’s scoring life. Do not design “death = −standing” or “death = auto-excommunicate” — those fight Blizzard’s ghost/logistics model and create grief UX. Prefer memorial / hide-from-ladder (see [death-ghost-and-guild-logistics.md](death-ghost-and-guild-logistics.md)).

---

## 2. PvP surface (BG scoring dies)

| Rule | Detail |
|------|--------|
| Opt-in PvP | Must `/pvp` before hostile actions vs flagged enemies; no accidental flag from attacking flagged players |
| Battlegrounds disabled | No BG queues / Battlemasters |
| Wargames allowed | Premade Wargames OK; **no honor/rep rewards**; death still permanent |
| Quest flag gotchas removed | Several quests that used to force PvP flag or require death were adjusted |

**Beef implication:** Spec §7 lists battlegrounds as a shared-instance co-play type. On HC that source is **empty**. Anniversary V1 can keep BG drip; any HC port must gate BG scoring off (or remap “instance” to dungeons/raids/wargames only — wargames are high-risk and probably should *not* pay drip without officer ceremony).

---

## 3. Dungeon / leveling constraints (anti-farm already baked in)

| Rule | Detail |
|------|--------|
| ≥24h dungeon lockout | For players **below level 60** on almost all dungeons |
| No high→low dungeon entry | Level 60s may not enter lower dungeons with sub-60 players |
| Group XP restrictions | Significantly higher-level players make dungeon XP trivial for the group (SoM-style anti-boost) |
| All Classic phases open | HC realms launched with full content available (not a fresh phased season) |

**Beef implication:** Instance drip + daily caps already limit farm on Anniversary. On HC, Blizzard’s lockouts further reduce “spam dungeon with guildmate” pacing. Ceremony and Gora become relatively more important fuel. Do not invent a second Beef lockout reader for V1 (track [46](../46-seasonality-fresh-servers/) already says lockouts are rhythm, not points authority).

---

## 4. Survival QoL removals (tone, not scoring)

| Rule | Detail |
|------|--------|
| No bubble-hearth | Paladin immunities block Hearthstone while active |
| Leash / kite disruption limited | High-level mob leashing to low-level zones constrained |
| Buff/debuff caps removed | 16 debuff / 32 buff Classic limits lifted on HC |
| Behavior enforcement | Malicious death-causing (kite elites onto players, deliberate wipe intent) subject to action; report-bombing also punished |

**Beef implication:** Do not ship “escape helper” or death-prevention UX. Stay away from combat automation framing ([track 12 HC ethics](../12-classic-vs-retail-philosophy/nostalgia-vs-qol.md)).

---

## 5. Duel to the Death (`/makgora`) — not Beef Gora

| Feature | Official HC |
|---------|-------------|
| Challenge | Portrait menu or `/makgora` |
| Consent | Both type “I Agree” after warning |
| Outcome | Loser **dies permanently**; winner gains cosmetic **String of Ears** stacks (limits: level 10+, level proximity) |

**Beef implication (critical UX edge):** Spec Beef Gora is challenge → human-recorded win/loss/draw → standing points, with losses paying participation. Naming, help text, and stream overlays must keep **Beef Gora** distinct from **Mak’gora / Duel to the Death**. Reusing “makgora” in slash commands or liturgy on an HC-aware audience is a liability.

---

## 6. What this track does *not* claim

- That V1 must detect “am I on Hardcore?” — V1 is Anniversary-locked ([30](../30-anniversary-vs-era-deltas/)).
- That Doomhowl progressed into TBC — it did not ([46](../46-seasonality-fresh-servers/fresh-servers-and-realm-identity.md); deep dive [doomhowl-transfer-to-tbc.md](doomhowl-transfer-to-tbc.md)).
- That Self-Found / Solo Self-Found community rulesets are Blizzard HC law — those are community/addon overlays (see [addon-limitations-and-ethics.md](addon-limitations-and-ethics.md)).
