# Phase 0 Lane E — Pope authority

**Status:** done

**Sections cited:** Bible §4.2, §4.4, §5 (guild rank = display, Church store = truth), §6 (ceremonial sovereignty; Council operations; no Pope, no rituals; no decay), §8 (KNIGHT THIS BEEF), §13.1–13.4 (star, witnesses report, authority hierarchy, registered-Pope senders), §18.1–18.3 (Director Console; what the console never does; Notebook). Audit V3. Ten Laws 3–5, 9. Appendix A item 4 (guild-rank write as capability, not a ban).

## Files written

- Created `.cursor/rules/pope-authority.mdc`
- Rewrote `.cursor/rules/officer-guild-roster.mdc`
- Appended OPEN_QUESTIONS.md item 8 (registered-Pope / designated-Council configuration — Bible/handoff unanswered; UX not invented)

## Old officer-rule sentences deleted

From `.cursor/rules/officer-guild-roster.mdc` (pre-rewrite):

- Officer+ = roster `rankIndex ≤ COB.Ranks.OfficerRankIndexMax` (default `1` → GM + top officer)
- Receivers re-check the sender’s rank index — UI “I am officer” is not enough on the wire
- The Officer+ gate snippet (`rankIndex <= OfficerRankIndexMax`) as Church authority
- Until local `guildRankIndex` known: treat as **not** Officer+ (hide Officer tab; approve no-ops)
- Each guild is an **independent** ladder — no cross-realm church state
- Not in a guild → empty ladder UI; pause scoring and BeefNet sends
- Church titles come from the live guild roster map — not addon commits
- Officer+ may **Dismiss** promote suggestions and **correct standing** in the addon
- Addon must not call guild promote/demote APIs
- Legacy `RANK_COMMIT` on the wire is soft-ignored

Retargeted, not deleted: 0-based `rankIndex`; `C_GuildInfo.GuildRoster()` / 10s throttle; wait for `GUILD_ROSTER_UPDATE`; realm-qualified names; do not flip `SetGuildRosterShowOffline`; never map from `rankName` strings; `CanGuildInvite` / `CanEditOfficerNote` / `IsGuildOfficer()` are not Church authority; officers may still change ranks in the Blizzard guild UI (now via display-vs-truth reconcile).

## Concerns

- Registered-Pope / designated-Council lists are required by §13.3–13.4 and left without UX, as ordered; filed as OPEN_QUESTIONS #8.
- Guild-rank write is authorized only on `KNIGHT THIS BEEF` (the only dual-write the Bible names). Other elevations write the Church store only.
- Demo `Core/Officer.lua` still implements Officer+ index gating; this rule set contradicts that code until Phase 1 rework (expected).
