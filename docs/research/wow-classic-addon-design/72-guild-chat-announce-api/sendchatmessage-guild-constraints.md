# `SendChatMessage` — GUILD constraints

**Track:** [72-guild-chat-announce-api](README.md)  
**Last updated:** 2026-07-25  

Canonical call shapes (Classic / Anniversary family):

```text
SendChatMessage(msg [, chatType [, languageID [, target]]])
C_ChatInfo.SendChatMessage(msg [, chatType [, languageID [, target]]])
```

Sources: [Wowpedia SendChatMessage](https://wowpedia.fandom.com/wiki/API_SendChatMessage) · [C_ChatInfo.SendChatMessage](https://warcraft.wiki.gg/wiki/API_C_ChatInfo.SendChatMessage) · [AddOn Studio](https://addonstudio.org/wiki/WoW:API_SendChatMessage).

---

## Constraint matrix (send path)

| Constraint | Value for Beef V1 | Evidence |
|------------|-------------------|----------|
| `chatType` | `"GUILD"` | Spec §10; flock-visible without addon |
| HW event outdoors | **Not required** for `GUILD` | HW column empty for GUILD/OFFICER/PARTY/RAID ([Wowpedia table](https://wowpedia.fandom.com/wiki/API_SendChatMessage); [C_ChatInfo table](https://warcraft.wiki.gg/wiki/API_C_ChatInfo.SendChatMessage)) |
| HW required types | `SAY`, `YELL` (outdoors); `CHANNEL` always | Patch 8.2.5 / Classic 1.13.3; [DBM tweet](https://twitter.com/deadlybossmods/status/1176685822223011842) |
| Max length | **255** characters; longer → truncate (or CTL refuse) | Patch 2.4.0+ truncate; CTL v18 length check ([ChatThrottleLib](https://wowpedia.fandom.com/wiki/ChatThrottleLib)) |
| Valid characters | Only valid chat chars; malformed item-link spoof → disconnect risk | Patch 1.10 lore ([AddOn Studio notes](https://addonstudio.org/wiki/WoW:API_SendChatMessage)) |
| Language arg | Irrelevant for `GUILD` (SAY/YELL only meaningfully) | Wowpedia args |
| Target arg | Unused for `GUILD` | Same |
| In guild | Must be in a guild; else send fails / no-ops | Spec §11 empty-state; guard with `IsInGuild()` |
| Speak permission | Rank must have `guildchat_speak` | [GuildControlGetRankFlags](https://wowpedia.fandom.com/wiki/API_GuildControlGetRankFlags) |
| Encounter / instance | Party/Raid/Guild/Officer **not** blocked the way Say/Yell/Emote can be during encounters (Retail notes; Classic GUILD historically fine) | [TOG Tools changelog](https://www.curseforge.com/wow/addons/togtools/files/8444187) (Retail encounter restriction docs public-chat only) |

---

## Hardware-event myth (clear for implementers)

| Channel | Addon auto-send outdoors? | Beef use |
|---------|---------------------------|----------|
| `SAY` / `YELL` | No — needs HW event | Never for spectacle |
| `CHANNEL` (General etc.) | No — HW always | Never |
| `GUILD` | **Yes** | **V1 spectacle** |
| `OFFICER` | Yes | Officer-private only — **not** V1 spectacle |
| `PARTY` / `RAID` / `INSTANCE_CHAT` | Yes | Loot cousins (Gargul/RCL); not Beef promote |

[MessageQueue](https://github.com/LenweSaralonde/MessageQueue) exists for HW-gated types; for `GUILD` it documents **instant send**. Do not add MessageQueue as a V1 dependency for promotes.

Community confirmation: Classic authors note `GUILD` works without a hardware event while SAY does not ([r/wowaddons](https://www.reddit.com/r/wowaddons/comments/gp9jyu/wow_classic_simple_chat_message_addon_help/)).

---

## `GUILD` vs `OFFICER` (do not confuse “officer-only”)

| | `GUILD` (`/g`) | `OFFICER` (`/o`) |
|--|----------------|------------------|
| Audience | Entire guild | Officers with listen flag |
| Addon-less members | See it | Miss it if not officer |
| Spec §10 / §13.11 | **Required** | Fails social check |
| Speak flag | `guildchat_speak` | `officerchat_speak` |

**Officer-only** in the product sense = only the **approving Officer+ client** calls send. The **payload** still goes to `GUILD`. See [officer-only-send.md](officer-only-send.md).

---

## Silent failure modes at the API edge

| Condition | Likely result | Beef handling |
|-----------|---------------|---------------|
| Not in guild | No delivery | Spec §11: scoring paused; skip announce |
| Rank lacks `guildchat_speak` | No delivery | Local officer warning after approve |
| Msg &gt; 255 | Truncate / CTL refuse | Pre-truncate; never ship multi-line liturgy |
| Malformed `|c…|Hitem…|h` links | Disconnect risk | V1: **plain text only** — no item/spell links in promote lines |
| Flood 10+ messages in one tick | High RTT / disconnect culture | Product: **one** line per commit ([AddOn Studio 2.4 note](https://addonstudio.org/wiki/WoW:API_SendChatMessage)) |
| Retail Community timing (`CLUB_STREAM_SUBSCRIBED`) | Early GUILD send too soon (Retail note) | Classic Anniversary: still gate on `IsInGuild` + roster-ready; do not invent Club events for V1 |

---

## Classic Anniversary notes

| Topic | V1 stance |
|-------|-----------|
| Global name | Prefer `SendChatMessage` / `C_ChatInfo.SendChatMessage` — prototype which exists on `Interface 20506`; behavior identical for `"GUILD"`. |
| HW restrictions | Same Classic-family policy as 1.13.3+ (guild permitted). |
| Community/Club APIs | Retail `CLUB_STREAM_SUBSCRIBED` early-send lore is **not** a V1 design dependency; gate on `IsInGuild()` + roster-ready from [16](../16-guild-roster-officer-edges/). |
| Encounter blocks | Retail docs that mute Say/Yell/Emote during boss encounters do **not** justify avoiding GUILD spectacle. |

---

## Boundary with wording (track 32)

This note stops at **transport constraints**. Template strings, comedy register, and skim-length craft belong exclusively in [32-microcopy-tone-voice/announce-line-craft.md](../32-microcopy-tone-voice/announce-line-craft.md). Implementers: build the line elsewhere, then pass a ≤255 plain string into this pipeline.
