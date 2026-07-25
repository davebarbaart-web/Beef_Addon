# Gray areas: guild point systems, ranks, and competition

**Track:** `24-policy-tos-compliance`  
**Last updated:** 2026-07-25  
**Purpose:** Where Church of Beef’s standing/rank ladder sits relative to Blizzard rules — what is clearly fine, what is clearly not, and what needs careful framing.

## Why this is a gray area

Blizzard’s written UI policy and EULA do **not** say “guild DKP addons are illegal.” The ecosystem has long used EPGP, loot council, attendance trackers, and attunement helpers. Those tools are social/governance overlays on top of the game.

At the same time, several EULA/CoC themes can catch a guild points product if it drifts:

| Theme | Source | How a guild ladder can trip it |
|-------|--------|--------------------------------|
| Unfair advantage / cheating | [CoC](https://us.battle.net/support/en/article/42673), [EULA Cheating](https://www.blizzard.com/en-us/legal/fba4d00f-c7e4-4883-b8b9-1b4500a402ea/blizzard-end-user-license-agreement) | If points automate combat or grant mechanical P2W outside social fiction |
| RMT / paid services | EULA Prohibited Commercial Uses | Selling ranks/points for real money or paid boosts |
| In-Platform advertising | EULA + UI policy rule 4 | Using the ladder UI to sell goods/services |
| Wagering | EULA Prohibited Commercial Uses (v) | Turning Gora into a betting book |
| Realm/player harm | UI policy rule 3 | Spam sync, grief via false commits |
| Win-trading / exploiting players | [CoC](https://us.battle.net/support/en/article/42673) | Collusive rank farming that scams members |

Church of Beef is intentionally a **comedy social / streamer spectacle** layer (spec §1), not a raid-optimization tool — that framing helps, but does not waive EULA commercial/wagering rules.

---

## Clearly allowed (typical guild-tool pattern)

These patterns match long-standing loot/attendance culture and the written rules:

1. **Cosmetic / social ranks and titles** tracked in SavedVariables and synced among willing addon users.
2. **Officer-gated authority** using real WoW guild rank (spec §6.2–6.3) — human judgment, not cryptographic anti-cheat.
3. **Self-reported standing** with officer approval (advisory testimony) — honest about SV editability.
4. **Recording outcomes of player-initiated events** (duel/Gora result entered by humans; ceremony closed by officer).
5. **Shared instance co-play credit** based on API-visible party/raid/instance state + anti-AFK heuristics — *information display and scoring*, not playing the instance for you.
6. **Guild chat announcements** of promotions for spectacle (success criterion §13.11).

Nothing here modifies the client binary, automates the character, or charges money for the addon.

---

## Clearly disallowed (do not build)

| Pattern | Why |
|---------|-----|
| Real-money purchase of Beef ranks / standing | UI policy rule 1 + EULA commercial / RMT themes |
| Paywalled “premium Prophet tools” | UI policy rule 1 |
| In-addon ads or tip jars | UI policy rules 4–5 |
| Auto-combat to farm standing | EULA bots + CoC automation + secure API |
| External bot feeds points into the ladder | Same |
| Guild “betting pool” with gold/USD stakes on Gora or BG outcomes wired into the addon | EULA wagering ban |
| Using BeefNet to broadcast gold-selling or commercial spam | EULA ads + UI policy |
| Obfuscated closed-source score engine | UI policy rule 2 |

---

## Gray / caution zones (design carefully)

### 1) “Unfair advantage”

CoC forbids activities that grant an **unfair advantage**. Purely social titles do not change DPS, loot rights in the WoW rules engine, or matchmaking.

**Caution:** If officers start requiring Beef rank for **actual raid loot** or kick non-payers, that becomes guild governance drama — not automatically a Blizzard ban, but can shade into scamming/exploitation if deceptive. Keep Beef ranks **addon-layer fiction** unless the guild’s own social contract is explicit and consensual (spec already: ranks are not a replacement for WoW guild ranks).

### 2) Wagering vs theatrical competition

EULA bans organizing/promoting/facilitating/participating in events involving **wagering** on game outcomes without authorization ([US EULA](https://www.blizzard.com/en-us/legal/fba4d00f-c7e4-4883-b8b9-1b4500a402ea/blizzard-end-user-license-agreement)).

| Safer framing | Riskier framing |
|---------------|-----------------|
| Beef Gora: challenge → record win/loss/draw → **standing points** (no stakes) | “Place your bets,” odds, pot, buy-in |
| Deferred “audience favor” as **streamer theater / pretend meter** (spec §3.2) | Real tip-driven gambling market tied to outcomes |
| Participation points for showing up (spec §7.1 “losses must pay”) | Side pots of gold winner-take-all managed by the addon |

**Recommendation:** V1 Gora stays a **recorded sporting ritual**. If V2 adds a favor meter, keep copy theatrical (“the crowd cheers”) and avoid stake/odds/pot terminology in UI strings. Do not take entry fees.

### 3) Farming / collusion

Anti-abuse caps (spec §7.2) are primarily product quality, but they also reduce “win-trading-like” standing mills that could feel like exploiting the guild’s social economy. Officer reject remains the backstop (spec §6.3).

### 4) Data about other players

Publishing another player’s performance or personal info outside the guild without consent is a trust/CoC-adjacent issue even when the API allows reading it. Keep ladder sync **guild-scoped**.

### 5) Automation of *social* decisions

Auto-approve promotions without an officer click would not usually be a Blizzard ban by itself (it’s still tainted UI clicking a button), but it **contradicts** the project’s anti-cheat stance and increases grief potential (forged social state). Spec correctly requires Officer+ human approval.

### 6) “Services related to the add-on”

Charging for a hosted Beef website that is **required** to make the addon function would collide with UI policy rule 1. A free optional fan site is fine; a mandatory paid backend is not.

---

## Comparison: Church of Beef vs classic DKP

| Classic DKP / EPGP | Church of Beef V1 |
|--------------------|-------------------|
| Points for raid attendance/loot priority | Points for co-play, Gora, ceremony |
| Officers adjust | Officers approve suggestions / manual correct |
| Often loot-binding social contract | Explicitly social/streamer ranks; WoW guild rank separate |
| Rarely automated combat | Must never automate combat |
| Free community addons exist | Must remain free |

Church of Beef is **closer to attendance + ceremony trackers** than to damage meters. That is the compliant neighborhood.

---

## Decision guide for future features

Ask four questions before shipping a points feature:

1. **Does it play the game for anyone?** If yes → reject (spec §2 + EULA bots).
2. **Does anyone pay real money for access or rank?** If yes → reject (UI policy + RMT themes).
3. **Is there a stake/bet/pot on an outcome?** If yes → reject or redesign without wagering (EULA).
4. **Can it spam or grief other players at scale?** If yes → throttle + officer gates (UI policy rule 3 + CoC).

If all four answers are no, the feature is likely in the same gray-safe band as existing guild social addons.