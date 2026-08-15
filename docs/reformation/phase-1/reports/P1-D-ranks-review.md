# Phase 1 Lane D — Adversarial Review

**Lane:** Six-rank canon, no thresholds  
**Exclusive files:** `addon/ChurchOfBeef/Data/Ranks.lua`, `tests/test_ranks.lua`  
**Lane report:** `docs/reformation/phase-1/reports/P1-D-ranks.md`  
**Cited law:** Ten Laws 1, 9; Bible §5; brief `docs/reformation/phase-1/briefs/P1-D-ranks.md`

**Spec:** PASS  
**Quality:** Approved

Six ranks, ids 1–6, titles exact. No seventh rung, no Beef Prophet, no thresholds, no points `kind`, no invented `CouncilSeats`. `ChurchRankIdForGuildIndex` is a nil stub. Writer did not edit TOC or `tests/run.lua`. Isolated ranks suite is green.

## Verdict

Refutation of Law 9 / Bible §5 / the Lane D brief **fails** for this lane’s exclusive files. The points-ladder rank table is gone. What remains is titles plus `Title(id)` / `List` / `ById`. Guild index is not Church truth. Officer, Roster, and dead UI callers still speak the old product — those are other lanes. This review did not rewrite `Ranks.lua` and did not invent slot numbers.

## Confirmations

| Check | Result |
|---|---|
| Ids 1–6 exactly: Fresh Beef, Cooked Beef, Beef Knight, Beef Lord, Beef Butcher, Beef Council | **Yes.** `List` / `ById` / `Title` agree. `#List == 6`. |
| No rank 7, no Beef Prophet, no `ProphetUnique` | **Yes.** `List[7]` and `ById[7]` are nil. `Title(7)` is `"Unknown"`. `R.ProphetUnique` is nil. No Prophet-shaped title. |
| No `threshold`, `kind == "points"`, `OfficerRankIndexMax`, `NeedsRite`, `IsPointDriven`, `Threshold` | **Yes.** Each row is `{ id, title }` only. Public keys are `List`, `ById`, `Title`, `ChurchRankIdForGuildIndex`. |
| No invented `CouncilSeats` number | **Yes.** Omitted. `R.CouncilSeats` is nil. Report invents no seat count. `OPEN_QUESTIONS.md` unchanged. |
| Butcher commented as raid-team role, display-only this phase | **Yes.** Line above id 5: “Raid-team role designation; display-only this phase (Bible §5).” |
| `ChurchRankIdForGuildIndex` always returns nil | **Yes.** Body is `return nil`. No 0→7, no GM-as-Prophet, no replacement map. Probed −1..10, `"0"`, `{}`. |
| `Title(id)` and list/by-id table kept | **Yes.** Unknown id → `"Unknown"` (pre-existing). |
| `test_ranks.lua` has no threshold / Prophet / `OfficerRankIndexMax` product tests | **Yes.** Old `{0,50,200,500,1000}`, Prophet title, `CouncilSeats = 4`, `OfficerRankIndexMax = 1`, `NeedsRite` / `IsPointDriven` value tests are gone. Remaining mentions are absence locks. |
| Writer did not invent a new numeric guild-index mapping | **Yes.** Stub only. Comment forbids treating GM as a Church rank. |
| Writer did not edit TOC / other modules | **Yes.** Writer transcript writes only `Ranks.lua`, `test_ranks.lua`, `P1-D-ranks.md`. `Data\Ranks.lua` still ships. TOC / `run.lua` diffs are other-lane / integrator. |

## Attack results

| Attack | Result |
|---|---|
| Hidden thresholds or point-driven kinds? | **No.** Pair-dump of every row: keys are `id` and `title` only. No `threshold`, `kind`, `min`, `xp`, `standing`, or `points`. `kind` is omitted entirely (stronger than “no `kind == points`”). Bible §5’s prose “threshold” (Knight as the point where identity features are expected) is not encoded as a number. |
| Prophet restored under another name? | **No.** Titles are the six Law 9 names. No Pope rank, no GM rank, no Seer / Pontiff / honorific Prophet in this module. `Title(7)` is `"Unknown"`, not a synonym. |
| `ChurchRankIdForGuildIndex` still maps index → Church id? | **No.** Argument is unused (`_rankIndex`). Always `nil`. Old 0→7 / 1→6 / 6+→Fresh table is deleted, not rewritten. |
| `CouncilSeats` invented? | **No.** Not a field, not a comment number, not an OPEN_QUESTION “answer.” |
| Isolated ranks suite actually green? | **Yes.** Ranks-only load (assert helpers + `dofile tests/test_ranks.lua`; `run.lua` not edited): **49 passed, 0 failed.** Matches the writer count. |
| Writer edited TOC / other modules? | **No.** Exclusive files only. Integrator: no TOC change required; `Ranks.lua` remains listed. |

Public `COB.Ranks` keys after load: `ById`, `ChurchRankIdForGuildIndex`, `List`, `Title`. `List` pairs-count 6 equals `#List`. `ById` keys are 1–6 only.

## Leftover callers (other lanes — expected; not fixed)

Writer leftover list is partly stale (parallel lanes already deleted the UI tabs). Current Ranks-shaped leftovers:

### Officer / Roster (other Core lanes)

- `Core/Officer.lua` — `IsOfficerIndex` still gates on `ranks.OfficerRankIndexMax`. That field is gone, so the gate **fails closed** (always false). Header still says “canon max.”
- `Core/Roster.lua` — still calls `ChurchRankIdForGuildIndex` and **drops** any member whose mapped id is nil. With the stub, seed / lib / API builds add nobody. `GetLadderView` still sorts by `rankId` descending and reads `COB.Ladder` standing (Lane B leftover).

### Net (other lane)

- `Net/BeefNet.lua` — suggestion path still talks “crossed a threshold,” reads `suggestion.threshold`, and calls `COB.Ranks.Title(toRankId)`.

### UI

- `UI/LadderTab.lua` — **gone.** Do not treat as a current caller.
- `UI/OfficerTab.lua` — **gone.** No “Beef Prophet” footer in live UI.
- Live `UI/` (`MainFrame`, `Status`, `Minimap`, `Toasts`) has no Prophet / `CouncilSeats` / rank-threshold reads.

### Tests that still encode the old 0→7 / Prophet / officer-max product

- `tests/test_roster.lua` — `ChurchRankIdForGuildIndex(0) == 7`, “Popeina is Prophet.”
- `tests/test_officer.lua` — `OfficerRankIndexMax == 1`.
- `tests/test_net_validate.lua` — “petition aimed at the Prophet's seat” (`toRankId` 7); suggestion threshold helpers.
- `tests/test_net_adversarial.lua` — “threshold is not treated as met.”

`tests/test_officer_ui.lua` is **gone**. `tests/test_ui.lua` is a quiet-shell suite and no longer asserts Prophet / 0→7.

Roster/Officer leftovers are other lanes. This review did not fix them.

## Findings

### Critical

None.

### Important

None for this lane’s exclusive files.

### Nit

1. **Writer leftover map is stale** (`P1-D-ranks.md`). It still lists `UI/LadderTab.lua`, `UI/OfficerTab.lua`, and `tests/test_officer_ui.lua`, and it describes `lua tests/run.lua` as listing dead suites (133 / 18). Those UI files and that suite are gone; current `run.lua` no longer lists `test_ladder` / `test_scoring` / `test_instance` / `test_quest`. Does not reopen Spec. This review’s leftover list is the current map.

2. **Roster nil-map is a drop, not a display-only annotate.** Writer said “every id is now nil.” True, and the live builders also skip the member when the id is nil — Presence empties until Roster is reworked. Other lane; not a Lane D defect. The brief required the stub.

## Brief contract

| Requirement | Result |
|---|---|
| Ranks exactly ids 1–6, named titles | Met |
| No 7 / Prophet / `ProphetUnique` | Met |
| No threshold / points kind / `OfficerRankIndexMax` / `NeedsRite` / `IsPointDriven` / `Threshold` | Met |
| No invented `CouncilSeats` | Met |
| Butcher raid-team / display-only comment | Met |
| `ChurchRankIdForGuildIndex` stub `nil`; no new map | Met |
| Keep `Title` + list/by-id | Met |
| Rewrite `test_ranks.lua`; no old product tests; suite passes | Met (49 / 0 isolated) |
| Do not edit TOC / other modules | Met |
| Report leftover callers; do not fix them | Met (map now stale; see Nit) |
| No commit | Met |
| No invented slot numbers / OPEN_QUESTIONS answers | Met |

## Sections checked

- Brief `docs/reformation/phase-1/briefs/P1-D-ranks.md`
- Writer report `docs/reformation/phase-1/reports/P1-D-ranks.md`
- `docs/reformation/phase-0/TEN_LAWS.md` Laws 1, 9
- Bible §5 (six relationships; Butcher raid-team; Council human judgment; guild rank = display; Church store = truth; Pope is not a rank)
- `addon/ChurchOfBeef/Data/Ranks.lua` (HEAD diff + live dump)
- `tests/test_ranks.lua` (HEAD diff + isolated run)
- Writer transcript (exclusive writes only)
- `ChurchOfBeef.toc` (still lists `Data\Ranks.lua`; other deletions are not this writer)
- `tests/run.lua` (not edited by this writer; `test_ranks` still listed)
- Live Core/UI/Net leftovers: Officer, Roster, BeefNet
- `docs/design/OPEN_QUESTIONS.md` (no ranks/slot invention)
