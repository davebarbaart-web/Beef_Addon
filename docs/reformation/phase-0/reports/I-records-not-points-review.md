# Phase 0 Lane I — Adversarial Review

**Lane:** Records, not points  
**Artifact:** `.cursor/rules/records-not-points.mdc`  
**Lane report:** `docs/reformation/phase-0/reports/I-records-not-points.md`

**Spec:** PASS  
**Quality:** Changes required

Rule not edited. No Critical Bible contradiction.

## Verdict

Conformance with the Design Bible and Laws 1, 2, and 9 holds. The rule does not smuggle back points, XP, currencies, Grant, standing, suggestion machinery, thresholds-as-progression, Beef Prophet, or a sortable ranked ladder. All six §5 ranks are present; Butcher is a raid-team role, display-only this phase; the Pope is not a rank. No invented numbers, extra ranks, or service scores.

The Law 1 “streaks” ban versus §10.9 Longest Streak is resolved in the Bible’s favor (narrative Gora record, not an economy), which is the correct conflict rule. That exception is not bounded tightly enough: “streaks as *narrative record*” is not locked to sanctioned-Gora win/loss, and §4.6 engagement streaks / §10.6 favor streaks are not named. That is an Important quality gap, not a Spec fail.

## Attack results

| Attack | Result |
|---|---|
| Points, thresholds, Grant, suggestion, Prophet, ranked ladder smuggled back? | **No.** Banned in product text and in the grep list. Records Book is parchment superlatives, not a ladder. |
| Law 1 “streaks” vs §10.9 Longest Streak without an engagement-streak economy? | **Mostly.** Correct distinction; exception under-bounded (Important). |
| Six ranks present; Butcher display-only; Pope not a rank? | **Yes.** Matches Law 9 and §5 / v1.1.1 Butcher confirmation. |
| Invented product (numbers, extra ranks, service scores)? | **No.** §10.9 list copied with OPEN_QUESTIONS #3 veto marked. No demo thresholds (50/200/500/1000). |

## Findings

### Critical

None.

### Important

1. **Streak exception is not locked to sanctioned-Gora W/L** (Law 1; §4.6; §10.6; §10.9).  
   Law 1 bans streaks flatly. §4.6 bans *engagement* streaks (no payout required). §10.9 requires streaks as Gora *stories*, including Records Book **Longest Streak** and **The Undefeated**. The rule’s phrase “streaks-as-economy” / “streaks as *narrative record*” is the right shape and sits in a Gora-records paragraph, but it never says the only legal streak is a sanctioned-Gora win/loss streak. It never names §4.6 “engagement streaks” or §10.6 “No favor streaks, no accuracy records.” A Phase 1 agent can file login, Gathering-attendance, or favor-accuracy counters as “narrative record” and still claim this rule. The Undefeated (“active unbeaten records”) plus an unbounded narrative-streak license is the residual engagement-economy risk. Tighten: Gora W/L streaks only; engagement / login / daily / favor / accuracy streaks remain banned.

### Minor

2. **Grep tells are over-broad against Bible vocabulary** (brief-mandated list; §5, §10.3, §10.5, §12, §15).  
   `threshold` hits §5 Knight (“The threshold where full Church identity features become expected”). `standing` hits §12 “social standing” and ordinary English. `suggestion` can collide with §10.5 “the software recommends.” `Grant` is the correct V1 tell; case-sensitive it does not hit “Pope-granted” (§15). “Refuse and delete” is stronger than “do not rebuild the points machine” and can cause false excision. Process risk, not a product smuggle.

3. **Lord attainment omits the Knight starting rank** (§10.4).  
   Bible norm: “a Beef Knight who wins a sanctioned Gora in a match the Pope judges fair.” The rule says “win a sanctioned Gora the Pope judges fair; Pope elevates. Attainable.” It does not authorize Fresh→Lord, but it does not forbid it either.

4. **Knight attainment omits the Pope as actor** (Law 3; §5; §8).  
   One-line “ceremony: KNIGHT THIS BEEF” is brief-faithful and does not give the verb to officers. Pope-authority is another lane.

5. **`Net/**` is not in the globs** (brief: Core/Data/UI).  
   Standing/Grant sync could be rebuilt in Net without this rule firing. Out of exclusive scope; integrator note.

## What was checked and held

- **No points economy.** Law 1 / §4.6 / Audit V1 language is present. “Do not rebalance a points system” is present. Demo grant table (5/12/20/3/40/15/8/5, daily caps) is absent.
- **No Grant / standing / suggestion machinery.** Named ban + grep: `standing`, `Grant`, `Grant(`, `threshold`, `suggestion`, `elo`, `leaderboard`, `prophet`. Report contract met.
- **No Prophet; Pope is not a rank.** Law 9; Bible v1.1.1 changelog. Audit V2 “Beef Prophet” stays dead.
- **No ranked ladder.** §5 “not a linear RPG ladder”; §10.9 / §22.1 “no ranked ladder”; rule: “not a sortable ranked ladder.” After Lord: records / rivalries / defenses / narrative streaks / honorifics — not more ranks (§5, §10.4).
- **Six ranks, exact names.** Fresh Beef, Cooked Beef, Beef Knight, Beef Lord, Beef Butcher, Beef Council. Butcher = human raid-team designation, display-only this phase (§5 v1.1.1; Law 9). Older audit “Butcher dies / five ranks” is superseded; the rule follows current canon, not the grind-capstone Butcher.
- **Attainment lines** match §5 / §10.4 one-liners: Fresh = recruitment, addon does not own recruit/purge; Cooked = outside addon, Council reflects; Knight = KNIGHT THIS BEEF; Lord = fair sanctioned Gora + Pope elevation, attainable; Butcher = human raid designation; Council = human judgment, prunable.
- **Records are stories.** W/L, streaks, defenses, head-to-heads, notable victims, rulings. No damage meters, duration stats, per-class win rates (§10.9).
- **Honorifics.** Pope-granted, cosmetic text, no mechanical benefits (§15). Not called a currency (safer under Law 1).
- **Quiet Knights.** Witnessed history + human recognition; no service scores; no achievement tracks (§5, §15).
- **Law 2 / §4.9 / §17.** Record events, never behavior; no hours / combat-minutes; no contribution numbers; no activity leaderboards; different contributions stay distinguishable; no single collapsing number.
- **No invented OPEN_QUESTIONS answer.** Records Book categories listed as Bible MVP with veto pointer to existing item 3. Nothing appended.

## Sections checked

- `docs/reformation/phase-0/TEN_LAWS.md` (Laws 1, 2, 9; Bible-wins)
- `docs/reformation/phase-0/briefs/I-records-not-points.md`
- `docs/reformation/phase-0/reports/I-records-not-points.md`
- `.cursor/rules/records-not-points.mdc` (frontmatter, bans, ranks, records, recognition)
- Bible §4.6, §4.9, §5, §10.4, §10.9, §15, §17
- Adjacent (attack only): §10.5 (no ELO; software recommends), §10.6 (no favor streaks), §12.1 (“social standing” phrase), §22.1–22.2 (Records Book MVP; no artificial economies)
- `docs/design/OPEN_QUESTIONS.md` item 3
- `docs/design/Demo_Build_Audit.md` V1, V2 (and v1.1.1 Butcher/Prophet changelog)

## Brief contract

Frontmatter, globs (Core/Data/UI; `alwaysApply: false`), must-include bans, six ranks, attainment lines, Records Book list, honorifics, quiet-Knight recognition, grep list, and the lane report’s Status / sections / grep line are all present. Lane correctly left `architecture-overview.mdc` and surviving Grant Lua to integrator / Phase 1.
