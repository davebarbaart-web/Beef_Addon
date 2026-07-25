# Classic guild fun-score systems (ladder-specific)

**Track:** 26 · **Scope:** How Classic guilds already run points, attendance, and duel ledgers — and which mechanics transfer to a comedy rank ladder.  
**Not in scope:** Full RCLootCouncil / Gargul / Attune product tear-downs (track 13). Guild chat/roster chrome (track 09).

## Taxonomy

| Family | Job | Beef relevance |
|--------|-----|----------------|
| **Loot points (DKP / EPGP)** | Ration raid loot via earned currency / priority | Low for V1 product; high as *anti-pattern* for UI density & toxicity |
| **Attendance / raid trackers** | Who showed up; often feeds DKP sites | Medium — co-play + ceremony attendance ideas |
| **Duel / challenge logs** | W/L memory, rivalry | High — Gora cousin |
| **External bank/score sites** | Export SV → website leaderboard | Caution — ToS / trust / offline drama |

## Loot-point economies (know them to avoid becoming them)

### EPGP

Effort Points (EP) measure contribution; Gear Points (GP) measure loot taken; Priority ≈ EP/GP; percentage **decay** fights hoarding; Min EP / Base GP tune new vs idle members ([Wowpedia: EPGP](https://wowpedia.fandom.com/wiki/EPGP)). Classic ports exist (e.g. [EPGP-Classic on GitHub](https://github.com/jpxthu/EPGP-Classic); [CEPGP on CurseForge](https://www.curseforge.com/wow/addons/cepgp); [WoWInterface CEPGP](https://www.wowinterface.com/downloads/info25051-CEPGP.html)).

**Steal:** Separate “effort” channels; decay-as-*optional later* tool; officer-visible math.  
**Avoid:** PR tables as primary UI; loot coupling; spreadsheet culture.

### DKP / OpenDKP / raid trackers

DKP bids attendance and preparedness into a spendable loot bank. Classic tooling includes raid attendance addons and site-linked trackers (e.g. [OpenDKP Classic Addon](https://github.com/Moncleared/OpenDKP-Classic-Addon); [GuildLaunch CT_RaidTracker Classic](https://www.wowinterface.com/downloads/info25254-GuildLaunchCT_RaidTrackerClassic.html); community “Guild Raid Attendance” style tools). Forum culture still debates whether these systems are toxic or merely leadership-dependent ([Blizzard: DKP and EPGP systems](https://us.forums.blizzard.com/en/wow/t/dkp-and-epgp-systems/1791081)).

**Steal:** Attendance as a *first-class credited event*; transparency so members can see their standing anytime.  
**Avoid:** Bidding, spend currency, “bonus DKP for favorites,” external site as system of record for Church ranks.

## Fun-score / rivalry cousins (closer to Beef)

### Duel trackers

Players have wanted duel W/L logs since Vanilla; Classic threads still ask for them ([EU forums: Duel logs addon](https://eu.forums.blizzard.com/en/wow/t/duel-logs-addon/154534)). Existing efforts include personal trackers such as [DuelTracker](https://kevinlocke.name/programs/dueltracker) and [DuelBook](https://www.curseforge.com/wow/addons/duelbook) ([GitHub](https://github.com/HotChilly/DuelBook)). Private-server communities even pitch “guild duel leaderboard” addons ([Warmane thread](https://forum.warmane.com/showthread.php?t=473558)) — treat as signal of demand, not as a ToS-safe blueprint.

**Steal for Gora:**

- Explicit challenge → outcome states (win / loss / draw).
- Per-opponent history on My Standing (rivalry memory).
- Sync of *official* outcomes only after officer/ceremony rules — personal logs can stay local.

**Avoid:** Elo ladder as the hero UI; endless same-opponent farming (apply DR — [anti-farm](anti-farm-incentives.md)).

### Guild incentive experiments

Classic officers have asked for addons that track time-in-group / levels-gained with guildmates to award DKP-like incentives for helping ([Blizzard: Guild Addon help](https://us.forums.blizzard.com/en/wow/t/guild-addon-help/450778)). That is the same *co-play* instinct as Beef’s shared-instance drip — but raw time tracking is AFK-farm candy.

**Steal:** Guildmate co-presence as a credit signal.  
**Avoid:** Ungated open-world time scores.

### External ledgers

Classic Guild Bank–style export-to-website patterns repeatedly trigger ToS anxiety ([Blizzard: Classic Guild Bank ToS thread](https://us.forums.blizzard.com/en/wow/t/classic-guild-bank-addon-maybe-violanting-tos/293244)). Even when legal, an external score site becomes the *real* ladder and splits the guild.

**Beef stance:** Officer-committed records + BeefNet remain system of record. No V1 website ladder.

## What a “fun-score” guild system looks like when healthy

1. **Participation pays** (attendance, losses, show-up).
2. **Scarcity at the top** (council seats / unique titles) so grind cannot finish the game.
3. **Human approval** for status changes (loot council / officer gate).
4. **Public theater** (announces) so non-addon members still feel the church.
5. **Caps + DR** so optimization weirdness stays funny, not meta-mandatory.
6. **Transparent breakdown** so favoritism claims are inspectable.

Beef’s hybrid ladder already matches this shape more than EPGP does. The risk is **accidentally shipping EPGP UX** (dense tables, PR sorts, decay anxiety) under comedy skin.
