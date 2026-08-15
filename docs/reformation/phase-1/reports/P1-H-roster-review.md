# Phase 1 Lane H — Adversarial Review

**Lane:** Roster cut (sensing only)  
**Exclusive files:** `addon/ChurchOfBeef/Core/Roster.lua`, `tests/test_roster.lua`  
**Lane report:** `docs/reformation/phase-1/reports/P1-H-roster.md`  
**Cited law:** Ten Laws 1, 2, 7, 9; Bible §5, §12; GATE1 §2; brief `docs/reformation/phase-1/briefs/P1-H-roster.md`

**Spec:** PASS  
**Quality:** Approved

Guild-roster sensing remains (names, `guildRankIndex`, completeness, local-player seed). Members still land when `ChurchRankIdForGuildIndex` is nil. `GetLadderView`, `SweepDeparted`, `ClearSatisfiedSuggestions`, and the Ladder standing merge are deleted, not stubbed. No Church-id map, Presence desk, or standing field. Isolated `test_roster` is green and does not `dofile` Ladder/Scoring. Writer did not edit TOC, MainFrame, Officer, or BeefNet. `GetLadderView` was not restored this review.

## Verdict

Refutation of GATE1 §2 / Laws 1, 2, 7, 9 **fails** for this lane’s exclusive files. The banned engines were the standing-shaped row merge, the suggestion clearer, and the departed-member sweep caller. They are gone. What remains is a live guild snapshot. That snapshot is not a points ladder, not a behavior ledger, not Church history, and not a rank map.

Lane D’s earlier leftover — Roster **dropping** anyone whose mapped Church id is nil — is closed. A three-name walk with every `ChurchRankIdForGuildIndex` result nil is ready, complete, and keeps all three names. `GetChurchRankId` stays nil. `OPEN_QUESTIONS.md` is unchanged. This review did not restore `GetLadderView`.

## Confirmations

| Check | Result |
|---|---|
| `GetLadderView` gone | **Yes.** No function. `Roster.GetLadderView` is nil. Suite locks it. |
| `SweepDeparted` / `sweepDeparted` / `sweptDeparted` gone | **Yes.** No symbol, no caller, no once-per-session flag. `ResetForTests` no longer clears `sweptDeparted`. |
| `ClearSatisfiedSuggestions` gone | **Yes.** No function. `applySnapshot` no longer calls it. |
| Ladder standing merge gone | **Yes.** Deleted `GetLadderView` body that wrote `standing = ladder:GetStanding` / `GetRecord.standing` and sorted by `rankId`. Live member rows have no `standing` key (probed). |
| Members land when `ChurchRankIdForGuildIndex` is nil | **Yes.** Seed / API / lib builders require `key`, shown name, and `rankIndex` only. Suite: three names kept; seed of one name is enough to leave `roster_wait`. |
| No invented Church-id map | **Yes.** No local index→id table. The three builders call `Ranks.ChurchRankIdForGuildIndex` and accept nil. `GetChurchRankId` returns nil. Tests lock GM index 0 and display index 6 as not Church ranks. |
| No Presence desk | **Yes.** Core snapshot + `officerCache` rankIndex write only. Header was narrowed off “Presence / display.” No desk, no flags, no reconcile questions. |
| No standing field | **Yes.** Member shape is `name`, `guildRankIndex`, optional `classFile`. `standing` is nil/absent. |
| `test_roster` does not `dofile` Ladder/Scoring | **Yes.** Load is Common + Ranks + Roster only. |
| Isolated suite green | **Yes.** Ranks-style load: **46 passed, 0 failed.** Matches the writer count. |
| Writer did not edit TOC / MainFrame / Officer / BeefNet | **Yes.** Writer transcript ([Roster cut](d4fa3e9c-5dd8-46a9-ad0e-cf66a1815e57)): `StrReplace`/`Write` only on `Core/Roster.lua`, `tests/test_roster.lua`, and `P1-H-roster.md`. |
| Writer did not edit bootstrap / `tests/run.lua` / DB | **Yes.** Exclusive files only. |
| No commit | **Yes.** |
| `GetLadderView` not restored this review | **Yes.** |

Public functions after load: `AttachLibrary`, `GetChurchRankId`, `GetGeneration`, `GetGuildRankIndex`, `GetOccupantCount`, `HasMember`, `IsComplete`, `IsReady`, `NameKey`, `OnLibraryRosterEvent`, `Refresh`, `ResetForTests`, `SetOnChanged`, `_NotifyChanged`. No `GetLadderView`, `ClearSatisfiedSuggestions`, or `SweepDeparted`.

## Attack results

| Attack | Result |
|---|---|
| Law 1 — standing rebuilt as occupant count / generation / `officerCache`? | **No.** `GetOccupantCount` is a derived pairs-count of the current snapshot, explicitly not a running total. `generation` is a dirty token. `officerCache` stores guild `rankIndex`, not points. No Grant, threshold, or suggestion path. |
| Law 2 — roster Refresh is a behavior / activity ledger? | **No.** `GetGuildRosterInfo` online/status columns are discarded. No hours, combat minutes, last-seen, contribution number, or activity leaderboard. Occupant count is “how many names this walk holds,” not a lifetime score. |
| Law 7 — leave-guild `clearSnapshot` is `SweepDeparted` under another name? | **No.** Roster is a live guild walk, not the Church store. It writes no SavedVariables. GATE1 §1: the guild roster forgets; the Church does not. Empty/failed walks do **not** wipe a good snapshot (Classic empty-update race). The 14-day departed prune caller is deleted. |
| Law 7 — wholesale replace on a later complete walk prunes history? | **No.** A later complete walk replaces the live snapshot. That is guild sensing. There are no Church records on these rows to delete. |
| Law 9 / GATE1 §2 — `churchRankId = ChurchRankIdForGuildIndex(...)` invents the map? | **No.** Lane D’s stub returns nil; Lua omits the nil key. No 0→7, no GM-as-Prophet, no Fresh Beef from index 6. Presence is empty of Church ids, as the directive allows. Display-vs-truth reconcile was not built. |
| Presence desk / Church store invented in Core? | **No.** No desk UI (Core cannot `CreateFrame`). No persist. `GetChurchRankId` is a nil getter, not a store. |
| `GetLadderView` left as `return {}` so ClassColorCode still has a standing-shaped adapter? | **No.** Function deleted. P1-L already cut `ClassColorCode`. This review did not put the adapter back. |
| Writer edited forbidden files? | **No.** TOC, `ChurchOfBeef.lua`, `tests/run.lua`, MainFrame, Officer, BeefNet, DB untouched by this writer. |
| Isolated suite still encodes Prophet / standing / Ladder? | **No.** Absence locks only. No `dofile` of deleted modules. |

Refutation of Law 1 (no points economy), Law 2 (record events, never behavior), Law 7 (never-delete Church history), Law 9 (six ranks; no invented map), and GATE1 §2 (do not invent Church-id mapping) **fails** for the exclusive files.

## Leftover callers (other lanes — expected; not fixed)

Writer leftover map is partly stale. `ClassColorCode` is **P1-L**. That lane already cut the `GetLadderView` walk. Live `MainFrame.lua:209` is `layoutContent`, not a roster walk. `UI:RefreshLadder` remains as a name BeefNet still invokes; its body is optional `Minimap:Refresh` only.

### Deleted-API leftovers (current tree)

None in live `addon/`. `GetLadderView` / `SweepDeparted` / `ClearSatisfiedSuggestions` have no remaining Lua callers.

### Other lanes (saw; not this writer)

| File | What remains |
|------|----------------|
| `tests/test_net_validate.lua:11` | `dofile("addon/ChurchOfBeef/Core/Ladder.lua")` — harness abort (Lane J) |
| `tests/test_net_adversarial.lua:14` | same `dofile` — harness abort (Lane J) |
| `Net/BeefNet.lua` | suggestion payload still names `standing` / `threshold`; still calls kept Roster sensing (`Refresh`, `IsReady`, `IsComplete`, `AttachLibrary`, `SetOnChanged`) |
| `Core/Officer.lua` | kept sensing (`Refresh`, `IsReady`, `HasMember`); `rosterCache` is display `rankIndex` |

`UI/Status.lua` uses `Roster:IsReady` only. `tests/test_db.lua` no longer `dofile`s Ladder (Lane K). Those are not leftover deleted-API callers.

Officer and BeefNet calls into kept sensing are in-scope leftovers of other lanes, not H defects.

## Findings

### Critical

None.

### Important

None for this lane’s exclusive files.

### Nit

1. **Writer leftover line is stale** (`P1-H-roster.md`). It still names `MainFrame.lua:209` `ClassColorCode` → `GetLadderView`. P1-L already deleted that walk. Report accuracy only; H correctly did not edit MainFrame.

2. **Writer overstates “`churchRankId` is still stored.”** The constructors assign the stub result; when it is nil, Lua omits the key. Probed rows are `{ name, guildRankIndex, classFile? }`. The getter still returns nil. Not a map either way.

3. **LibGuildRoster build path is untested.** API walk + local-player seed cover the sensing contract the brief named. The lib path is the same keep rule.

## Brief contract

| Requirement | Result |
|---|---|
| Keep sensing: names, `guildRankIndex`, completeness, local-player seed | Met |
| Members stay when `ChurchRankIdForGuildIndex` is nil | Met |
| Delete `GetLadderView` | Met |
| Delete `SweepDeparted` / `ClearSatisfiedSuggestions` / standing merge | Met |
| No standing field; no history prune | Met |
| Do not invent Church-id map / Presence desk / display-vs-truth / Church store / Prophet / thresholds | Met |
| Rewrite `test_roster.lua`; do not `dofile` Ladder/Scoring; isolated green | Met (46 / 0) |
| Do not edit TOC / bootstrap / `run.lua` / MainFrame / Officer / BeefNet / DB | Met |
| Report leftovers; do not fix them (`ClassColorCode` is P1-L) | Met (map now stale; P1-L already cut the walk) |
| No commit | Met |
| `OPEN_QUESTIONS.md` unchanged | Met |
| `GetLadderView` not restored this review | Met |

## Sections checked

- `docs/reformation/phase-0/TEN_LAWS.md` Laws 1, 2, 7, 9
- Brief `docs/reformation/phase-1/briefs/P1-H-roster.md`
- Writer report `docs/reformation/phase-1/reports/P1-H-roster.md`
- `GATE1_DESIGN_LEAD_DIRECTIVE.md` §2 (Roster presence may be empty; do not invent Church-id mapping)
- Writer transcript [Roster cut](d4fa3e9c-5dd8-46a9-ad0e-cf66a1815e57)
- `addon/ChurchOfBeef/Core/Roster.lua` (live + writer cut: sweep / suggestions / `GetLadderView`)
- `tests/test_roster.lua` (rewrite; isolated 46 / 0)
- `addon/ChurchOfBeef/Data/Ranks.lua` (`ChurchRankIdForGuildIndex` nil stub)
- Live leftovers: MainFrame (P1-L; `ClassColorCode` gone), Status, Officer, BeefNet, `test_net_validate.lua`, `test_net_adversarial.lua`
- `ChurchOfBeef.toc`, `ChurchOfBeef.lua`, `tests/run.lua` (not this writer)
- `docs/design/OPEN_QUESTIONS.md` (unchanged; no product invention)
