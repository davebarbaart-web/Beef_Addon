# Phase 1 Lane B — Adversarial Review

**Lane:** Delete Ladder standing machinery  
**Exclusive files:** `addon/ChurchOfBeef/Core/Ladder.lua`, `tests/test_ladder.lua` (delete)  
**Lane report:** `docs/reformation/phase-1/reports/P1-B-ladder.md`  
**Cited law:** Ten Laws 1 and 7; Bible §4.6, §4.9, §12; Audit V1, V6

**Spec:** PASS  
**Quality:** Approved

No lite ladder. Ladder.lua and test_ladder.lua are gone (deleted, not attic’d, not renamed). TOC, bootstrap, and `tests/run.lua` no longer list them (integrator). Leftover callers are other lanes. Ladder was not restored. Writer did not invent points, XP, thresholds, or a replacement standing product.

## Verdict

Lane B removed the standing / suggestion / SweepDeparted engine. Nothing in live `addon/` implements `COB.Ladder =`, `SetStanding`, `MaybeSuggest`, `ImportSuggestion`, `CorrectStanding`, `SweepDeparted`, or a batch/revision standing store. `Roster:GetLadderView` still *shapes* rows with `standing = 0` when `COB.Ladder` is absent; that is a dead adapter, not a second engine. `Net:HandleSuggestion` returns `"ladder unavailable"`. Law 1 / Law 7 / Bible §4.6, §4.9, §12 / Audit V1, V6 hold for this lane’s exclusive files. Residual suggestion protocol, departed-sweep *callers*, and suites that `dofile` the deleted file are expected other-lane leftovers — they cannot award standing or prune Church history without the deleted module.

## Confirmations

| Check | Result |
|---|---|
| `addon/ChurchOfBeef/Core/Ladder.lua` gone (deleted, not attic’d, not renamed) | **Yes.** `ls`: no such file. Repo-wide glob: 0 `Ladder.lua`. Git: `D` (not `R` / `RM`). Attic holds Instance/Quest only. |
| `tests/test_ladder.lua` gone | **Yes.** Not on disk. Not among `tests/test_*.lua`. Git: `D`. |
| No lite ladder / standing engine / `SweepDeparted` implementation under another name | **Yes.** No `function …:SweepDeparted`, `MaybeSuggest`, `SetStanding`, `CorrectStanding`, `ImportSuggestion`, `BeginBatch`, or `COB.Ladder =` in `addon/`. Live Core is Common, Roster, Officer, Gora, Ceremony, DB. |
| No new file ports batch/revision persistence as a standing machine | **Yes.** `Core/Common.lua` is Names / Clock / Group only (not this lane). No `batchDepth` / `GetRevision` store. Writer persistence notes stay in the lane report. |
| TOC does not list `Core\Ladder.lua` | **Yes.** `ChurchOfBeef.toc` has no `Ladder` string. |
| `ChurchOfBeef.lua` has no `WireSuggestionFanout` / `COB.Ladder` | **Yes.** Bootstrap is OnLoad / OnLogin / OnLogout / `/beef` only. |
| `tests/run.lua` does not list `test_ladder` | **Yes.** Suite list has no `test_ladder`. |
| Writer did not invent points, XP, thresholds, or a replacement standing product | **Yes.** Exclusive work is delete + report. `Data/Ranks.lua` has titles only (Lane D). `OPEN_QUESTIONS.md` untouched. |

Writer brief forbade TOC / bootstrap / `run.lua` edits. Integrator owns those files (`docs/REFORMATION_LOG.md`). Writer report’s “still listed” lines are stale against the current tree; the live tree matches the review contract. Writer transcript ([Ladder delete](fb8a4699-db8a-4925-9ba7-bcb924f30e81)): `Delete` on the two exclusive files + `Write` the report only.

## Attack results

| Attack | Result |
|---|---|
| Ladder moved / renamed instead of deleted? | **No.** Zero `Ladder.lua` anywhere. Git `D`, not rename. Attic is Instance/Quest. |
| Standing rebuilt as “records,” “petitions,” or “suggestions” in a new Core file? | **No.** No new Standing / Records / Petitions / Suggestions module. `Common.lua` does not store standing. `DB.lua` (Lane G) is `{ version, ui }` only; leftover SV keys are left in place (Law 7), not imported into a store. |
| `SweepDeparted` still implemented as a history prune (Law 7)? | **No implementation.** Roster has a guarded caller (`if ladder and ladder.SweepDeparted`) that returns without writing. `Toasts` `pruneRecent` is toast-dedupe, not Church history. Last-commit `Ladder.lua` also had no `SweepDeparted` (`git log -S SweepDeparted` on `*.lua` is empty); Audit V6 named the demo method. The prune cannot run. |
| Bootstrap still fans suggestions to Net? | **No.** No `WireSuggestionFanout`, no `SetOnSuggestion`. `Net:OnLocalSuggestion` / `SendSuggestion` remain as leftover protocol (other lane) with no Core producer and no bootstrap wire. |
| Writer edited TOC / bootstrap / `run.lua` (forbidden)? | **No.** Writer leftover list still named those as leftovers. Integrator dropped the TOC line, the fanout, and `test_ladder`. |
| Writer replaced the engine and called it records? | **No.** Persistence patterns are documented in the lane report only, as the brief required. No product answers added to `OPEN_QUESTIONS.md`. |

Refutation of Law 1 / Law 7 / §4.6 / §4.9 / §12 / Audit V1, V6 **fails** for this lane. The banned mechanism is the standing store, the promote-suggestion queue, and the departed-member sweep. They are gone. Call sites without an implementation cannot score members or delete Church history.

## Leftover callers (other lanes — expected; not fixed)

Writer leftover list is partly stale (TOC / bootstrap / `run.lua` already integrator-cleaned; Lane G cut DB import/export and Ceremony/Gora `SetRiteFlag`; Lanes E/F deleted StandingTab / OfficerTab / LadderTab and their suites). Current Ladder-shaped leftovers:

### Roster (not this lane)

- `Core/Roster.lua` — header still says standing lives on Ladder. `sweepDeparted` after a complete roster (guarded; no-op). `ClearSatisfiedSuggestions` → `GetSuggestions` / `RejectSuggestion` (guarded). `GetLadderView` still emits `standing = 0`, `revision = 0` when Ladder is absent. `MainFrame.lua` reads `Roster:GetLadderView` for class-color cache only — not `COB.Ladder`.

### Net (not this lane)

- `Net/BeefNet.lua` — `ReleaseHeld` still calls `BeginBatch` / `EndBatch` if present. `HandleSuggestion` requires `COB.Ladder.ImportSuggestion` and returns `"ladder unavailable"`. `SendSuggestion` / `OnLocalSuggestion` still encode standing/threshold fields. No bootstrap fanout.

### Officer / comments

- `Core/Officer.lua` — comment still says rites “write a ladder record.” No Ladder calls.

### Tests that `dofile` the deleted file (abort when those suites run)

- `tests/test_db.lua`
- `tests/test_roster.lua`
- `tests/test_net_validate.lua`
- `tests/test_net_adversarial.lua`

`tests/test_gora_ceremony.lua`, `tests/test_minimap.lua`, and `tests/test_ui.lua` no longer `dofile` Ladder (other lanes). `tests/test_officer_ui.lua` and `tests/test_standing_ui.lua` are gone.

### Attic (Lane C — not shipped)

- `attic/tests/test_instance.lua`, `attic/tests/test_quest.lua` — still `dofile` deleted `Core/Ladder.lua` and read `GetRecord(name).standing`.

### Not leftover `COB.Ladder` callers

- `UI/MainFrame.lua` / `UI/Status.lua` call `Roster:GetLadderView`, not `COB.Ladder`.
- `COB.LadderTab` is gone with the UI tab file (Lane F).
- `Core/Scoring.lua` / `tests/test_scoring.lua` already gone (Lane A).
- `ChurchOfBeef.lua` has no Ladder references.

`## SavedVariablesPerCharacter: ChurchOfBeefDB` remains on the TOC (Audit V6 identity). Account-level SV is Phase 2 / packaging — not this lane.

## Findings

### Critical

None.

### Important

None for this lane’s exclusive files.

### Nit

1. **Writer report leftover map is stale** (`P1-B-ladder.md`). It still lists TOC / `WireSuggestionFanout` / `test_ladder`, DB Import/Export, Ceremony/Gora `SetRiteFlag`, and deleted UI tabs. Integrator and parallel lanes already moved those. Does not reopen Spec. This review’s leftover list is the current map.

2. **Writer attributed `SweepDeparted` to the deleted file.** Last-commit `Ladder.lua` had no such function. Roster’s guarded caller predates the writer (writer did not edit Roster). Dead path; Law 7 still holds. Report accuracy only.

3. **`GetLadderView` still returns a standing-shaped row** (`standing = 0`). Not a store. Roster / shell lanes.

## Brief contract

| Requirement | Result |
|---|---|
| Delete `Core/Ladder.lua` | Met |
| Delete `tests/test_ladder.lua` | Met |
| No lite ladder | Met |
| Persistence patterns in docs only; no new standing file | Met |
| Do not edit TOC / bootstrap / `run.lua` / other modules (writer) | Met (integrator dropped TOC, fanout, suite list) |
| Report leftover callers; do not fix them | Met |
| No commit | Met |
| Ladder not restored this review | Met |

## Sections checked

- Brief `docs/reformation/phase-1/briefs/P1-B-ladder.md`
- Writer report `docs/reformation/phase-1/reports/P1-B-ladder.md`
- Writer transcript [Ladder delete](fb8a4699-db8a-4925-9ba7-bcb924f30e81)
- `docs/reformation/phase-0/TEN_LAWS.md` Laws 1, 7
- Bible §4.6, §4.9, §12
- Audit V1, V6 and §4 `Core/Ladder.lua` Discard row
- `ChurchOfBeef.toc`, `ChurchOfBeef.lua`, `tests/run.lua`
- Live Core/UI/Net Lua for `COB.Ladder`, `SweepDeparted`, `MaybeSuggest`, `SetStanding`, `BeginBatch`, suggestion fanout
- `Data/Ranks.lua` (no thresholds)
- Attic Instance/Quest tests
- `docs/design/OPEN_QUESTIONS.md` (unchanged)
- `docs/REFORMATION_LOG.md` P1-B integrator note
