# Detection methods — “playing with guildmates”

**Track:** 59 · **Last updated:** 2026-07-25  
**Audience:** Implementers of `Core/Instance.lua` co-play eligibility.  
**Stance:** Research notes only — no addon code.

Confidence: **Doc** = wiki / primary API docs in [annotated-urls.md](annotated-urls.md); **Infer** = Beef design conclusion; **Prototype** = verify on Anniversary `20506`.

---

## 1. What “co-play” means for Classic addons

Ecosystem instinct matches Beef: officers want time-in-group with guildmates as an incentive signal ([Blizzard: Guild Addon help](https://us.forums.blizzard.com/en/wow/t/guild-addon-help/450778)). Healthy Classic pattern:

| Layer | Typical APIs | Beef stance |
|-------|--------------|-------------|
| Am I grouped? | `IsInGroup` / `IsInRaid` / `GetNumGroupMembers` | Required |
| Who is in the group? | `partyN` / `raidN` UnitIds, `GetRaidRosterInfo` | Required |
| Are they guild? | `UnitIsInMyGuild`, roster name match | Required |
| Are they “here”? | Instance type (track 15), optionally zone on raid roster | Instance type only for V1 |
| Are they AFK? | Combat (track 15), optional `UnitIsAFK` | Combat is authority |

Open-world “near a guildmate” is **not** a reliable Classic scoring signal (see proximity §5 and [false-positives](false-positives-afk-crossrealm.md)).

---

## 2. Group membership (party / raid)

### APIs

| Call | Role | Classic note |
|------|------|--------------|
| [`IsInGroup([groupType])`](https://warcraft.wiki.gg/wiki/API_IsInGroup) | Any group? Optional HOME/INSTANCE | Added **5.0.4 / 1.13.2** (**Doc**) |
| [`IsInRaid([groupType])`](https://warcraft.wiki.gg/wiki/API_IsInGroup) | Raid-shaped group? | Same family (**Doc**) |
| [`GetNumGroupMembers([groupType])`](https://warcraft.wiki.gg/wiki/API_GetNumGroupMembers) | Count including self; `0` if alone | Prefer over fragile `IsInGroup` alone — community reports rare false `IsInGroup` (**Doc** — [WoWInterface](https://www.wowinterface.com/forums/showthread.php?t=56146)) |
| [`GetNumSubgroupMembers([groupType])`](https://wowwiki-archive.fandom.com/wiki/API_GetNumSubgroupMembers) | Party peers excluding self (0–4) | Use for party iteration bounds (**Doc**) |
| [`GROUP_ROSTER_UPDATE`](https://warcraft.wiki.gg/wiki/GROUP_ROSTER_UPDATE) | Composition / subgroup / role churn | Debounce; fires often (**Doc**) |

### UnitId iteration (canonical pattern)

From [UnitId](https://wowwiki-archive.fandom.com/wiki/UnitId) and community practice ([WoWInterface party/raid frames](https://www.wowinterface.com/forums/showthread.php?t=56134); DBM `GetGroupMembers` style):

| Group shape | Tokens | Include `"player"`? |
|-------------|--------|---------------------|
| Party | `"party1"` … `"party4"` | **Yes separately** — player is **not** in `partyN` |
| Raid | `"raid1"` … `"raid40"` | Player **is** one of the `raidN` slots |

**Infer:** Loop peers only (skip self via `UnitIsUnit(unit, "player")`). Need ≥1 **other** guildmate.

### HOME vs INSTANCE category (critical)

[`partyCategoryType`](https://addonstudio.org/wiki/WoW:API_TYPE_partyCategoryType) / wiki on [`IsInGroup`](https://warcraft.wiki.gg/wiki/API_IsInGroup):

| Enum | Meaning |
|------|---------|
| `LE_PARTY_CATEGORY_HOME` (1) | Manual / local party or raid |
| `LE_PARTY_CATEGORY_INSTANCE` (2) | Automatic BG / arena / finder-style instance group |

- A character can be in **both** at once (home friends raid + BG instance raid) (**Doc**).
- When `groupType` is omitted, APIs often default to **INSTANCE if applicable, else HOME** (**Doc** — [GetNumGroupMembers](https://warcraft.wiki.gg/wiki/API_GetNumGroupMembers)).

**Beef rule (Infer):**

| Instance type (track 15) | Prefer category |
|--------------------------|-----------------|
| `party` / `raid` (manual dungeon/raid) | `HOME` first; if empty of guildmates, do not invent credit from INSTANCE unless product later wants LFG |
| `pvp` (battleground) | `INSTANCE` — this is the BG raid |

Anniversary V1 is mostly pre-cross-realm LFG for PvE; still write the category explicitly so BG and dual-group cases do not silently break.

---

## 3. Guildmate predicates

### Primary: `UnitIsInMyGuild(unit)`

Listed on Classic-era API inventories as returning whether the unit is in the same guild as the player ([AddOn Studio WoW API](https://addonstudio.org/wiki/WoW:World_of_Warcraft_API)). Takes a **UnitId** (group tokens work when the unit exists).

**Infer / Prototype:** Confirm on `20506` for party, raid, and BG raid tokens. Treat as primary fast path.

### Secondary: guild roster name match

When `UnitIsInMyGuild` is unavailable/false-negative:

1. Keep a cache from track [16](../16-guild-roster-officer-edges/) after `GUILD_ROSTER_UPDATE`.
2. Read `UnitName(unit)` / realm (often bare same-realm; `Name-Server` in cross-realm BGs — [GetRaidRosterInfo](https://wowwiki-archive.fandom.com/wiki/API_GetRaidRosterInfo)).
3. Normalize to the same key form as track [25](../25-multi-toon-realm-edges/) (`Name-NormalizedRealm`).
4. Lookup in roster set.

**Do not** use bare string equality without realm normalization.

### Tertiary (avoid as sole gate): `GetGuildInfo(unit)`

[GetGuildInfo](https://warcraft.wiki.gg/wiki/API_GetGuildInfo):

- Returns guild name / rank / realm for a unit.
- **Only works in close proximity** (same distance as party portrait load); abandons data after leaving the area (**Doc**).
- `"player"` can be nil at login until roster events (**Doc** — track 16).

**Beef:** Optional corroboration when unit is nearby. Never the only guildmate detector (false negatives mid-instance when someone is out of portrait range).

### Not required: peer runs Church of Beef

Spec §7.1. No addon-message handshake for co-play eligibility.

---

## 4. Raid roster extras (`GetRaidRosterInfo`)

[GetRaidRosterInfo](https://wowwiki-archive.fandom.com/wiki/API_GetRaidRosterInfo) returns (among others):

| Return | Co-play use |
|--------|-------------|
| `name` | Identity; `Name-Server` in cross-realm BGs |
| `online` | Connected? |
| `isDead` | Flavor only — dead guildmates still count |
| `zone` | Same-zone heuristic (unreliable for self after reload; locale bugs) — **not** V1 pay gate |

**Infer:** In raids/BG raids, prefer `online == 1` (or `UnitIsConnected`) before counting a guildmate. Offline raid slots should not satisfy “playing with.”

---

## 5. Proximity (document, then mostly ignore)

| API | What it measures | V1 for Beef |
|-----|------------------|-------------|
| [`UnitInRange(unit)`](https://wowwiki-archive.fandom.com/wiki/API_UnitInRange) | ~40yd helpful-spell range; party/raid only; false for non-group | **Ignore** for credit — large raids routinely fail |
| [`CheckInteractDistance(unit, distIndex)`](https://warcraft.wiki.gg/wiki/API_CheckInteractDistance) | Inspect/trade/duel/follow bands (~7–28 yd) | **Ignore** — restricted in combat on modern clients; Classic 1.15 community reports range-check cuts in instances ([Reddit PSA](https://www.reddit.com/r/classicwow/comments/1amv8o5/psa_new_115_build_removes_range_checking_from/)) |
| Same `zone` from raid roster | Coarse map name | **Ignore** for grants — wing splits / nil self-zone bugs |

**Conclusion:** Classic addons that need “together” for **scoring** use **same instance + same group + guild**, not yard checks. Proximity belongs to combat UX (DBM range), not church standing.

---

## 6. Refresh triggers (when to recompute)

| Event / signal | Action |
|----------------|--------|
| `GROUP_ROSTER_UPDATE` | Recompute guildmate set (debounced) |
| `PLAYER_ENTERING_WORLD` | Re-read instance (track 15) **and** group category + guildmates |
| `PLAYER_GUILD_UPDATE` / `GUILD_ROSTER_UPDATE` | Rebuild roster name set (track 16 throttle) |
| Bucket timer tick | Re-check connected guildmate still present before paying drip |

Do not poll group membership on a tight `OnUpdate` — event + bucket boundary is enough (**Infer**, aligns with track 04 performance norms).

---

## 7. Minimal algorithm (pseudocode, not ship code)

```
function HasCoPlayGuildmate():
  if not QualifyingInstance(): return false          -- track 15
  cat = CategoryForInstanceType()                    -- HOME or INSTANCE
  for unit in GroupUnits(cat):                       -- exclude player
    if not UnitExists(unit): continue
    if not UnitIsConnected(unit): continue
    if UnitIsInMyGuild(unit): return true
    if RosterContains(Normalize(UnitName(unit))): return true
  return false
```

Wire drip/completion grants only when this is true at evaluation time ([beef-scoring-map.md](beef-scoring-map.md)).
