# Progress to next title

**Track:** 70 · **Scope:** How My Standing should show distance to the next **point-driven** Beef title — without fake XP bars, castbar skins, or inventing grind paths to Council/Prophet.  
**Not in scope:** Ladder band layout ([26](../26-ladders-points-gamification/), [57](../57-scrollframe-list-rows/)); season/Lent resets ([26/season-resets](../26-ladders-points-gamification/season-resets.md)).

## Product rules

| Rank band | Progress chrome |
|-----------|-----------------|
| Fresh Beef → Beef Butcher (1–5) | Show next threshold + remaining standing |
| Beef Council / Beef Prophet | **No** point progress — “Appointed ranks only” / bestowed (plan Task 8; [53](../53-beef-lore-ui-bible/)) |
| Pending suggestion after threshold | Standing still shows; status badge “Petition pending” (officer gate) |

Draft thresholds live in canon `Data/Ranks.lua` (e.g. 0 / 50 / 200 / 500 / 1000) — docs must not fork numbers; UI reads canon.

---

## What works (research + Classic cousins)

### Determinate “band progress” (reputation model)

Watched reputation exposes **min / max / value** inside the current standing band ([GetWatchedFactionInfo](https://warcraft.wiki.gg/wiki/API_GetWatchedFactionInfo)). Players understand: *named tier now, fill toward named tier next.*

**Beef formula (point-driven):**

```text
currentTitle
standing S
nextTitle (if any)
need = threshold(next) - S   # clamp display at 0 when eligible
```

Primary readout (always):

```text
Cooked Beef · 38 standing
12 to Beef Knight
```

Optional secondary: thin fill `S / threshold(next)` or `(S - threshold(current)) / (threshold(next) - threshold(current))` for “within band” feel. Prefer **remaining-to-next** as the hero number — it matches player goal language better than raw fraction.

### Visibility of system status

Progress indicators reduce uncertainty when the system state is otherwise opaque ([NN/g — Progress Indicators](https://www.nngroup.com/articles/progress-indicators/)). Standing is not a wait spinner, but the same heuristic applies: members should not wonder whether the addon is “working” after a dungeon.

**Beef implication:** After a grant, My Standing (and optional toast) must show **new total + remaining**. Silent SV mutation with no UI movement is a trust bug.

### Honest pacing

SaaS progress-bar research stresses **honest, paced feedback** over theatrical bars that stall at 99% ([Userpilot — Progress bar UI/UX](https://userpilot.com/blog/progress-bar-ui-ux-saas/)). For Beef:

- Do not animate a bar that lags behind actual standing.  
- Cap-hit should show as capped (chip footer), not as a stuck 99% bar.  
- Suggestion-pending is a **status**, not a progress freeze pretending the threshold was not crossed.

### Attune “what’s next”

Attune’s personal tree makes the **next objective** obvious ([Arcane Intellect](https://arcaneintellect.com/attune-world-of-warcraft-wow-tbc-addon-spotlight/)). Beef’s next objective is almost always numeric (“earn M more standing”) plus social path (“run with guildmates / show up to Gora / attend ceremony”) — put the number in the header; put the path in empty-state / help blurb ([41](../41-empty-states-degraded-ux/)), not as a second quest tracker.

---

## Recommended V1 presentation

| Priority | Element | Notes |
|----------|---------|-------|
| 1 | Current title (large) | Sacred hero word ([53](../53-beef-lore-ui-bible/)) |
| 2 | Standing integer | “N standing” |
| 3 | Next line | “M to {NextTitle}” **or** “Appointed ranks only” |
| 4 | Optional StatusBar | Single thin bar; Classic `StatusBar` texture; **not** castbar template; hide if appointed-only |
| 5 | Petition badge | If `MaybeSuggest` already fired: “Suggestion pending officers” |

### Do / Don’t

| Do | Don’t |
|----|-------|
| Text thresholds from canon | Hardcode 50/200/… in UI strings docs as truth |
| Show remaining for ranks 1–5 | Show “points to Council/Prophet” |
| Keep progress on the panel | Combat HUD threshold beeps ([08](../08-combat-hud-alerts/)) |
| Update on grant / sync paint | Require `/reload` to see progress |
| Plain FontString first | ElvUI-fighting XP bar skins as V1 dependency |

---

## Edge cases

| Case | Progress UI |
|------|-------------|
| Standing ≥ next threshold, suggestion pending | Remaining shows **0** (or “Eligible”) + petition badge; do not hide eligibility |
| Standing ≥ next, suggestion rejected | Points remain ([§7.3](../../../superpowers/specs/2026-07-25-church-of-beef-design.md)); still eligible; show last reject if cheap ([40](../40-officer-moderation-audit/)) |
| Official rank already at next title | Recompute next from **official** rank id, not from standing alone |
| Unguilded / scoring paused | Progress muted; empty-state owns the story ([41](../41-empty-states-degraded-ux/)) |
| Day cap on instance | Header progress unchanged; source chip explains stall |

---

## Explicit non-goals

- Multi-step onboarding wizard progress for ranks.  
- Prestige / Lent reset chrome on My Standing (product decision lives in [26](../26-ladders-points-gamification/)).  
- Comparing your fill % against guildmates on this tab (that is ladder / rivalry, not personal breakdown).
