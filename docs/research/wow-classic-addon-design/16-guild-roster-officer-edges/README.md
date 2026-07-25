# 16 — Guild roster timing, ranks, Officer+ permissions

**Started:** 2026-07-25  
**Scope:** Classic / TBC Anniversary API edge cases for Church of Beef officer approval gates.  
**Not this track:** Guild-tool UX cousins, loot-council IA, social spectacle copy — that belongs in [09-guild-social-community](../09-guild-social-community/) when filled. This track goes deeper only on roster/rank/permission mechanics.

**Product anchors:** Design spec §6.2–6.3, §11 (roster not loaded); plan Task 5 (`Core/Officer.lua`, `OfficerRankIndexMax`).

## Docs in this folder

| File | Contents |
|------|----------|
| [api-edges.md](api-edges.md) | GuildRoster APIs, events, login races, rank-index quirks, offline members, `IsGuildOfficer` vs invite/notes |
| [annotated-urls.md](annotated-urls.md) | Curated primary URLs with steal/adapt notes |
| [`.raw/`](.raw/) | Search/extract JSON for audit |

## Top insights for Beef (executive)

1. **Keep the spec’s rank-index gate.** Do not gate on rank *names*, `CanGuildInvite()`, or officer-note edit rights — those diverge from “Officer+” in real guilds.
2. **Treat `C_GuildInfo.IsGuildOfficer()` as optional shorthand, not authority.** Present on Classic-family clients since BCC 2.5.1, but undocumented criteria and not configurable like `OfficerRankIndexMax`.
3. **Never validate `RANK_COMMIT` before roster is ready.** `GetGuildInfo("player")` / roster counts can be nil/0 at login; wait for `GUILD_ROSTER_UPDATE` (and `PLAYER_GUILD_UPDATE`). Queue or drop — never apply unverified.
4. **Roster refresh is throttled (~10s).** Call `C_GuildInfo.GuildRoster()` / `GuildRoster()` on login and on demand; respect `canRequestRosterUpdate` from the event. Do not spam on every BeefNet message.
5. **Name matching must normalize realms.** Roster names are often `Name-Realm`; addon-message senders may not match raw strings — normalize before `IsOfficerName`.
6. **Offline officers do not break the model.** Offline members remain on the roster with `isOnline == false` (rank still readable). They cannot send live commits; login sync (§8.3) covers members who missed broadcasts.
7. **Guild reorgs remap meaning of index 1.** Configurable `OfficerRankIndexMax` is correct; document that Church officer ranks must stay at the top of the WoW rank list (GM = 0).

## Relationship to track 09

| 09 (patterns) | 16 (this track) |
|---------------|-----------------|
| Attune / Gargul-style officer queue UX | When roster APIs are safe to read |
| Social announce / spectacle | Rank-index vs invite/notes permission traps |
| Community addon norms | Classic login / throttle / offline edge cases |
