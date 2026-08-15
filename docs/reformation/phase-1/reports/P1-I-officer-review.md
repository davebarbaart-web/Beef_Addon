# Phase 1 Lane I — Adversarial Review

**Lane:** Officer fail-closed stub  
**Exclusive files:** `addon/ChurchOfBeef/Core/Officer.lua`, `tests/test_officer.lua`  
**Lane report:** `docs/reformation/phase-1/reports/P1-I-officer.md`  
**Writer:** [Officer stub](b3cc42a8-9462-4794-9e59-329ee3101350)  
**Cited law:** Ten Laws 3, 5; Bible §6, §13.1; GATE1_DESIGN_LEAD_DIRECTIVE.md §2; brief `docs/reformation/phase-1/briefs/P1-I-officer.md`

**Spec:** PASS  
**Quality:** Approved

Authority APIs refuse everything. No `OfficerRankIndexMax`, no Prophet, no GM=officer. `IsGuildRosterName` and the roster cache remain membership / display-rank sensing. Writer did not invent registered-Pope / Council config. Writer did not edit TOC / Roster / Ranks / BeefNet / UI. Isolated officer suite is green. This review did not restore officer-index gating and did not invent product.

## Verdict

Refutation of GATE1 §2 / Law 3 / Law 5 **fails** for this lane’s exclusive files.

Law 3 (ceremonial sovereignty) is not refuted by “always false.” Officers still cannot perform rituals through this module. The Pope also cannot, because Phase 1 has no ritual verbs — GATE1 §2 names that as the correct Quiet-Mode shell, not a sovereignty leak. “Always false” becomes wrong in Phase 4, when there is something true to say. That day is not this lane.

Law 5 (Pope-authoritative star) is not refuted by the missing registered-Pope list. GATE1 §2 and §4 forbid this cut from becoming that module. OPEN_QUESTIONS #8 stays direction only. Fail-closed refuses peer / Officer+ self-reported authority. No second writer was added.

The leftover SUGGESTION path in BeefNet still *asks* `LocalIsOfficer` and now always hears `"not an officer"`. That is Lane J’s cut, not a Lane I restore of Officer+.

## Confirmations

| Check | Result |
|---|---|
| `IsOfficerIndex` always false | **Yes.** Body is `return false`. Argument unused (`_rankIndex`). Probed −1, 0, 1, 2, 3, 99, `inf`, `nil`, `"0"`, `{}`. |
| `IsOfficerName` always false | **Yes.** Body is `return false`. Injected GM/officer lookups, `nil` lookup, and a non-function lookup all false. |
| `LocalIsOfficer` always false | **Yes.** Body is `return false`. No `GetGuildInfo` read. Still false when `GetGuildInfo` returns GM index 0, officer index 1, or when `C_GuildInfo.IsGuildOfficer` is stubbed true. |
| No `OfficerRankIndexMax` | **Yes.** `O.OfficerRankIndexMax` is nil. `Ranks.OfficerRankIndexMax` is not read. Old `rankIndex <= ranks.OfficerRankIndexMax` gate is deleted. |
| No Prophet | **Yes.** `O.IsProphet` is nil. No Prophet-shaped function or comment product. |
| No GM=officer | **Yes.** Index 0 and name `"Pope"` are false. Tests lock that. |
| `IsGuildRosterName` remains membership, not authority | **Yes.** Name match via Roster or a local `GetGuildRosterInfo` walk. Returns true/false for membership only. No live `addon/` caller. |
| Roster cache kept; no SUGGESTION logic added | **Yes.** `RefreshRosterCache` / `HasRosterCache` / `GetRosterLookup` stay. `GetRosterLookup` returns display `rankIndex` and is commented not-an-authority-gate. No petition / threshold / suggest code. |
| Tests assert the stub; isolated 27/0 | **Yes.** Re-ran writer’s isolated load: **27 passed, 0 failed.** Old `IsOfficerIndex(0/1) == true`, `LocalIsOfficer` GM/officer pass, and `R.OfficerRankIndexMax == 1` product tests are gone. Remaining mentions are absence locks. |
| Writer did not invent registered-Pope / Council config | **Yes.** Header comment only: Phase 4 owns it; OPEN_QUESTIONS #8 is direction only. No data file, no Pope list, no override UX, no `IsPope`. `OPEN_QUESTIONS.md` unchanged by this writer. |
| Writer did not edit TOC / Roster / Ranks / BeefNet / UI | **Yes.** Writer transcript writes only `Officer.lua`, `test_officer.lua`, and `P1-I-officer.md`. Those other paths are dirty from parallel lanes. |

Public `COB.Officer` keys after load: `IsOfficerIndex`, `IsOfficerName`, `LocalIsOfficer`, `IsGuildRosterName`, `RefreshRosterCache`, `HasRosterCache`, `GetRosterLookup`, `ResetForTests`. Probe: no authority API returned true.

## Attack results

| Attack | Result |
|---|---|
| Hidden true path on index 0 / `"Pope"` / live GM `GetGuildInfo`? | **No.** Unconditional `return false`. Probe found no leak. |
| `OfficerRankIndexMax` restored under another name? | **No.** No max field, no `<= 1` compare, no `CanGuildInvite` / `CanEditOfficerNote` / `IsGuildOfficer()` gate. |
| Prophet / GM=officer smuggled through the cache? | **No.** Cache may answer `lookup("Pope") == 0`. `IsOfficerName` on that lookup is still false. Tests lock both facts. |
| Fail-closed violates Law 3 (Pope cannot act)? | **No.** GATE1 §2: nothing in a Quiet-Mode-only addon legitimately exercises authority. No ritual verbs yet. Officers still cannot knight, sanction, verdict, elevate, or canonize through this module. |
| Fail-closed violates Law 5 (no Pope writer identified)? | **No.** Identifying the writer is Phase 4 / OPEN_QUESTIONS #8. Inventing it here would be the violation. Refusing every Officer+ claim is the Phase 1 expression of “witnesses report, never rule.” |
| Registered-Pope / Council config invented? | **No.** Comment only. No workspace data file, no SV key, no UX. |
| `GetRosterLookup` is a second authority gate? | **No.** It returns display `rankIndex` for BeefNet roster readiness. Live `addon/` does not compare that index to decide Officer+. `Net:RosterLookup` exists; the only live Officer authority ask is `HandleSuggestion` → `LocalIsOfficer` (always refuse). |
| `IsGuildRosterName` used as a ritual / write gate? | **No.** Zero callers in `addon/`. Membership sensing only. |
| Writer restored officer-index gating “so tests pass”? | **No.** Tests were rewritten to assert the stub. Isolated 27/0. |
| Writer edited forbidden files? | **No.** Exclusive writes only. |
| Writer coded OPEN_QUESTIONS #8? | **No.** Direction text left in place. Not implemented. |

## Leftover callers (other lanes — expected; not fixed)

Writer leftover map is partly stale (parallel lanes already deleted Ceremony and the Officer tab). Current Officer-shaped leftovers:

### Net (Lane J)

- `Net/BeefNet.lua` — `GetRosterLookup` / `HasRosterCache` / `RefreshRosterCache` still used (kept on purpose). `HandleSuggestion` still calls `LocalIsOfficer` and now always returns `"not an officer"`. SUGGESTION / standing / threshold still live on the wire. Lane J owns the cut.
- `tests/test_net_validate.lua` — still asserts `IsOfficerName("Pope", lookup) == true` (“the cached lookup gates officers in”). Suite currently aborts earlier on missing `Core/Ladder.lua`. Lane J.

### Roster (other Core lane)

- `Core/Roster.lua` — still writes `COB.Officer.rosterCache` with guild `rankIndex`. Display-rank sensing, not Church authority. Not this lane.

### Gone (do not treat as current callers)

- `Core/Ceremony.lua` — **gone.** Writer’s “Start / Close still call `LocalIsOfficer`” is stale.
- `UI/MainFrame.lua` — no `UpdateOfficerVisibility`, no `LocalIsOfficer` read. Writer’s UI leftover is stale. Live shell has no Officer tab.

`ChurchOfBeef.lua` has no Officer calls.

## Findings

### Critical

None.

### Important

None for this lane’s exclusive files.

### Nit

1. **Writer leftover map is stale** (`P1-I-officer.md`). It still lists `Core/Ceremony.lua` Start/Close and `UI/MainFrame.lua` `UpdateOfficerVisibility`. Both are gone. BeefNet SUGGESTION + `test_net_validate.lua` officer-true assert remain. Does not reopen Spec.

2. **`IsGuildRosterName` true-path is untested.** Suite locks nil/empty only. Allowed membership sensing is otherwise unasserted. Not a Spec miss — the brief required the authority stub.

3. **`GetRosterLookup` still hands out raw `rankIndex`.** Brief allowed the cache. A later caller could write `lookup(name) <= 1` without touching `IsOfficer*`. Today no live `addon/` caller does. Phase 4 must not treat that number as sovereignty.

## Brief contract

| Requirement | Result |
|---|---|
| `IsOfficerIndex` / `IsOfficerName` / `LocalIsOfficer` always false | Met |
| Comment: Phase 4 owns registered-Pope / Council | Met |
| Do not invent that module or a config UX (OPEN_QUESTIONS #8 direction only) | Met |
| `IsGuildRosterName` may stay as membership | Met |
| Roster cache may stay; no SUGGESTION logic added | Met |
| Rewrite `test_officer.lua` to assert the stub | Met |
| No `OfficerRankIndexMax`, no Prophet, no GM=officer | Met |
| Isolated suite passes | Met (27 / 0) |
| Do not edit TOC / Roster / Ranks / BeefNet / UI | Met |
| Report leftover callers; do not fix them | Met (map now stale; see Nit) |
| No commit | Met |
| Do not invent product | Met |

## Sections checked

- Brief `docs/reformation/phase-1/briefs/P1-I-officer.md`
- Writer report `docs/reformation/phase-1/reports/P1-I-officer.md`
- `docs/reformation/phase-0/TEN_LAWS.md` Laws 3, 5
- GATE1_DESIGN_LEAD_DIRECTIVE.md §2 (fail-closed is correct for the Phase 1 shell) and §4 (#8 direction only)
- `addon/ChurchOfBeef/Core/Officer.lua` (HEAD diff + live probe)
- `tests/test_officer.lua` (HEAD diff + isolated run 27/0)
- Writer transcript (exclusive writes only)
- Live leftovers: BeefNet `HandleSuggestion`, `tests/test_net_validate.lua`, Roster cache write
- Confirmed absent: `Core/Ceremony.lua`, MainFrame `LocalIsOfficer`
- `docs/design/OPEN_QUESTIONS.md` #8 (unchanged by this writer)
