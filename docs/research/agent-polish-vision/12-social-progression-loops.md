# 12 — Social progression feedback loops

**Lane:** Agent polish vision  
**Date:** 2026-07-26  
**Maps to:** [Church of Beef V1 design](../../superpowers/specs/2026-07-25-church-of-beef-design.md) §4, §7, §10, §13 · optional amendment [roster-backed ladder](../../superpowers/specs/2026-07-25-roster-backed-ladder-design.md)  
**Cousins in-repo:** [track 26 ladders/gamification](../wow-classic-addon-design/26-ladders-points-gamification/), [track 70 My Standing](../wow-classic-addon-design/70-standing-breakdown-ui/)  
**Status:** Research guidance for UI polish — not product law. Spec + `Data/Ranks.lua` win on numbers and authority.

---

## 1. Verdict

Church of Beef already has a healthy **three-layer social progression stack**: instant participation feedback → session/title aspiration → scarce institutional legacy. Polish should make those layers *legible* without turning the UI into a power meter, DKP sheet, or battle-pass shop.

| Horizon | Player feeling | CoB fuel | Primary surface |
|---------|----------------|----------|-----------------|
| **Short** | “I just did something that counted” | Instance drip, Gora result, ceremony close, toast | Toast + My Standing history line |
| **Medium** | “I’m building toward a named title” | Standing → threshold → suggestion | My Standing (title · standing · next) |
| **Long** | “The flock remembers who I am” | Officer-recognized title; Council/Prophet scarcity; guild-chat spectacle | Ladder tab + guild announce |

**Anti–pay-to-win rule of thumb:** progress chrome must read as **recognition of co-play and clergy judgment**, never as **purchasable power, buyable rank, or grind that unlocks gameplay advantage**. Beef ranks do not change combat stats — the UI must never imply they do.

---

## 2. What research says about layered loops

### 2.1 Short / medium / long compulsion

Compelling experiences keep **three loops** running at once: short-term thrills alone decay (whack-a-mole forever fails); medium-term loops must **frame short actions as bricks toward a larger structure**; long-term loops carry legacy, mastery display, and reflective meaning — and often never fully “close,” which is fine ([Opinion: Compulsion Loops In The Short, Medium and Long-term — Game Developer / Pete Collier](https://www.gamedeveloper.com/design/opinion-compulsion-loops-in-the-short-medium-and-long-term)).

Practical layering elsewhere:

- **Short loops** (~seconds–minutes): clear action → immediate feedback → small reward ([Action → Feedback → Reward → Motivation → Repeat](https://medium.com/@algoryte/action-feedback-reward-motivation-repeat-the-compulsive-game-loop-that-hooks-you-0ce432bd7463); [NextBigGames on short + long goals](https://nextbiggames.com/2025/11/19/how-to-design-gameplay-loops-that-keep-players-coming-back-for-more)).
- **Long / session loops:** a visualizable endpoint (“N more to the next sword/title”) ([engagement loops guide](https://github.com/AlexWynn-AM/game-designer/blob/main/guides/game-mechanics-engagement-loops-player-psychology.md)).
- **Meta loops (days–months):** prestige, seasons, social investment, collection — what keeps people returning after the session ends ([same guide](https://github.com/AlexWynn-AM/game-designer/blob/main/guides/game-mechanics-engagement-loops-player-psychology.md)).

### 2.2 Feedback quality (any horizon)

Good feedback is **immediate, clear, and meaningful**; common failures are delayed, inconsistent, overwhelming, or missing response ([Feedback Systems — Blood Moon Interactive](https://www.bloodmooninteractive.com/articles/feedback-systems.html)). Positive (reinforcing) loops amplify desired behavior; negative (balancing) loops stabilize runaway leads — e.g. catch-up items ([Feedback Loops — Game Design Toolkit](https://tkdev.dss.cloud/gamedesign/toolkit/feedback-loops/); [How Game Designers Use Feedback Loops](https://medium.com/@dm3_38053/how-game-designers-use-feedback-loops-to-keep-players-hooked-dfa24089374a)).

**Social feedback loops** specifically use peer recognition and status as the reward channel ([Medium: social feedback loops](https://medium.com/@dm3_38053/how-game-designers-use-feedback-loops-to-keep-players-hooked-dfa24089374a)) — CoB’s native channel, not DPS meters.

### 2.3 Status without “power shop” vibes

Patterns that stay social (not P2W):

| Pattern | Why it feels fair | CoB analogue |
|---------|-------------------|--------------|
| Named standing bands (WoW rep: Friendly → Exalted) | Progress is a *relationship label*, not a damage buff UI ([WoW Classic reputation guide](https://www.pcgamesn.com/world-of-warcraft/classic-reputation-faction-standing)) | Fresh Beef → Beef Butcher bands |
| Cosmetic / recognition rewards layered with intrinsic play | Short cosmetics + long goals without gatekeeping skill ([Game Pill on progression & cosmetics](https://gamepill.com/level-up-the-art-of-designing-game-progression-and-player-rewards)) | Titles, chat spectacle, ceremony theater — not gear |
| Prestige as *reset / scarcity / story*, not paid skip | Meta loops reopen aspiration ([engagement loops guide](https://github.com/AlexWynn-AM/game-designer/blob/main/guides/game-mechanics-engagement-loops-player-psychology.md)) | Council seats + unique Prophet; optional later “Lent” season ([track 26 seasons](../wow-classic-addon-design/26-ladders-points-gamification/season-resets.md)) |
| Human gate on official status | Stops self-serve Elo / edited SV from becoming law | Suggestion → Officer+ (spec §6.3) |

P2W / grind-shop smell arrives when UI shows: shop CTAs, time-skip language, “VIP rank,” parallel paid currencies, or meters that look like combat power. Spec already forbids RMT standing ([track 26 spectacle red lines](../wow-classic-addon-design/26-ladders-points-gamification/spectacle-vs-toxicity.md)); polish must not reintroduce the *aesthetic* of a store.

---

## 3. Church of Beef loop map

### 3.1 Diagram

```text
SHORT (seconds → one dungeon/Gora/ceremony)
  Play with guild / fight Gora / attend rite
       → capped standing grant (+ history line)
       → toast (credit / suggestion created)
       → [balancing] daily caps, combat gate, instance-only

MEDIUM (one guild night → a few weeks)
  Standing climbs toward next point-driven threshold
       → My Standing: "N to Next Title"
       → threshold crossed → pending suggestion (not auto-rank)
       → officer sees breakdown → approve / dismiss / (roster promote*)
       → title changes on Ladder + local highlight

LONG (season of guild life)
  Occupancy of named seats (esp. Council / Prophet)
       → guild-chat announce (spectacle for non-addon members)
       → demotion / excommunication as first-class theater
       → [open] Lent soft reset if Butcher saturates
       → rivalry + stream moments; ranks stay social costumes, not MMR

* Roster-backed amendment: officer fulfills in Blizzard guild UI;
  classic V1 draft: RANK_COMMIT + BeefNet. Loop shape is the same:
  suggestion → human clergy → public recognition.
```

### 3.2 Loop inventory (implementer cheat sheet)

| ID | Horizon | Trigger | Player-visible feedback | Reinforcing (+) / Balancing (−) | Spec / UI home |
|----|---------|---------|-------------------------|----------------------------------|----------------|
| S1 | Short | Instance bucket + combat | Toast optional; history `+N · instance` | (+) co-play; (−) AFK/combat gate, day cap | §7.2 · StandingTab |
| S2 | Short | Gora result recorded | Toast; history win/draw/**loss pays** | (+) show up; (−) avoid win-only | §7.1 · thin Gora |
| S3 | Short | Ceremony close | Toast; flat grant line | (+) ritual attendance | §7.1 · thin Ceremony |
| S4 | Short | Suggestion created | Local toast “petition / officers can promote” | (+) threshold drama | §7.3 · toasts |
| M1 | Medium | Standing rises | Title · standing · **remaining to next** | (+) claim clarity | §10 · StandingTab |
| M2 | Medium | Eligible for next title | Badge “petition pending”; officer queue row | (+) aspiration; (−) no auto-promote | §7.3 · OfficerTab |
| M3 | Medium | Officer approve / roster promote | Ladder row moves; title hero updates | (+) social recognition | LadderTab |
| M4 | Medium | Officer reject / dismiss | Points remain; petition clears | (−) anti-cheat / judgment | §7.3 |
| L1 | Long | Promotion / demotion | Throttled guild-chat line | (+) spectacle; (−) announce opt-out | §10, §13.11 |
| L2 | Long | Council appointment / Prophet bestowal | Empty grind chrome; “appointed only” | (−) scarcity stops month-one solve | §4.1 |
| L3 | Long | Ladder occupancy view | Seven title bands + local highlight | (+) identity costume; (−) not raw-points sort | §10 · LadderTab |
| L4 | Long | (Later) Lent / season | Soft reopen of aspiration | (−) saturation brake | §16 · track 26 |

### 3.3 Cadence vs pacing rule

Spec pacing: **first full dungeon night → first suggestion** (Fresh → Cooked) ([§4.2](../../superpowers/specs/2026-07-25-church-of-beef-design.md)). That is the medium-loop hook that converts short co-play into purpose ([Collier medium-term framing](https://www.gamedeveloper.com/design/opinion-compulsion-loops-in-the-short-medium-and-long-term)). Later thresholds stretch; short loops must still move the standing number so nights feel productive even when titles are rare ([track 26 ranking UX](../wow-classic-addon-design/26-ladders-points-gamification/ranking-ux.md)).

Exact thresholds live only in `Data/Ranks.lua` — do not fork numbers into this note.

---

## 4. Surfacing progress without pay-to-win vibes

### 4.1 UI language (do / don’t)

| Do | Don’t |
|----|-------|
| **Title as hero** (“Cooked Beef”) | Big XP/level chrome that screams RPG power curve |
| **Remaining-to-next** (“12 to Beef Knight”) | Shop-like “Buy boost” / “Skip wait” copy |
| Thin optional track for ranks 1–5 only | Fake castbar / unit-frame power bar for standing |
| Source story lines (Instance / Ceremony / Gora) | EP/GP/PR multi-currency grid |
| “Appointed ranks only” at Council/Prophet | Grind bar toward Prophet |
| “Petition pending — officers decide” | “Rank unlocked!” auto-celebrate before clergy |
| Costume / scripture voice for titles | “Ranked MMR #3” / skill-rating metaphors |
| Caps shown as quiet footnotes on chips | Progress gated behind login streaks / FOMO timers |

Locked V1 standing chrome: text thresholds first; thin 1–5 track optional post-playtest; no meter-dashboard breakdown ([spec §10 / §15](../../superpowers/specs/2026-07-25-church-of-beef-design.md); [track 70](../wow-classic-addon-design/70-standing-breakdown-ui/progress-to-next-title.md)).

### 4.2 Why this avoids P2W *feel* (even with no shop)

Pay-to-win vibes are often **visual and economic**, not only literal RMT:

1. **Power metaphor** — thick meters, “level up” fanfare, combat-adjacent HUD → players assume advantage. Keep edge social UI, not center combat mass ([implications synthesis](../wow-classic-addon-design/00-church-of-beef-implications.md)).
2. **Purchasable shortcut aesthetic** — VIP badges, gold borders for payers, dual currencies. Beef has one currency: advisory standing; officers are the gate.
3. **Infinite grind → top seat** — without scarcity, the “whale” is the no-lifer. Council/Prophet break the loop ([§4.1](../../superpowers/specs/2026-07-25-church-of-beef-design.md)).
4. **Opaque favoritism** — looks like payola even when unpaid. Officer breakdown + human reject is the transparency fix ([§6.3](../../superpowers/specs/2026-07-25-church-of-beef-design.md); [track 26 copy/avoid](../wow-classic-addon-design/26-ladders-points-gamification/beef-copy-avoid.md)).
5. **Shame / bottom boards** — weaponize status. Celebrate promotions and participation; no “worst beef” sorts ([spectacle vs toxicity](../wow-classic-addon-design/26-ladders-points-gamification/spectacle-vs-toxicity.md)).

### 4.3 Macro vs micro surfaces

| Surface | Loop role | Anti-pattern |
|---------|-----------|--------------|
| **Toasts** | Short confirmation | Spam every drip tick |
| **My Standing** | Medium personal purpose | Guild-wide spreadsheet |
| **Ladder** | Long social map | Sort by raw standing as hero |
| **Officer queue** | Medium human gate | Auto-approve chrome |
| **Guild chat announce** | Long public legacy | Duplicate spam / officer-note dump |

Success criterion remains social: a real promotion that **gets a guild-chat reaction** ([§13.11](../../superpowers/specs/2026-07-25-church-of-beef-design.md)).

---

## 5. Balancing loops already in the design

Treat these as intentional **negative feedback** (stabilize the economy), not bugs to “polish away”:

| Mechanism | What it balances |
|-----------|------------------|
| Daily caps / combat-gated buckets | Farm / AFK drip |
| Instance-only co-play | City standing loops |
| Gora losses pay | Challenge avoidance |
| Suggestion ≠ rank | SV edit / self-promote |
| Officer reject + standing correction | Implausible testimony |
| Council seats / unique Prophet | Ladder solved by grind |
| No auto decay in V1 (optional Lent later) | Avoid honor-style maintain-grind hate |

Positive loops to protect in polish: **losses still credit**, **first-night Cooked Beef**, **public announce**, **title theater over points**.

---

## 6. Polish checklist (agents)

When touching UI / copy for progression:

1. Name which horizon you are serving (S / M / L from §3.2). Short feedback must not wait for a title change.
2. Prefer **remaining-to-next** and **event story** over fraction fetishism.
3. Never draw a progress track for appointed ranks.
4. Keep Ladder as **title buckets**, not a points leaderboard.
5. Phrase officer actions as **clergy judgment / roster rite**, not system “level-up complete.”
6. If chrome could be mistaken for WeakAuras power UI or a cash shop, simplify.
7. Pair recognition tools (title + toast + announce) — don’t rely on standing number alone ([PMC / leaderboard pairing caution via track 26](../wow-classic-addon-design/26-ladders-points-gamification/spectacle-vs-toxicity.md)).

---

## 7. Open questions (do not invent in polish)

- Roster-backed vs RANK_COMMIT authority (amendment draft) — loop map unchanged; announcer may defer.
- Lent / seasonal soft reset when Butcher saturates ([§16](../../superpowers/specs/2026-07-25-church-of-beef-design.md)).
- Alt linking vs “flesh proves anew.”
- Thin standing track post-playtest only.

---

## Sources

External (search dumps under `_search-*.json` in this folder):

- [Opinion: Compulsion Loops In The Short, Medium and Long-term](https://www.gamedeveloper.com/design/opinion-compulsion-loops-in-the-short-medium-and-long-term) (Game Developer / Pete Collier; reprinted 2011 piece)
- [How to Design Gameplay Loops That Keep Players Coming Back for More](https://nextbiggames.com/2025/11/19/how-to-design-gameplay-loops-that-keep-players-coming-back-for-more) (Nov 2025)
- [Action → Feedback → Reward → Motivation → Repeat](https://medium.com/@algoryte/action-feedback-reward-motivation-repeat-the-compulsive-game-loop-that-hooks-you-0ce432bd7463)
- [game-mechanics-engagement-loops-player-psychology.md](https://github.com/AlexWynn-AM/game-designer/blob/main/guides/game-mechanics-engagement-loops-player-psychology.md) (short / long / meta loops)
- [Feedback Loops – Game Design Toolkit](https://tkdev.dss.cloud/gamedesign/toolkit/feedback-loops/)
- [How Game Designers Use Feedback Loops to Keep Players Hooked](https://medium.com/@dm3_38053/how-game-designers-use-feedback-loops-to-keep-players-hooked-dfa24089374a) (Sep 2025)
- [Feedback Systems — Blood Moon Interactive](https://www.bloodmooninteractive.com/articles/feedback-systems.html)
- [WoW Classic reputation guide for new players](https://www.pcgamesn.com/world-of-warcraft/classic-reputation-faction-standing) (Aug 2019)
- [Designing Game Progression and Reward Systems](https://gamepill.com/level-up-the-art-of-designing-game-progression-and-player-rewards) (May 2026)

Internal:

- [2026-07-25-church-of-beef-design.md](../../superpowers/specs/2026-07-25-church-of-beef-design.md)
- [26-ladders-points-gamification](../wow-classic-addon-design/26-ladders-points-gamification/)
- [70-standing-breakdown-ui](../wow-classic-addon-design/70-standing-breakdown-ui/)

Search JSON for follow-up:

- `docs/research/agent-polish-vision/_search-social-progression-loops.json`
- `docs/research/agent-polish-vision/_search-progression-cadence-prestige.json`
- `docs/research/agent-polish-vision/_search-cosmetic-status-prestige.json`
