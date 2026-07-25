# Classic catch-up patterns (newcomers & alts)

**Track:** 64 · **Scope:** How guild points/loot cultures already solve (or fail) “I just joined / I’m on a baby alt.” Steal framing; do not import loot math into Church of Beef.  
**Not in scope:** Full EPGP/DKP product teardown or anti-farm (track [26](../26-ladders-points-gamification/)). SV/account identity (track [25](../25-multi-toon-realm-edges/)).

## 1. The problem these systems are solving

Guild points economies create a **time-in-guild advantage**. Veterans keep earning; newcomers earn at the same rate from a lower base — so without a valve, they never feel competitive ([MMORPG.com — DKP inflation](https://forums.mmorpg.com/discussion/239047/how-to-make-a-dkp-system-work); private-server DKP critique threads such as [Warmane: Why the DKP system is a fraud](https://forum.warmane.com/showthread.php?t=453203) — treat as *demand signal*, not ToS guidance).

Classic officers also report the blunt case: no decay → “really new people catching up didn’t happen” ([How Did You DKP?](https://us.forums.blizzard.com/en/wow/t/how-did-you-dkp/1645502)).

**Beef translation:** Standing only goes up in V1. The fairness product cannot be “inflate faster forever.” It must be **reachable early titles** + **scarce late prestige** + optional later soft season (track 46).

## 2. EPGP priming toolkit (know it to avoid copying it)

Canonical “priming the system” parameters ([EPGPWeb — The System](http://www.epgpweb.com/help/system); mirrored on [Wowpedia: EPGP](https://wowpedia.fandom.com/wiki/EPGP)):

| Knob | Job | Catch-up effect |
|------|-----|-----------------|
| **Decay** | Shrink old EP/GP so recent attendance dominates | Veterans and newcomers converge if they raid together (~15 raids at 10% decay in Wowpedia’s narrative) |
| **Min EP** | Roadblock: below threshold → effectively no loot PR | *Anti*-instant-catch-up; new members must attend before they can need |
| **Base GP** | Floor on GP so 0-GP trials cannot have infinite PR | Stops “newbie leapfrogs veteran,” not “newbie feels welcome” |

Classic ports (e.g. [EPGP-Classic](https://www.curseforge.com/wow/addons/epgp-classic), [GitHub fork](https://github.com/jpxthu/EPGP-Classic)) expose decay / mass EP / standby — still **loot priority machinery**.

### Steal for Beef

- Explicit **onboarding parameters** (“what happens when someone joins”).
- Separate “recent show-up” from “lifetime grind” *as a product story* (titles + My Standing events do this without decay math).

### Avoid for Beef

- Min EP as a promotion gate (opposite of Fresh → Cooked first-night hook).
- Base GP / PR tables / officer-note ledgers as UI.
- Continuous decay in V1 (spec locked; honor decay was hated and later removed in Classic Era — see track 26 seasons notes).

## 3. DKP catch-up valves guilds actually use

From Classic forum practice ([How Did You DKP?](https://us.forums.blizzard.com/en/wow/t/how-did-you-dkp/1645502)) and DKP design discussion ([MMORPG.com](https://forums.mmorpg.com/discussion/239047/how-to-make-a-dkp-system-work)):

| Valve | Intent | Beef analogue |
|-------|--------|---------------|
| **Hard DKP cap** (e.g. ~800) | Stops infinite lead; spenders stay competitive | Daily source caps already; do **not** need lifetime standing cap if titles + Council scarcity work |
| **Zerosum / spend-down** | Points leave the system when loot is taken | N/A — Beef standing is not spend currency |
| **Trial period** (earn but cannot spend) | Protects raid loot from day-one bids | **Opposite** of desired comedy hook — do not trial-lock Cooked Beef |
| **Day-one earn + bid** | Some guilds let new members participate immediately | Closer to Beef: earn standing night one |
| **Bonus DKP for helping** (attunes, consumes) | Credits non-raid contribution | Maps to co-play drip + ceremony + officer adjust |
| **Bench / standby DKP** (alt online ready) | Rewards availability | Optional later; Gora/ceremony already reward show-up |

## 4. How alts are treated in points culture

Observed patterns:

- **Main priority / alt bid caps** — alts bid less or lose to mains ([How Did You DKP?](https://us.forums.blizzard.com/en/wow/t/how-did-you-dkp/1645502) anecdotes).
- **Addon filters for alt characters** in DKP tables ([WebDKP](https://webdkp.com/addon) changelog: filters for alt / standby).
- **Separate alt DKP pools** or “alt raids” social nights (guild culture, rarely addon-enforced).

**Beef V1 stance (spec §9):** each character is a flock member. That matches comedy doctrine and avoids “bank alt inherits Prophet.” Fairness for alts is **fast early pacing on that character**, not inheritance from the main.

Officer-linked alts remain §16.1 / track 25 — if ever added, fairness means **display collapse**, not silent standing merge.

## 5. Fun-score cousin: “pay people to help lowbies”

Classic officers explicitly asked for addons that track **time in group / levels gained with guildmates** to award DKP-like incentives for power-leveling and quest help ([Guild Addon help](https://us.forums.blizzard.com/en/wow/t/guild-addon-help/450778)).

| Instinct | Healthy Beef mapping | Unhealthy mapping |
|----------|----------------------|-------------------|
| Helping guildmates should pay | Shared-instance co-play + ceremony | Open-world time / XP-gained meters |
| Lowbie nights matter | Full credit in low-level instances | Raid-only standing |
| Veterans who shepherd feel seen | Toast / announce when lowbie hits Cooked | Hidden officer bonus multipliers |

## 6. Leaderboard framing for rookies (non-WoW, still binding)

- Absolute global boards discourage rookies; prefer friends/local/similar-activity cohorts and short windows ([UI Patterns: Leaderboard](https://ui-patterns.com/patterns/leaderboard)).
- Huge absolute ranks feel random and intimidating; seasonal / bracketed competition reopens catch-up ([Building better leaderboards](https://uxdesign.cc/building-better-leaderboards-a5013d19cbd7)).

**Beef already uses title buckets** instead of a single Elo. For Fresh Beef fairness: emphasize **progress to Cooked** and same-rank neighbors over “guild standing #47 of 120.”

## 7. One-page steal / avoid

| Steal | Avoid |
|-------|-------|
| Day-one earn rights | Min EP / trial lockouts on early titles |
| Caps that stop infinite lead (daily, not lifetime) | Lifetime DKP race as the hero number |
| Credit for helping / attendance theater | XP-gain / open-world time trackers |
| Clear “what happens when you join” rules | Silent account merge of standing |
| Soft season later if saturated | Continuous decay anxiety in V1 |
