# Annotated URLs — ladders, points, gamification

**Track:** 26 · Curated primary references. Prefer these over `.raw/` dumps when citing.  
**Legend:** **Steal** = use directly · **Adapt** = reshape for comedy/officer hybrid · **Avoid** = anti-pattern warning · **Context** = background only.

## Ranking UX

| URL | Annotation |
|-----|------------|
| [https://ui-patterns.com/patterns/leaderboard](https://ui-patterns.com/patterns/leaderboard) | **Steal:** show user placement + neighbors; short-horizon defaults; friends/local cohorts. **Avoid:** boards in non-competitive communities; stagnant all-time elite lists. |
| [https://uxdesign.cc/building-better-leaderboards-a5013d19cbd7](https://uxdesign.cc/building-better-leaderboards-a5013d19cbd7) | **Steal:** boards must move on human timescales; parallel goals (beat neighbor / aspire). **Adapt:** title tiers supply parallel goals without Elo. |
| [https://pmc.ncbi.nlm.nih.gov/articles/PMC8097522/](https://pmc.ncbi.nlm.nih.gov/articles/PMC8097522/) | **Adapt:** macro + micro leaderboards; minimize relative deprivation / failure spirals. Maps to Ladder tab vs My Standing. |
| [https://leaderboarded.com/blog/posts/gamification-leaderboards](https://leaderboarded.com/blog/posts/gamification-leaderboards) | **Context:** real-world boards skew to single ranked metric; complexity loses adoption. Supports simple V1 ladder. |

## Season resets & WoW ladders

| URL | Annotation |
|-----|------------|
| [https://wowpedia.fandom.com/wiki/PvP_season](https://wowpedia.fandom.com/wiki/PvP_season) | **Adapt:** season = rating reset + refreshed rewards; model for optional “Lent” soft reset, not V1 default. |
| [https://wowpedia.fandom.com/wiki/Honor_system_(Classic)](https://wowpedia.fandom.com/wiki/Honor_system_(Classic)) | **Context:** weekly standing + historical decay. Warning: maintenance grind culture. |
| [https://www.wowhead.com/classic/guide/pvp-honor-system-overview-wow-classic](https://www.wowhead.com/classic/guide/pvp-honor-system-overview-wow-classic) | **Context:** Classic honor ranking overview (Era/SoD-era guides). Use for weekly-reset mental model. |
| [https://www.wowhead.com/classic/news/decay-being-removed-entirely-from-pvp-honor-system-wow-classic-336421](https://www.wowhead.com/classic/news/decay-being-removed-entirely-from-pvp-honor-system-wow-classic-336421) | **Avoid:** continuous decay as engagement — Blizzard removed it after community pain. |
| [https://us.forums.blizzard.com/en/wow/t/classic-era-pvp-rank-reset-coming-with-patch-1144/1596356](https://us.forums.blizzard.com/en/wow/t/classic-era-pvp-rank-reset-coming-with-patch-1144/1596356) | **Adapt:** explicit announced resets > silent drip. |
| [https://boosting-ground.com/wow-classic/guides/pvp-guides/wow-classic-honor-system](https://boosting-ground.com/wow-classic/guides/pvp-guides/wow-classic-honor-system) | **Steal idea:** same-target diminishing returns / daily reset as anti-farm curve for Gora & instance drip. |
| [https://www.turtlebeach.com/blog/black-ops-6-how-does-the-prestige-system-work-explained](https://www.turtlebeach.com/blog/black-ops-6-how-does-the-prestige-system-work-explained) | **Adapt:** opt-in prestige reset for glory/cosmetics — metaphor for Lenten vow. |

## Anti-farm & point economies

| URL | Annotation |
|-----|------------|
| [https://wiki.guildwars.com/wiki/Anti-farm_code](https://wiki.guildwars.com/wiki/Anti-farm_code) | **Steal idea:** reduce value of repeating the same farm objective. |
| [https://wowpedia.fandom.com/wiki/EPGP](https://wowpedia.fandom.com/wiki/EPGP) | **Adapt:** separate effort channels; transparent priority math. **Avoid:** importing EP/GP/PR as Beef UX. |
| [https://github.com/jpxthu/EPGP-Classic](https://github.com/jpxthu/EPGP-Classic) | **Context:** Classic EPGP port shape — officer tools, not comedy ladder. |
| [https://www.curseforge.com/wow/addons/cepgp](https://www.curseforge.com/wow/addons/cepgp) | **Avoid as template:** loot-distribution UI density. |
| [https://www.wowinterface.com/downloads/info25051-CEPGP.html](https://www.wowinterface.com/downloads/info25051-CEPGP.html) | **Context:** Classic distribution listing for CEPGP. |

## Spectacle vs toxicity

| URL | Annotation |
|-----|------------|
| [https://leaderboarded.com/blog/posts/leaderboards-in-gaming/](https://leaderboarded.com/blog/posts/leaderboards-in-gaming/) | **Steal:** celebrate more than top; team goals; casual vs ranked pressure. **Avoid:** rank-as-identity, time-as-skill, unchecked cheaters. |
| [https://pmc.ncbi.nlm.nih.gov/articles/PMC8916940/](https://pmc.ncbi.nlm.nih.gov/articles/PMC8916940/) | **Context:** leaderboards-only can feel worse than boards + other recognition — pair titles/toasts/chat. |
| [https://rodrigobelo.com/assets/pdf/leaderboards.pdf](https://rodrigobelo.com/assets/pdf/leaderboards.pdf) | **Steal:** performance feedback often drives upside more than pure social comparison — My Standing event log. |
| [https://xqa.io/blog/gamification-in-ux-design-2026](https://xqa.io/blog/gamification-in-ux-design-2026) | **Avoid:** shallow points/badges/login FOMO. **Steal:** immediate feedback + positive social relatedness. |
| [https://www.onwardpsychservices.com/blog/what-is-toxic-comparison](https://www.onwardpsychservices.com/blog/what-is-toxic-comparison) | **Context:** clinical framing of harmful comparison — don’t build shame boards. |
| [https://us.forums.blizzard.com/en/wow/t/dkp-and-epgp-systems/1791081](https://us.forums.blizzard.com/en/wow/t/dkp-and-epgp-systems/1791081) | **Avoid lesson:** favoritism / opaque bonus points narratives. **Steal lesson:** transparency + leadership boundaries. |

## Classic guild fun-score cousins

| URL | Annotation |
|-----|------------|
| [https://kevinlocke.name/programs/dueltracker](https://kevinlocke.name/programs/dueltracker) | **Adapt:** duel outcome logging patterns for thin Gora. |
| [https://www.curseforge.com/wow/addons/duelbook](https://www.curseforge.com/wow/addons/duelbook) | **Adapt:** personal W/L vs opponents — rivalry memory on My Standing. |
| [https://github.com/HotChilly/DuelBook](https://github.com/HotChilly/DuelBook) | **Context:** small open-source duel log addon. |
| [https://eu.forums.blizzard.com/en/wow/t/duel-logs-addon/154534](https://eu.forums.blizzard.com/en/wow/t/duel-logs-addon/154534) | **Context:** demand signal for duel history in Classic. |
| [https://forum.warmane.com/showthread.php?t=473558](https://forum.warmane.com/showthread.php?t=473558) | **Context only:** private-server “guild duel leaderboard” demand — not a distribution target. |
| [https://github.com/Moncleared/OpenDKP-Classic-Addon](https://github.com/Moncleared/OpenDKP-Classic-Addon) | **Avoid as product:** site-linked DKP attendance. **Steal:** attendance as credited event. |
| [https://www.wowinterface.com/downloads/info25254-GuildLaunchCT_RaidTrackerClassic.html](https://www.wowinterface.com/downloads/info25254-GuildLaunchCT_RaidTrackerClassic.html) | **Context:** Classic raid attendance/loot tracking lineage. |
| [https://us.forums.blizzard.com/en/wow/t/guild-addon-help/450778](https://us.forums.blizzard.com/en/wow/t/guild-addon-help/450778) | **Adapt carefully:** officers want co-play incentives — gate with combat/instance rules. |
| [https://us.forums.blizzard.com/en/wow/t/classic-guild-bank-addon-maybe-violanting-tos/293244](https://us.forums.blizzard.com/en/wow/t/classic-guild-bank-addon-maybe-violanting-tos/293244) | **Avoid:** external website as Church ladder of record. |

## Product truth (internal)

| URL / path | Annotation |
|------------|------------|
| [`docs/superpowers/specs/2026-07-25-church-of-beef-design.md`](../../../superpowers/specs/2026-07-25-church-of-beef-design.md) | **Canon:** §4 ladder, §6.3 officer anti-cheat, §7 scoring, §10 UI/spectacle, §16 Lent/decay open question. |

## Provenance files

Raw Parallel search/extract JSON for audit:

- `.raw/search-ranking-ux.json`
- `.raw/search-season-resets.json`
- `.raw/search-anti-farm.json`
- `.raw/search-spectacle-toxicity.json`
- `.raw/search-classic-guild-scores.json`
- `.raw/search-leaderboard-research.json`
- `.raw/search-wow-honor-seasons.json`
- `.raw/search-epgp-dkp.json`
- `.raw/search-gamification-criticism.json`
- `.raw/search-duel-attendance.json`
- `.raw/extract-ux-principles.json`
- `.raw/extract-honor-seasons.json`
- `.raw/extract-epgp-antifarm.json`
- `.raw/extract-toxicity-mitigation.json`
- (plus earlier extract batches if present)
