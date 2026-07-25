# Doomhowl → TBC: guild & character transfer edges

**Last updated:** 2026-07-25  
**Scope:** How Anniversary Hardcore (NA **Doomhowl**, EU **Soulseeker**) relates to TBC Anniversary (NA **Dreamscythe**, etc.) and what that means for Church ladders. Does **not** restate install/TOC trees ([30](../30-anniversary-vs-era-deltas/)) or phase calendars ([46](../46-seasonality-fresh-servers/)).

---

## 1. Realm identity (fact sheet)

| Realm | Region | Type | TBC Anniversary progression |
|-------|--------|------|------------------------------|
| Dreamscythe | NA | PvE | **Yes** — V1 Alliance home in brand copy |
| Nightslayer | NA | PvP | Yes |
| Thunderstrike | EU | PvE | Yes |
| Spineshatter | EU | PvP | Yes |
| Maladath | AU–NA | PvP | Yes |
| **Doomhowl** | NA | **Hardcore** | **No** — remains Classic HC |
| **Soulseeker** | EU | **Hardcore** | **No** — same rule |

Source: [Wowhead TBC Anniversary roadmap](https://www.wowhead.com/tbc/guide/the-burning-crusade-classic-anniversary-phase-release-roadmap).

Spec brand: Alliance Dreamscythe / Horde Doomhowl, **independent ladders** ([spec §3.3, §5](../../../superpowers/specs/2026-07-25-church-of-beef-design.md)). After TBC, “Horde on Doomhowl” may describe **origin lore** more than a live TBC guild home.

---

## 2. There is no TBC Hardcore

Blizzard did not ship Burning Crusade Hardcore realms. Characters who wanted Outland had to leave Anniversary HC for **Normal (non-Hardcore) Anniversary** realms during a free transfer window ([Warcraft Tavern — transfers close Jan 12](https://www.warcrafttavern.com/wow-classic/news/anniversary-transfers-for-hardcore-and-classic-era-close-january-12th/); blue-post text quoted in [Doomhowl fate forum thread](https://us.forums.blizzard.com/en/wow/t/what-happens-to-doomhowl-server-on-tbc-launch/2209819)):

| Choice (before window closed) | Outcome |
|-------------------------------|---------|
| Transfer HC Anniversary → Normal Anniversary | Character advances into **TBC Classic Anniversary**; **no longer Hardcore** |
| Stay on Doomhowl / Soulseeker | Remain on current HC realm; continue Classic (Era-adjacent HC life); **no TBC** |
| Miss window, later die on HC | FCM destinations shift toward **non-HC Classic Era** (resurrect there; still not TBC Anniversary unless other paid/special moves exist — do not assume) |

Window cited in community coverage: **12 January 2026** (aligned with TBC Anniversary pre-patch maintenance), with TBC launch **5 February 2026** ([Warcraft Tavern](https://www.warcrafttavern.com/wow-classic/news/anniversary-transfers-for-hardcore-and-classic-era-close-january-12th/)).

Community confirmation of the “transfer by 1/12 to take Doomhowl chars toward Dreamscythe-class progression” reading: [r/wowhardcore transition thread](https://www.reddit.com/r/wowhardcore/comments/1p0kfu3/relevant_info_for_hc_regarding_transition_to_tbc/).

---

## 3. Beef consequences (ladder / SV / guild)

| Event | Ladder consequence |
|-------|--------------------|
| Guild stays on Doomhowl HC | **Not a V1 Beef install target.** Any future Classic HC port = separate product/TOC (see [30](../30-anniversary-vs-era-deltas/)). |
| Members transfer to Dreamscythe (or other Normal Anniversary) | New realm + usually new guild id → **new BeefNet mesh**. Per-character SV does not carry standing. |
| Horde Church reconstitutes on Dreamscythe | Still **faction/guild-scoped** independent ladder; do not merge Alliance Dreamscythe ladder with Horde arrivals. |
| Officer wants continuity of ranks | Manual Officer+ correction / `RANK_COMMIT` after “pilgrim” ceremony — never silent import. |
| Dead ghost left on Doomhowl | Not playable on HC; FCM off-realm creates a **different** character life for Beef (Fresh Beef on destination guild). |

This matches track [46](../46-seasonality-fresh-servers/fresh-servers-and-realm-identity.md) transfer one-liner and doctrine “the flesh must prove itself anew” ([spec §9](../../../superpowers/specs/2026-07-25-church-of-beef-design.md)) — expanded here for HC→TBC specifically.

---

## 4. Support / onboarding copy (HC→TBC pilgrims)

**Q: Does Beef work on Doomhowl?**  
A: V1 is **TBC Classic Anniversary** only. Doomhowl is Classic Hardcore and did not progress to TBC. Install under `_anniversary_` on your TBC realm (see track 30).

**Q: I transferred from Doomhowl to Dreamscythe — where is my Beef rank?**  
A: Standing is per-character and per guild mesh. You start Fresh Beef; officers can recognize prior service manually.

**Q: Can we sync the old Doomhowl ladder into Dreamscythe?**  
A: No automatic sync. Independent ladders by design. Officers may re-bestow Council/Prophet seats by decree.

**Q: Is there Hardcore TBC Beef?**  
A: There is no Blizzard TBC Hardcore realm set. Do not advertise HC TBC support.

---

## 5. Design checklist for clergy / stream

- [ ] Confirm current guild realm name (Dreamscythe vs still-Doomhowl holdouts)
- [ ] Treat post-transfer Horde flock as a **new congregation** for V1 scoring
- [ ] Lore may still say “born on Doomhowl”; machine canon must key off **live guild**, not brand string
- [ ] Memorial content for HC deaths stays on Classic HC cohorts — do not spam Anniversary ladders with HC death ledgers
