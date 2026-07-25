# Annotated URLs — guild roster / Officer+ edges

Curated for track 16. Prefer these over listicles when changing officer-gate behavior.

| Source | URL | Use for | Steal / adapt for Beef |
|--------|-----|---------|------------------------|
| C_GuildInfo.GuildRoster | https://warcraft.wiki.gg/wiki/API_C_GuildInfo.GuildRoster | Request roster; 10s ignore throttle; event coupling | Login + stale refresh only; never per-commit spam |
| GuildRoster (legacy) | https://wowpedia.fandom.com/wiki/API_GuildRoster | Same throttle wording; history | Fallback awareness; prefer `C_GuildInfo` on Anniversary |
| GUILD_ROSTER_UPDATE | https://warcraft.wiki.gg/wiki/GUILD_ROSTER_UPDATE | Payload `canRequestRosterUpdate`; when cache is fresh | Gate officer map rebuild; honor can-request flag |
| GetGuildRosterInfo | https://warcraft.wiki.gg/wiki/API_GetGuildRosterInfo | name/realm, rankIndex 0=GM, online bit, notes empty semantics | Rank-index lookup; normalize names; ignore rankName |
| GetNumGuildMembers | https://warcraft.wiki.gg/wiki/API_GetNumGuildMembers | total/online; need GuildRoster first; max 500 | Iterate 1..numTotal after update; don’t trust pre-login 0 |
| GetGuildInfo | https://warcraft.wiki.gg/wiki/API_GetGuildInfo | Local rankIndex; **nil at login** race; PLAYER_GUILD_UPDATE | LocalIsOfficer waits for non-nil; pair with roster event |
| C_GuildInfo.IsGuildOfficer | https://warcraft.wiki.gg/wiki/API_C_GuildInfo.IsGuildOfficer | Exists; boolean; criteria undocumented | Optional UX hint only; not RANK_COMMIT authority |
| BCC 2.5.1 UI changes | https://github.com/Stanzilla/WoWUIBugs/wiki/2.5.1-Consolidated-UI-Changes | Classic-family gained `C_GuildInfo.*` (GuildRoster, IsGuildOfficer, CanEdit/ViewOfficerNote) | Confirms APIs are in-family for TBC Classic / Anniversary lineage |
| GuildControlGetRankFlags | https://wowwiki-archive.fandom.com/wiki/API_GuildControlGetRankFlags | invite / officer-note / officer-chat bits; 1-based SetRank quirk | Proof permissions are independent; don’t proxy Officer+ |
| CanGuildInvite | https://wowprogramming.com/docs/api/CanGuildInvite.html | Invite permission only | **Not** the Beef approve gate |
| CanEditOfficerNote | https://wowprogramming.com/docs/api/CanEditOfficerNote.html | Officer-note edit permission | **Not** the Beef approve gate |
| SetGuildRosterShowOffline | https://wowpedia.fandom.com/wiki/API_SetGuildRosterShowOffline | Offline filter; can fire roster update | Don’t toggle for validation; verify Anniversary iteration |
| Design spec §6.2 / §11 | `docs/superpowers/specs/2026-07-25-church-of-beef-design.md` | Product: index threshold, queue/drop unverified | Implement against this, not permission proxies |
| Plan Task 5 | `docs/superpowers/plans/2026-07-25-church-of-beef-v1.md` | `OfficerRankIndexMax`, injected rosterLookup | Keep pure Core tests; wrap APIs at edge |

## Secondary / context only

| Source | URL | Note |
|--------|-----|------|
| ChatBar (officer note proxy anecdote) | https://www.wowinterface.com/downloads/info4422-ChatBar.html | Shows ecosystem habit of using note perms as “officer” — anti-pattern for Beef |
| Guild Roster Manager | https://www.curseforge.com/wow/addons/guild-roster-manager | Heavy roster consumer; UX cousin for 09, not authority model for 16 |
| Classic web guild API 403 thread | https://us.forums.blizzard.com/en/wow/t/era-guild-and-guild-roster-api-no-longer-works/1969144 | Battle.net profile API — irrelevant to in-game addon gates |

## Provenance

Search/extract JSON under [`.raw/`](.raw/) from 2026-07-25 research pass (`parallel-cli`).
