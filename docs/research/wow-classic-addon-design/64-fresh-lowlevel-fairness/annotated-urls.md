# Annotated URLs — Fresh / low-level fairness & catch-up

Primary sources for track 64. Prefer EPGP priming docs, Classic officer practice, and leaderboard UX over booster “level alts fast” listicles.

## EPGP priming & catch-up math (loot — steal framing only)

| URL | Annotation |
|-----|------------|
| http://www.epgpweb.com/help/system | Canonical **Decay / Base GP / Min EP** priming. Decay = catch-up valve; Min EP = newcomer *roadblock*; Base GP stops 0-GP infinite PR. **Avoid** importing Min EP into Fresh→Cooked. |
| https://wowpedia.fandom.com/wiki/EPGP | Same system narrative + worked examples; notes newcomers converge under decay (~15 raids @ 10%) with Min EP as the only entry barrier. Use as anti-pattern for Beef early ranks. |
| https://www.curseforge.com/wow/addons/epgp-classic | Classic/TBC port surface (decay, mass EP, standby). Proof the priming knobs shipped in-game — still loot machinery, not fun-score theater. |
| https://github.com/jpxthu/EPGP-Classic | Source/README for Classic EPGP fork; links EPGPWeb system help. |

## DKP inflation, caps, alt practice

| URL | Annotation |
|-----|------------|
| https://us.forums.blizzard.com/en/wow/t/how-did-you-dkp/1645502 | Classic officers: earn rates, trial periods, day-one bid rights, hard caps (~800), alt/bench DKP, “new people catching up didn’t happen” without decay. Rich steal/avoid table. |
| https://forums.mmorpg.com/discussion/239047/how-to-make-a-dkp-system-work | DKP design failure modes: **inflation discourages newcomers**, hoarding, farm-vs-progress payout skew; recommends zerosum + caps. Maps to why Beef must not hero raw lifetime standing. |
| https://forum.warmane.com/showthread.php?t=453203 | Private-server rant on DKP as newcomer trap — **demand signal** for catch-up anxiety, not a ToS-safe blueprint. |
| https://webdkp.com/addon | WebDKP Classic-era addon notes: DKP cap option, **alt/standby filters**, attendance — shows how loot tools segregate alts in the UI. |

## Helping lowbies / leveling incentives

| URL | Annotation |
|-----|------------|
| https://us.forums.blizzard.com/en/wow/t/guild-addon-help/450778 | Officer wants time-in-group / levels-gained meters for DKP-like help incentives. Validates co-play instinct; warns against XP/time AFK farms (see track 26). |

## Level-gated credit precedent (Blizzard)

| URL | Annotation |
|-----|------------|
| https://wowpedia.fandom.com/wiki/Honor_system_(Classic) | HK only if target is high enough level (**not gray**). Precedent for level-banding *credit*, not a recipe for Beef weights. |

## Rookie / catch-up leaderboard UX

| URL | Annotation |
|-----|------------|
| https://ui-patterns.com/patterns/leaderboard | Absolute boards go stale and demotivate rookies; prefer friends/local/similar cohorts and short windows. Supports title buckets + My Standing over global standing sort. |
| https://uxdesign.cc/building-better-leaderboards-a5013d19cbd7 | Boards need session-scale movement; huge absolute ranks intimidate; seasonal/bracket catch-up. Anchors Fresh→Cooked as the fairness hook. |

## Product truth (repo)

| Path | Why |
|------|-----|
| [`docs/superpowers/specs/2026-07-25-church-of-beef-design.md`](../../../superpowers/specs/2026-07-25-church-of-beef-design.md) §4.2, §7, §9, §16 | Fresh Beef pacing rule, scoring sources, per-char alts, open doors. |
| [`../26-ladders-points-gamification/`](../26-ladders-points-gamification/) | Gamification core — do not duplicate; this track owns newcomer/alt fairness only. |
| [`../25-multi-toon-realm-edges/`](../25-multi-toon-realm-edges/) | Alt SV identity & account-merge options. |
| [`../46-seasonality-fresh-servers/`](../46-seasonality-fresh-servers/) | Late catch-up via season/Lent — not early-rank Min EP. |
| [`../51-guild-night-playbook/`](../51-guild-night-playbook/) | How to measure the first dungeon night in the field. |

## Provenance dumps

| File | Contents |
|------|----------|
| [`.raw/search-catchup-fairness.json`](.raw/search-catchup-fairness.json) | Parallel search: DKP/EPGP catch-up, newbie fairness |
| [`.raw/search-epgp-priming-newbie.json`](.raw/search-epgp-priming-newbie.json) | Parallel search: Base GP / Min EP / newbie nights |
| [`.raw/search-alts-levelbands-ux.json`](.raw/search-alts-levelbands-ux.json) | Parallel search: alt DKP policy, leaderboard UX |
| [`.raw/search-newbie-nights.json`](.raw/search-newbie-nights.json) | Parallel search: leveling/alt nights (noisy; prefer Blizzard forum hits) |
| [`.raw/search-epgp-priming-url.json`](.raw/search-epgp-priming-url.json) | Parallel search: EPGPWeb priming URL discovery |
| [`.raw/extract-key-sources.json`](.raw/extract-key-sources.json) | Extracts: EPGP wiki, DKP forum, guild-addon-help, leaderboard UX |
| [`.raw/extract-epgpweb-priming.json`](.raw/extract-epgpweb-priming.json) | Extract: EPGPWeb Decay / Base GP / Min EP |
| [`.raw/extract-dkp-inflation-honor-level.json`](.raw/extract-dkp-inflation-honor-level.json) | Extracts: MMORPG DKP inflation, honor gray-level, WebDKP alts |
