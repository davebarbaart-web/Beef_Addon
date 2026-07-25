# Officer / role gates (authority surfaces)

**Track:** [48 README](README.md)  
**Related:** [16 guild-roster-officer-edges](../16-guild-roster-officer-edges/README.md), [22 officer-vs-member-verbs](../22-slash-commands-ux/)

## 1. Why role gates are the first feature flag

In guild tools, the riskiest features are not animations — they are **who may change shared state** and **who may spam chat**. Classic cousins encode that as role checks, not SV booleans.

Church of Beef locks this in product:

- Only Officer+ may approve rank changes (spec §6.2)
- Receivers ignore `RANK_COMMIT` from non-officers (spec §8.2)
- Officer tab hidden; approve actions no-op for others (spec §11)
- Announcement sent only from approving officer’s client (spec §10)

## 2. Cousin patterns

### Gargul — Master Looter as authority

- Soft-reserve **broadcast** is ML-only ([Importing Soft Reserves](https://github.com/papa-smurf/Gargul/wiki/Importing-Soft-Reserves) in cousin research dumps)
- Loot announce defaults on for ML looting corpses; quality / softres inclusion are settings toggles ([Announcing Loot in Chat](https://github.com/papa-smurf/Gargul/wiki/Announcing-Loot-in-Chat))
- Version check helps ML see who lacks the addon ([Version Check](https://github.com/papa-smurf/Gargul/wiki/Version-Check))

**Steal:** authority role + optional noise toggles. Softres broadcast ≈ Beef `RANK_COMMIT` (privileged emit); announce toggles ≈ Beef `ui.announce`.

### RCLootCouncil — Master Looter Options vs personal options

- Personal General settings vs **Master Looter Options** that affect the group only when you are ML ([Options wiki](https://rclootcouncil.com/wiki/Options))
- ML settings are “temporarily copied to the group — nothing overwritten on their end” unless using the synchronizer ([same](https://rclootcouncil.com/wiki/Options))
- Council membership is an explicit list under ML options

**Steal:** mental model — *personal comfort* vs *session authority*. Avoid RCLC’s denser voting council for V1 Beef (cousin teardown already prefers Gargul-like single Officer+ approve).

### Blizzard guild verbs (cultural training)

Players already know officer-restricted chat commands fail with privilege errors. Beef slash/UI should feel like that family: clear deny, not mysterious no-op (see track 22).

## 3. Beef-specific gate checklist

| Action | Gate | Soft UI | Hard validate |
|--------|------|---------|---------------|
| Open Officer tab | Local Officer+ | Hide tab | — |
| Approve / demote / appoint / bestow | Local Officer+ | Disable buttons | Before mutate + before send |
| Apply inbound `RANK_COMMIT` | Sender Officer+ via roster rank-index | — | **Mandatory** (spec §6.2) |
| Guild-chat promotion line | Local Officer+ + `ui.announce` | Opt-out | Don’t send if not officer |
| Emit `SUGGESTION` | Any guild member with addon | — | Shape validation only |
| Debug grant standing | Dev / Alpha only | Hidden | Packaging strip |

Configurable threshold: `OfficerRankIndexMax` (plan Task 5 / track 16) — **not** rank name strings, invite rights, or officer-note edit rights.

## 4. Role gates are not rollout complete

Officer-only UI still ships to every member’s disk. That is fine for V1 authority. It is **not** enough when:

- A new commit schema can crash non-officer receivers while parsing
- A V2 BeefNet type is misunderstood by old clients
- Verbose logging floods guild Alpha testers’ chat

For those, add [version-protocol-gates](version-protocol-gates.md) and [packaging-and-channels](packaging-and-channels.md).

## 5. Insight

**Role gate = product anti-cheat.** Spec §6.3 is explicit: standings are advisory; officer approval is the real gate. Staged rollout of *ceremony chrome* can be SV-flagged; staged rollout of *who may commit* must stay roster-hard forever.
