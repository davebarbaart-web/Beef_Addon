# Backoff, jitter, and request coalescing

**Maps to:** Spec §8.3 “random response delay + suppression”; extends that idea to **requesters** and **retries**. Transport token buckets stay in track 14.

## Why jitter beats plain delays

Capped exponential backoff without randomness still produces **retry clumps**: everyone sleeps `2^k` and wakes together. Adding randomness spreads arrivals ([AWS: Exponential Backoff And Jitter](https://aws.amazon.com/blogs/architecture/exponential-backoff-and-jitter); [Builders’ Library: timeouts, retries, backoff](https://aws.amazon.com/builders-library/timeouts-retries-and-backoff-with-jitter)).

| Algorithm | Sleep intuition | Beef fit |
|-----------|-----------------|----------|
| No jitter | `min(cap, base·2^attempt)` | **Avoid** — recreates herds |
| Equal jitter | keep half backoff + random half | OK; slower recovery |
| **Full jitter** | `random(0, min(cap, base·2^attempt))` | **Preferred** for SYNC retries |
| Decorrelated | next delay from previous random | Fine if implementers prefer; slightly more calls in AWS sims |

AWS finding (still cited in SDK retry guidance): full / decorrelated jitter cut client work sharply vs no-jitter exponential; equal jitter loses on completion time.

**Also jitter non-retry timers.** Builders’ Library: periodic jobs and delayed work should not align on wall-clock (login settle timers, “retry later” on roster update). Prefer per-client random or stable-per-character offset so the same toon is reproducible in bug reports without aligning the whole guild.

## Three layers Beef needs

### 1) Request send jitter (before first `SYNC_REQUEST`)

Do not fire `SYNC_REQUEST` at `PLAYER_LOGIN` + fixed 5.0s for everyone.

Conceptual:

```
settle = enter-world + roster ready + CTL post-login window   # see track 14 / 16
sendAt = settle + Uniform(T_min, T_max)   # e.g. 2–12s extra full jitter
```

Widen `T_max` on large online peer counts if measurable (optional heuristic: more online → wider window). Cap so UX still heals within ~30s on a quiet night.

### 2) Responder jitter + suppression (already in spec / track 14)

Peers wait random short delay; abort if any `SYNC_STATE` for `reqId` (or for a coalesced epoch — below) is seen. Prefer Officer+ longer delay so fresher caches answer first (track 14 mapping).

This track adds: suppression should also key off a **short-lived guild sync epoch**, not only a single request id, so late requesters can adopt an in-flight answer.

### 3) Retry backoff with full jitter + budget

On timeout / incomplete chunk set:

```
attempt = 0..N_max          # small, e.g. 3–5
delay   = Uniform(0, min(cap, base * 2^attempt))
```

| Knob | Suggested design envelope | Rationale |
|------|---------------------------|-----------|
| `base` | 5–15s | Longer than reply window; shorter than “player gives up” |
| `cap` | 60–120s | Avoid hour-long sync zombies |
| `N_max` | 3–5 | Retry budget — prevent death spirals ([retry budgets at scale](https://platformwale.blog/2026/04/30/resilience-patterns-at-scale-exponential-backoff-jitter-retry-budgets-and-circuit-breakers-in-practice)) |
| Manual refresh | Resets budget once | Player agency without auto-storm |

**Do not** retry on every `GUILD_ROSTER_UPDATE` — that event is chatty; see [guild-scale-event-load.md](guild-scale-event-load.md).

## Request coalescing (singleflight on the guild bus)

Cache stampede / singleflight idea: when many need the same value, **one** fetch runs; others wait or share ([thundering herd mitigations](https://aryandhirhi.hashnode.dev/the-thundering-herd-problem)).

Beef adaptations (peer bus, no coordinator):

| Tactic | Behavior |
|--------|----------|
| **Hear a peer `SYNC_REQUEST`** | If local also intends to request soon, **cancel** local send and wait for resulting `SYNC_STATE`; apply merge (track 27). Optionally send nothing if watermark ≤ answered state. |
| **Hear `SYNC_STATE` for others** | Always merge if revisions newer — free heal for silent peers. |
| **Epoch / quiet window** | After any guild-wide sync activity, suppress new automatic requests for `E` seconds (jittered), except manual refresh. |
| **Watermark banding** | Two clients with the same max-revision watermark want the same diff; coalescing is exact. Divergent watermarks may still share a full dump from an officer. |
| **In-flight latch (local)** | One client never runs two sync FSMs at once (local singleflight). |

Coalescing is complementary to responder suppression: suppression stops **N answers to one request**; coalescing stops **N requests for one herd**.

## Stale-while-revalidate

Herd literature’s “serve stale” maps cleanly to SavedVariables:

1. Login → show cached ladder immediately.
2. Mark UI “syncing…” only if desired (optional, low drama).
3. Revalidate via coalesced sync; never blank the ladder because the bus is busy.

This is availability-first AP behavior (track 27 partition healing) with an explicit **load** motivation: storms must not turn into spinner hell or retry floods.

## What not to copy from server-land

| Pattern | Why weak on BeefNet |
|---------|---------------------|
| Circuit breaker opening “the API” | No central API; opening locally just means “stop syncing” — use retry budget instead |
| Distributed lock for cache rebuild | No reliable lock store; use bus observation + suppression |
| Gossip anti-entropy mesh | Overkill for V1 ladder; login heal + commits suffice (see track 27) |

## Precedents in WoW addons (load behavior only)

| Addon | Pattern to steal | Pattern to avoid for Beef V1 |
|-------|------------------|------------------------------|
| [RCLootCouncil Synchronizer](https://github.com/evil-morfar/RCLootCouncil2/wiki/Synchronizer) | Consent, 1:1, AceComm + CTL **low priority**, ~4 kB/s, minutes OK | Guild-broadcast multi-KB dumps as default |
| Guild Roster Manager changelogs | Harder throttle when grouped; avoid sync fighting raid chatter; disconnects real on Classic | Retail “1.28MB/s login bulk window” assumptions; 1000-member roster dumps |

CEPGP sidesteps GUILD addon storms for standings by storing EP/GP in **officer notes** (server-backed note field) — different architecture; Beef stays on BeefNet commits ([CEPGP overview](https://legacy-wow.com/classic-addons/cepgp)).
