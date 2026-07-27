# Church of Beef — Roster-backed ladder (design amendment)

**Date:** 2026-07-25  
**Status:** Accepted — implemented 2026-07-26  
**Amends:** [2026-07-25-church-of-beef-design.md](2026-07-25-church-of-beef-design.md) (§4 authority model, §6–8 rank commits/sync, §10 Officer tab, §11–13 success criteria)  
**Does not amend:** Scoring sources (instance / ceremony / Gora), Officer+ gate via guild `rankIndex`, layer rules (UI→Core→Data), Interface `20506`

## 1. Intent

Make the Ladder a live mirror of the **WoW guild roster**, mapped onto Church titles. Keep standing and thresholds so loyal members become **promote suggestions** that officers fulfill **in the Blizzard guild UI** — not via addon rank commits.

Solo / single-client testing becomes viable: one Guild Master with a real roster can see the full flock and exercise the suggestion queue without a second player running the addon.

## 2. Decisions (locked)

| Topic | Decision |
|-------|----------|
| Rank source of truth | Live guild roster only |
| Mapping | Fixed by WoW `rankIndex` (experiment; configurable mapping is a later escape hatch) |
| Points | Stay; capped grants; create promote suggestions only |
| Auto guild promote/demote APIs | Never — prompt only |
| Officer Approve → `RANK_COMMIT` | Removed |
| Demote / Council appoint / Prophet bestow rites | Removed from addon |
| Standing correction | Kept (Officer+); adjusts points only, never Church title |
| BeefNet rank replication | Removed / no-op (nothing official to sync for ranks) |
| Guild-chat promote spectacle | Deferred for this amendment (no Commit announcer). Toast + officer queue remain. Revisit roster-diff announce after playtest |
| Approach | Roster-backed ladder view (no SV copy of ranks) |

## 3. Fixed rank map

WoW guild `rankIndex` is 0-based (`0` = Guild Master).

| WoW `rankIndex` | Church `rankId` | Title |
|----------------:|----------------:|-------|
| 0 | 7 | Beef Prophet |
| 1 | 6 | Beef Council |
| 2 | 5 | Beef Butcher |
| 3 | 4 | Beef Lord |
| 4 | 3 | Beef Knight |
| 5 | 2 | Cooked Beef |
| 6+ | 1 | Fresh Beef |

Canon titles/thresholds/kinds remain in `Data/Ranks.lua`. The map itself is machine policy (same file or a tiny helper next to it) so UI does not hardcode indices.

**Guild shape mismatch:** If the guild has fewer than seven ranks, upper Church bands stay empty except where an index lands. Extra ranks (7–9) all display as Fresh Beef. That brittleness is accepted for this experiment; switch to officer-configurable mapping if a real guild night proves the table wrong.

## 4. Authority & data model

| Truth | Source | Addon writes? |
|-------|--------|---------------|
| Membership + Church title | `GetGuildRosterInfo` after `GUILD_ROSTER_UPDATE` | No |
| Standing + promote suggestions | SavedVariables / Scoring / Ladder suggestion store | Yes |

### 4.1 SavedVariables shape (target)

- Keep: local standing tallies, suggestion queue, UI prefs, scoring daily caps.
- Stop treating as official: per-member `rankId`, `revision`, `updatedBy` as ladder authority.
- Migration: on load, ignore legacy official rank fields for display. Do not invent ranks from old SV. Optionally drop them on next save once UI no longer reads them.
- `GetRecord`-style APIs either retire or return standing-only / suggestion-only data; ladder occupancy never comes from SV.

### 4.2 Officer+

Unchanged: `rankIndex ≤ COB.Ranks.OfficerRankIndexMax` (default `1`). Still never gate on rank name strings. Still fail closed until roster is ready.

## 5. Runtime flow

```
GUILD_ROSTER_UPDATE
  → Core roster snapshot (names + rankIndex → churchRankId)
  → UI Ladder refresh

Instance / Ceremony / Gora
  → Scoring grant (capped)
  → MaybeSuggestPromote(name)
       only if next point-driven Church title is above current mapped title
  → Officer tab queue + toast

Officer opens guild roster in Blizzard UI and promotes
  → GUILD_ROSTER_UPDATE
  → Ladder moves the name
  → Suggestion auto-clears if mapped title ≥ suggested title

Officer Dismiss on a suggestion
  → Clear local suggestion only (standing unchanged)
```

## 6. Core modules (target responsibilities)

| Module | Change |
|--------|--------|
| `Data/Ranks.lua` | Add `ChurchRankIdForGuildIndex(rankIndex)` (or equivalent); keep thresholds/kinds |
| New or `Core/Roster.lua` | Build/refresh name→`guildRankIndex`/`churchRankId` snapshot; `GetLadderView()` from snapshot; name normalize (strip realm) consistent with Officer |
| `Core/Ladder.lua` | Shrink to standing + suggestions (+ maybe standing correction helpers). Remove Commit / Demote / Appoint / ApplyRemoteCommit seat logic as product paths |
| `Core/Officer.lua` | Keep IsOfficer* / roster membership; used for tab visibility and suggestion dismiss authority |
| `Core/Scoring.lua` | Unchanged grant math; suggestion hook uses **mapped** current rank, not SV rank |
| `Net/BeefNet.lua` / `Net/Sync.lua` | Stop applying rank commits as authority. Prefer remove handlers; soft-ignore legacy `RANK_COMMIT` / `SYNC_STATE` rank payloads so mixed-version guilds do not fork |
| `UI/LadderTab.lua` | Consume roster-backed view |
| `UI/OfficerTab.lua` | Queue + Dismiss + standing correction only; copy tells officer to promote in guild UI |
| `UI/StandingTab.lua` | Show roster-mapped title + progress toward next point-driven title |

Layer rule holds: roster snapshot lives in Core (or thin Core helper), not in UI. UI still does not award points.

## 7. Suggestions (promote prompts)

- Crossing the standing threshold for the **next point-driven** Church title (`kind == "points"`) enqueues a suggestion.
- Never suggest Council or Prophet from points (unchanged).
- Suggestion payload: `name`, `fromRankId` (mapped at creation), `toRankId`, `standing`, `threshold`, `createdAt`.
- Refresh/clear when roster mapping already `≥ toRankId`.
- Officer actions: **Dismiss** only. No Approve/Reject commit path.
- Non-officers never see the Officer tab; members may still toast locally when *they* become suggestion-eligible (“Officers can promote you in the guild roster”).

## 8. UI copy & empty states

- Not in guild: existing empty flock copy.
- In guild, roster not ready: “Waiting for guild roster…”
- Officer queue row: “Promote *Name* to *Title* in the guild roster.”
- Remove confirm modals for demote / Council / Prophet (rites gone).
- Announce checkbox: hide or disable until a future roster-diff announcer exists (do not leave a dead control that claims to announce promotions).

## 9. Edge cases

| Situation | Behavior |
|-----------|----------|
| Roster not loaded | No occupants; no Officer+; standing may still accrue, but `MaybeSuggestPromote` does not enqueue until a successful roster snapshot exists for that name |
| Player not in guild | Empty ladder; pause scoring / net sends (unchanged intent) |
| Name with `-Realm` | Normalize consistently with existing Officer roster keys |
| Member leaves guild | Disappears from ladder; local standing may remain in SV but is hidden |
| Member returns | Reappears from roster; standing restored if SV still has them |
| Guild rank rename | Irrelevant — index map only |
| Guild adds/reorders ranks | May mis-bucket people — known limitation of fixed map |
| Legacy `RANK_COMMIT` received | Ignore (do not apply) |
| Disconnect mid-ceremony | Unchanged — no credit until clean close |
| Offline members | Show whatever the client roster includes; do not toggle `SetGuildRosterShowOffline` |

## 10. Testing & solo verification

**Offline (desktop harness)**  
- Stub guild roster with several `rankIndex` values; assert Ladder view buckets.  
- Assert threshold → suggestion uses mapped rank.  
- Assert Dismiss clears suggestion; no Commit API required for green suite.  
- Assert legacy commit apply paths are gone or no-op.

**In-game (single client)**  
1. Install → `/reload` → `/beef`.  
2. Ladder shows real guild members in mapped bands (GM → Prophet).  
3. Grant standing (ceremony/Gora stub or officer standing correction) until a member crosses a threshold → appears on Officer queue.  
4. Promote that member one step in Blizzard guild UI → ladder moves; suggestion clears.  
5. Non-officer alt (if available): no Officer tab; cannot dismiss others’ queue.

Two-client BeefNet rank sync is **not** a success criterion for this amendment.

## 11. Success criteria (this amendment)

1. Ladder occupants come from the live guild roster via the fixed index map.  
2. Local GM (index `0`) displays as Beef Prophet without ceremony or Commit.  
3. Standing grants still work; thresholds create promote suggestions only.  
4. Officer tab has no Approve-commit / Demote / Council / Prophet rites — Dismiss + standing correction only.  
5. Promoting in WoW guild UI updates the Ladder on roster refresh.  
6. Addon never calls guild promote/demote APIs.  
7. No Retail-only APIs; layer rules preserved.  
8. `lua tests/run.lua` exits 0 after Core/Data/harness updates.

## 12. Implementation notes (non-blocking)

- Prefer extending `Core/Officer.lua` roster cache or a sibling `Core/Roster.lua` over putting `GetGuildRosterInfo` in UI tabs.  
- `Ladder:GetLadderView()` can become a facade over the roster snapshot so tabs churn less.  
- Update parent design decisions log when this amendment is accepted.  
- Cursor rules that mandate Commit-as-authority (`ladder-authority.mdc`, `canon-data.mdc` SV blurb) need a follow-up edit in the same implementation plan — product law moves here first.

## 13. Out of scope

- Configurable rank mapping UI  
- Auto `SetGuildMemberRank` / `GuildPromote`  
- Account-wide standing  
- Roster-diff guild-chat spectacle  
- Classic+  

## 14. Open only if playtest fails

- Fixed map mismatches real Church of Beef guild structure → design configurable mapping (former option B).  
- Officers miss promotions without guild-chat lines → design careful roster-diff announce.
`}