# Revisioned sync and anti-spam

**Maps to:** Spec §8.1 message types, §8.3 state reconciliation, §11 edge cases.

## The offline problem (why sync exists)

`SendAddonMessage` only reaches players who are **online** (and, for GUILD, in the guild) with the addon listening. Anyone offline during a promotion keeps a stale SavedVariables cache forever unless reconciliation exists.

V1 answer (spec §8.3):

1. Every official player record carries an incrementing **revision**.
2. `RANK_COMMIT` bumps the target’s revision.
3. Merge rule: higher revision wins; on tie → later timestamp → officer name.
4. On login/reload: `SYNC_REQUEST` → peers may answer `SYNC_STATE` → merge newer records.
5. Replays with revision ≤ local are ignored (replay-safe).

There is **no server**. Officer copies are freshest in practice because only Officer+ may create commits.

## Pattern: request / response / suppress

```
Client A (login)
  wait settle (enter world + roster + CTL post-login window)
  send SYNC_REQUEST (GUILD, NORMAL)
  arm timeout → keep cache if silence

Peers B…N
  on SYNC_REQUEST:
    random delay (e.g. 0.5–3s)
    if saw SYNC_STATE from anyone else for this request-id → abort
    if local ladder empty / older than requester watermark → abort or send only newer
    else send SYNC_STATE chunks (BULK)
```

| Mechanism | Why |
|-----------|-----|
| Random delay | Desynchronize responders |
| Single-responder suppression | Prevents N× full dumps |
| Request id / nonce | Distinguish overlapping logins |
| Watermark (max known rev or per-player rev map hash) | Shrink payload |
| Chunk sequence + `more` flag | Stay ≤ 255 bytes/frame |
| Timeout without answer | Offline guild night is OK — retry later on `GUILD_ROSTER_UPDATE` / peer HELLO |

## Message-type anti-spam matrix

| Type | Emit when | Suppress / limits |
|------|-----------|-------------------|
| `HELLO` | Login settle; optional periodic | Soft-warn on major version mismatch; do not apply incompatible commits (spec §11) |
| `RANK_COMMIT` | Officer approve/reject path only | Validate Officer+ via roster before apply; ignore forged; ignore rev ≤ local |
| `SUGGESTION` | Member crosses threshold / manual | Rate-limit per player; officers may miss offline — open question for suggestion-queue sync |
| `SCORE_EVENT` | Prefer **local-first** | If broadcast: coarse, rare, BULK; never per-combat tick |
| `SYNC_REQUEST` | Login/reload once; manual “refresh” | Backoff; do not loop every second |
| `SYNC_STATE` | Answer to request (or rare officer push) | One responder; BULK; chunk; prefer diffs |

## Guild-chat spectacle vs BeefNet

Spec §10: on promotion/demotion, **one** plain guild-chat line from the approving officer’s client (opt-out). That reaches members **without** the addon. Rules:

- Not an addon message — uses chat throttle / social norms separately.
- Never let every peer re-announce the same promotion.
- Keep copy short for stream readability.

BeefNet remains the structured ladder; guild chat is the public ceremony.

## Login / zone timing (anti-spam + reliability)

| Hazard | Evidence | Mitigation |
|--------|----------|------------|
| Comms not ready on cold login | [SO: SendAddonMessage fails until reload](https://stackoverflow.com/questions/62723031/wow-classic-api-event-for-addon-messages) | Delay send; libraries that queue until ready |
| CTL 1/10 rate ~5s after login/zone | [ChatThrottleLib notes](https://wowpedia.fandom.com/wiki/ChatThrottleLib) | Defer `SYNC_REQUEST`; avoid bulk immediately after zoning into Karazhan |
| Roster not loaded | Spec §11 | Queue commits; never verify Officer+ against empty roster |
| Not in guild | Spec §11 | Pause BeefNet |

Recommended settle order (conceptual): register prefix → enter world → wait short timer → confirm `IsInGuild()` → request roster update → then HELLO + SYNC_REQUEST.

## Reliability without ACKs

Classic addon messaging is best-effort. BeefNet reliability stack:

1. **Idempotent revisions** — safe to re-send commits.
2. **Login sync** — heals missed live broadcasts.
3. **Optional HELLO exchange** — discover peers before dumping.
4. **Do not** build a chatty NACK protocol that doubles traffic under loss.

If sync is incomplete (chunk loss), requester can re-`SYNC_REQUEST` with a higher watermark after backoff — still cheaper than continuous streaming.

## Trust boundary (related, not throttle)

Anti-spam is not anti-cheat. Spec stance: standings are advisory; Officer+ approval is the real gate. Payload validation stops malformed/forged **commits**, not self-reported points. Keep validation cheap so bad packets are dropped without reply storms.
