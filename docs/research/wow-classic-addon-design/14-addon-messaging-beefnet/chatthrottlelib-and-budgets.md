# ChatThrottleLib and sync budgets

**Maps to:** Spec §8.2 “pace outgoing messages (ChatThrottleLib-style throttling)”.

## Why CTL exists

WoW disconnects clients that sustain too much outbound traffic (chat and addon). ChatThrottleLib (Mikk) is the long-standing embeddable shaper used by AceComm and most serious comms addons.

Documented CTL shaping targets ([ChatThrottleLib wiki](https://warcraft.wiki.gg/wiki/ChatThrottleLib) / [Wowpedia mirror](https://wowpedia.fandom.com/wiki/ChatThrottleLib)):

| Parameter | Typical CTL value | Meaning |
|-----------|-------------------|---------|
| Burst | ~4000 bytes | Short spikes OK |
| Steady | ~800 CPS | Long-term target after burst |
| Overhead assumption | ~40 bytes / message | Small messages still “cost” |
| Post-login / zone | ~1/10 rate for ~5 seconds | Hostile window for `SYNC_REQUEST` |
| Fairness | Shared across all CTL users | One addon cannot starve others forever |

Priorities (all share the shaped pipe; higher prio does not completely starve lower when contended):

| Priority | Intended use | BeefNet mapping |
|----------|--------------|-----------------|
| `ALERT` | Time-sensitive, small | Optional: `HELLO` reply under load; rarely needed |
| `NORMAL` | Default interactive | `RANK_COMMIT`, `SUGGESTION`, `HELLO`, guild-chat announce via chat API |
| `BULK` | Background transfer | `SYNC_STATE` chunks, optional compressed dumps |

API shape (addon path):

`ChatThrottleLib:SendAddonMessage(prio, prefix, text, chattype [, target [, queueName [, callbackFn, callbackArg]]])`

Project pages: [WowAce ChatThrottleLib](https://www.wowace.com/projects/chatthrottlelib) · [CurseForge](https://www.curseforge.com/wow/addons/chatthrottlelib)

## AceComm vs raw + CTL

| Approach | Pros | Cons for Beef V1 |
|----------|------|------------------|
| **Raw `C_ChatInfo` + CTL** | Matches spec complexity; explicit chunks | You own framing |
| **AceComm-3.0** | Unlimited-length send; auto-split/reassemble; uses CTL | Extra Ace surface; still subject to Classic silent drops on large transfers |
| **Raw with no CTL** | None | Disconnects / throttle failures — wiki literally says you will blow up the server |

AceComm docs: [AceComm-3.0](https://www.wowace.com/projects/ace3/pages/api/ace-comm-3-0) — “send messages of unlimited length… ChatThrottleLib is of course being used.”

**Library recommendation for V1:** embed **ChatThrottleLib** (or go through AceComm if the project already pulls Ace). Do not invent a second global rate limiter that fights CTL’s shared fairness.

## Budget model for prefix `COB` on `GUILD`

Layer two constraints:

1. **Client prefix token bucket** — ~10 burst, ~1/sec refill ([wiki](https://warcraft.wiki.gg/wiki/API_C_ChatInfo.SendAddonMessage#Message_throttling)).
2. **CTL / disconnect CPS** — shared with every other chatty addon on the machine.
3. **Classic cultural reality** — intermittent silent loss of fast GUILD floods even when (1) and (2) look satisfied ([forum: SendAddonMessage problems](https://us.forums.blizzard.com/en/wow/t/classic-sendaddonmessage-problems/620054)).

### Steady-state planning numbers (design envelopes)

| Traffic class | Target rate | Notes |
|---------------|-------------|-------|
| Idle guild night | ≈ 0 addon msgs | Ladder is SV-cached |
| Single `RANK_COMMIT` | 1 NORMAL frame | Fanout to online guild with addon |
| Login `SYNC_REQUEST` | 1 NORMAL after settle delay | One shot; retry with backoff if no answer |
| `SYNC_STATE` reply | N BULK frames, ≤ ~1 msg/sec sustained after burst | Prefer one designated responder; see anti-spam note |
| `SCORE_EVENT` | Prefer **0** on wire | Local-first; or rare coarse summaries |
| Guild-chat announce | 1 plain `SendChatMessage` GUILD | Separate from addon prefix budget; still throttle / officer-only |

### Worked example: full ladder sync

Assume 60 occupied ladder records × ~60 bytes ≈ 3600 bytes ≈ **15+ frames** at 255 bytes.

- Token bucket: cannot blast 15 frames in one tick — need ≥ ~5–15 seconds at 1/sec after burning the 10-burst, or paced CTL queue.
- Silent-drop risk: prefer **watermark / revision-diff** sync (“send records with rev > R”) over full dump every login.
- Reply storm: if 20 peers each dump 15 frames → hundreds of frames. Spec’s **random delay + suppress if someone else answered** is mandatory.

### Priority assignment cheat sheet

| BeefNet type | CTL prio | Why |
|--------------|----------|-----|
| `RANK_COMMIT` | NORMAL | Official state; small; rare |
| `SUGGESTION` | NORMAL | Officer inbox; not bulk |
| `HELLO` | NORMAL (or ALERT if version gate urgent) | Tiny |
| `SYNC_REQUEST` | NORMAL | One-shot after delay |
| `SYNC_STATE` | **BULK** | Background catch-up |
| `SCORE_EVENT` | BULK if ever sent | Lowest value per byte |

## Callbacks and verification

CTL optional `callbackFn` fires when a chunk hits the wire — useful to advance a sync progress UI or to schedule the next chunk only after the previous left. Still not a peer-ACK; for critical commits, **revision replay** (spec §8.3) is the reliability layer: peers who missed a commit pick it up on next sync.

## What not to do

- Burst a for-loop of `SendAddonMessage` for every guild member (forum reports of “only 10 of 43 sent”).
- Ship multi-KB config dumps on GUILD as the happy path (loot-addon authors: “send less data”).
- Open a second prefix for “more bandwidth” — multi-prefix floods risk disconnects and still share CTL.
- Treat API success as delivery confirmation on Classic.
