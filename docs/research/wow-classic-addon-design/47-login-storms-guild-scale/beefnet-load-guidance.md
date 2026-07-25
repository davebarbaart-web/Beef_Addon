# BeefNet load guidance (40 / 150 / 500)

**Purpose:** Design envelopes for Church of Beef V1 under guild-scale concurrency. Numbers are **planning targets**, not measured Classic guarantees. Token-bucket/CTL floors remain in track 14; this note answers “how hard do we push the bus when many clients wake?”

## Assumptions

| Assumption | Value |
|------------|-------|
| Channel / prefix | `GUILD` / `COB` |
| Steady send floor | ~1 msg/s per prefix after burst (track 14) |
| CTL post-login clamp | ~5s hostile window (track 14) |
| Record size | ~40–80 bytes packed official row |
| Chunk | ≤255 body chars |
| Default traffic | Commits + sync; `SCORE_EVENT` off-wire |

## Scale bands

| Band | Roster | Peak online Beef `W` (design) | Typical night |
|------|--------|-------------------------------|---------------|
| S — intimate | ~40 | 15–30 | Friend guild / early Anniversary |
| M — raid social | ~150 | 30–50 | One 25 + socials / alts |
| L — soft-cap social | ~400–500 | 50–80 | Large community / stream magnet |

If real `W` exceeds the band, treat as next band up (wider jitter, stricter coalescing).

## Per-band envelopes

### Quiet steady state (all bands)

| Traffic | Target |
|---------|--------|
| Idle | ≈ 0 BeefNet frames |
| `RANK_COMMIT` | 1 NORMAL frame per approval |
| Guild chat announce | 1 plain chat line from approving officer |
| Automatic sync | none |

### Login / reload heal

| Band | Request jitter after settle | Coalesce quiet window | Max auto retries | Sync payload bias |
|------|-----------------------------|-----------------------|------------------|-------------------|
| S | Uniform 1–6s | 15–20s | 4 | Diff; full OK if tiny ladder |
| M | Uniform 2–12s | 20–30s | 4 | Diff mandatory if watermark known |
| L | Uniform 3–20s | 30–45s | 3 | Diff mandatory; prefer officer answer |

**Guild-wide goal:** in any 60s herd window, prefer **≤ 1–3** `SYNC_STATE` transfers total (not per client), each paced BULK.

### Fresh-install wave (cold caches)

Worst case: many empty SV caches after “install this addon” in guild chat.

| Guidance | Detail |
|----------|--------|
| Prefer officer-online answer | Longer non-officer responder delay |
| Chunk patiently | No burst for-loops; CTL BULK; expect tens of seconds |
| Defer in combat / instance | Queue until out of lock / raid combat |
| Do not open second prefix | Multi-prefix floods risk disconnects (track 14) |

RCLootCouncil’s lesson for huge blobs: **directed, consented, low-priority** transfer ([Synchronizer wiki](https://github.com/evil-morfar/RCLootCouncil2/wiki/Synchronizer)). If ladder dumps ever hurt in playtest, a future “officer push to me” whisper path is an escape hatch — not V1 default.

### Raid pull / combat

| Allowed | Deferred |
|---------|----------|
| `RANK_COMMIT` (rare) | Automatic `SYNC_REQUEST` |
| Tiny HELLO only if already mid-flight | New bulk `SYNC_STATE` initiation |
| Local score ticks | Any `SCORE_EVENT` broadcast |

GRM’s Classic disconnect reports when sync fights grouped raid chatter are the red line ([GRM changelog notes](https://www.curseforge.com/wow/addons/guild-roster-manager/files/2874277)).

## Worked load sketches

### Sketch A — M band raid invite (40 Beef online, warm caches)

- Without hardening: ~40 `SYNC_REQUEST` in 30s → up to ~40 overlapping dumps if suppression misses.  
- With jitter + coalesce: ~2–5 requests survive → ~2–5 diff answers of 1–3 chunks → bus busy <30s, then quiet.

### Sketch B — L band cold wave (60 online, empty ladder, ~200 occupied records)

- Bytes ≈ 200 × 60 ≈ 12KB ≈ ~50 chunks at 255.  
- One BULK stream @ ~1 msg/s ≈ under a minute; ten parallel streams ≈ disaster + silent loss.  
- Hard requirement: **one responder**, coalesced requests, everyone else merges from the overheard stream.

### Sketch C — score spam anti-pattern

- 40 players × 1 event/10s on GUILD ≈ 4 msg/s sustained **before** other addons — already above comfort vs ~1/s prefix regen.  
- Verdict: keep scores local (spec).

## Do / don’t (load checklist)

**Do**

- Jitter requesters and responders (full jitter on retries).  
- Coalesce: hearing a peer request cancels yours; hearing state heals you.  
- Cap retries; serve SV stale meanwhile.  
- Diff by revision watermark.  
- Prefer officer answers; BULK for state; NORMAL for commits.  
- Pause automatic sync in combat / heavy instance.

**Don’t**

- Sync on every roster event.  
- Periodic HELLO mesh.  
- Broadcast per-combat scores.  
- Peer re-announce promotions in chat.  
- Assume API success = delivery (Classic silent drops).  
- “Fix” slowness by raising CTL priority or adding prefixes.

## Acceptance for guild playtest (load)

From design spec social check + this track:

1. Raid-invite login wave: ladder usable from cache; no disconnects blamed on Beef.  
2. Debug counters: automatic `SYNC_REQUEST` count ≪ online Beef count during the wave.  
3. At least one promotion still visible in guild chat (spectacle) without message storms.  
4. Late joiner converges within a few minutes without manual spam.

## Pointers

| Need | Where |
|------|-------|
| CPS / burst / priorities | [14 chatthrottlelib-and-budgets](../14-addon-messaging-beefnet/chatthrottlelib-and-budgets.md) |
| Type → priority table | [14 beefnet-mapping](../14-addon-messaging-beefnet/beefnet-mapping.md) |
| Merge / authority | [27 README](../27-desync-conflict-resolution/README.md) |
| Mechanisms | [backoff-jitter-coalescing.md](backoff-jitter-coalescing.md) |
