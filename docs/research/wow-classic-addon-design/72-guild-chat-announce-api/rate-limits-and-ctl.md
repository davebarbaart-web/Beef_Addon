# Rate limits & ChatThrottleLib (plain chat)

**Track:** [72-guild-chat-announce-api](README.md)  
**Last updated:** 2026-07-25  

BeefNet already budgets `SendAddonMessage` in track [14](../14-addon-messaging-beefnet/chatthrottlelib-and-budgets.md). This note covers the **plain `SendChatMessage` pipe** used for guild spectacle — same disconnect physics, different API and product cadence.

---

## Why officers disconnect from “just chat”

WoW rate-limits **all outbound client traffic**, not only addon prefixes. Sustained floods disconnect the player. ChatThrottleLib (Mikk) exists to keep chat **and** addon traffic under a shared shaped pipe ([ChatThrottleLib — Wowpedia](https://wowpedia.fandom.com/wiki/ChatThrottleLib); [CurseForge](https://www.curseforge.com/wow/addons/chatthrottlelib)).

Documented CTL shaping targets:

| Parameter | Typical value | Meaning for announce |
|-----------|---------------|----------------------|
| Burst | ~4000 bytes | One ~100-char `/g` line is trivial |
| Steady | ~800 CPS | Safe long-term after burst |
| Post-login / zone | ~1/10 rate for ~5s | Defer announce if approve happens in the hostile window *and* a sync storm is also queued |
| Fairness | Shared across CTL users | Beef announce + BeefNet + other addons share the pipe |
| Length guard | Refuse chat text &gt; 255 | Avoid disconnect on oversize |

CTL API for chat:

```text
ChatThrottleLib:SendChatMessage(prio, prefix, text, chattype, language, destination [, queueName [, callbackFn, callbackArg]])
```

Use priority **`NORMAL`** for spectacle (same band as interactive commits in track 14). Do **not** invent a second global limiter that fights CTL.

---

## Two throttle layers (do not conflate)

| Layer | Mechanism | What it protects |
|-------|-----------|------------------|
| **A. Blizzard / CTL CPS** | Shared outbound shaping | Disconnects from floods |
| **B. Product single-owner + cadence** | Approving officer only; one line per commit; opt-out | Guild-chat spam / §13.11 fatigue |

Layer A is almost never the bottleneck for V1 (one short line per promote). Layer B is the real design problem — see [single-announcer-patterns.md](single-announcer-patterns.md).

Addon-message **prefix token buckets** (~10 burst / ~1/sec) from `C_ChatInfo.SendAddonMessage` do **not** apply to plain chat. Still: chat and addon share CTL’s CPS, so a login `SYNC_STATE` dump can delay a promote line by a few hundred ms — acceptable.

---

## Empirical burst folklore (plain chat)

| Observation | Source | Beef takeaway |
|-------------|--------|---------------|
| 10+ messages at once → high RTT on later msgs | [AddOn Studio SendChatMessage](https://addonstudio.org/wiki/WoW:API_SendChatMessage) (patch 2.4 discussion lore) | Never batch liturgy; one line |
| Sustained ~3000 CPS disconnects; ~2000 CPS “seems safe”; CTL uses 800 | [ChatThrottleLib notes](https://wowpedia.fandom.com/wiki/ChatThrottleLib) | One announce is noise-level |
| Classic silent drops are mostly an **addon-message** story | Track [14](../14-addon-messaging-beefnet/classic-anniversary-realities.md) | Plain `/g` is more reliable for “did the guild see it?” than BeefNet |

---

## Product throttle recipe (V1)

| Rule | Default | Rationale |
|------|---------|-----------|
| Max lines per rank commit | **1** | Spec §10 |
| Coalesce window | Optional ≥2–3s if double-click approve | Prevents accidental double fire if UI retries |
| Dedup key | `commitId` / revision+player+rank | Wire replay must not re-announce |
| Opt-out | Per-officer SV, **default on** | Gargul “Announce loot to chat” pattern; default-off kills §13.11 ([13 steal/avoid](../13-cousin-addon-teardowns/steal-avoid-for-beef.md)) |
| Post-zone delay | If CTL post-login clamp active **and** large sync queued, wait settle | Prefer announce after commit ACK locally; tiny delay OK |
| Multi-promote night | No artificial “one per minute” if officers promote slowly | Cadence is human; spam risk is N clients, not N promotes |

---

## Interaction with simultaneous BeefNet traffic

On approve, the officer client typically emits:

1. `RANK_COMMIT` via `SendAddonMessage` (CTL NORMAL)  
2. One spectacle line via `SendChatMessage` (CTL NORMAL, separate flow prefix e.g. `COB-ANN`)

Both share the ~800 CPS pipe. Ordering recommendation: **enqueue commit first, announce second** (pipeline in [beef-v1-announce-pipeline.md](beef-v1-announce-pipeline.md)). Worst case under post-zone clamp: announce arrives a fraction of a second later — still one line, still correct ownership.

Do **not** raise announce to `ALERT` to “jump the sync queue”; that fights fairness with other addons’ alerts.

---

## What not to do

- Call raw `SendChatMessage` in a loop for “flavor” lines (scripture + title + standing) — multi-line walls trip filters and RTT lore.
- Route spectacle through BeefNet and ask every peer to print to `/g`.
- Use `ALERT` CTL priority for promotes — unnecessary; reserve ALERT for tiny urgent HELLO if ever.
- Skip CTL “because it’s only one message” if the project already embeds CTL for BeefNet — **go through the same library** so fairness accounting stays coherent ([14 recommendation](../14-addon-messaging-beefnet/chatthrottlelib-and-budgets.md)).
- Mimic RCL “Announce Considerations” (header + N item lines) for ceremony — product throttle exists to forbid that shape.
