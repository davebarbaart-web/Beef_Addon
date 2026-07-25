# Fresh Beef pacing implications

**Track:** 64 · **Scope:** Concrete product implications for Fresh Beef → Cooked Beef (and early alt) pacing.  
**Spec anchors:** §4.2 pacing rule + draft thresholds; §7 scoring; §9 alts; §16.1 / §16.6 open questions.

## 1. The acceptance bar (already written)

> A new member's first full dungeon night with guildmates should produce their first promotion suggestion (Fresh Beef → Cooked Beef).

Draft: Cooked at **50** standing ([design spec §4.2](../../../superpowers/specs/2026-07-25-church-of-beef-design.md)).

That bar is Church of Beef’s **catch-up product**. Loot systems invent decay/Min EP because gear is zero-sum; Beef invents a **cheap first title** because comedy needs a fast costume change.

## 2. What “fair” means at Fresh Beef

| Fair | Unfair |
|------|--------|
| One guild dungeon night → suggestion-eligible | Weeks of raid attendance before first title |
| Alt and brand-new recruit use the same path | Mains inherit rank; alts skip Fresh |
| Low-level instances count fully | Only Karazhan+ pays |
| My Standing shows path to 50 with recent events | Only a global standing sort vs veterans |
| Officer reject is theater/judgment | Silent “trials can’t promote” |

Rookie leaderboard research agrees: boards need movement on a human timescale and a “you are here” rail ([Building better leaderboards](https://uxdesign.cc/building-better-leaderboards-a5013d19cbd7); [UI Patterns](https://ui-patterns.com/patterns/leaderboard)). Fresh → Cooked is that movement.

## 3. Pacing risks unique to no-decay + per-char alts

| Risk | Why it appears | Mitigation |
|------|----------------|------------|
| **Veteran standing intimidation** | Lifetime standing grows; newbies see huge numbers | Ladder shows **titles**, not raw sort as hero; My Standing focuses next threshold |
| **Alt army farming suggestions** | Many Fresh alts each farming night-one Cooked | Daily caps; officer judgment; doctrine keeps ranks per-char (spectacle dilution is social, not a scoring bug) |
| **Helper fatigue** | Max-levels carry RFC for zero glory | Shepherds earn same co-play; celebrate their Cooked/Knight toasts too |
| **Late join mid-expansion** | Guild full of Knights+ when recruit arrives | Fast Cooked still works; mid ranks stretch; Lent later if Butcher-saturated (track 46) |
| **Heroic grind vs lowbie night imbalance** | Same drip, different clears/hour | Tune drip/completion in playtest; ceremony on newbie nights before inventing level bands |

## 4. Threshold shape (early vs late)

Spec already stretches later ranks (50 → 200 → 500 → 1000). Fairness insight from DKP inflation: **do not flatten early and late**. Keep the hook steep; keep the middle long; keep the top scarce (Council/Prophet).

Playtest questions (owned by track 51 instrumentation, answered here as *what to watch*):

1. Did ≥1 Fresh Beef hit Cooked eligibility in the first full dungeon night?
2. Did low-level content (not heroics) suffice for that night?
3. Did any alt hit Cooked *without* a guildmate instance (should be no)?
4. Did officers feel pressure to soft-reject “bank alt spam”?

## 5. Decision table for Fresh Beef fairness

| Decision | V1 recommendation | Defer |
|----------|-------------------|-------|
| First title speed | Keep / protect §4.2 pacing rule | — |
| Alt standing | Per-character Fresh @ 0 | Officer link display (§16.1) |
| Low-level instance credit | Full weight | Level-band multiplier only if playtest demands |
| Newbie night | Ceremony + co-play | Dedicated “levels gained” module |
| Catch-up inject | Officer manual adjust (comedy/corrections) | Automatic EP-style inject |
| Lifetime standing lead | Ignore for UX; titles primary | Soft Lent / season label (46) when saturated |
| Min-EP analogue | **Never** for ranks 1–2 | — |

## 6. Microcopy / guild README (fairness as communication)

Document for members (tone may live in track 32; content belongs here):

- “Alts start at Fresh Beef. This is not a bug.”
- “Your first guild dungeon night is how the Church notices you.”
- “Council and Prophet are appointed — grinding will not finish the game.”

That messaging prevents DKP-brain (“I can never catch their points”) from colonizing a comedy ladder.

## 7. Explicit non-goals (do not build)

- Newbie standing multiplier that never expires.
- Auto-promote Fresh → Cooked (officer gate stays).
- Account-wide Fresh skip.
- Raid attendance streak required before first suggestion.
- Separate “alt ladder” UI in V1.
