# Officer-only send (ownership, not `/o`)

**Track:** [72-guild-chat-announce-api](README.md)  
**Last updated:** 2026-07-25  

Spec §10: guild-chat announce is sent by the **approving officer’s client only** (no duplicate spam); per-officer opt-out. This note separates **product ownership** from **Blizzard Officer chat** and from the **approve gate** in track [16](../16-guild-roster-officer-edges/).

---

## Three different “officer” concepts

| Concept | Meaning | Beef rule |
|---------|---------|-----------|
| **Officer+ approve gate** | `rankIndex ≤ OfficerRankIndexMax` may commit ranks | Required before announce ([16](../16-guild-roster-officer-edges/api-edges.md)) |
| **Announce ownership** | Exactly one client emits `/g` for a given commit | Approving officer’s client |
| **`OFFICER` chat type** | `/o` channel | **Do not use** for V1 spectacle |

Invite / officer-note `Can*` proxies are **not** ownership signals ([16](../16-guild-roster-officer-edges/api-edges.md)).

---

## Who may call send

```text
LocalIsOfficer()
  AND IsInGuild()
  AND announceOptIn ~= false          -- default true
  AND guildchat_speak for player rank
  AND this client authored the RANK_COMMIT (approve path)
→ SendChatMessage(line, "GUILD")
```

| Client role | Sends `/g`? | Local toast? |
|-------------|-------------|--------------|
| Approving Officer+ (opt-in) | **Yes** (once) | Yes |
| Approving Officer+ (opt-out) | No | Yes (officer still needs feedback) |
| Peer with addon applying `RANK_COMMIT` | **No** | Yes (promotee / flock UI) |
| Member without addon | N/A | Sees `/g` only |
| Offline officer later syncing | **No** | Optional silent ladder heal only |

Wire replay / login sync must **never** re-fire guild announce. Dedup on commit id (or revision + subject + toRank).

---

## `guildchat_speak` vs Officer+

`GuildControlGetRankFlags` returns independent booleans including `guildchat_listen`, `guildchat_speak`, `officerchat_listen`, `officerchat_speak` ([Wowpedia](https://wowpedia.fandom.com/wiki/API_GuildControlGetRankFlags); [wowwiki-archive](https://wowwiki-archive.fandom.com/wiki/API_GuildControlGetRankFlags)).

Implications:

1. A guild can grant Beef Officer+ index while **muting guild chat** for that rank — rare, but announce becomes a no-op.
2. GM/officer ranks usually have speak; do not assume.
3. **Detecting speak (Classic recipe):** `GetGuildInfo("player")` → `rankIndex` (0-based) → `GuildControlSetRank(rankIndex + 1)` → read `guildchat_speak` from `GuildControlGetRankFlags()` ([16 quirks](../16-guild-roster-officer-edges/api-edges.md)). Cache per session; refresh on `PLAYER_GUILD_UPDATE` / rank change.
4. Fail soft: if speak is false, still commit; local “could not announce — check guild rank Speak in Guild Chat.” Do not retry into `/o`.

Operational guidance for Church guilds (same spirit as [16](../16-guild-roster-officer-edges/)): keep approving ranks able to speak in `/g`.

### Optional UX hint (not authority)

`C_GuildInfo.IsGuildOfficer()` may exist on Classic-family clients ([16](../16-guild-roster-officer-edges/api-edges.md)) but must **not** gate announce ownership or approve. Ownership = “this client just authored a valid `RANK_COMMIT`.”

---

## Why not designate a “guild announcer” alt

| Pattern | Verdict |
|---------|---------|
| Approving officer announces | **V1** — matches authority + Gargul ML ownership |
| Dedicated “herald” alt always online | Reject — requires second machine, desyncs from approve click, ToS-adjacent botting optics |
| Highest online Officer+ announces for others’ commits | Reject — racey; two officers online → duplicate risk; breaks “approver owns the moment” |
| Promotee announces their own elevate | Reject — forgeable / silly; not institutional |

---

## Opt-out placement

| Setting | Scope | Default |
|---------|-------|---------|
| Announce rank changes to guild chat | Per-character SV (officer characters) | **On** |

Mirror Gargul’s “Announce loot to chat” toggle ([wiki](https://github.com/papa-smurf/Gargul/wiki/Announcing-Loot-in-Chat)). Default-off starves §13.11 ([13](../13-cousin-addon-teardowns/steal-avoid-for-beef.md)). Opt-out must not block `RANK_COMMIT` — only the `/g` side effect.
