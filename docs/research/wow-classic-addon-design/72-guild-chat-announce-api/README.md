# Track 72 — Guild-chat announce API & throttling

**Track id:** `72-guild-chat-announce-api`  
**Last updated:** 2026-07-25  
**Sole focus:** How Church of Beef **sends** the V1 promotion/demotion spectacle — `SendChatMessage` / `C_ChatInfo.SendChatMessage` on `GUILD`, rate limits, officer-owned single-announcer patterns, and the Beef V1 announce pipeline.  
**Maps to:** [Church of Beef V1 design spec](../../../superpowers/specs/2026-07-25-church-of-beef-design.md) §10 (throttled guild-chat line from approving officer), §13.11 (visible guild-chat reaction), §8 (BeefNet commit precedes spectacle).

## Out of scope (deliberate)

| Covered elsewhere | Why not here |
|-------------------|--------------|
| [32-microcopy-tone-voice](../32-microcopy-tone-voice/) | **Words** — templates, tone, skim length craft. This track owns **API / throttle / ownership**. Do not restate announce liturgy here. |
| [61-streamer-mode-privacy](../61-streamer-mode-privacy/) | Receive-side filters (`profanityFilter`, ignore, name obfuscators). Cross-link only for send-path hygiene. |
| [14-addon-messaging-beefnet](../14-addon-messaging-beefnet/) | `SendAddonMessage` / CTL for BeefNet. Announce is **plain chat**, a separate pipe that still shares CTL’s CPS budget. |
| [16-guild-roster-officer-edges](../16-guild-roster-officer-edges/) | Officer+ **approve** gate (`rankIndex`). Announce send uses that gate + `guildchat_speak`. |
| [49-officer-notifications](../49-officer-notifications/) | Local officer pings (`print` / toast) — not public `/g`. |
| Addon Lua / commits | Research only |

## Index

| Note | Covers |
|------|--------|
| [sendchatmessage-guild-constraints.md](sendchatmessage-guild-constraints.md) | Signature, 255 cap, HW-event matrix, `GUILD` vs `OFFICER`, speak flags |
| [rate-limits-and-ctl.md](rate-limits-and-ctl.md) | Disconnect CPS, CTL `SendChatMessage`, post-login clamp, product throttle |
| [officer-only-send.md](officer-only-send.md) | Approving-officer ownership vs Blizzard Officer channel; mute ranks |
| [chat-filter-interactions.md](chat-filter-interactions.md) | Send hygiene that reduces filter false positives (pointer to 61 for receive) |
| [single-announcer-patterns.md](single-announcer-patterns.md) | Gargul ML ownership, RCL ML announce, Attune celebration |
| [beef-v1-announce-pipeline.md](beef-v1-announce-pipeline.md) | **Recommended V1 pipeline** + failure table |
| [annotated-urls.md](annotated-urls.md) | Primary URLs with steal/adapt notes |

## Top insights for Beef (read this first)

1. **`GUILD` is automation-safe for Classic — no outdoor hardware event.** Blizzard restricted `SAY` / `YELL` / `CHANNEL` (outdoors; CHANNEL always) after Classic 1.13.3 / Retail 8.2.5; **`GUILD` / `OFFICER` / `PARTY` / `RAID` remain sendable from addon code** ([SendChatMessage](https://wowpedia.fandom.com/wiki/API_SendChatMessage); [DBM restriction summary](https://twitter.com/deadlybossmods/status/1176685822223011842); [MessageQueue](https://github.com/LenweSaralonde/MessageQueue) sends non-HW types instantly). Approve UI still provides a click, but V1 does **not** need MessageQueue for `/g`.

2. **Hard length is 255; design for one short line.** Oversized text is truncated (post–2.4.0 no longer disconnects on length alone); CTL also refuses `SendChatMessage` text &gt; 255 to avoid disconnects ([AddOn Studio SendChatMessage](https://addonstudio.org/wiki/WoW:API_SendChatMessage); [ChatThrottleLib](https://wowpedia.fandom.com/wiki/ChatThrottleLib)). Copy budgets live in track [32](../32-microcopy-tone-voice/); here: **truncate-safe encode before send**.

3. **Throttle is two layers: Blizzard CPS + product single-owner.** ChatThrottleLib shapes outbound chat+addon to ~4000-byte burst then ~800 CPS, with ~1/10 rate for ~5s after login/zone ([ChatThrottleLib](https://wowpedia.fandom.com/wiki/ChatThrottleLib)). Separately, Beef must ensure **only the approving officer’s client** emits one line per commit — N peers replaying `RANK_COMMIT` must **not** each `/g` (Gargul ML pattern; [Announcing Loot in Chat](https://github.com/papa-smurf/Gargul/wiki/Announcing-Loot-in-Chat)).

4. **Spectacle channel is `GUILD`, never `OFFICER`.** Spec §10 requires visibility without the addon for the whole flock. `OFFICER` is for officer-private traffic; using it would fail §13.11. “Officer-only send” means **who presses send** (approving Officer+ client), not the chat type.

5. **`guildchat_speak` can silently no-op an announce.** Rank flags from `GuildControlGetRankFlags` include `guildchat_speak` / `officerchat_speak` independently of invite/notes/promote ([GuildControlGetRankFlags](https://wowpedia.fandom.com/wiki/API_GuildControlGetRankFlags); track [16](../16-guild-roster-officer-edges/)). An Officer+ who can approve but whose WoW rank cannot speak in `/g` will not deliver spectacle — surface a local warning, do not treat as BeefNet failure.

6. **Announce after successful local commit, not on suggestion.** Pipeline: Officer+ approve (UI) → validate → apply + broadcast `RANK_COMMIT` → **then** optional `SendChatMessage("…", "GUILD")` if announce enabled. Peers who apply the commit from the wire toast locally and stay silent in guild chat.

## Recommended V1 one-liner

**CTL-paced `SendChatMessage` / `C_ChatInfo.SendChatMessage` on `GUILD`, NORMAL priority, approving-officer client only, once per commit id, after `RANK_COMMIT`, with per-officer opt-out (default on) and `guildchat_speak` / `IsInGuild` guards.**

Detail: [beef-v1-announce-pipeline.md](beef-v1-announce-pipeline.md).

## Solid-quality checklist

| Indexed note | Role |
|--------------|------|
| [sendchatmessage-guild-constraints.md](sendchatmessage-guild-constraints.md) | API matrix + HW myth + GUILD vs OFFICER |
| [rate-limits-and-ctl.md](rate-limits-and-ctl.md) | CTL CPS + product throttle + BeefNet coexistence |
| [officer-only-send.md](officer-only-send.md) | Ownership + `guildchat_speak` recipe |
| [chat-filter-interactions.md](chat-filter-interactions.md) | Send hygiene (receive → 61) |
| [single-announcer-patterns.md](single-announcer-patterns.md) | Gargul / RCL / Attune ownership map |
| [beef-v1-announce-pipeline.md](beef-v1-announce-pipeline.md) | End-to-end V1 pipeline + which commits announce |
| [annotated-urls.md](annotated-urls.md) | Primary bibliography |

## Provenance

Search/extract dumps under [`.raw/`](.raw/). Prefer warcraft.wiki.gg / Wowpedia API pages, ChatThrottleLib docs, Gargul wiki, RCL Options wiki, and DBM’s restriction note over listicles.
