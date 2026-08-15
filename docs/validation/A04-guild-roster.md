# A04 — Guild roster API

**Appendix A item:** 4  
**Owner:** David  
**Result:** NOT RUN

Cited: Bible Appendix A item 4; §5 (Guild Rank ↔ Church Rank); §8 (KNIGHT THIS BEEF); §18.1 (Presence desk).

## Dependent feature

**KNIGHT THIS BEEF**, the Presence desk, and §5 rank mapping.

- §8: one action performs everything the API legally permits — Church record, guild-rank promotion, proclamation to installed clients, record entry — and stages the next candidate.
- §5: Blizzard guild rank (10 slots) is **public display**; the Church store is **truth**. KNIGHT THIS BEEF performs both the Church record and the guild-rank promotion **where the API permits**. When they drift, the console reconciles silently where the mapping is unambiguous and asks the Pope one clear question where it is not.
- §18.1 Presence: who's here, ranks, needs-Knighting flags. The Pope never searches the default guild roster during an active ceremony (§8).

Appendix A: rank read/write (`GuildPromote` / `SetRank` permissions), roster refresh behavior.

## Bible fallback

Appendix A item 4 names **no** standalone fallback. The verbs already carry the degradation:

- Guild-rank write happens **where the API permits** (§5, §8). If promote / set-rank is refused, the Church record is still the truth; display may drift until a human reconciles.
- Presence without a fresh roster snapshot is empty / unknown — not a ritual gate.

The Appendix A closer still applies: do not invent a 10-slot guild-rank map, and do not code `GuildPromote` / `SetGuildRank` from this sheet. Core Knighting today writes the Church store only. That is leftover, not a pass of this item.

## Live-client method (Anniversary TBC, Interface 20506)

Pope character logged in, in the Church guild, with whatever Blizzard promote permission that character actually has. One other guild member online if possible. `/console scriptErrors 1`. Do not flip `SetGuildRosterShowOffline` as a side effect.

1. **Rank read.** After login, request a roster refresh (`C_GuildInfo.GuildRoster()` or the client's equivalent) and wait for `GUILD_ROSTER_UPDATE`. Record: whether `GetGuildRosterInfo` returns name, rank name, and 0-based `rankIndex`; whether realm suffix is present; whether the local player appears before the full walk completes.
2. **Refresh behavior.** Request roster twice inside 10 seconds. Record whether the second request is ignored and whether a later request (after ~10s) updates. Note stale-cache vs `PLAYER_GUILD_UPDATE`.
3. **Write permission (Blizzard UI, not addon code).** On a willing test alt, use the default guild UI to promote one rank, then restore. Record whether this Pope character can promote, which ranks are legal, and the exact error if refused. **Do not add `GuildPromote` / `SetGuildRank` to the addon.**
4. **Presence.** Record who the roster marks online vs the people actually standing next to you. That is the Presence-desk input, not a Church rank.
5. **Write facts on this sheet.** No mapping table. No silent reconcile rule. §5 mapping stays a later design when read/write are known.

Do not change addon Lua from this sheet.

## Not a pass

- `Store:SetRank` / `Knighting:KnightThisBeef` writing Church rank only
- `Roster.lua` snapshot without a live `GUILD_ROSTER_UPDATE` walk
- An invented Fresh Beef → guild-index table

## Leftovers

- Guild-rank map (do not invent)
- `GuildPromote` / `SetGuildRank` on the Pope verb (later UI, where this Result says the API permits)
- Presence desk wiring
- Silent vs one-question drift reconcile (§5)
