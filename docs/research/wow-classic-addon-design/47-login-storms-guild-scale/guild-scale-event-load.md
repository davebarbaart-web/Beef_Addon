# Guild-scale event load (online-N, not roster-N)

**Maps to:** Spec §8.2 traffic stance; §10 guild-chat announce (one sender). Complements login storms with **steady and bursty event** load.

## Two different N’s

| N | Meaning | Drives |
|---|---------|--------|
| **Roster N** | Members in guild (40–500 design band) | Cold-cache full dump size; officer note alternatives elsewhere |
| **Online Beef N (`W`)** | Characters online with addon listening | Receive CPU, CTL contention, storm width |

A 500-roster guild that is mostly offline is cheap. A 60-roster guild stacked in Karazhan with every raider on Beef is expensive.

Historic soft visibility ~500 members in guild UI ([Classic guild size threads](https://us.forums.blizzard.com/en/wow/t/max-guild-size-in-classic/263039)); design for that roster ceiling, **stress-test** against peak `W` on a stream/raid night.

## Event classes by fanout cost

| Event | Fanout | Cost at large `W` | V1 rule |
|-------|--------|-------------------|---------|
| `RANK_COMMIT` | GUILD broadcast | 1 small frame × rare | OK — official state |
| Guild-chat spectacle | GUILD chat | 1 line from **approving officer only** | OK — never peer re-announce |
| `SUGGESTION` | GUILD broadcast | Medium if every threshold ping fires | Rate-limit per player; officers filter |
| `SYNC_REQUEST` / `SYNC_STATE` | GUILD | Storm amplifier | Coalesce + diff (this track) |
| `HELLO` | GUILD | Easy to turn into login spam | Tiny; debounce; no periodic mesh ping |
| `SCORE_EVENT` | GUILD | **Catastrophic** if per-combat | Prefer **local-only**; if ever wired, coarse + rare + BULK |
| Local standing accrual | none | Free | Default path |

Threat-meter history is the cautionary tale: many clients exchanging high-frequency data forced Classic throttle culture ([SendAddonMessage problems](https://us.forums.blizzard.com/en/wow/t/classic-sendaddonmessage-problems/620054)). Beef must not reinvent that with comedy points.

## Roster-churn traps

`GUILD_ROSTER_UPDATE` (and friends) can fire often as people login/out, notes change, or the client refreshes. Dangerous bindings:

| Anti-pattern | Why it hurts at scale |
|--------------|----------------------|
| Sync on every roster update | Login wave → roster events → sync storm feedback loop |
| Re-validate all commits on every update | CPU spike on 500-row rosters; do targeted lookups |
| Broadcast HELLO on every update | Same as sync storm, smaller packets |
| Officer+ checks that call full roster scans in receive hot path | Receivers pay `W × cost` per message |

Safe pattern (conceptual): roster updates **enable** queued work (unblock a waiting settle, refresh Officer+ cache) but do **not** by themselves emit BeefNet traffic. Optional: at most one deferred “maybe sync” after a long offline gap, still jittered/coalesced.

## HELLO and version gates under load

Version soft-warn is valuable; a mesh of periodic HELLO is not.

| Approach | Verdict |
|----------|---------|
| HELLO once after settle | OK |
| HELLO when major version changes locally | OK |
| HELLO every N minutes while online | Avoid for V1 |
| Reply-ALERT to every HELLO | Avoid — amplification |

Hearing `RANK_COMMIT` / `SYNC_STATE` already proves peer presence.

## Raid-night contention (shared CTL)

Guild Roster Manager’s Classic notes: global addon-comms budget is shared; sync during group/combat contended with raid addons; disconnects reproducible on Classic when sync loops mis-accounted throttle ([GRM file notes](https://www.curseforge.com/wow/addons/guild-roster-manager/files/2874277)). 

Beef load guidance:

- Prefer **no automatic bulk sync** while `InCombatLockdown()` or in instance with a full raid — defer with jittered backoff.
- Live `RANK_COMMIT` stays small/NORMAL and should still flow (rare).
- Never raise priority of sync to “win” against DBM/Details — lose politely (BULK).

## Score and suggestion volume (guild night)

Back-of-envelope for a lively night (illustrative, not a promise):

| Source | If broadcast naively | If local-first |
|--------|----------------------|----------------|
| 40 players × instance buckets × hour | Hundreds of point ticks on wire | 0 on wire |
| Threshold crossed → suggestion | Tens of `SUGGESTION` | Same, but rate-limited |
| 3 promotions | 3 commits + 3 chat lines | Same |

Product stance already says spectacle is the chat line + ladder change — not a live points ticker on GUILD.

## Receive-side cost

Even “small” messages cost every listener. At `W=50`, a mistaken 10 Hz broadcast is 500 handler wakes/sec across the guild. Design receive handlers to be cheap: parse → revision gate → ignore, no UI work on duplicates (track 27 replay-safe).

## Playtest metrics (guild scale)

Log (locally, debug) for one guild night:

1. Count of `SYNC_REQUEST` sent / heard per hour  
2. Count of `SYNC_STATE` chunk bursts and overlap  
3. Max concurrent sync FSMs observed  
4. Whether any sync ran during combat  
5. `SCORE_EVENT` on wire (target: zero)

If (1) spikes with raid invites, coalescing/jitter is failing. If (2) overlaps, responder suppression window is too tight.
