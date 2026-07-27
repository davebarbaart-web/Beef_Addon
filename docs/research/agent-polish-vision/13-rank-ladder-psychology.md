# 13 — Rank ladder psychology (Church of Beef)

**Lane:** Agent polish vision · UX psychology applied to the V1 ladder  
**Audience:** Agents polishing Ladder / My Standing / Officer spectacle — not a product-law fork  
**Last updated:** 2026-07-26  

**Authority (do not invert):**

1. Design spec §4 / §10 / §15 — `docs/superpowers/specs/2026-07-25-church-of-beef-design.md`
2. Machine canon — `addon/ChurchOfBeef/Data/Ranks.lua` (`COB.Ranks`)
3. Lore prose only — `docs/canon/ranks.md` (no numbers)
4. This note — guidance for presentation; log any new product choice in the spec decisions log

**Related:** [26 ranking UX](../wow-classic-addon-design/26-ladders-points-gamification/ranking-ux.md) · [70 progress-to-next-title](../wow-classic-addon-design/70-standing-breakdown-ui/progress-to-next-title.md) · [UI agent brief](../../superpowers/ui-polished-direction-for-agents.md)

**Numbers:** Thresholds, `CouncilSeats`, `ProphetUnique`, and officer index live only in `Data/Ranks.lua`. This document names titles and *kinds* (`points` / `council` / `prophet`); it does not restate numeric policy.

---

## 1. What the Beef ladder is psychologically

Church of Beef is a **hybrid status system**:

| Band | Kind | Psychological contract |
|------|------|------------------------|
| Fresh Beef → Beef Butcher | `points` | Earn *eligibility*; officers grant recognition |
| Beef Council | `council` | Seat-scarce governance appointment |
| Beef Prophet | `prophet` | Unique bestowed honor (event, not grind finish) |

That split is the product’s prestige engine: the flock climbs by standing; the clergy chooses the clergy ([design §4.1](../../superpowers/specs/2026-07-25-church-of-beef-design.md); [canon lore](../../canon/ranks.md)). UI must **never imply** that standing fills a bar into Council or Prophet.

---

## 2. Core psychology (cited)

### 2.1 Goal-gradient effect

People increase effort as a goal becomes nearer and more visible ([Goal-gradient in UX — UX Collective](https://uxdesign.cc/designing-for-motivation-with-the-goal-gradient-effect-c873cdf58beb); [LogRocket](https://blog.logrocket.com/ux-design/goal-gradient-effect); [Supercharge Design](https://supercharge.design/articles/goal-gradient-effect-ux-design); origin: Hull 1932 via [Cognitive UX summary](https://cognitive-ux.com/name_en/goal-gradient-effect)).

**Beef apply:**

- My Standing should expose **remaining standing to the next point-driven title** (hero number), not a vague “keep grinding.”
- Near-threshold anticipation should escalate *socially* (suggestion-pending badge, officer queue evidence) more than with Retail XP chrome — V1 locks **text thresholds** first ([UI brief](../../superpowers/ui-polished-direction-for-agents.md); [70 progress](../wow-classic-addon-design/70-standing-breakdown-ui/progress-to-next-title.md)).
- Visual milestones on long stretches (Knight → Lord → Butcher) matter more than early tiers; early tiers already fire quickly by pacing rule.

### 2.2 Endowed progress

People persist more when they feel they have already started ([Nunes & Drèze 2006 — Endowed Progress Effect](https://loyaltyrewardco.com/loyalty-psychology-series-endowed-progress-effect)).

**Beef apply:**

- Every character **starts on the ladder** as Fresh Beef (threshold 0 in canon data) — that *is* endowed membership, not an empty void.
- Copy and Ladder empty-state should treat Fresh Beef as welcome / present (“raw and welcome”), never as “unranked / no title.”
- Alts re-start at Fresh Beef on purpose (flesh proves itself anew) — frame as ritual rebirth, not punishment.

### 2.3 Scarcity principle (real vs fake)

Scarce goods feel more valuable; Cialdini’s conditions include **new scarcity** and **competition for limited slots** ([NN/g — Scarcity Principle](https://www.nngroup.com/articles/scarcity-principle-ux); [Cialdini notes](https://grahammann.net/book-notes/influence-robert-cialdini)). Luxury branding weaponizes rarity as status signaling ([Scarcity and Status — Suger Mint](https://sugermint.com/luxury-branding-scarcity-status)).

**Beef apply:**

- Council seats and Prophet uniqueness are **actual scarcity** (machine-enforced), not countdown-timer dark patterns. UI should show occupancy (“N of seats filled” / “seat open” / “Prophet occupied”) honestly.
- Do **not** fake scarcity with “limited time rank” or urgency spam; prestige comes from appointment rarity + guild spectacle.
- Empty Council seats should feel like open governance drama, not a broken UI.

### 2.4 Authority and human gate

Under uncertainty, people look to authority cues ([NN/g — Authority Principle](https://www.nngroup.com/articles/authority-principle)). Beef’s anti-cheat *is* Officer+ Commit — standing is advisory testimony ([canon](../../canon/ranks.md)).

**Beef apply:**

- Threshold cross → **suggestion**, never auto-promote. UI must dual-encode “eligible / petition pending / official.”
- Officer Commit is the prestige moment; guild-chat announce + private toast are the spectacle budget (spec §10), not a WeakAuras pulse.
- Authority symbols in V1 = clear Officer tab, Commit verb, officer name on record — not fake seals required for V1.

### 2.5 Prestige signaling & social proof

Status systems work when ranks are **legible to the group**, not only to the holder. Progress + community feedback reinforce persistence ([LogRocket — social proof & levels](https://blog.logrocket.com/ux-design/goal-gradient-effect)). Conspicuous rank (Veblen-style signaling via rarity) only works if observers can see and name the title ([Suger Mint](https://sugermint.com/luxury-branding-scarcity-status)).

**Beef apply:**

- Ladder tab: seven title buckets with occupants — titles are the hero signal; standing numbers support eligibility.
- Promotion announce in `/g` is the cheapest public signal for members *without* the addon.
- Do not paint ranks with item-quality rainbow; class color on **names** only (UI brief). Prestige = wording + placement + scarcity chrome, not loot-tier color coding.

### 2.6 Parallel goals beat “be #1”

Named tiers create multiple simultaneous goals (reach next title, sit among Knights, aspire to scarce seats) better than a single Elo climb ([26 ranking UX](../wow-classic-addon-design/26-ladders-points-gamification/ranking-ux.md); UX Collective leaderboard guidance cited there).

**Beef apply:** Keep title as primary; avoid collapsing Ladder into a dense all-time standing spreadsheet.

### 2.7 Honest progress (trust)

Faked or stalled progress bars destroy trust ([goal-gradient honesty notes](https://idseed.fr/ressources/gradient-objectif-motivation-progression-en.html); [70 progress](../wow-classic-addon-design/70-standing-breakdown-ui/progress-to-next-title.md)).

**Beef apply:** Standing updates must move UI on grant/sync; “suggestion pending” is a status, not a frozen 99% bar; cap-hits show as capped, not stuck.

---

## 3. Threshold pacing psychology (point-driven band)

Spec pacing rule: first full dungeon night with guildmates → first promotion *suggestion* (Fresh → Cooked). Fast early hook; later ranks stretch ([design §4.2](../../superpowers/specs/2026-07-25-church-of-beef-design.md)).

| Phase | Psychological job | UI emphasis |
|-------|-------------------|-------------|
| Early (Fresh → Cooked) | Endowed start + quick win → habit | Celebrate first suggestion loudly (toast + pending badge) |
| Mid (Cooked → Knight → Lord) | Goal-gradient across longer gaps; social identity (“people plan around Knights”) | Remaining-to-next + rival peers in band; Ladder occupancy density |
| Late grind (Lord → Butcher) | Mastery / fixture status; standing still moves when titles rare | Micro feedback (event chips) so the board doesn’t feel dead |
| Soft ceiling (Butcher) | Graceful end of grind prestige | Explicit “highest standing-earned rank” copy; redirect aspiration to appointment theater |

Stretching intervals without feedback causes dropout; stretching *titles* while still showing standing movement is the safe pattern ([26 ranking UX](../wow-classic-addon-design/26-ladders-points-gamification/ranking-ux.md)).

---

## 4. Seat scarcity & unique prestige (Council / Prophet)

| Mechanism | Psychology | UI implication |
|-----------|------------|----------------|
| Fixed Council seats (`CouncilSeats`) | Real scarcity + competition for limited governance roles | Show filled vs open seats; list seat holders by name; never a progress bar to “Council %” |
| Prophet unique (`ProphetUnique`) | Extreme rarity → event memory; aspiration without inevitability | Single-occupant slot; “bestowed” language; vacant vs occupied states; no “points to Prophet” |
| Officer appointment only | Authority > grind | Officer flows: Appoint / Bestow distinct from Approve suggestion |
| Demotion / excommunication | Loss + comedy rivalry (no auto-decay in V1) | Same commit path; public announce optional spectacle — do not soft-hide demotions |

Scarcity is ethical here because it is **structural and transparent**, not a fake timer. Dark-pattern urgency (“Council seats closing in 5m!”) is out of scope and off-brand.

---

## 5. UI implications per rank tier

Read titles from `COB.Ranks.Title(id)`. Thresholds via `COB.Ranks.Threshold(id)` / `IsPointDriven`. Lore tone from `docs/canon/ranks.md`.

### 5.1 Fresh Beef (`id` 1 · `points`)

| Concern | Implication |
|---------|-------------|
| Endowed membership | Default title on Ladder and My Standing; never “Unranked” |
| Welcome / onboarding | Empty Ladder for new guild night: show structure of all seven tiers so Fresh Beef sees the mountain |
| First goal | My Standing: remaining to Cooked Beef; pacing copy: invitation, not trophy |
| Alt restart | On-brand “prove the flesh anew” — same chrome as mains |

### 5.2 Cooked Beef (`id` 2 · `points`)

| Concern | Implication |
|---------|-------------|
| First heat / hook | First promotion suggestion should feel like invitation accepted — toast + pending badge + officer visibility |
| Goal-gradient ignition | After Commit, immediately show remaining to Beef Knight |
| Social proof | Ladder occupancy at Cooked should look populated over time; lonely top tiers are OK, lonely entry tiers feel like a dead guild |

### 5.3 Beef Knight (`id` 3 · `points`)

| Concern | Implication |
|---------|-------------|
| Reliability identity | Title copy/lore: “sworn / present” — UI can lightly emphasize *presence* via recent events, not DPS meters |
| Mid-ladder gravity | Highlight local player among Knights; optional nearest standing rivals in-band (post-V1 OK) |
| Stretch begins | Remaining-to-next matters more; keep grant feedback visible |

### 5.4 Beef Lord (`id` 4 · `points`)

| Concern | Implication |
|---------|-------------|
| Pillar / tone-setter | Ladder row should feel weighty (spacing, title weight) without custom art in V1 |
| Long gap survival | Event log + standing integer carry motivation when title cadence slows |
| Prestige without scarcity seats | Lords are numerous relative to Council — do not oversell exclusivity chrome reserved for 6–7 |

### 5.5 Beef Butcher (`id` 5 · `points`)

| Concern | Implication |
|---------|-------------|
| Soft ceiling of grind | My Standing: **no** numeric path to Council/Prophet — “Appointed ranks only” / bestowed copy ([70](../wow-classic-addon-design/70-standing-breakdown-ui/progress-to-next-title.md)) |
| Fixture status | Ladder: Butcher band as “highest earned” landmark before governance break |
| Aspiration redirect | Nearby empty Council seats / Prophet slot create healthy FOMO without fake progress |

### 5.6 Beef Council (`id` 6 · `council`)

| Concern | Implication |
|---------|-------------|
| Seat scarcity | Show seat count from canon (`CouncilSeats`); filled names; open seats as drama, not error |
| Governance, not grind | Distinct Officer actions (Appoint) vs Approve suggestion; no standing threshold display |
| Prestige signaling | Mild authority chrome OK later (seal); V1: clear section break on Ladder between 5 and 6 |
| Competition for seats | Roster of holders is the signal; avoid “Council score” inventing a second ladder |

### 5.7 Beef Prophet (`id` 7 · `prophet`)

| Concern | Implication |
|---------|-------------|
| Unique / bestowed | Single slot; vacant state as sacred absence, not missing data |
| Event memory | Commit → guild announce is mandatory product theater; private toast for holder |
| Unreachable by standing | Same appointed-only Standing copy as Council; never residual “% to Prophet” |
| Maximum prestige | Minimal, highest-contrast treatment — one name, one title — beats dense chrome |

---

## 6. Cross-cutting UI rules (psychology → V1 chrome)

| Do | Don’t |
|----|-------|
| Title as hero; standing as eligibility support | Elo-sort as hero Ladder view |
| Remaining-to-next for ranks 1–5 | Progress chrome into Council/Prophet |
| Dual-encode suggestion / official / demoted | Auto-promote on threshold |
| Honest seat occupancy for Council/Prophet | Fake urgency / limited-time ranks |
| Guild-chat line + edge toast for Commit | Center-screen WA pulses for social prestige |
| Fresh Beef as welcome membership | “No rank” empty identity |
| Read all numbers from `COB.Ranks` | Fork thresholds into UI strings or this doc |

---

## 7. Agent checklist (when polishing Ladder / Standing)

1. Confirm kind via `COB.Ranks` / helpers before choosing progress chrome.
2. Near-threshold: escalate **status** (pending petition), not fake bar drama.
3. On Commit: refresh Ladder occupants + announce path; psychology fails if nobody sees the title change.
4. At Butcher+: flip Standing copy to appointed/bestowed — goal-gradient stops; scarcity theater starts.
5. Keep Classic shell / GameFont* / high-contrast panels; prestige is hierarchy + copy + scarcity, not Media seals in V1.

---

## Sources

- [Designing for motivation with the goal-gradient effect — UX Collective](https://uxdesign.cc/designing-for-motivation-with-the-goal-gradient-effect-c873cdf58beb) (2025)
- [Goal-Gradient Effect in UX Design — Supercharge Design](https://supercharge.design/articles/goal-gradient-effect-ux-design) (2026)
- [The goal gradient effect — LogRocket](https://blog.logrocket.com/ux-design/goal-gradient-effect) (2023)
- [Goal Gradient Effect — Cognitive UX](https://cognitive-ux.com/name_en/goal-gradient-effect)
- [Goal-gradient effect — IDSEED](https://idseed.fr/ressources/gradient-objectif-motivation-progression-en.html) (2026)
- [Scarcity Principle in UI Design — NN/g](https://www.nngroup.com/articles/scarcity-principle-ux) (2021)
- [The Authority Principle — NN/g](https://www.nngroup.com/articles/authority-principle) (2022)
- [Loyalty Psychology: Endowed Progress Effect — Loyalty & Reward Co](https://loyaltyrewardco.com/loyalty-psychology-series-endowed-progress-effect) (summarizing Nunes & Drèze 2006)
- [Scarcity and Status in Luxury Branding — Suger Mint](https://sugermint.com/luxury-branding-scarcity-status) (2026)
- [Influence / Cialdini notes — Graham Mann](https://grahammann.net/book-notes/influence-robert-cialdini) (2026)
- In-repo: `Data/Ranks.lua`, `docs/canon/ranks.md`, design spec §4/§10, tracks 26 & 70

**Search dumps (follow-up):**  
`docs/research/agent-polish-vision/_search-rank-ladder-psychology.json` · `_search-prestige-scarcity.json`
