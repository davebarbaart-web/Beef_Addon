# Implications for Church of Beef

**Last updated:** 2026-07-25  
**Maps to:** [V1 design spec](../../../superpowers/specs/2026-07-25-church-of-beef-design.md)  
**Evidence base:** This folder’s landscape + patterns docs; deep research [`.raw/guild-social-deep.md`](.raw/guild-social-deep.md).

---

## Top insights (read this first)

1. **Belonging = visible history.** GRM-class tools prove the strongest social mechanic is biography (join/promo history, alts, logs) — Beef’s ladder titles + standing breakdown are the V1 form of that.
2. **Officer queue ≈ loot council Voting Frame.** Steal RCLC’s pending-list IA (who / claim / context / approve), not gear math. Judgment + log beats autopilot.
3. **Spectacle fails if silent.** Congratulator/Greet addons and the V1 social-check agree: a rank change nobody hears did not happen. Throttled cult-voice guild chat is the cheapest ritual.
4. **Scarcity at the top is the point.** EPGP/council cultures collapse if everything is grindable — Beef Council seats + unique Prophet match that lesson.
5. **Graceful degrade is a social feature.** Attune/Gargul succeed when non-installers still raid; BeefNet must stay invisible to the unconverted.
6. **Cadence before cathedral.** Calendars (GEM/Group Calendar/GoW) show rituals need rhythm; V1 thin ceremony/Gora is enough if officers run them weekly.
7. **Discord is the hall; game is the pulpit.** Bridges are out of V1 scope, but naming and one-line announcements should be stream/Discord-pasteable.
8. **Standing is comedy-DKP.** Publish it; officer-gate it; don’t pretend client points are sacred truth.

---

## Steal / adapt / avoid

| Pattern | Source exemplars | Verdict for V1 | Notes |
|---------|------------------|----------------|-------|
| Enriched roster biography | GRM | **Adapt** | Ladder + My Standing; not full CRM |
| Suggest → human approve | RCLC council; Beef spec | **Keep** | Already core |
| Autopilot promote/kick | Guild Manager | **Avoid** | Kills sacred theater |
| Session/queue officer UI | RCLC Voting Frame | **Steal** | Officer tab checklist |
| SoftRes speed tooling | Gargul | **Avoid** | Wrong philosophy |
| Attendance → currency | WebDKP / EPGP | **Adapt** | Standing points, not loot DKP |
| Appointed scarce seats | Council cultures | **Keep** | Council / Prophet |
| Guild survey sync | Attune | **Keep** | BeefNet degrade path |
| Delayed funny grats | Guild Achieves | **Adapt** | Cult templates + throttle |
| Proactive greet prompts | GuildGreet | **Defer** | Nice for Fresh Beef onboarding later |
| Full guild calendar | GEM / Group Calendar | **Defer** | Thin ceremony first |
| Discord ↔ calendar bot | Guilds of WoW | **Conceptual only** | Hard in-game rule |
| Cross-realm shared ladder | Cross-guild chat dreams | **Avoid** | Spec: independent churches |

---

## V1 feature mapping

| Spec surface | Social pattern it implements | Success signal |
|--------------|------------------------------|----------------|
| Rank ladder UI | Enriched identity / status board | Members open `/beef` to see flock order |
| Standing sources | Attendance + ritual participation ledger | First dungeon night → first suggestion |
| Suggestion → Officer+ | Loot-council judgment ritual | Officers argue in good faith over a row |
| `RANK_COMMIT` + revisions | Immutable-enough award log | Offline member catches up on login |
| Guild-chat announcement | Shoutout vernacular | Audible reaction on stream/guild night |
| Council appoint / Prophet bestow | Scarcity rites | Feels like anointment, not ding |
| Demotion / excommunication | Public ledger of consequence | Comedy + deterrence |
| Per-character alts | “Flesh proves itself anew” | On-brand; GRM alt-link is a later doctrine question |

---

## Cult/community checklist (from deep research, Beef-filtered)

Grounded checklist from [deep research](.raw/guild-social-deep.md), filtered by V1 hard rules:

| # | Primitive | V1? | Where |
|---|-----------|-----|-------|
| 1 | Enriched roster / history | Partial | Ladder + standing events |
| 2 | Milestone shoutouts | Yes | Promotion/demotion guild lines |
| 3 | Ritual calendar | Thin | Ceremony start/close |
| 4 | Discord bridge | No | Ops naming only |
| 5 | Voting / approve ritual | Yes | Officer tab |
| 6 | Contribution ledger | Yes | Standing sources + caps |
| 7 | Public reputation score | Yes | Standing + titles |
| 8 | Shared inside-language | Yes | Announcement templates / footer |
| 9 | Persistent change logs | Partial | Revisions; fuller history later |
| 10 | Threshold ceremonies | Yes | Suggestion toast + announce |

---

## Phase hints (do not expand V1 silently)

| Phase | Social upgrade suggested by this research |
|-------|--------------------------------------------|
| V2 | Ceremonial dashboard = collective memory wall; confession/spotlight = GuildGreet energy at scale |
| V3 | Gora presentation = match theater (closer to session spectacle than RCLC loot) |
| Later / ops | Optional Discord echo of public announces; still no gameplay control |
| Open question | GRM-style alt linking vs permanent per-character penance (already in spec §16) |

---

## Design tests (social, not unit)

Before calling V1 “done” socially:

1. A Fresh Beef finishes a guild dungeon night and gets a **suggestion** (not a silent rank).
2. An officer approves and **guild chat speaks in Church voice**.
3. Someone without the addon still understands the sentence.
4. A Prophet bestowal feels different in UI + wording from Cooked Beef.
5. Two realms never share one ladder (Dreamscythe ≠ Doomhowl).
