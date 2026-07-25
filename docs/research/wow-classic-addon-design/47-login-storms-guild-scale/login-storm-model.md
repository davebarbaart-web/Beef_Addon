# Login-storm model (thundering herd on GUILD)

**Maps to:** Spec §8.3 login sync; track 14 reply-storm suppression (referenced, not re-derived).

## Herd vs ordinary load

| Pattern | Cause | Timing | Duplication |
|---------|-------|--------|-------------|
| Ordinary load | More people online over an evening | Gradual | Low — commits are rare |
| **Login storm / thundering herd** | Many clients react to the **same trigger** | Simultaneous | High — same sync work repeated |

Classic distributed-systems framing: a herd is everyone rushing the same exit after the whistle — not “too many fans,” but **correlated demand** ([DEV: thundering herd](https://dev.to/thdr/the-thundering-herd-problem-and-how-to-actually-fix-it-14aa); [AWS backoff + jitter](https://aws.amazon.com/blogs/architecture/exponential-backoff-and-jitter)).

For BeefNet the “exit” is the shared `GUILD` addon-message pipe (and each client’s CTL/prefix budget — details in track 14).

## Triggers that correlate Beef clients

| Trigger | Why it herds |
|---------|--------------|
| Raid invite / “invs going out” | Dozens log in or `/reload` within 1–3 minutes |
| Server restart / patch day | Mass cold login; CTL post-login clamp on everyone |
| Guild event / stream night | Social wave into Orgrimmar / Shattrath |
| Officer announces “install Church of Beef” | First-join cold caches (largest payloads) |
| Accidental | Addon error → mass `/reload` |

**Non-triggers (usually):** a single player zoning; one officer approving a rank (one small `RANK_COMMIT`).

## Actors and message fanout

On `GUILD`, a broadcast is heard by every online peer with the prefix registered. Rough cost model (conceptual):

```
R  = number of clients emitting SYNC_REQUEST in a short window
P  = peers willing to answer SYNC_STATE (before suppression)
C  = chunks per SYNC_STATE answer (full dump or diff)
W  = online Beef listeners (receive cost on every machine)
```

| Regime | Wire shape | Receive load |
|--------|------------|--------------|
| Naive | `R` requests + `R×P×C` state chunks | Everyone processes ≈ all of it |
| Spec §8.3 (responder suppress) | `R` requests + ~`R×1×C` state | Better, still `R` dumps if requests are staggered enough that suppression misses |
| **Storm-hardened (this track)** | Coalesced requests (~1–few per window) + one answer each + diffs | Closest to `O(C)` per herd window |

Suppression fails open when requests are **desynchronized by more than the random reply window** (e.g. 0.5–3s in track 14’s sketch): each late requester looks like a new herd. Coalescing + longer “recent request seen” windows fix that.

## Guild-night scenarios (design stress tests)

Assume Anniversary / social guild; Beef installed on a healthy fraction of actives.

| Scenario | Roster | Online w/ Beef (est.) | Storm risk | Dominant failure |
|----------|--------|------------------------|------------|------------------|
| Quiet weekday | 80 | 5–15 | Low | Silence → keep SV |
| Mid-size raid prep | 120 | 25–40 | **High** | Correlated `SYNC_REQUEST` |
| Large social / zerg | 400–500 | 40–80 | **Very high** | Request + reply volume; silent drops |
| Fresh install wave | any | 20+ cold caches | **Very high** | Full-ladder `SYNC_STATE` chunks |
| During raid combat | any | raid + alts | Extreme if syncing | Contends with other addons’ CTL (GRM lesson) |

Roster caps: Classic discourse treats ~**500** as the historic soft/UI visibility band; hard caps later rose to 600→1000 in Cata-era retail ([forum: max guild size](https://us.forums.blizzard.com/en/wow/t/max-guild-size-in-classic/263039); [Bashiok soft-cap note via forum](https://us.forums.blizzard.com/en/wow/t/max-guild-size-in-classic/263039)). Beef should treat **500** as the upper design roster, not as “500 simultaneous syncers.”

## What “success” looks like under a storm

1. Ladder UI remains usable from SV within seconds of login (stale OK).
2. At most a **small constant** of full/diff sync transfers runs for the whole guild in a given 30–60s window.
3. No disconnects attributable to Beef (CTL shared pipe respected; no for-loop floods).
4. Late joiners still converge — via a later coalesced request or hearing a live `RANK_COMMIT`, not via retry hammering.

## Failure signatures (observe in playtest)

| Symptom | Likely cause |
|---------|----------------|
| Many identical `SYNC_STATE` streams overlap | Responder delay window too short vs request stagger; no coalescing |
| Sync “works” for first 10 clients, stalls for rest | Prefix/CTL exhaustion + Classic silent drops ([forum](https://us.forums.blizzard.com/en/wow/t/classic-sendaddonmessage-problems/620054)) |
| Disconnects when pulling | Sync competing with raid addon chatter (GRM Classic notes) |
| Ladder flips then flips back | Consistency issue → track 27; not a storm issue unless partial chunks |

## Pointers into other tracks

- Settle order before any send: track 14 `sync-state-and-anti-spam.md`, track 16 roster readiness.
- Chunk budgets and CTL priorities: track 14 `chatthrottlelib-and-budgets.md`.
- Merge rules when multiple states arrive: track 27.
