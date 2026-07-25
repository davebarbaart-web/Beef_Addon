# Classic Anniversary CLEU caveats

**Track:** [63-combatlog-social-signals](README.md)  
**Last updated:** 2026-07-25  
**Audience:** Implementers tempted to “borrow” CLEU patterns from Retail/TBC boss mods.  
**Stance:** Documented so V1 can **confidently refuse** CLEU — not so V1 can implement it.

---

## 1. Payload access on modern Classic clients

Since Retail **8.0.1**, CLEU/COMBAT_LOG_EVENT carry **no payload args**; read via [`CombatLogGetCurrentEventInfo()`](https://warcraft.wiki.gg/wiki/API_CombatLogGetCurrentEventInfo) ([Blizzard: Combat Log Event Changes](https://us.battle.net/forums/en/wow/topic/20762318007); [wiki](https://warcraft.wiki.gg/wiki/COMBAT_LOG_EVENT)).

TBC Classic Anniversary / modern Classic trees use this pattern (community tools and TBC CLEU viewers assume it — e.g. [Wick’s Combat Log](https://www.curseforge.com/wow/addons/wicks-combat-log) for Classic TBC). **Infer:** Anniversary `20506` follows the same getter; still verify once with `/etrace` if anyone prototypes CLEU outside Beef.

Do **not** write Classic Era 1.13-style `...` payload handlers for Beef — wrong era of the API surface.

---

## 2. Range restrictions (Classic-specific history)

| When | Behavior | Source |
|------|----------|--------|
| Hotfix **2019-11-20** | In-game combat log limited to **~50 yards** (closer to 1.12; cuts Spy-style long-range sensing) | [Kaivax — In-Game Combat Log Range Decreased](https://us.forums.blizzard.com/en/wow/t/in-game-combat-log-range-decreased/370390); [wiki Classic notes](https://warcraft.wiki.gg/wiki/COMBAT_LOG_EVENT) |
| Hotfix **2020-06-22** | **Dungeons and raids no longer restricted**; open world remains ~50 yards | [wiki](https://warcraft.wiki.gg/wiki/COMBAT_LOG_EVENT); hotfix index cited there |

**Beef implications:**

- Spec §7.2 already scores **instance types only** — so the outdoor 50 yd limit is not a V1 scoring dependency.
- If someone wrongly used CLEU for open-world “who fought near me” social credit, outdoor range would silently drop events — another reason not to invent open-world CLEU scoring.
- Inside instances, CLEU volume is **unrestricted and high** — worst case for a social addon’s CPU.

---

## 3. `spellId` restoration (TBC / Era)

Classic combat-log `spellId` was historically `0` on early Classic Era (**1.13.2** resemblance to pre-2.4). Restored:

- **Burning Crusade Classic 2.5.1** (2021-05-18)
- **Classic Era 1.15.0** (2023-11-14)

([wiki Classic patch section](https://warcraft.wiki.gg/wiki/COMBAT_LOG_EVENT))

Anniversary TBC-line clients should have real spell IDs. **Irrelevant to Beef V1** if CLEU is avoided — listed only so nobody “ports” a Vanilla-era spellId=0 hack into CoB.

---

## 4. Filtered vs unfiltered

| Event | Behavior |
|-------|----------|
| `COMBAT_LOG_EVENT` | Only events matching the **global combat-log UI filters** |
| `COMBAT_LOG_EVENT_UNFILTERED` | All events; preferred by addons |

([wiki](https://warcraft.wiki.gg/wiki/COMBAT_LOG_EVENT); [2.4 guide](https://wowwiki-archive.fandom.com/wiki/Patch_2.4.0/Consolidated_API_changes/Guide_to_the_New_Combat_Log))

Using the filtered event for scoring would make standing depend on whether the player hid “friendly players” damage — unacceptable. Using CLEU avoids that bug **by paying full volume cost**. Prefer neither for Beef: use non-CLEU events.

---

## 5. Advanced Combat Logging interaction (caution)

Retail/Mainline bug reports: with **Advanced Combat Logging** enabled, in-game CLEU can **drop events** relative to `WoWCombatLog.txt` (~10% damage events missing in one report); Blizzard-acknowledged on [WoWUIBugs #326](https://github.com/Stanzilla/WoWUIBugs/issues/326) (label: Mainline).

**Anniversary status:** Not proven for TBC Anniv from docs alone — treat as **portability / hostility-to-CLEU** evidence: even “correct” CLEU consumers disagree with file logs under ACL. Another reason social scoring must not depend on CLEU completeness.

File combat logging (`LoggingCombat` / `/combatlog`) is for **external** parsers — not a Beef scoring channel ([wiki Advanced Combat Log](https://warcraft.wiki.gg/wiki/COMBAT_LOG_EVENT)).

---

## 6. Retail Midnight contrast (out of V1 scope)

Retail Midnight-era work removes or secrets CLEU for addons (community migration notes, e.g. [DragonShout issue #28](https://github.com/Xerrion/DragonShout/issues/28)). Classic Anniversary is **not** that client.

**Steal the lesson, not the migration:**

- Products that *must* survive CLEU removal are redesigning onto `UNIT_*` / other events.
- Beef should start on those coarse events **now**, so there is nothing to migrate later if Classic ever tightens CLEU.

Do not cite Midnight as “CLEU is fine on Classic forever” — cite it as “don’t build the church on the combat log.”

---

## 7. Anniversary playtest note (only if someone insists)

If an alpha build ever registers CLEU for an experiment (not ship):

1. Confirm `CombatLogGetCurrentEventInfo` works on `20506`.
2. Compare AddonUsage CPU with CLEU registered vs regen-only during a Karazhan pull.
3. Toggle Advanced Combat Logging and look for missing subevents if using CLEU for anything grant-adjacent.
4. **Delete the registration** before Release — experiments must not leave CLEU live.

Default remains: **no CLEU registration in V1.**
