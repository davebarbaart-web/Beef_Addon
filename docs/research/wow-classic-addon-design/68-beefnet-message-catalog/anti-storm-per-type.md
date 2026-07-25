# Anti-storm notes (per message type)

**Track:** 68  
**Purpose:** Protocol-level “what not to emit / when to suppress” for each catalog type.  
**Defers numbers:** Jitter windows, band envelopes, retry budgets → [47](../47-login-storms-guild-scale/). CTL / token bucket → [14](../14-addon-messaging-beefnet/). Merge predicates → [27](../27-desync-conflict-resolution/).

Storms happen when many clients share one `GUILD`/`COB` pipe. The catalog must make **quiet the default**.

---

## Global rules (all types)

1. **Idle ≈ 0 frames.** SV cache holds the ladder; no heartbeat mesh.  
2. **No reply-to-validate.** Malformed packets die silently — never NACK.  
3. **One prefix.** Do not open `COB2` for headroom.  
4. **Combat / instance:** defer automatic sync initiation; allow rare `RANK_COMMIT`.  
5. **API success ≠ delivery.** Design for loss with revisions + sync, not chatty repair.

---

## Per-type discipline

### `HELLO`

| Do | Don’t |
|----|-------|
| Once after login settle | Periodic presence ping (e.g. every 60s) |
| Soft-warn once per foreign major | HELLO war: reply to every HELLO with HELLO |
| Optional rare re-emit after *peer request* only | Fan-out HELLO on every roster update |

**Failure mode:** Periodic HELLO × W online peers ≈ steady bus noise before any ladder traffic.  
**Product note:** Co-play scoring must not wait for HELLO ([59](../59-coplay-guildmate-detection/)).

---

### `SUGGESTION`

| Do | Don’t |
|----|-------|
| Rate-limit per subject / rank step ([67](../67-offline-officer-suggestion-sync/)) | Rebroadcast all pendings on every login |
| One frame per petition | Attach point-breakdown essays |
| Accept offline-officer miss in V1 | Member push-on-officer-HELLO (login amplifier) |

**Failure mode:** “Helpful” re-petition storms after raid invite when everyone crosses a threshold together — still tens/night, not combat ticks, but coalesce UI toasts ([49](../49-officer-notifications/)).  
**V1.1:** Catch-up uses reserved types + single-responder suppress — never piggyback on ladder `SYNC_STATE`.

---

### `RANK_COMMIT`

| Do | Don’t |
|----|-------|
| One NORMAL frame per mint | Batch unrelated players into a faux dump |
| Officer+ emit only | Member “preview commit” |
| Rely on revision replay-safety | ACK/NACK handshake |
| Pair with **one** guild-chat announce from approving officer | Let every peer re-announce |

**Failure mode:** Social spam more than bus spam — duplicate ceremony lines. Spec §10 already assigns announce to the approving officer only.

---

### `SYNC_REQUEST`

| Do | Don’t |
|----|-------|
| Once per settle epoch + full jitter ([47](../47-login-storms-guild-scale/backoff-jitter-coalescing.md)) | Fire at `PLAYER_LOGIN` |
| Coalesce: hearing peer request/state cancels yours | Sync on every `GUILD_ROSTER_UPDATE` |
| Cap auto-retries with full jitter | Infinite retry loop |
| Include watermark | Always demand cold full dump |

**Failure mode:** Raid-invite herd — classic N× request without coalesce. Track 47 Sketch A is the acceptance story.

---

### `SYNC_STATE`

| Do | Don’t |
|----|-------|
| Single-responder suppress on `reqId` / sync epoch | Everyone answers |
| Officer-prefer (longer non-officer delay) | Prefer random members with empty caches |
| BULK + chunk ≤255; pace | For-loop burst 50 frames |
| Diff by watermark | Full dump every warm login |
| Let eavesdroppers merge | Whisper N copies to each requester |

**Failure mode:** Parallel full dumps (track 47 Sketch B) + Classic silent drops → worse sync, more retries, death spiral.  
**Incomplete chunks:** Requester re-asks with watermark after backoff — still cheaper than NACK storms.

---

### `SCORE_EVENT`

| Do | Don’t |
|----|-------|
| Keep local | Broadcast per bucket / kill / quest |
| If ever: coarse, rare, BULK | “Realtime DPS of faith” |

**Failure mode:** Track 47 Sketch C — sustained multi-msg/s before other addons. Spec already prefers commits over chatty scores.

---

## Cross-type interaction hazards

| Hazard | Why it hurts | Catalog rule |
|--------|--------------|--------------|
| HELLO triggers everyone’s SYNC | Doubles login herd | HELLO never implies “dump ladder” |
| SUGGESTION bundled in SYNC_STATE | Cold login pays inbox tax | Separate types; V1 omits |
| Commit + full sync push | Redundant bus use | Live commit for online; sync only for heal |
| Version warn reply loops | Soft-warn becomes chat | Warn in UI; no protocol reply |
| Manual `/beef sync` spam | Player-driven herd | Share retry budget with auto path |

---

## Debug counters (research ask for implementers)

Useful for guild-night proof (not part of wire format):

| Counter | Healthy intuition |
|---------|-------------------|
| `syncRequestEmitted` | Much less than online Beef count during invite wave |
| `syncStateEmitted` | About 1–3 transfers per wave (guild-wide) |
| `helloEmitted` | About 1 per login |
| `scoreEventEmitted` | 0 in V1 |
| `commitEmitted` | About equal to promotions/demotes |

Acceptance aligns with track 47 load checklist + spec social criteria.

---

## Pointers

| Mechanism detail | Track |
|------------------|-------|
| Random delay + suppress | 14 `sync-state-and-anti-spam` |
| CTL priorities | 14 `chatthrottlelib-and-budgets` |
| Jitter / coalesce / bands | 47 |
| Petition policy traffic | 67 |
